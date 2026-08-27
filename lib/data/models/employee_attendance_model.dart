enum AttendanceStatus { present, wfh, absent, leave }

class EmployeeAttendance {
  final String id;
  final String name;
  AttendanceStatus status;
  String? checkIn;
  String? checkOut;

  EmployeeAttendance({
    required this.id,
    required this.name,
    required this.status,
    this.checkIn,
    this.checkOut,
  });

  String get displayEmp => '$id - $name';
}
