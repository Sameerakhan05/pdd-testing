const ExcelJS = require('exceljs');
const fs = require('fs');
const path = require('path');

const excelDir = path.join(__dirname, '../reports/excel');
if (!fs.existsSync(excelDir)) {
  fs.mkdirSync(excelDir, { recursive: true });
}

// Styling helper
function styleHeader(sheet, columnsCount) {
  const row = sheet.getRow(1);
  row.height = 25;
  for (let col = 1; col <= columnsCount; col++) {
    const cell = row.getCell(col);
    cell.fill = {
      type: 'pattern',
      pattern: 'solid',
      fgColor: { argb: 'FF4F46E5' } // Indigo color header
    };
    cell.font = {
      name: 'Arial',
      size: 11,
      bold: true,
      color: { argb: 'FFFFFFFF' }
    };
    cell.alignment = { vertical: 'middle', horizontal: 'left' };
  }
}

function autoFitColumns(sheet) {
  sheet.columns.forEach(column => {
    let maxLength = 0;
    column.eachCell({ includeEmpty: true }, cell => {
      const columnLength = cell.value ? cell.value.toString().length : 10;
      if (columnLength > maxLength) {
        maxLength = columnLength;
      }
    });
    column.width = Math.min(Math.max(maxLength + 4, 12), 40);
  });
}

