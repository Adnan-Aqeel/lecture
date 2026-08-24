# Document Types Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a local, mobile-friendly Document Types administration screen matching the supplied reference.

**Architecture:** Keep the screen self-contained in `document_type.dart` with a local `DocumentType` model and in-memory list. Render an empty state or responsive cards, and reuse one validated bottom-sheet form for add/edit operations.

**Tech Stack:** Flutter/Dart, Material 3, existing `AppConstant.primarycolor`.

## Global Constraints

- No API calls, database, authentication changes, file upload handling, or persistence.
- The initial list is empty so the first launch matches the screenshot.
- Keep controls touch-friendly and avoid horizontal scrolling.

---

### Task 1: Implement the Document Types screen

**Files:**
- Modify: `lib/Screens/Administration/document_type.dart`

**Interfaces:**
- Produces `DocumentTypeScreen`, usable by the existing administration navigation.
- Keeps the local `DocumentType` model private to this screen file.

- [ ] Add the `DocumentType` model and state fields for an empty in-memory list.
- [ ] Build the AppBar, empty state, and responsive card list with Material styling.
- [ ] Add the validated add/edit bottom sheet with name, description, max size, allowed types, and status fields.
- [ ] Add edit and delete actions, including delete confirmation.
- [ ] Run `dart format lib/Screens/Administration/document_type.dart`.

### Task 2: Verify the implementation

**Files:**
- Test: existing Flutter analyzer and test suite

- [ ] Run `flutter analyze` and resolve issues introduced by the screen.
- [ ] Run `flutter test` and confirm the project tests pass or record unrelated existing failures.
- [ ] Inspect the final diff and confirm only the intended implementation and plan/spec files are involved.
