class PayrollEmployee {
  final int sno;
  final String employeeId;
  final String name;
  final String doj;
  final int monthDays;
  final int workingDays;
  final int present;
  final int absent;
  final int paidDays;
  final int unpaidDays;
  final int expectedHours;
  final int actualHours;
  final int extraHours;
  final double basicSalary;
  final double salaryPerDay;
  final double salaryPerHour;
  final double houseAllow;
  final double medicalAllow;
  final double travelAllow;

  const PayrollEmployee({
    required this.sno,
    required this.employeeId,
    required this.name,
    required this.doj,
    required this.monthDays,
    required this.workingDays,
    required this.present,
    required this.absent,
    required this.paidDays,
    required this.unpaidDays,
    required this.expectedHours,
    required this.actualHours,
    required this.extraHours,
    required this.basicSalary,
    required this.salaryPerDay,
    required this.salaryPerHour,
    required this.houseAllow,
    required this.medicalAllow,
    required this.travelAllow,
  });
}
