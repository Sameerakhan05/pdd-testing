const http = require('http');
const fs = require('fs');
const path = require('path');
const { spawn } = require('child_process');

const PORT = 8080;
const WEB_DIR = path.join(__dirname, '../build/web');

// Simple static file server
const server = http.createServer((req, res) => {
  let urlPath = req.url.split('?')[0]; // strip query strings
  let filePath = path.join(WEB_DIR, urlPath === '/' ? 'index.html' : urlPath);
  
  if (!filePath.startsWith(WEB_DIR)) {
    res.writeHead(403);
    res.end('Forbidden');
    return;
  }
  
  const ext = path.extname(filePath);
  let contentType = 'text/html';
  switch (ext) {
    case '.js': contentType = 'text/javascript'; break;
    case '.css': contentType = 'text/css'; break;
    case '.json': contentType = 'application/json'; break;
    case '.wasm': contentType = 'application/wasm'; break;
    case '.mp3': contentType = 'audio/mpeg'; break;
    case '.png': contentType = 'image/png'; break;
    case '.jpg':
    case '.jpeg': contentType = 'image/jpeg'; break;
    case '.svg': contentType = 'image/svg+xml'; break;
    case '.ttf': contentType = 'font/ttf'; break;
    case '.otf': contentType = 'font/otf'; break;
    case '.woff': contentType = 'font/woff'; break;
    case '.woff2': contentType = 'font/woff2'; break;
  }
  
  fs.readFile(filePath, (err, content) => {
    if (err) {
      if (err.code === 'ENOENT') {
        // Fallback to index.html for SPA routing
        fs.readFile(path.join(WEB_DIR, 'index.html'), (err2, indexContent) => {
          if (err2) {
            console.error(`[404] NOT FOUND: ${req.url} (and index.html fallback failed)`);
            res.writeHead(404);
            res.end('Not Found');
          } else {
            console.log(`[200-fallback] ${req.url} -> index.html`);
            res.writeHead(200, { 'Content-Type': 'text/html' });
            res.end(indexContent, 'utf-8');
          }
        });
      } else {
        console.error(`[500] ERROR: ${req.url} - ${err.code}`);
        res.writeHead(500);
        res.end(`Server Error: ${err.code}`);
      }
    } else {
      console.log(`[200] ${req.url} (${contentType})`);
      res.writeHead(200, { 'Content-Type': contentType });
      res.end(content, 'utf-8');
    }
  });
});

server.listen(PORT, () => {
  console.log(`Local web server running at http://localhost:${PORT}`);
  startTunnel();
});

function startTunnel() {
  console.log('Starting ssh tunnel to localhost.run...');
  
  const sshProcess = spawn('ssh', [
    '-o', 'StrictHostKeyChecking=no',
    '-o', 'UserKnownHostsFile=/dev/null',
    '-R', `80:localhost:${PORT}`,
    'nokey@localhost.run'
  ]);
  
  sshProcess.stdout.on('data', (data) => {
    const output = data.toString();
    console.log(output);
    
    // Search for the generated https link
    const match = output.match(/https:\/\/[a-z0-9]+\.lhr\.life/i);
    if (match) {
      console.log('\n==================================================');
      console.log(`SUCCESS! YOUR PUBLIC URL: ${match[0]}`);
      console.log('==================================================\n');
    }
  });
  
  sshProcess.stderr.on('data', (data) => {
    const msg = data.toString();
    if (!msg.includes('Warning: Permanently added') && !msg.includes('Pseudo-terminal')) {
      console.error('ssh stderr:', msg);
    }
  });

  sshProcess.on('close', (code) => {
    console.log(`ssh tunnel exited with code ${code}. Reconnecting in 5s...`);
    setTimeout(startTunnel, 5000);
  });
}
