import 'package:lecture/data/models/models.dart';

abstract class ExpenseRepository {
  Future<List<ExpenseRequest>> getExpenseRequests();
  Future<void> createExpenseRequest(ExpenseRequest request);
  Future<List<ApprovalPipeline>> getApprovalPipelines();
  Future<List<PendingApproval>> getPendingApprovals();
  Future<List<ExpenseCategory>> getExpenseCategories();
}
