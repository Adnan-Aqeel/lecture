class PayrollHistoryRecord {
  final int id;
  final String period;
  final String dateRange;
  final String status;
  final int employees;
  final double totalBasic;
  final double totalAllowances;
  final double totalEarnings;
  final double totalDeductions;
  final double netSalary;

  const PayrollHistoryRecord({
    required this.id,
    required this.period,
    required this.dateRange,
    required this.status,
    required this.employees,
    required this.totalBasic,
    required this.totalAllowances,
    required this.totalEarnings,
    required this.totalDeductions,
    required this.netSalary,
  });
}
