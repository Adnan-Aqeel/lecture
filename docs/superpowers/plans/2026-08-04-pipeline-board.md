# Recruitment Pipeline Board Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build the Recruitment Pipeline Board mobile screen with nine horizontally scrollable empty stage columns.

**Architecture:** Replace the placeholder `PipelineBoard` screen in `pipeline_board.dart` with a self-contained board. Use fixed-width stage columns inside a horizontal `SingleChildScrollView`, with local search/filter controls and empty candidate states.

**Tech Stack:** Flutter/Dart, Material 3, existing `AppConstant.primarycolor`.

## Global Constraints

- No API, database, drag-and-drop persistence, or candidate records yet.
- Show all nine stages: Applied, CV Screening, Interview Round 1, Interview Round 2, Technical Assessment, HR Review, Offer Sent, Hired, Rejected.
- The board must scroll horizontally so the first six are visible initially and the final three can be reached by scrolling.

---

### Task 1: Implement pipeline board

**Files:**
- Modify: `lib/Screens/Recruitment/pipeline_board.dart`

**Interfaces:**
- Produces `PipelineBoard`, usable from Recruitment navigation.

- [ ] Build header actions, pipeline selector, search field, and department/job filters.
- [ ] Define the nine stage configurations and render fixed-width columns horizontally.
- [ ] Add empty drop-zone content and zero count badges to every column.
- [ ] Add local field interactions and placeholder actions for configure/import/add candidate.
- [ ] Format the file and inspect the diff.

### Task 2: Verify

**Files:**
- Test: Flutter analyzer and existing test suite

- [ ] Run `flutter analyze`.
- [ ] Run `flutter test`.
- [ ] Run `git diff --check`.
