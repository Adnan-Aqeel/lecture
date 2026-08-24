# Record Cards to Consistent DataTables Implementation Plan

> **For agentic workers:** Execute this plan task-by-task with review checkpoints.

**Goal:** Convert record-list cards in Magnitude Flutter screens to the project’s existing consistent DataTable presentation without changing record data, actions, or business logic.

**Architecture:** Reuse each screen’s existing state, filtering, loading, empty, and action logic. Replace only the record-list builder with a horizontally scrollable styled DataTable matching the established report/management table pattern; retain summary cards, filter cards, dialogs, configuration panels, and dashboard cards.

**Tech Stack:** Flutter/Dart, Material DataTable, existing project theme/constants.

## Global Constraints

- Do not change models, API calls, filtering behavior, labels, values, permissions, or actions.
- Do not convert summary/statistics, filter, dialog, configuration, pipeline, or dashboard cards.
- Preserve loading and empty states.
- Use the same table styling already present in the project, including header/text colors, borders, spacing, and action-cell behavior.
- Run `dart format` and `flutter analyze` after edits; run the existing Flutter tests.

## Task 1: Inventory and reference table

**Files:**
- Modify: affected `lib/Screens/**/*.dart` files identified by record-list card builders.
- Reference: existing DataTable implementations in Reports, Payroll, Attendance, Administration, and Expense Management screens.

- [ ] Identify every card builder that renders a collection of records and exclude non-record cards.
- [ ] Record the fields and actions currently rendered by each selected card.
- [ ] Select the most consistent existing DataTable wrapper/style as the visual baseline.

## Task 2: Convert management record-list screens

**Files:**
- Modify: selected Administration, Assets_management, Attendance, Document_management, Employee_management, Expense_Management, Leave_management, Loan_management, Recruitment, and Wallet_management Dart screens.

- [ ] Replace each selected record-card list with a DataTable while preserving the current collection, ordering, filters, empty state, and callbacks.
- [ ] Keep every existing record field represented as a column; use an action column for existing buttons/icons.
- [ ] Wrap wide tables in the existing horizontal-scroll/container pattern and preserve responsive behavior.
- [ ] Remove only obsolete card-builder code made unreachable by the conversion.

## Task 3: Convert remaining payroll/KPI record-card lists

**Files:**
- Modify: selected Payroll_management and Kpi_management screens that contain record cards, excluding summary cards and non-list panels.

- [ ] Convert record cards to the same DataTable structure and style.
- [ ] Preserve row-level actions, status widgets, and evaluation/approval interactions.
- [ ] Verify that existing DataTable screens remain unchanged except where needed for visual consistency.

## Task 4: Verification and cleanup

**Files:**
- Modify: only files required by analyzer/formatting corrections.

- [ ] Run `dart format` on changed Dart files.
- [ ] Run `flutter analyze` and fix only issues caused by the migration.
- [ ] Run `flutter test`.
- [ ] Review the diff to confirm no data/model/API changes and no unrelated files were modified.

