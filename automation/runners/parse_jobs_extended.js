const fs = require('fs');
const content = fs.readFileSync('C:\\Users\\samee\\.gemini\\antigravity-ide\\brain\\9fd4bea1-a0ef-4738-966b-a7ab5d400d11\\.system_generated\\steps\\753\\content.md', 'utf8');
const jsonStart = content.indexOf('{');
const jsonStr = content.substring(jsonStart).trim();
try {
  const data = JSON.parse(jsonStr);
  console.log('--- Action Runs Status (Extended) ---');
  data.workflow_runs.slice(0, 10).forEach(r => {
    console.log(`Run #${r.run_number}: status=${r.status}, conclusion=${r.conclusion}, name=${r.display_title}, sha=${r.head_sha}`);
  });
} catch(err) {
  console.error('Error parsing JSON:', err.message);
}
