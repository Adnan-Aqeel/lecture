# Pipeline Builder Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a mobile-friendly Pipeline Builder screen matching the supplied reference image.

**Architecture:** Replace the placeholder `PipelineBuilder` screen with a self-contained local template view. Show the pipeline template card and configuration panel stacked on small screens, with local selection and action feedback.

**Tech Stack:** Flutter/Dart, Material 3, existing `AppConstant.primarycolor`.

## Global Constraints

- No API, database, or persistence.
- Start with the Standard Recruitment Pipeline template shown in the reference.
- Keep the screen mobile-friendly and vertically scrollable.

---

### Task 1: Implement Pipeline Builder

**Files:**
- Modify: `lib/Screens/Recruitment/pipeline_builder.dart`

**Interfaces:**
- Produces `PipelineBuilder`, usable from Recruitment navigation.

- [ ] Build the title header and Open Board/New Template actions.
- [ ] Render the Standard Recruitment Pipeline card with Default badge, 9 stages, and 0 positions.
- [ ] Render the empty configuration panel with back-arrow prompt.
- [ ] Add local action feedback and deactivate confirmation.
- [ ] Format and inspect the file.

### Task 2: Verify

**Files:**
- Test: Flutter analyzer and existing test suite

- [ ] Run `flutter analyze`.
- [ ] Run `flutter test`.
- [ ] Run `git diff --check`.
