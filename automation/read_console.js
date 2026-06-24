const { remote } = require('webdriverio');

async function main() {
  console.log("Starting browser check...");
  const browser = await remote({
    capabilities: {
      browserName: 'chrome',
      'goog:chromeOptions': {
        args: ['--headless', '--disable-gpu']
      }
    }
  });

  try {
    console.log("Navigating to http://localhost:8080/ ...");
    await browser.url('http://localhost:8080/');
    
    console.log("Waiting 5 seconds for page load...");
    await browser.pause(5000);
    
    console.log("Retrieving browser logs...");
    const logs = await browser.getLogs('browser');
    console.log("\n=================== BROWSER LOGS ===================");
    if (logs && logs.length > 0) {
      logs.forEach(log => {
        console.log(`[${log.level}] ${log.message}`);
      });
    } else {
      console.log("No console logs found.");
    }
    console.log("====================================================\n");

    const html = await browser.getHTML('body');
    console.log("Body HTML content length:", html.length);
    
  } catch (err) {
    console.error("Error during browser check:", err);
  } finally {
    await browser.deleteSession();
    console.log("Browser session closed.");
  }
}

main().catch(console.error);
