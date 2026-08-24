# Document Assignments Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a mobile-friendly Document Assignments screen matching the supplied reference.

**Architecture:** Keep the screen self-contained in `assignment.dart` with three local sample assignments matching the image. Use a status filter and render each assignment as a mobile card with unassign actions.

**Tech Stack:** Flutter/Dart, Material 3, existing `AppConstant.primarycolor`.

## Global Constraints

- No API, database, or persistence.
- Initialize with the three pending mandatory `bnm` v1.0 assignments shown in the reference.
- Use a vertically scrollable mobile layout instead of the desktop table.

---

### Task 1: Implement Document Assignments screen

**Files:**
- Modify: `lib/Screens/Document_management/assignment.dart`

**Interfaces:**
- Produces `DocumentAssignments`, usable from Document Management navigation.

- [ ] Build header and Assign Document action.
- [ ] Add status filter and assignment count.
- [ ] Render employee assignment cards with metadata and badges.
- [ ] Add local unassign action and confirmation.
- [ ] Format and inspect the file.

### Task 2: Verify

**Files:**
- Test: Flutter analyzer and existing test suite

- [ ] Run `flutter analyze`.
- [ ] Run `flutter test`.
- [ ] Run `git diff --check`.
