import 'package:lecture/data/models/models.dart';

abstract class PayrollRepository {
  Future<List<PayrollEmployee>> getPayrollEmployees();
  Future<List<PayrollApprovalItem>> getPayrollApprovals();
  Future<List<PayrollHistoryRecord>> getPayrollHistory();
  Future<List<DeductionRule>> getDeductionRules();
}
