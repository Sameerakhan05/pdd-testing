const BasePage = require('./base.page');

class LoginPage extends BasePage {
  constructor() {
    super('LoginScreen');
  }

  // Element Selectors (XPaths/IDs/Accessibility IDs commonly used in Flutter/Appium)
  get emailInput() { return '//*[@resource-id="email"]'; }
  get passwordInput() { return '//*[@resource-id="password"]'; }
  get loginButton() { return '//*[@resource-id="login-button"]'; }
  get signUpLink() { return '//*[contains(@text, "Sign up")]'; }
  get errorMessage() { return '//*[contains(@text, "error") or contains(@text, "invalid")]'; }

  async login(email, password) {
    await this.type(this.emailInput, email, 'Email Field');
    await this.type(this.passwordInput, password, 'Password Field');
    await this.click(this.loginButton, 'Login Button');
  }

  async navigateToSignUp() {
    await this.click(this.signUpLink, 'Sign Up Link');
  }

  async getError() {
    return await this.getText(this.errorMessage);
  }
}

module.exports = new LoginPage();
