# Job Positions Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a mobile-friendly Job Positions screen matching the supplied empty-state reference.

**Architecture:** Keep the screen self-contained in `job_positions.dart` with local filter state and an empty positions list. Use a vertically scrollable mobile layout with a responsive header, search, dropdown filters, and empty state.

**Tech Stack:** Flutter/Dart, Material 3, existing `AppConstant.primarycolor`.

## Global Constraints

- No API, database, or persistence.
- Start with zero positions to match the reference image.
- Keep the layout mobile-friendly and vertically scrollable.

---

### Task 1: Implement Job Positions screen

**Files:**
- Modify: `lib/Screens/Recruitment/job_positions.dart`

**Interfaces:**
- Produces `JobPositions`, usable from Recruitment navigation.

- [ ] Build header and New Position action.
- [ ] Add search, department, and status filters with local state.
- [ ] Add centered “No positions found.” state.
- [ ] Add placeholder feedback for New Position.
- [ ] Format and inspect the file.

### Task 2: Verify

**Files:**
- Test: Flutter analyzer and existing test suite

- [ ] Run `flutter analyze`.
- [ ] Run `flutter test`.
- [ ] Run `git diff --check`.
