import 'package:lecture/domain/repositories/expense_repository.dart';
import 'package:lecture/data/models/models.dart';

class MockExpenseRepository implements ExpenseRepository {
  @override
  Future<List<ExpenseRequest>> getExpenseRequests() async => [
    const ExpenseRequest(id: 1, title: 'Office Supplies', amount: 2500, status: 'Pending', priority: 'Medium', category: 'Office', date: '15 Aug 2026'),
    const ExpenseRequest(id: 2, title: 'Client Meeting', amount: 5000, status: 'Approved', priority: 'High', category: 'Travel', date: '12 Aug 2026'),
    const ExpenseRequest(id: 3, title: 'Software License', amount: 15000, status: 'Rejected', priority: 'Low', category: 'IT', date: '10 Aug 2026'),
    const ExpenseRequest(id: 4, title: 'Team Lunch', amount: 8000, status: 'Pending', priority: 'Medium', category: 'Food', date: '18 Aug 2026'),
    const ExpenseRequest(id: 5, title: 'Travel Expense', amount: 12000, status: 'Approved', priority: 'High', category: 'Travel', date: '05 Aug 2026'),
  ];

  @override
  Future<void> createExpenseRequest(ExpenseRequest request) async {}

  @override
  Future<List<ApprovalPipeline>> getApprovalPipelines() async => [
    const ApprovalPipeline(id: 1, name: 'Standard Expense', description: 'Default pipeline for expenses under 10K', stages: 3),
    const ApprovalPipeline(id: 2, name: 'High Value', description: 'For expenses above 10K', stages: 4),
    const ApprovalPipeline(id: 3, name: 'Travel Only', description: 'Travel and accommodation expenses', stages: 2),
    const ApprovalPipeline(id: 4, name: 'IT Purchases', description: 'Software and hardware purchases', stages: 3),
  ];

  @override
  Future<List<PendingApproval>> getPendingApprovals() async => [
    PendingApproval(id: 1, title: 'Office Supplies', requestedBy: 'Ali Ahmed', amount: 2500, date: '15 Aug 2026', status: 'Pending'),
    PendingApproval(id: 2, title: 'Team Lunch', requestedBy: 'Zain Malik', amount: 8000, date: '18 Aug 2026', status: 'Pending'),
    PendingApproval(id: 3, title: 'Client Visit', requestedBy: 'Hamza Khan', amount: 3500, date: '20 Aug 2026', status: 'Pending'),
  ];

  @override
  Future<List<ExpenseCategory>> getExpenseCategories() async => [
    const ExpenseCategory(id: 1, name: 'Office Supplies', description: 'General office items and stationery', status: 'Active', created: '01 Jan 2026'),
    const ExpenseCategory(id: 2, name: 'Travel', description: 'Business travel and accommodation', status: 'Active', created: '01 Jan 2026'),
    const ExpenseCategory(id: 3, name: 'Food', description: 'Meals and refreshments', status: 'Active', created: '01 Jan 2026'),
    const ExpenseCategory(id: 4, name: 'IT', description: 'Software and hardware purchases', status: 'Active', created: '01 Jan 2026'),
  ];
}
