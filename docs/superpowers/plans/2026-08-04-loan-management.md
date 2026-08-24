# Loan Management Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a mobile-friendly Loan Management screen matching the supplied empty-state reference.

**Architecture:** Keep the screen self-contained in `loan.dart` with local zero loan records. Use search and status state, and render separate Employee Loans and Non-Employee Loans sections as mobile empty-state cards.

**Tech Stack:** Flutter/Dart, Material 3, existing `AppConstant.primarycolor`.

## Global Constraints

- No API, database, or persistence.
- Start with zero employee and non-employee loans to match the reference.
- Use a vertically scrollable mobile layout instead of desktop tables.

---

### Task 1: Implement Loan Management screen

**Files:**
- Modify: `lib/Screens/Loan_management/loan.dart`

**Interfaces:**
- Produces `LoanManagement`, usable from Loan Management navigation.

- [ ] Build header and Apply for Loan action.
- [ ] Add local search, status filter, and refresh controls.
- [ ] Add Employee Loans and Non-Employee Loans empty sections.
- [ ] Add placeholder feedback for actions.
- [ ] Format and inspect the file.

### Task 2: Verify

**Files:**
- Test: Flutter analyzer and existing test suite

- [ ] Run `flutter analyze`.
- [ ] Run `flutter test`.
- [ ] Run `git diff --check`.
