class ExpenseRequest {
  final int id;
  final String title;
  final double amount;
  final String status;
  final String priority;
  final String category;
  final String date;

  const ExpenseRequest({
    required this.id,
    required this.title,
    required this.amount,
    required this.status,
    required this.priority,
    required this.category,
    required this.date,
  });
}
