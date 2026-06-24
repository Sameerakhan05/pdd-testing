const BasePage = require('./base.page');

class SettingsPage extends BasePage {
  constructor() {
    super('SettingsScreen');
  }

  get liveTrackingSwitch() { return '//*[contains(@text, "Live location")]/following-sibling::*'; }
  get voiceTriggerSwitch() { return '//*[contains(@text, "Voice trigger")]/following-sibling::*'; }
  get profileCard() { return '//*[contains(@text, "profile")]'; }
  get logOutTile() { return '//*[contains(@text, "Log out")]'; }

  async toggleLiveTracking() {
    await this.click(this.liveTrackingSwitch, 'Live Tracking Toggle');
  }

  async logout() {
    await this.click(this.logOutTile, 'Log Out Option');
  }
}

module.exports = new SettingsPage();
