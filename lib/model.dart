class UserModel {
  int id;
  String name;
  String email;
  String phone;
  String department;
  String routine;
  String designation;
  String status;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.department,
    required this.routine,
    required this.designation,
    required this.status,
  });
}

class HolidayModel {
  final String fromDate;
  final String toDate;
  final String holidayName;
  HolidayModel({
    required this.fromDate,
    required this.toDate,
    required this.holidayName,
  });
}
