class AttendanceRecord {
  final int id;
  final String name;
  final String email;
  final String department;
  final int totalDays;
  final int daysPresent;
  final int daysAbsent;
  final int lateDays;
  final int leavesTaken;
  final int holidayWorkedDays;
  final int holidayWorkedHours;
  final int expectedHours;
  final int totalHoursWorked;

  const AttendanceRecord({
    required this.id,
    required this.name,
    required this.email,
    required this.department,
    required this.totalDays,
    required this.daysPresent,
    required this.daysAbsent,
    required this.lateDays,
    required this.leavesTaken,
    required this.holidayWorkedDays,
    required this.holidayWorkedHours,
    required this.expectedHours,
    required this.totalHoursWorked,
  });
}
