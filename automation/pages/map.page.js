const BasePage = require('./base.page');

class MapPage extends BasePage {
  constructor() {
    super('MapScreen');
  }

  get searchInput() { return '//*[@resource-id="search-input"]'; }
  get findRouteButton() { return '//*[@resource-id="find-route"]'; }
  get routeOptionsHeader() { return '//*[contains(@text, "Route options")]'; }
  get firstRouteCard() { return '//*[@resource-id="route-card-0"]'; }
  get startNavButton() { return '//*[contains(@text, "Start")]'; }
  get endNavButton() { return '//*[contains(@text, "End")]'; }
  get navBanner() { return '//*[@resource-id="nav-banner"]'; }
  get emergencyFab() { return '//*[@resource-id="emergency-fab"]'; }
  get gpsBadge() { return '//*[contains(@text, "GPS")]'; }

  async searchDestination(dest) {
    await this.type(this.searchInput, dest, 'Destination Search Field');
    await this.click(this.findRouteButton, 'Find Route Button');
  }

  async selectFirstRouteAndNavigate() {
    await this.click(this.firstRouteCard, 'First Route Option');
    await this.click(this.startNavButton, 'Start Navigation Button');
  }

  async endNavigation() {
    await this.click(this.endNavButton, 'End Navigation Button');
  }

  async triggerEmergency() {
    await this.click(this.emergencyFab, 'Emergency Floating Button');
  }
}

module.exports = new MapPage();
