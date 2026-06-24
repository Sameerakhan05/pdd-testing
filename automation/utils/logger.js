const fs = require('fs');
const path = require('path');

const logDir = path.join(__dirname, '../logs');
if (!fs.existsSync(logDir)) {
  fs.mkdirSync(logDir, { recursive: true });
}

const logFile = path.join(logDir, 'test_run.log');
// Clean logs from previous run
fs.writeFileSync(logFile, '');

function formatMessage(level, message) {
  const timestamp = new Date().toISOString();
  return `[${timestamp}] [${level}] ${message}\n`;
}

module.exports = {
  info(message) {
    const msg = formatMessage('INFO', message);
    process.stdout.write(msg);
    fs.appendFileSync(logFile, msg);
  },
  error(message, errorObject) {
    let msg = formatMessage('ERROR', message);
    if (errorObject) {
      msg += `${errorObject.stack || errorObject}\n`;
    }
    process.stderr.write(msg);
    fs.appendFileSync(logFile, msg);
  },
  warn(message) {
    const msg = formatMessage('WARN', message);
    process.stdout.write(msg);
    fs.appendFileSync(logFile, msg);
  }
};
