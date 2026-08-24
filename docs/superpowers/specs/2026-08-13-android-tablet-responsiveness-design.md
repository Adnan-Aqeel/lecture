# Android and Tablet Responsiveness Design

## Goal

Make the Magnitude Flutter app reliable on Android phones and tablets by removing layout overflows and adapting spacing, grids, forms, dialogs, and tables to available width without changing business logic, navigation, or displayed data.

## Scope

- Target platforms: Android phones and Android tablets only.
- Small phone layouts use one-column content and wrapped actions.
- Wider phone/tablet layouts may use two- or three-column grids where the existing content supports it.
- DataTables remain horizontally scrollable when their columns cannot fit safely.
- Existing dark theme, light theme, and shimmer wrappers remain supported.
- No API, model, navigation, permission, or business-rule changes.

## Responsive breakpoints

- Compact phone: width below 360 logical pixels.
- Phone: width from 360 through 599 logical pixels.
- Tablet: width 600 logical pixels or wider.

Use `LayoutBuilder` constraints for local layout decisions and `MediaQuery` only for screen-level insets, keyboard/view-insets, and safe areas. Avoid device-name checks and fixed assumptions about Android models.

## Design rules

### Content containers

- Use screen padding of 12–16 px on phones and 20–24 px on tablets.
- Constrain wide tablet content with a sensible maximum width where centered presentation improves readability.
- Replace fixed widths that can exceed constraints with `Expanded`, `Flexible`, `ConstrainedBox`, or width fractions bounded by minimum/maximum values.

### Rows, buttons, and filters

- Replace non-wrapping action rows with `Wrap` or breakpoint-specific columns.
- Keep primary actions visible and move secondary actions below them on compact widths.
- Give form fields full available width on phones; use two columns only when each field remains usable on tablets.
- Preserve existing labels and callbacks.

### Grids and cards

- Use one column below 600 px, two columns on normal tablets, and three columns only where card content remains readable.
- Calculate grid item widths from constraints rather than hard-coded screen widths.
- Preserve summary-card meaning; responsiveness must not convert or remove content.

### Tables

- Keep each DataTable inside a horizontal `SingleChildScrollView` when required.
- Preserve all columns and actions.
- Use compact spacing/text only when needed for phone readability; do not truncate values that users need to inspect.

### Dialogs and forms

- Bound dialogs to available width and height using `ConstrainedBox`/`MediaQuery`.
- Wrap dialog bodies in `SingleChildScrollView` with keyboard insets.
- Ensure bottom sheets use safe areas and do not exceed tablet width unnecessarily.

## Implementation phases

1. Audit and fix dashboard, drawer, and shared layout patterns.
2. Fix management screens and forms/dialogs.
3. Fix reports, DataTables, filters, and action toolbars.
4. Test compact phone, normal phone, and tablet constraints; resolve overflow warnings and run analyzer/tests.

## Verification

- Run `dart format` on changed files.
- Run `flutter analyze`.
- Run `flutter test`.
- Inspect representative screens at 320 px, 360 px, 414 px, 600 px, and 800 px logical widths using Android emulators or Flutter test constraints where available.
- Confirm no `RenderFlex overflowed` errors and confirm light/dark themes plus shimmer behavior remain intact.
