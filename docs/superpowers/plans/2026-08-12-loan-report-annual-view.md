# Loan Report Annual View Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a reference-matching Annual dashboard to `LoanReportScreen` while preserving Summary as the default.

**Architecture:** Keep `_viewType` local to the existing stateful screen. Branch the report body after the shared controls: Summary uses the current widgets, while Annual uses focused private widgets for empty-state panels and charts.

**Tech Stack:** Flutter/Dart, `flutter_test`, `fl_chart`, existing `AppConstant` theme helpers.

## Global Constraints

- Summary remains selected initially and renders the current report content unchanged.
- Annual uses the existing zero/default values until a data source is connected.
- Do not change navigation, data models, or Summary behavior.
- Reuse existing theme colors and chart dependencies.

---

### Task 1: Add the Annual view regression test

**Files:**
- Modify: `test/widget_test.dart`

**Interfaces:**
- Consumes: `LoanReportScreen` and its `Summary`/`Annual` choice chips.
- Produces: A test proving view switching and annual section labels.

- [ ] **Step 1: Replace the obsolete counter test with a failing report-view test**

Test `LoanReportScreen` directly and assert `Summary` content initially, tap the `Annual` chip, and assert annual headings. The test must use `MaterialApp` so the screen has a theme and navigator.

- [ ] **Step 2: Run the focused test to verify it fails**

Run: `flutter test test/widget_test.dart`

Expected: FAIL because the Annual headings do not yet exist.

### Task 2: Implement Annual dashboard rendering

**Files:**
- Modify: `lib/Screens/Reports/loan_report.dart`

**Interfaces:**
- Consumes: Existing `_viewType`, zero-valued report fields, `fl_chart`, and `AppConstant`.
- Produces: `_buildAnnualView()`, `_buildAnnualPanel()`, `_buildMonthlyAnnualChart()`, and `_buildOutstandingBalanceChart()` private widgets.

- [ ] **Step 1: Add the view branch while retaining the current Summary widget sequence**

Render `_buildAnnualView()` when `_viewType == 'Annual'`; otherwise render the existing cards, filters, table, charts, breakdown, and pagination in their current order.

- [ ] **Step 2: Add annual empty-state panels**

Create titled panels for `Disbursed Amount` and `Repayment Summary`. Show the reference-style empty-state icon/message and repayment badges `Paid`, `Partial`, `Overdue`, and `Pending`.

- [ ] **Step 3: Add annual charts**

Create a Jan–Dec line chart with `Disbursed` and `Repaid` legends and zero-valued spots. Create an outstanding-balance chart with the existing loan types and zero-valued bars/axis. Keep charts responsive inside the existing scroll view.

- [ ] **Step 4: Run the focused test to verify it passes**

Run: `flutter test test/widget_test.dart`

Expected: PASS.

### Task 3: Verify the project changes

**Files:**
- Verify: `lib/Screens/Reports/loan_report.dart`
- Verify: `test/widget_test.dart`

- [ ] **Step 1: Run formatting**

Run: `dart format lib/Screens/Reports/loan_report.dart test/widget_test.dart`

- [ ] **Step 2: Run focused and project tests**

Run: `flutter test test/widget_test.dart`

Then run: `flutter test`

- [ ] **Step 3: Run static analysis**

Run: `flutter analyze --no-pub`

Expected: no new errors caused by the Annual view.

