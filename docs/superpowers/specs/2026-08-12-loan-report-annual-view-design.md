# Loan Report Annual View Design

## Goal

Add a functional Annual view to `LoanReportScreen` while preserving the existing Summary view as the default.

## Behavior

- `Summary` remains selected initially and renders the current report content unchanged.
- Selecting `Annual` renders an annual dashboard matching the supplied reference image.
- Selecting `Summary` again restores the existing summary dashboard.
- The existing PDF, download/CSV, and refresh controls remain available in both views.

## Annual layout

The annual view contains:

1. A Disbursed Amount panel with an empty state when there is no annual data.
2. A Repayment Summary panel with Paid, Partial, Overdue, and Pending status badges and an empty state.
3. A Monthly Disbursement vs Repayment line chart with Jan–Dec labels and two series.
4. An Outstanding Balance by Loan Types chart with loan-type labels and a zero-value axis when data is empty.

The annual view uses the report's existing default zero values until a data source is connected, so its empty state matches the reference image.

## Implementation boundaries

- Keep view state local to `_LoanReportScreenState`.
- Extract annual sections into private widgets in `loan_report.dart`.
- Reuse existing theme colors and chart dependencies.
- Do not change navigation, data models, or Summary behavior.

## Testing

Add a widget test that builds the screen, confirms Summary content is initially visible, taps Annual, confirms annual section titles are visible, then taps Summary and confirms the original Summary content returns.

