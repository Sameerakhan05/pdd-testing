const BasePage = require('./base.page');

class ContactsPage extends BasePage {
  constructor() {
    super('ContactsScreen');
  }

  get addContactFab() { return '//*[@resource-id="add-contact-fab"]'; }
  get nameField() { return '//*[@resource-id="contact-name"]'; }
  get phoneField() { return '//*[@resource-id="contact-phone"]'; }
  get relationField() { return '//*[@resource-id="contact-relation"]'; }
  get saveButton() { return '//*[contains(@text, "Save")]'; }
  get contactListItems() { return '//*[@resource-id="contact-item"]'; }
  get deleteMenuOption() { return '//*[contains(@text, "Delete")]'; }

  async addNewContact(name, phone, relation) {
    await this.click(this.addContactFab, 'Add Contact FAB');
    await this.type(this.nameField, name, 'Contact Name Field');
    await this.type(this.phoneField, phone, 'Contact Phone Field');
    await this.type(this.relationField, relation, 'Contact Relation Field');
    await this.click(this.saveButton, 'Save Contact Button');
  }
}

module.exports = new ContactsPage();