module.exports = {
  async generateReports(results, metrics, buildNumber) {
    const passed = results.filter(r => r.status === 'PASSED');
    const failed = results.filter(r => r.status === 'FAILED');
    const skipped = results.filter(r => r.status === 'SKIPPED');

    // ─── 1. AUTOMATION TEST REPORT (All-in-One Workbook) ───
    const mainWorkbook = new ExcelJS.Workbook();
    
    // Sheet 1: Executed Test Cases
    const executedSheet = mainWorkbook.addWorksheet('Executed Test Cases');
    executedSheet.columns = [
      { header: 'Test ID', key: 'id' },
      { header: 'Module', key: 'module' },
      { header: 'Test Name', key: 'name' },
      { header: 'Priority', key: 'priority' },
      { header: 'Status', key: 'status' },
      { header: 'Execution Time (ms)', key: 'duration' }
    ];
    results.forEach(r => executedSheet.addRow({
      id: r.id,
      module: r.module,
      name: r.name,
      priority: r.priority,
      status: r.status,
      duration: r.duration || 120
    }));
    styleHeader(executedSheet, 6);
    autoFitColumns(executedSheet);

    // Sheet 2: Passed Tests
    const passedSheet = mainWorkbook.addWorksheet('Passed Tests');
    passedSheet.columns = executedSheet.columns;
    passed.forEach(r => passedSheet.addRow({
      id: r.id,
      module: r.module,
      name: r.name,
      priority: r.priority,
      status: r.status,
      duration: r.duration || 120
    }));
    styleHeader(passedSheet, 6);
    autoFitColumns(passedSheet);

    // Sheet 3: Failed Tests
    const failedSheet = mainWorkbook.addWorksheet('Failed Tests');
    failedSheet.columns = [
      ...executedSheet.columns,
      { header: 'Failure Reason', key: 'reason' }
    ];
    failed.forEach(r => failedSheet.addRow({
      id: r.id,
      module: r.module,
      name: r.name,
      priority: r.priority,
      status: r.status,
      duration: r.duration || 120,
      reason: r.failureReason || 'Verification Failed'
    }));
    styleHeader(failedSheet, 7);
    autoFitColumns(failedSheet);

    // Sheet 4: Skipped Tests
    const skippedSheet = mainWorkbook.addWorksheet('Skipped Tests');
    skippedSheet.columns = executedSheet.columns;
    skipped.forEach(r => skippedSheet.addRow({
      id: r.id,
      module: r.module,
      name: r.name,
      priority: r.priority,
      status: r.status,
      duration: r.duration || 0
    }));
    styleHeader(skippedSheet, 6);
    autoFitColumns(skippedSheet);

    // Sheet 5: Execution Metrics
    const metricsSheet = mainWorkbook.addWorksheet('Execution Metrics');
    metricsSheet.columns = [
      { header: 'Metric Name', key: 'name' },
      { header: 'Value', key: 'value' }
    ];
    metricsSheet.addRow({ name: 'Total Test Cases', value: results.length });
    metricsSheet.addRow({ name: 'Passed', value: passed.length });
    metricsSheet.addRow({ name: 'Failed', value: failed.length });
    metricsSheet.addRow({ name: 'Skipped', value: skipped.length });
    metricsSheet.addRow({ name: 'Pass Rate (%)', value: ((passed.length / results.length) * 100).toFixed(1) });
    metricsSheet.addRow({ name: 'Execution Duration', value: metrics.duration || '00:02:15' });
    styleHeader(metricsSheet, 2);
    autoFitColumns(metricsSheet);

    // Sheet 6: Defect Summary
    const defectSheet = mainWorkbook.addWorksheet('Defect Summary');
    defectSheet.columns = [
      { header: 'Defect ID', key: 'defId' },
      { header: 'Linked Test Case', key: 'tcId' },
      { header: 'Module', key: 'module' },
      { header: 'Description', key: 'desc' },
      { header: 'Severity', key: 'sev' }
    ];
    failed.forEach((r, idx) => defectSheet.addRow({
      defId: `DEF_${String(idx + 1).padStart(3, '0')}`,
      tcId: r.id,
      module: r.module,
      desc: r.failureReason || 'UI verification check failed.',
      sev: r.priority === 'High' ? 'Critical' : (r.priority === 'Medium' ? 'Major' : 'Minor')
    }));
    styleHeader(defectSheet, 5);
    autoFitColumns(defectSheet);

    // Sheet 7: Pass Rate Summary (Module level)
    const passRateSheet = mainWorkbook.addWorksheet('Pass Rate Summary');
    passRateSheet.columns = [
      { header: 'Module', key: 'module' },
      { header: 'Total', key: 'total' },
      { header: 'Passed', key: 'passed' },
      { header: 'Failed', key: 'failed' },
      { header: 'Pass Rate (%)', key: 'rate' }
    ];
    Object.entries(metrics.modules || {}).forEach(([mName, mData]) => {
      passRateSheet.addRow({
        module: mName,
        total: mData.total,
        passed: mData.passed,
        failed: mData.failed,
        rate: ((mData.passed / mData.total) * 100).toFixed(1)
      });
    });
    styleHeader(passRateSheet, 5);
    autoFitColumns(passRateSheet);

    // Write all sheets
    await mainWorkbook.xlsx.writeFile(path.join(excelDir, 'Automation_Test_Report.xlsx'));

    // ─── 2. PASSED TEST CASES WORKBOOK ───
    const passedWorkbook = new ExcelJS.Workbook();
    const passedOnlySheet = passedWorkbook.addWorksheet('Passed Tests');
    passedOnlySheet.columns = executedSheet.columns;
    passed.forEach(r => passedOnlySheet.addRow({
      id: r.id,
      module: r.module,
      name: r.name,
      priority: r.priority,
      status: r.status,
      duration: r.duration || 120
    }));
    styleHeader(passedOnlySheet, 6);
    autoFitColumns(passedOnlySheet);
    await passedWorkbook.xlsx.writeFile(path.join(excelDir, 'Passed_Test_Cases.xlsx'));

    // ─── 3. FAILED TEST CASES WORKBOOK ───
    const failedWorkbook = new ExcelJS.Workbook();
    const failedOnlySheet = failedWorkbook.addWorksheet('Failed Tests');
    failedOnlySheet.columns = failedSheet.columns;
    failed.forEach(r => failedOnlySheet.addRow({
      id: r.id,
      module: r.module,
      name: r.name,
      priority: r.priority,
      status: r.status,
      duration: r.duration || 120,
      reason: r.failureReason || 'Verification Failed'
    }));
    styleHeader(failedOnlySheet, 7);
    autoFitColumns(failedOnlySheet);
    await failedWorkbook.xlsx.writeFile(path.join(excelDir, 'Failed_Test_Cases.xlsx'));

    // ─── 4. EXECUTION SUMMARY WORKBOOK ───
    const summaryWorkbook = new ExcelJS.Workbook();
    const summarySheet = summaryWorkbook.addWorksheet('Summary');
    summarySheet.columns = [
      { header: 'Summary Key', key: 'key' },
      { header: 'Value', key: 'value' }
    ];
    summarySheet.addRow({ key: 'Build Number', value: buildNumber });
    summarySheet.addRow({ key: 'Execution Date', value: new Date().toISOString() });
    summarySheet.addRow({ key: 'Total Cases', value: results.length });
    summarySheet.addRow({ key: 'Passed', value: passed.length });
    summarySheet.addRow({ key: 'Failed', value: failed.length });
    summarySheet.addRow({ key: 'Skipped', value: skipped.length });
    styleHeader(summarySheet, 2);
    autoFitColumns(summarySheet);
    await summaryWorkbook.xlsx.writeFile(path.join(excelDir, 'Execution_Summary.xlsx'));
  }
};
