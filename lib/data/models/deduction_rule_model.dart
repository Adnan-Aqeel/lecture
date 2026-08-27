class DeductionRule {
  final int id;
  final String rule;
  final String condition;
  final String value;
  final String type;
  final bool isActive;

  const DeductionRule({
    required this.id,
    required this.rule,
    required this.condition,
    required this.value,
    required this.type,
    this.isActive = true,
  });
}
