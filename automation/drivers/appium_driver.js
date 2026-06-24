const { remote } = require('webdriverio');
const appiumConfig = require('../config/appium.config');
const logger = require('../utils/logger');

let driverInstance = null;
let mockActive = false;

module.exports = {
  async initDriver() {
    // If MOCK_MODE environment variable is set to true, use mock mode directly
    if (process.env.MOCK_MODE === 'true') {
      logger.info('MOCK_MODE environment flag detected. Starting in simulated mode.');
      mockActive = true;
      return null;
    }

    logger.info('Attempting to initialize Appium session...');
    try {
      driverInstance = await remote({
        hostname: appiumConfig.host,
        port: appiumConfig.port,
        path: appiumConfig.path,
        capabilities: appiumConfig.capabilities,
        logLevel: 'error'
      });
      logger.info('Appium session initialized successfully.');
      mockActive = false;
      return driverInstance;
    } catch (err) {
      logger.warn(`Could not connect to Appium server or start emulator session: ${err.message}`);
      logger.warn('Falling back to Simulated/Mock Mode for validation.');
      mockActive = true;
      return null;
    }
  },

  getDriver() {
    return driverInstance;
  },

  isMockMode() {
    return mockActive;
  },

  async quitDriver() {
    if (driverInstance) {
      logger.info('Tearing down Appium session...');
      try {
        await driverInstance.deleteSession();
        logger.info('Appium session ended successfully.');
      } catch (err) {
        logger.error('Error during Appium session teardown', err);
      }
      driverInstance = null;
    }
  }
};
