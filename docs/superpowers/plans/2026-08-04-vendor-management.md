# Vendor Management Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a mobile-friendly local Vendor Management screen matching the supplied design.

**Architecture:** Keep the feature self-contained in `vendor_management.dart` with an in-memory vendor model and list. Use a search/filter toolbar, responsive cards, and one validated bottom-sheet form for add/edit.

**Tech Stack:** Flutter/Dart, Material 3, existing `AppConstant.primarycolor`.

## Global Constraints

- No API, database, or persistence; data resets when the app restarts.
- Start with an empty vendor list to match the reference image.
- Keep the layout mobile-friendly with no horizontal scrolling.

---

### Task 1: Implement vendor management UI and local CRUD

**Files:**
- Modify: `lib/Screens/Administration/vendor_management.dart`

**Interfaces:**
- Produces `VendorManagement`, usable by the existing Administration navigation.
- Keeps the local `Vendor` model and form widgets private to this file.

- [ ] Add the vendor model and local list state.
- [ ] Build AppBar, search field, show-inactive filter, empty state, and vendor cards.
- [ ] Add validated form fields for name, code, contact, phone, email, tax number, and active status.
- [ ] Add edit/delete actions and delete confirmation.
- [ ] Format the file and inspect the diff.

### Task 2: Verify the screen

**Files:**
- Test: Flutter analyzer and existing test suite

- [ ] Run `flutter analyze`.
- [ ] Run `flutter test`.
- [ ] Run `git diff --check`.
