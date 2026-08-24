# Apply Leave Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a mobile-friendly Leave Management Apply Leave screen matching the supplied reference.

**Architecture:** Replace the empty `apply_leave.dart` screen with a self-contained local form. Stack the Quick Request card above the Leave Overview card on mobile, and update the overview prompt when an employee is selected.

**Tech Stack:** Flutter/Dart, Material 3, existing `AppConstant.primarycolor`.

## Global Constraints

- No API, database, or persistence.
- Use local employee and leave-type options only.
- Keep the form vertically scrollable and keyboard-friendly.

---

### Task 1: Implement Apply Leave screen

**Files:**
- Modify: `lib/Screens/Leave_management/apply_leave.dart`

**Interfaces:**
- Produces `ApplyLeave`, usable from Leave Management navigation.

- [ ] Build Leave Management header and subtitle.
- [ ] Add Quick Request fields for employee, dates, leave type, and reason.
- [ ] Add Leave Overview panel with employee-dependent empty prompt.
- [ ] Add local validation and Submit Request feedback.
- [ ] Format and inspect the file.

### Task 2: Verify

**Files:**
- Test: Flutter analyzer and existing test suite

- [ ] Run `flutter analyze`.
- [ ] Run `flutter test`.
- [ ] Run `git diff --check`.
