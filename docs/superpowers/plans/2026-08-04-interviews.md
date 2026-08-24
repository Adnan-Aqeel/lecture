# Interviews Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a mobile-friendly Interview Schedules screen matching the supplied empty-state reference.

**Architecture:** Replace the current placeholder in `interviews.dart` with a local empty interview schedule screen. Use a status dropdown, responsive empty state, and a Schedule Interview action with placeholder feedback.

**Tech Stack:** Flutter/Dart, Material 3, existing `AppConstant.primarycolor`.

## Global Constraints

- No API, database, or persistence.
- Start with zero interview records to match the reference.
- Adapt the desktop table into a mobile empty-state/card-ready layout.

---

### Task 1: Implement Interview Schedules screen

**Files:**
- Modify: `lib/Screens/Recruitment/interviews.dart`

**Interfaces:**
- Produces `Interviews`, usable from Recruitment navigation.

- [ ] Build the title header and Schedule Interview action.
- [ ] Add status filter with local state.
- [ ] Add empty calendar state and explanatory copy.
- [ ] Add placeholder feedback for scheduling.
- [ ] Format and inspect the file.

### Task 2: Verify

**Files:**
- Test: Flutter analyzer and existing test suite

- [ ] Run `flutter analyze`.
- [ ] Run `flutter test`.
- [ ] Run `git diff --check`.
