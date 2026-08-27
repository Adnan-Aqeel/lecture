class PayrollApprovalItem {
  final int id;
  final String name;
  final double grossSalary;
  final double totalDeductions;
  final double netAmount;
  String status;
  bool isSelected;

  PayrollApprovalItem({
    required this.id,
    required this.name,
    required this.grossSalary,
    required this.totalDeductions,
    required this.netAmount,
    required this.status,
    this.isSelected = false,
  });
}
