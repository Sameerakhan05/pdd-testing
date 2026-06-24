# React Deployment and Selenium E2E Testing Documentation

## Step 1 — Push Your React Project to GitHub
Inside your React project folder, initialize a Git repository and push it to GitHub:
```bash
git init
git add .
git commit -m "Initial frontend upload"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO.git
git push -u origin main
```
*Replace `YOUR_USERNAME` and `YOUR_REPO` with your specific GitHub details.*

---

## Step 2 — Install GitHub Pages Package
Install the `gh-pages` dependency in your project as a development dependency:
```bash
npm install gh-pages --save-dev
```

---

## Step 3 — Update `package.json`
Open your `package.json` file.

1. Add the `homepage` property:
   ```json
   "homepage": "https://YOUR_USERNAME.github.io/YOUR_REPO",
   ```
2. Add the deployment scripts inside the `"scripts"` block:
   ```json
   "scripts": {
     "start": "react-scripts start",
     "build": "react-scripts build",
     "predeploy": "npm run build",
     "deploy": "gh-pages -d build"
   }
   ```

---

## Step 4 — Deploy React Project to GitHub Pages
To compile and upload your application, run:
```bash
npm run deploy
```
This command automatically:
* Builds the React application.
* Creates an optimized production build.
* Uploads the build assets to the `gh-pages` branch on GitHub.

---

## Step 5 — Enable GitHub Pages on GitHub
1. Open your repository on GitHub.
2. Go to **Settings** → **Pages**.
3. Under the **Build and deployment** section, configure:
   * **Source**: *Deploy from branch*
   * **Branch**: *gh-pages* (typically chosen automatically)
4. Click **Save**.

---

## Step 6 — Access the Live Application
Once the deployment build completes, GitHub will host your site at:
```text
https://YOUR_USERNAME.github.io/YOUR_REPO
```

---

## Step 7 — Configure React Router for GitHub Pages
To prevent `404 Page Not Found` errors when refreshing pages or navigating directly to non-root URLs, swap `BrowserRouter` for `HashRouter`:

**Before:**
```javascript
import { BrowserRouter } from 'react-router-dom';

// ...
<BrowserRouter>
  <App />
</BrowserRouter>
```

**After:**
```javascript
import { HashRouter } from 'react-router-dom';

// ...
<HashRouter>
  <App />
</HashRouter>
```

---

## Step 8 — Rebuild and Redeploy
After making any router changes, run the build and deploy script again:
```bash
npm run build
npm run deploy
```

---

## Step 9 — Verify Deployment
Verify your pages:
* Check if the homepage loads.
* Test if login/routing paths work.
* Refresh the browser on nested pages to ensure routing persists.
* Access URLs directly (e.g. `https://USERNAME.github.io/REPO/#/login`).

---

## Step 10 — Add Selenium E2E Testing
Install the Selenium Webdriver and Mocha test framework:
```bash
npm install selenium-webdriver mocha --save-dev
```

---

## Step 11 — Create Selenium Test Structure
It is recommended to organize your tests under a dedicated folder:
```text
frontend/
│
├── selenium-tests/
│   ├── tests/
│   │   └── login.test.js
│   └── package.json
```

---

## Step 12 — Add Stable IDs for Automation
Make sure to add unique `id` attributes to input elements so that Selenium selectors can reliably locate them:
```html
<Input id="email" />
<Input id="password" />
<Button id="login-button" />
```

---

## Step 13 — Run Selenium Test Locally
Define a script inside the test suite `package.json` to execute your tests:
```bash
npm run login
```
This script will:
1. Spin up a Chrome browser instance.
2. Navigate to the login page.
3. Automatically enter test credentials.
4. Verify redirection to the dashboard page.

---

## Step 14 — Setup GitHub Actions
Create a workflow configuration file at `.github/workflows/selenium-login.yml` to automate your tests:
```yaml
name: Selenium End-to-End Login Test

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Code
        uses: actions/checkout@v3

      - name: Set up Node.js
        uses: actions/setup-node@v3
        with:
          node-version: 18

      - name: Install Dependencies
        run: npm ci

      - name: Install Chrome & ChromeDriver
        run: |
          sudo apt-get update
          sudo apt-get install -y google-chrome-stable

      - name: Run E2E Tests
        run: npm test
```

---

## Step 15 — Automatic CI/CD Testing
On every code push (`git push`), GitHub Actions triggers a build validation pipeline:
```text
Developer Push
      ↓
GitHub Repository
      ↓
GitHub Actions Trigger
      ↓
Selenium E2E Testing
      ↓
Production Validation
      ↓
Pass / Fail Report
```
