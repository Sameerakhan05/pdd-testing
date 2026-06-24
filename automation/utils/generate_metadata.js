const fs = require('fs');
const path = require('path');

const modules = [
  { key: 'AUTH', count: 40, name: 'Authentication' },
  { key: 'AZ', count: 30, name: 'Authorization' },
  { key: 'REG', count: 20, name: 'Registration' },
  { key: 'PROF', count: 20, name: 'Profile Management' },
  { key: 'NAV', count: 30, name: 'Navigation' },
  { key: 'DASH', count: 20, name: 'Dashboard' },
  { key: 'FORM', count: 40, name: 'Forms' },
  { key: 'CRUD', count: 40, name: 'CRUD Operations' },
  { key: 'SRCH', count: 20, name: 'Search' },
  { key: 'FILT', count: 20, name: 'Filters' },
  { key: 'VAL', count: 40, name: 'Input Validation' },
  { key: 'ERR', count: 20, name: 'Error Handling' },
  { key: 'SESS', count: 20, name: 'Session Management' },
  { key: 'NOTIF', count: 20, name: 'Notifications' },
  { key: 'UPL', count: 20, name: 'File Upload' },
  { key: 'OFF', count: 10, name: 'Offline Handling' },
  { key: 'ACC', count: 20, name: 'Accessibility' },
  { key: 'RESP', count: 10, name: 'Responsive UI' },
  { key: 'PERF', count: 20, name: 'Performance Smoke Tests' },
  { key: 'REGR', count: 50, name: 'Regression Suite' }
];

const testCases = [];

for (const mod of modules) {
  for (let i = 1; i <= mod.count; i++) {
    const id = `TC_${mod.key}_${String(i).padStart(3, '0')}`;
    const priority = i % 3 === 0 ? 'High' : (i % 3 === 1 ? 'Medium' : 'Low');
    
    testCases.push({
      id: id,
      module: mod.name,
      name: `${mod.name} Verification - Case ${i}`,
      priority: priority,
      preconditions: `Application is launched. Device is in steady state.`,
      steps: [
        `1. Navigate to ${mod.name} module.`,
        `2. Perform action/input for test case scenario ${i}.`,
        `3. Verify outcomes and states.`
      ],
      data: {
        scenarioId: `SC_DATA_${mod.key}_${i}`,
        testInput: `Input value ${i}`,
        expectedState: `State_${mod.key}_Active`
      },
      expectedResult: `Successful validation of ${mod.name} scenario ${i} showing expected state.`,
    });
  }
}

const resourcesDir = path.join(__dirname, '../resources');
if (!fs.existsSync(resourcesDir)) {
  fs.mkdirSync(resourcesDir, { recursive: true });
}

fs.writeFileSync(
  path.join(resourcesDir, 'test_cases_metadata.json'),
  JSON.stringify(testCases, null, 2)
);

console.log(`Successfully generated ${testCases.length} test cases in resources/test_cases_metadata.json`);
