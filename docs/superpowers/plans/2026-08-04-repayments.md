# Loan Repayments Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a mobile-friendly Loan Repayments screen matching the supplied reference.

**Architecture:** Keep the screen self-contained in `repayments.dart` with zero local repayment records. Use search/status filters, six summary metric cards, refresh feedback, and an empty repayment state.

**Tech Stack:** Flutter/Dart, Material 3, existing `AppConstant.primarycolor`.

## Global Constraints

- No API, database, or persistence.
- Summary values start at zero as shown in the reference.
- Use a vertically scrollable mobile layout.

---

### Task 1: Implement Loan Repayments screen

**Files:**
- Modify: `lib/Screens/Loan_management/repayments.dart`

**Interfaces:**
- Produces `Repayments`, usable from Loan Management navigation.

- [ ] Build header and refresh action.
- [ ] Add local search and status filters.
- [ ] Add six zero-value summary cards.
- [ ] Add empty repayment state and placeholder refresh feedback.
- [ ] Format and inspect the file.

### Task 2: Verify

**Files:**
- Test: Flutter analyzer and existing test suite

- [ ] Run `flutter analyze`.
- [ ] Run `flutter test`.
- [ ] Run `git diff --check`.
