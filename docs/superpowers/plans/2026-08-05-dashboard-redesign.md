# Executive Dashboard Redesign Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace the old fixed dashboard layout with a responsive Flutter dashboard matching the supplied Magnitude HTML design.

**Architecture:** Keep navigation in `dashboard_screen.dart` but rebuild the body around reusable local dashboard cards. Use zero/placeholder metrics where no API data exists, responsive wrapping for KPI cards, and vertical mobile stacking for the HTML sections.

**Tech Stack:** Flutter/Dart, Material 3, existing project screens and `AppConstant.primarycolor`.

## Global Constraints

- No API or database integration is added.
- Existing feature screens remain reachable from the drawer.
- The dashboard must be usable on narrow mobile screens without horizontal overflow.

---

### Task 1: Replace dashboard presentation

**Files:**
- Modify: `lib/Screens/Dashboard/dashboard_screen.dart`

**Interfaces:**
- Preserves `DashboardScreen` as the app’s dashboard entry point.

- [ ] Rebuild the AppBar and navigation drawer with the existing feature routes.
- [ ] Add the HTML-inspired welcome/date header and KPI cards.
- [ ] Add attendance, recruitment, financial, interview, action center, live attendance, events, and clearance sections.
- [ ] Add local tab interactions and refresh feedback.
- [ ] Format and inspect the file.

### Task 2: Verify

**Files:**
- Test: Flutter analyzer and existing test suite

- [ ] Run `flutter analyze`.
- [ ] Run `flutter test`.
- [ ] Run `git diff --check`.
