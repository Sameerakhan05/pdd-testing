const fs = require('fs');
const path = require('path');
const logger = require('./logger');
const driverManager = require('../drivers/appium_driver');

const screenshotDir = path.join(__dirname, '../screenshots');
if (!fs.existsSync(screenshotDir)) {
  fs.mkdirSync(screenshotDir, { recursive: true });
}

// A 1x1 transparent pixel PNG base64 representation
const tinyPngBase64 = 'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNkYAAAAAYAAjCB0C8AAAAASUVORK5CYII=';

module.exports = {
  async captureScreenshot(testId) {
    const filename = `${testId}_failure.png`;
    const destPath = path.join(screenshotDir, filename);
    
    if (driverManager.isMockMode()) {
      // Mock mode: save a placeholder tiny PNG
      fs.writeFileSync(destPath, Buffer.from(tinyPngBase64, 'base64'));
      logger.info(`Saved mock screenshot to: ${destPath}`);
      return destPath;
    }
    
    const driver = driverManager.getDriver();
    if (!driver) {
      fs.writeFileSync(destPath, Buffer.from(tinyPngBase64, 'base64'));
      return destPath;
    }
    
    try {
      logger.info(`Capturing screenshot for test failure: ${testId}`);
      await driver.saveScreenshot(destPath);
      logger.info(`Saved device screenshot to: ${destPath}`);
      return destPath;
    } catch (err) {
      logger.error(`Failed to capture screenshot via Appium client: ${err.message}`);
      // Fallback
      fs.writeFileSync(destPath, Buffer.from(tinyPngBase64, 'base64'));
      return destPath;
    }
  }
};
