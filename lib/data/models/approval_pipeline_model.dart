class ApprovalPipeline {
  final int id;
  final String name;
  final String description;
  final int stages;
  final bool isActive;

  const ApprovalPipeline({
    required this.id,
    required this.name,
    required this.description,
    required this.stages,
    this.isActive = true,
  });
}
