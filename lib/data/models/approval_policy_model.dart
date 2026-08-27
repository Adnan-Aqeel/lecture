enum PolicyTiming { immediate, requiresApproval }

class ApprovalPolicy {
  final String code;
  final String title;
  final bool isActive;
  final PolicyTiming timing;
  final bool docRequired;
  final String applicableRoles;
  final String ownerType;
  final String amountRange;
  final String? sla;

  const ApprovalPolicy({
    required this.code,
    required this.title,
    required this.isActive,
    required this.timing,
    this.docRequired = false,
    required this.applicableRoles,
    required this.ownerType,
    required this.amountRange,
    this.sla,
  });
}
