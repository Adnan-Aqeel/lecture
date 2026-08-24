import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lecture/Screens/Recruitment/pipeline_board.dart';

import 'package:lecture/Screens/Reports/loan_report.dart';
import 'package:lecture/Screens/Recruitment/pipeline_builder.dart';
import 'package:lecture/Screens/Recruitment/job_positions.dart';
import 'package:lecture/Screens/Wallet_management/policies.dart';
import 'package:lecture/Screens/Loan_management/loan.dart';
import 'package:lecture/Screens/Expense_Management/approval_pipelines.dart';

void main() {
  testWidgets('switches between summary and annual loan report views',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: LoanReportScreen()),
    );

    expect(find.text('Employees with Loans'), findsOneWidget);
    expect(find.text('Disbursed Amount'), findsNothing);

    await tester.tap(find.widgetWithText(ChoiceChip, 'Annual'));
    await tester.pumpAndSettle();

    expect(find.text('Disbursed Amount'), findsOneWidget);
    expect(find.text('Repayment Summary'), findsOneWidget);
    expect(find.text('Monthly Disbursement vs Repayment'), findsOneWidget);
    expect(find.text('Outstanding Balance by Loan Types'), findsOneWidget);
    expect(find.text('Employees with Loans'), findsNothing);

    await tester.tap(find.widgetWithText(ChoiceChip, 'Summary'));
    await tester.pumpAndSettle();

    expect(find.text('Employees with Loans'), findsOneWidget);
    expect(find.text('Disbursed Amount'), findsNothing);
  });

  testWidgets('opens create pipeline dialog from New Template', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: PipelineBuilder()),
    );

    await tester.tap(find.text('New Template'));
    await tester.pumpAndSettle();

    expect(find.text('Create New Pipeline'), findsOneWidget);
    expect(find.text('Pipeline Name *'), findsOneWidget);
    expect(find.text('Description'), findsOneWidget);
    expect(find.text('Set as Default'), findsOneWidget);
    expect(find.text('Create'), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);
  });

  testWidgets('opens new job position dialog', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: JobPositions()));

    await tester.tap(find.text('New Positions'));
    await tester.pumpAndSettle();

    expect(find.text('New Job Position'), findsOneWidget);
    expect(find.text('Title *'), findsOneWidget);
    expect(find.text('Employment Type'), findsOneWidget);
    expect(find.text('Department *'), findsOneWidget);
    expect(find.text('Recruitment Pipeline'), findsOneWidget);
    expect(find.text('Create'), findsOneWidget);
  });

  testWidgets('opens add candidate dialog from pipeline board', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: PipelineBoard()));

    await tester.tap(find.text('Add New Candidate'));
    await tester.pumpAndSettle();

    expect(find.text('Add New Candidate'), findsOneWidget);
    expect(find.text('CONTACT INFORMATION'), findsOneWidget);
    expect(find.text('Name *'), findsOneWidget);
    expect(find.text('Email *'), findsOneWidget);
    expect(find.text('Upload CV (Optional)'), findsOneWidget);
    expect(find.text('Add Candidate'), findsOneWidget);
  });

  testWidgets('opens new approval policy dialog', (tester) async {
    await tester.pumpWidget(
        const MaterialApp(home: ApprovalPoliciesScreen()));

    await tester.tap(find.text('New Policy'));
    await tester.pumpAndSettle();

    expect(find.text('New Approval Policy'), findsOneWidget);
    expect(find.text('Policy Name *'), findsOneWidget);
    expect(find.text('Applicable Roles *'), findsOneWidget);
    expect(find.text('Requires Approval'), findsOneWidget);
    expect(find.text('Create Policy'), findsOneWidget);
  });

  testWidgets('opens apply for loan dialog', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoanManagement()));

    await tester.tap(find.text('Apply for Loan'));
    await tester.pumpAndSettle();

    expect(find.text('Apply for Loan'), findsOneWidget);
    expect(find.text('Applicant Type *'), findsOneWidget);
    expect(find.text('Loan Type *'), findsOneWidget);
    expect(find.text('Purpose of Loan *'), findsOneWidget);
    expect(find.text('Submit Application'), findsOneWidget);
  });

  testWidgets('opens new approval pipeline builder', (tester) async {
    await tester.pumpWidget(
        const MaterialApp(home: ApprovalPipelinesScreen()));

    await tester.tap(find.text('New Pipeline'));
    await tester.pumpAndSettle();

    expect(find.text('New Approval Pipeline'), findsOneWidget);
    expect(find.text('Pipeline Settings'), findsOneWidget);
    expect(find.text('Approval Stages'), findsOneWidget);
    expect(find.text('Add Stage'), findsOneWidget);
    expect(find.text('Create Pipeline'), findsOneWidget);
  });
}
