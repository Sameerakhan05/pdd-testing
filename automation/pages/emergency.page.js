const BasePage = require('./base.page');

class EmergencyPage extends BasePage {
  constructor() {
    super('EmergencyScreen');
  }

  get sosButton() { return '//*[@resource-id="sos-button"]'; }
  get stopButton() { return '//*[contains(@text, "STOP") or contains(@text, "Stop")]'; }
  get statusText() { return '//*[@resource-id="sos-status-text"]'; }
  get callPoliceButton() { return '//*[contains(@text, "Call Police")]'; }
  get contactQuickCall() { return '//*[contains(@text, "Call ") and not(contains(@text, "Police"))]'; }

  async triggerSOS() {
    await this.click(this.sosButton, 'SOS Button');
  }

  async stopSOS() {
    await this.click(this.stopButton, 'Stop SOS Button');
  }

  async callPolice() {
    await this.click(this.callPoliceButton, 'Call Police Emergency Option');
  }
}

module.exports = new EmergencyPage();
