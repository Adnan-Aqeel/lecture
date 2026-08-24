# Mobile Export, Import, and Download Actions Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Give every existing Export, Import, Download, and file-template action in the HRMS mobile app practical file handling without changing unrelated UI or business logic.

**Architecture:** Add one shared utility for CSV/PDF generation, native file sharing, and file picking. Connect existing action callbacks to that utility using each screen's current placeholder/empty data. Import actions validate the selected file and show a user-facing result; they do not alter domain data until an existing screen has an explicit import workflow.

**Tech Stack:** Flutter/Dart, `csv`, `pdf`, `file_picker`, `path_provider`, `share_plus`.

## Global Constraints

- Only Export, Import, Download, CSV Template, PDF, Excel, and file-upload actions are in scope.
- Existing layouts, labels, navigation, and non-file business logic remain unchanged.
- Exports use native mobile sharing/saving rather than assuming a public Downloads path.
- Empty datasets produce a valid file with headers and a clear empty-data row.
- Imports validate extension and show errors without mutating domain state.

---

### Task 1: Add shared mobile file utility and dependencies

**Files:**
- Modify: `pubspec.yaml`
- Create: `lib/utils/mobile_file_actions.dart`

**Interfaces:**
- Produces `MobileFileActions.exportCsv`, `MobileFileActions.exportPdf`, `MobileFileActions.downloadCsvTemplate`, and `MobileFileActions.pickImportFile`.

- [ ] Add dependencies for CSV, PDF, file picker, path provider, and share sheet support.
- [ ] Implement UTF-8 CSV creation, temporary-file writing, and native sharing.
- [ ] Implement a simple PDF report export with title, headers, and rows.
- [ ] Implement extension-filtered file picking and user-safe error results.

### Task 2: Connect report export/download actions

**Files:**
- Modify: `lib/Screens/Reports/recruitment_report.dart`
- Modify: `lib/Screens/Reports/payroll_reports.dart`
- Modify: `lib/Screens/Reports/monthly_attendance.dart`
- Modify: `lib/Screens/Reports/kpi_report.dart`
- Modify: `lib/Screens/Reports/expense_report.dart`
- Modify: `lib/Screens/Reports/employee_report.dart`
- Modify: `lib/Screens/Reports/assets_report.dart`
- Modify: `lib/Screens/Reports/loan_report.dart`

- [ ] Replace empty file-action callbacks with utility calls using each screen's existing visible data or empty headers.
- [ ] Preserve each button's current label and placement.
- [ ] Show loading, success, and failure feedback through existing screen context.

### Task 3: Connect payroll, KPI, attendance, and recruitment templates

**Files:**
- Modify: `lib/Screens/Payroll_management/salary_slip.dart`
- Modify: `lib/Screens/Payroll_management/payroll_history.dart`
- Modify: `lib/Screens/Payroll_management/payroll_run.dart`
- Modify: `lib/Screens/Kpi_management/Kpi_dashboard_button/employee_evaluation.dart`
- Modify: `lib/Screens/Kpi_management/Kpi_dashboard_button/bulk_evaluation.dart`
- Modify: `lib/Screens/Recruitment/pipeline_board.dart`

- [ ] Connect PDF/template downloads to generated files.
- [ ] Connect Import CSV and Import Evaluations to picker validation.
- [ ] Preserve existing wizard state and avoid inserting records automatically.

### Task 4: Verify only scoped changes

- [ ] Run formatting on changed Dart files.
- [ ] Run `flutter pub get` and `flutter analyze --no-pub`.
- [ ] Run widget tests and add utility tests for CSV headers, empty rows, and rejected extensions.
- [ ] Review diff to ensure no unrelated UI/business logic changed.
