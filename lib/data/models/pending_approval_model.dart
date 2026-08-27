class PendingApproval {
  final int id;
  final String title;
  final String requestedBy;
  final double amount;
  final String date;
  final String status;
  bool isSelected;

  PendingApproval({
    required this.id,
    required this.title,
    required this.requestedBy,
    required this.amount,
    required this.date,
    required this.status,
    this.isSelected = false,
  });
}
