const BasePage = require('./base.page');

class SignupPage extends BasePage {
  constructor() {
    super('SignupScreen');
  }

  get nameInput() { return '//*[@resource-id="name"]'; }
  get emailInput() { return '//*[@resource-id="email"]'; }
  get passwordInput() { return '//*[@resource-id="password"]'; }
  get signUpButton() { return '//*[@resource-id="signup-button"]'; }
  get backToLoginLink() { return '//*[contains(@text, "Log in")]'; }

  async register(name, email, password) {
    await this.type(this.nameInput, name, 'Name Field');
    await this.type(this.emailInput, email, 'Email Field');
    await this.type(this.passwordInput, password, 'Password Field');
    await this.click(this.signUpButton, 'Sign Up Button');
  }

  async goBackToLogin() {
    await this.click(this.backToLoginLink, 'Back to Login Link');
  }
}

module.exports = new SignupPage();
