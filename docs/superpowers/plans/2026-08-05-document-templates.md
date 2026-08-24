# Document Templates Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a mobile-friendly Document Templates screen matching the supplied reference.

**Architecture:** Create the correctly named `templates.dart` screen with one local template matching the image. Use local search/category filters and render the template as a responsive card with edit/delete actions.

**Tech Stack:** Flutter/Dart, Material 3, existing `AppConstant.primarycolor`.

## Global Constraints

- No API, database, or persistence.
- Initialize with the sample `bnm` HR template shown in the reference.
- Keep the layout vertically scrollable and mobile-friendly.

---

### Task 1: Implement Document Templates screen

**Files:**
- Create: `lib/Screens/Document_management/templates.dart`

**Interfaces:**
- Produces `DocumentTemplates`, usable from Document Management navigation.

- [ ] Build header and New Template action.
- [ ] Add search and category filters with local state.
- [ ] Render the Published HR `bnm` template card with version metadata.
- [ ] Add local edit/delete actions and delete confirmation.
- [ ] Format and inspect the file.

### Task 2: Verify

**Files:**
- Test: Flutter analyzer and existing test suite

- [ ] Run `flutter analyze`.
- [ ] Run `flutter test`.
- [ ] Run `git diff --check`.
