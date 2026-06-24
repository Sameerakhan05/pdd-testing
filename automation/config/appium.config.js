const path = require('path');

module.exports = {
  host: process.env.APPIUM_HOST || '127.0.0.1',
  port: parseInt(process.env.APPIUM_PORT || '4723', 10),
  path: '/',
  
  capabilities: {
    platformName: 'Android',
    'appium:automationName': 'UiAutomator2',
    'appium:deviceName': process.env.ANDROID_DEVICE_NAME || 'Android Emulator',
    'appium:app': process.env.APK_PATH || path.join(__dirname, '../../build/app/outputs/flutter-apk/app-debug.apk'),
    'appium:appPackage': 'com.example.saferoute',
    'appium:appActivity': 'com.example.saferoute.MainActivity',
    'appium:noReset': false,
    'appium:fullReset': false,
    'appium:newCommandTimeout': 300,
    'appium:autoGrantPermissions': true,
    'appium:gpsEnabled': true
  }
};
