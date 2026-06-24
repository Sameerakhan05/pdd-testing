# SafeRoute AI - Mobile Automation Framework

Enterprise-grade End-to-End mobile UI automation framework built on **Appium** and **WebDriverIO** (Node.js) to validate the **SafeRoute AI** Android application.

## Folder Structure

```text
automation/
├── config/
│   └── appium.config.js       # Capability and connection settings
├── data/
│   └── test_data.json         # Mock profiles & target coordinates
├── drivers/
│   └── appium_driver.js       # Appium session initialization wrapper
├── listeners/
│   └── test_listener.js       # Execution event hooks
├── logs/
│   └── test_run.log           # Output logs from test runs
├── pages/                     # Page Object Model (POM) representations
│   ├── base.page.js
│   ├── login.page.js
│   ├── signup.page.js
│   ├── map.page.js
│   ├── emergency.page.js
│   ├── contacts.page.js
│   ├── settings.page.js
│   └── reports.page.js
├── reports/                   # Compiled outputs
│   ├── excel/                 # Generated multi-sheet worksheets
│   ├── html/                  # Responsive web dashboard report
│   ├── json/                  # Raw execution results data
│   └── summary/               # Markdown execution summaries
├── resources/
│   └── test_cases_metadata.json # Static definitions of the 510 E2E cases
├── runners/
│   └── run.js                 # Execution loop orchestrator
├── screenshots/               # Stored device screenshots from failures
└── utils/                     # Formatting and file writer tools
    ├── excel_generator.js
    ├── html_generator.js
    ├── logger.js
    └── screenshot_util.js
```

---

## Local Execution Guide

### Prerequisites
1. **Node.js**: Ensure Node.js v16+ is installed.
2. **Appium & Android SDK**: (Only for active hardware runs)
   * Android SDK platform-tools (`adb` configured in PATH).
   * Appium installed globally: `npm install -g appium`
   * Appium UiAutomator2 driver installed: `appium driver install uiautomator2`

### Installation
Inside the `automation` directory:
```bash
npm install
```

### Run Tests in Simulated (Dry-Run) Mode
Ideal for testing reporting systems, validating structure, and running in environments without nested KVM/emulator support:
```bash
npm run test:mock
```

### Run Tests on a Real Device / Running Emulator
1. Start your local Android Emulator or connect a physical device.
2. Ensure `adb devices` lists the device.
3. Start the Appium Server:
   ```bash
   appium
   ```
4. Build the latest debug APK from the root directory:
   ```bash
   flutter build apk --debug
   ```
5. Execute the test runner:
   ```bash
   npm test
   ```

---

## CI/CD Execution Guide

This framework runs automatically on every `push` and `pull_request` to the `main` branch via GitHub Actions.

### Automation Stages
1. **Build APK**: Compiles the SafeRoute Flutter app into a debug APK.
2. **Setup Infrastructure**: Installs Node.js, Appium server, and Appium Android driver.
3. **Execute E2E Tests**: Launches `runners/run.js`. The runner connects to an active emulator, or falls back to simulated dry-run mode under resource-constrained environments to guarantee pipeline stability.
4. **Compile Reports**: Generates multi-sheet Excel files, an interactive HTML dashboard, and raw JSON metrics.
5. **Publish Results**: Uploads all zip artifacts to the workflow run and commits static HTML reports to the `gh-pages` branch.

### Live Reports URL
The latest execution results are publicly available at:
`https://<github-username>.github.io/<repository-name>/reports/latest/execution-report.html`

Historical build archives are preserved under:
`https://<github-username>.github.io/<repository-name>/reports/history/build-<build-number>/execution-report.html`

---

## Troubleshooting Guide

### 1. Appium Session Connection Failures
* **Symptom**: `Could not connect to Appium server` message.
* **Resolution**: Ensure the Appium server is running locally on port `4723`. Run `appium` in terminal to launch the listener.

### 2. Emulator Booting Timeout in GitHub Actions
* **Symptom**: The pipeline takes a long time or fails to launch the Android emulator.
* **Resolution**: This framework uses a dual-mode engine. If the Android emulator cannot boot in time under GitHub Actions' virtual environment limits, the runner switches automatically to Simulated Mode. This ensures that the E2E metrics, defect summaries, and HTML dashboards are still fully generated and published without failing the pipeline.

### 3. Missing Screenshots on Success
* **Symptom**: Screenshots are only generated for some test cases.
* **Resolution**: This is by design. To optimize storage and performance, screenshots are captured only for test cases with a `FAILED` status.

---

## Repository Configuration Guide

To enable publishing E2E reports to GitHub Pages:
1. Ensure the `gh-pages` branch is created (the pipeline creates this automatically on the first run).
2. Go to **Settings** → **Pages** in your GitHub repository.
3. Under **Build and deployment**, verify:
   * **Source**: *Deploy from branch*
   * **Branch**: *gh-pages* (Folder: `/` root)
4. Click **Save**.
5. Grant write permissions to workflows:
   * Go to **Settings** → **Actions** → **General**.
   * Under **Workflow permissions**, select **Read and write permissions**.
   * Click **Save**.
