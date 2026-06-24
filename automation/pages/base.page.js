const logger = require('../utils/logger');
const driverManager = require('../drivers/appium_driver');

class BasePage {
  constructor(pageName) {
    this.pageName = pageName;
  }

  get driver() {
    return driverManager.getDriver();
  }

  get isMockMode() {
    return driverManager.isMockMode();
  }

  async findElement(selector) {
    if (this.isMockMode) return { selector, mock: true };
    logger.info(`Finding element: ${selector}`);
    const el = await this.driver.$(selector);
    await el.waitForExist({ timeout: 10000 });
    return el;
  }

  async click(selector, elementName) {
    logger.info(`Clicking ${elementName || selector} on ${this.pageName}`);
    if (this.isMockMode) {
      await new Promise(resolve => setTimeout(resolve, 50)); // simulated latency
      return;
    }
    const el = await this.findElement(selector);
    await el.click();
  }

  async type(selector, text, elementName) {
    logger.info(`Typing "${text}" into ${elementName || selector} on ${this.pageName}`);
    if (this.isMockMode) {
      await new Promise(resolve => setTimeout(resolve, 50));
      return;
    }
    const el = await this.findElement(selector);
    await el.setValue(text);
  }

  async getText(selector) {
    if (this.isMockMode) return "Mock Text";
    const el = await this.findElement(selector);
    return await el.getText();
  }

  async isDisplayed(selector) {
    if (this.isMockMode) return true;
    try {
      const el = await this.driver.$(selector);
      return await el.isDisplayed();
    } catch (_) {
      return false;
    }
  }

  async waitForPageToLoad(selector) {
    logger.info(`Waiting for ${this.pageName} to load`);
    if (this.isMockMode) return;
    const el = await this.driver.$(selector);
    await el.waitForDisplayed({ timeout: 15000 });
  }
}

module.exports = BasePage;
