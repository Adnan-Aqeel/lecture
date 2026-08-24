# Assets Categories Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a responsive Flutter categories screen with local in-memory add, edit, and delete interactions.

**Architecture:** Keep the feature self-contained in `categories.dart` as a `StatefulWidget`. Use a local `List<String>` for categories, a reusable modal form for add/edit, and confirmation dialog for deletion. Reuse `AppConstant.primarycolor` and Flutter Material components.

**Tech Stack:** Flutter, Dart, Material 3.

## Global Constraints

- Initial data is exactly one category: `laptop`.
- Data is in-memory only and resets when the app restarts.
- No new dependencies, database, API, provider, or unrelated screen changes.
- Match the supplied cyan/white categories reference and keep the table horizontally usable on narrow screens.

---

### Task 1: Implement the categories screen and interactions

**Files:**
- Modify: `lib/Screens/Assets_management/categories.dart`

**Interfaces:**
- Produces a public `CategoriesScreen` widget suitable for use as a route/home screen.
- Internal state owns `List<String> _categories` and exposes add, edit, and delete behavior through UI actions.

- [ ] **Step 1: Build the page shell**

Create a `StatefulWidget` named `CategoriesScreen`, initialize `_categories` with `['laptop']`, and build the white page with the cyan left accent, tag icon, title, subtitle, and add button.

- [ ] **Step 2: Build the responsive table and footer**

Render the category rows inside a rounded card with number, name, edit, and delete columns. Add the page-size selector, record summary, and pagination controls shown in the reference. Wrap the table content in horizontal scrolling for narrow widths.

- [ ] **Step 3: Add the reusable add/edit dialog**

Implement a private dialog helper that accepts an optional existing index, pre-fills the text field for edit, validates trimmed non-empty names, rejects duplicates except for the currently edited value, and updates `_categories` with `setState` after save.

- [ ] **Step 4: Add delete confirmation**

Implement a confirmation dialog for each row’s delete action and remove the selected category only after the user confirms.

- [ ] **Step 5: Format and analyze**

Run:

```text
dart format lib/Screens/Assets_management/categories.dart
flutter analyze
```

Expected: formatting completes and analysis reports no errors for the project.

- [ ] **Step 6: Run tests**

Run:

```text
flutter test
```

Expected: the existing test suite passes.
