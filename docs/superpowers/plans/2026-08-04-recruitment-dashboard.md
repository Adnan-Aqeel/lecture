# Recruitment Dashboard Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a mobile Recruitment & Onboarding dashboard matching the supplied zero-value reference image.

**Architecture:** Keep the dashboard self-contained in `dashboard_recruitment.dart`. Use fixed local zero metrics and pipeline stages, with stacked responsive cards and simple local filter/configure interactions.

**Tech Stack:** Flutter/Dart, Material 3, existing `AppConstant.primarycolor`.

## Global Constraints

- No API, database, or persistence.
- Initial metrics and pipeline counts remain zero/empty as shown in the reference.
- Use a mobile-friendly vertical layout with no horizontal scrolling.

---

### Task 1: Implement Recruitment dashboard

**Files:**
- Modify: `lib/Screens/Recruitment/dashboard_recruitment.dart`

**Interfaces:**
- Produces `RecruitmentDashboard`, usable from Recruitment navigation.

- [ ] Add header, pipeline board/configure actions, and position filter.
- [ ] Add six KPI metric cards with the reference labels and zero values.
- [ ] Add pipeline stage distribution cards with progress bars and percentages.
- [ ] Add local dropdown/filter behavior and responsive scrolling layout.
- [ ] Format and inspect the file.

### Task 2: Verify

**Files:**
- Test: Flutter analyzer and existing test suite

- [ ] Run `flutter analyze`.
- [ ] Run `flutter test`.
- [ ] Run `git diff --check`.
