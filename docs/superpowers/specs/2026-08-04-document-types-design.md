# Document Types Mobile Screen Design

## Goal

Create a mobile-friendly Document Types administration screen in `lib/Screens/Administration/document_type.dart`, matching the provided desktop reference while adapting the layout for phone screens. The feature will use local in-memory state only; no API or persistence is required yet.

## User experience

- Show an AppBar titled `Document Types` with a short subtitle where space allows.
- Show an `Add Document Type` action in the AppBar and in the empty state.
- When there are no records, show a document icon, `No document types found`, and an instruction to add one.
- When records exist, show each record as a responsive card rather than a desktop table.
- Each card displays name, description, maximum size, allowed file types, status, and created date.
- Each card provides Edit and Delete actions.
- Add and Edit use the same form in a modal bottom sheet or dialog. The form contains name, description, maximum size, allowed file types, and active/inactive status.
- Delete requires confirmation.

## Data model and state

Use a local `DocumentType` model with an in-memory list owned by the screen. Suggested fields:

- `id`
- `name`
- `description`
- `maxSizeMb`
- `allowedTypes`
- `isActive`
- `createdDate`

The list starts empty so the first launch matches the supplied screenshot. Changes are immediately reflected in the screen and are lost when the app process is restarted.

## Visual and interaction design

- Reuse the project’s existing `AppConstant.primarycolor` and Material styling.
- Use a light background, cyan primary actions, rounded cards, and clear status chips.
- Use validation for required name and valid positive maximum size.
- Prevent accidental dismissal while the form has unsaved input only when practical; otherwise the form may be dismissed normally.
- Keep controls touch-friendly and avoid horizontal scrolling.

## Testing and verification

- Run `dart format` on the changed Dart file.
- Run `flutter analyze` and fix issues introduced by this screen.
- Run the available Flutter tests or at minimum verify the project analyzes successfully.
- Manually verify empty state, add, edit, delete confirmation, validation, and keyboard-friendly scrolling on a narrow viewport.

## Scope exclusions

- No API calls, database, authentication changes, file upload handling, or persistence.
- No unrelated refactoring of the existing administration screens.
