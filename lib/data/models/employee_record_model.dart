class EmployeeRecord {
  final int id;
  final String name;
  final String department;
  final String joiningDate;
  final String status;
  final int presentDays;
  final String email;
  final String phone;
  final int totalWorkingDays;
  final int attendancePercentage;
  final int attendanceDays;
  final int annualLeaveBalance;
  final int leaveDays;
  final int assignedAssets;
  final int loans;

  const EmployeeRecord({
    required this.id,
    required this.name,
    required this.department,
    required this.joiningDate,
    required this.status,
    required this.presentDays,
    required this.email,
    required this.phone,
    this.totalWorkingDays = 0,
    this.attendancePercentage = 0,
    this.attendanceDays = 0,
    this.annualLeaveBalance = 0,
    this.leaveDays = 0,
    this.assignedAssets = 0,
    this.loans = 0,
  });
}
