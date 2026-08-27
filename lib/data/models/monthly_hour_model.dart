class MonthlyHourModel {
  final String id;
  final String name;
  final String department;
  final double totalHours;
  final double expectedHours;
  final double incompleteHours;

  MonthlyHourModel({
    required this.id,
    required this.name,
    required this.department,
    required this.totalHours,
    required this.expectedHours,
    required this.incompleteHours,
  });

  String get displayEmp => '$id - $name';
}
