class EmployeeShiftModel {
  final String id;
  final String name;
  final String department;
  String timeSlot;
  String effectiveFrom;
  bool isSelected;

  EmployeeShiftModel({
    required this.id,
    required this.name,
    required this.department,
    required this.timeSlot,
    required this.effectiveFrom,
    this.isSelected = false,
  });

  String get displayEmp => '$id - $name';
}
