# Assets Management Categories Design

## Goal

Implement `lib/Screens/Assets_management/categories.dart` as a responsive Flutter categories screen matching the supplied reference image, with local in-memory add, edit, and delete behavior.

## UI

- Use a white page with a cyan accent header.
- Header includes a tag icon, `Categories` title, subtitle `Manage asset and expense categories`, and an `Add New Category` button.
- Display categories in a rounded table/card with columns for row number, category name, and actions.
- Provide edit and delete icon buttons for each row.
- Include a footer showing the page-size selector, record summary, and pagination controls styled to match the reference.
- Use `AppConstant.primarycolor` for the primary cyan accent and Material icons for controls.
- Keep the layout usable on narrow screens by allowing the table content to scroll horizontally where necessary.

## State and interactions

- The screen is stateful and initializes with one category: `laptop`.
- Add opens a modal form with a category-name field.
- Edit opens the same form prefilled with the selected category.
- Reject blank names and duplicate names with inline validation.
- Delete opens a confirmation dialog and removes the category only after confirmation.
- All data is stored in widget memory and resets when the app restarts.

## Boundaries

- No database, API, provider, or new package is required.
- Navigation and other asset-management screens are not changed.

## Verification

- Run `dart format` on the changed Dart file.
- Run `flutter analyze`.
- Run the existing test suite with `flutter test`.
- Confirm the screen builds and the add/edit/delete flows are represented by the implementation.
