class ExpenseCategory {
  final int id;
  final String name;
  final String description;
  final String status;
  final String created;
  final bool isActive;

  const ExpenseCategory({
    required this.id,
    required this.name,
    required this.description,
    required this.status,
    required this.created,
    this.isActive = true,
  });
}
