const BasePage = require('./base.page');

class ReportsPage extends BasePage {
  constructor() {
    super('ReportsScreen');
  }

  get addReportFab() { return '//*[@resource-id="add-report-fab"]'; }
  get incidentTypeDropdown() { return '//*[@resource-id="incident-type"]'; }
  get areaField() { return '//*[@resource-id="report-area"]'; }
  get notesField() { return '//*[@resource-id="report-notes"]'; }
  get submitReportButton() { return '//*[contains(@text, "Submit")]'; }
  get reportTypeChips() { return '//*[@resource-id="type-chip"]'; }

  async createReport(type, area, notes) {
    await this.click(this.addReportFab, 'Add Report FAB');
    await this.click(this.incidentTypeDropdown, 'Incident Type Select');
    await this.click(`//*[contains(@text, "${type}")]`, `Dropdown Type: ${type}`);
    await this.type(this.areaField, area, 'Area/Landmark Field');
    await this.type(this.notesField, notes, 'Incident Notes Field');
    await this.click(this.submitReportButton, 'Submit Report Button');
  }
}

module.exports = new ReportsPage();
