import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lecture/appcolor.dart';
import 'package:lecture/widgets/shimmer_widgets.dart';

/// ----------------------------------------------------------------------
/// MODEL
/// ----------------------------------------------------------------------
enum PolicyTiming { immediate, requiresApproval }

class ApprovalPolicy {
  final String code; // e.g. "P1"
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

/// ----------------------------------------------------------------------
/// SCREEN
/// ----------------------------------------------------------------------
class ApprovalPoliciesScreen extends StatefulWidget {
  const ApprovalPoliciesScreen({super.key});

  @override
  State<ApprovalPoliciesScreen> createState() => _ApprovalPoliciesScreenState();
}

class _ApprovalPoliciesScreenState extends State<ApprovalPoliciesScreen> {
  final _policyNameController = TextEditingController();
  final _priorityController = TextEditingController(text: '10');
  final _rolesController = TextEditingController();
  final _minAmountController = TextEditingController();
  final _maxAmountController = TextEditingController();
  final _slaController = TextEditingController();

  @override
  void dispose() {
    _policyNameController.dispose();
    _priorityController.dispose();
    _rolesController.dispose();
    _minAmountController.dispose();
    _maxAmountController.dispose();
    _slaController.dispose();
    super.dispose();
  }

  // Sample data matching the screenshot. Replace with your API/DB source.
  final List<ApprovalPolicy> _policies = const [
    ApprovalPolicy(
      code: 'P1',
      title: 'Exec Immediate',
      isActive: true,
      timing: PolicyTiming.immediate,
      applicableRoles: 'SuperAdmin, CEO, CTO',
      ownerType: 'All',
      amountRange: '— — —',
    ),
    ApprovalPolicy(
      code: 'P5',
      title: 'Finance Document Required',
      isActive: true,
      timing: PolicyTiming.requiresApproval,
      docRequired: true,
      applicableRoles: 'Accounts, Finance, Finance Manager',
      ownerType: 'All',
      amountRange: '— — —',
      sla: '72h',
    ),
    ApprovalPolicy(
      code: 'P10',
      title: 'Admin Low Value',
      isActive: true,
      timing: PolicyTiming.immediate,
      applicableRoles: 'Admin',
      ownerType: 'All',
      amountRange: 'Rs 0 — Rs 10,000',
    ),
    ApprovalPolicy(
      code: 'P11',
      title: 'Admin High Value',
      isActive: true,
      timing: PolicyTiming.requiresApproval,
      applicableRoles: 'Admin',
      ownerType: 'All',
      amountRange: 'Rs 10,001 — —',
      sla: '48h',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstant.appBarBg(context),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Theme.of(context).scaffoldBackgroundColor,
          statusBarIconBrightness:
              Theme.of(context).brightness == Brightness.dark
              ? Brightness.light
              : Brightness.dark,
          statusBarBrightness: Theme.of(context).brightness == Brightness.dark
              ? Brightness.dark
              : Brightness.light,
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Approval Policies',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppConstant.textPrimary(context),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Define threshold rules that determine the approval '
              'tier for wallet transactions',
              style: TextStyle(
                fontSize: 13,
                color: AppConstant.textPrimary(context),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: AppConstant.scaffoldBg(context),
      body: ScreenShimmerWrapper(
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: 12,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: SizedBox(
                  height: 50,
                  width: 120,
                  child: Card(
                    color: AppConstant.primarycolor,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(4),
                      onTap: _showNewPolicyDialog,
                      child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Icon(Icons.add, color: Colors.black),
                        Text(
                          "New Policy",
                          style: TextStyle(color: Colors.black),
                        )
                      ],
                      ),
                    ),
                  ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                  itemCount: _policies.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    return _PolicyCard(
                      policy: _policies[index],
                      onEdit: () => _onEdit(_policies[index]),
                      onPause: () => _onPause(_policies[index]),
                      onDelete: () => _onDelete(_policies[index]),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onEdit(ApprovalPolicy p) {
    // TODO: navigate to edit screen / open edit dialog
    debugPrint('Edit ${p.code}');
  }

  void _onPause(ApprovalPolicy p) {
    // TODO: toggle active/paused state via your state management / API
    debugPrint('Pause ${p.code}');
  }

  void _onDelete(ApprovalPolicy p) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete policy?'),
        content: Text('Are you sure you want to delete "${p.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                // TODO: remove from real data source
              });
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _showNewPolicyDialog() async {
    _policyNameController.clear();
    _priorityController.text = '10';
    _rolesController.clear();
    _minAmountController.clear();
    _maxAmountController.clear();
    _slaController.clear();
    String ownerType = 'All types';
    PolicyTiming timing = PolicyTiming.requiresApproval;
    bool docRequired = false;
    bool active = true;
    final formKey = GlobalKey<FormState>();

    final created = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: StatefulBuilder(
          builder: (context, setDialogState) => ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900, maxHeight: 760),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 18, 20, 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('New Approval Policy',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        Text('Define threshold rules for transaction approval'),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final compact = constraints.maxWidth < 600;
                          final name = _policyField('Policy Name *',
                              _policyNameController,
                              hint: 'e.g. Finance Manager Approval', required: true);
                          final priority = _policyField('Priority *',
                              _priorityController,
                              hint: '10',
                              required: true,
                              keyboardType: TextInputType.number,
                              helper: 'Lower number = higher priority');
                          final roles = _policyField('Applicable Roles *',
                              _rolesController,
                              hint: 'e.g. Manager,Finance Manager,Admin (comma-separated)',
                              required: true);
                          final owner = _policyDropdown('Owner Type Filter',
                              ownerType, ['All types', 'Employee', 'Non-employee'],
                              (value) => setDialogState(() => ownerType = value!));
                          final min = _policyField('Min Amount (PKR)',
                              _minAmountController,
                              hint: 'No minimum', keyboardType: TextInputType.number);
                          final max = _policyField('Max Amount (PKR)',
                              _maxAmountController,
                              hint: 'No maximum', keyboardType: TextInputType.number);
                          final sla = _policyField('SLA Hours', _slaController,
                              hint: 'e.g. 48', keyboardType: TextInputType.number);

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _policyRow([name, priority], compact),
                              _policyRow([roles], compact),
                              _policyRow([owner, min, max], compact),
                              _policyRow([
                                _executionMode(timing,
                                    (value) => setDialogState(() => timing = value)),
                                sla,
                              ], compact),
                              CheckboxListTile(
                                contentPadding: EdgeInsets.zero,
                                value: docRequired,
                                onChanged: (value) => setDialogState(
                                    () => docRequired = value ?? false),
                                title: const Text('Requires financial document',
                                    style: TextStyle(fontWeight: FontWeight.w600)),
                                subtitle: const Text(
                                    'Transactions matching this policy must attach a financial document'),
                                controlAffinity: ListTileControlAffinity.leading,
                              ),
                              CheckboxListTile(
                                contentPadding: EdgeInsets.zero,
                                value: active,
                                onChanged: (value) => setDialogState(
                                    () => active = value ?? false),
                                title: const Text('Active',
                                    style: TextStyle(fontWeight: FontWeight.w600)),
                                subtitle: const Text('Policy is enforced immediately'),
                                controlAffinity: ListTileControlAffinity.leading,
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                  const Divider(height: 1),
                  Padding(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: () => Navigator.pop(dialogContext),
                            child: const Text('Cancel')),
                        const SizedBox(width: 10),
                        FilledButton.icon(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              Navigator.pop(dialogContext, true);
                            }
                          },
                          icon: const Icon(Icons.save_outlined, size: 17),
                          label: const Text('Create Policy'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    if (created == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Approval policy created.')));
    }
  }

  Widget _policyRow(List<Widget> children, bool compact) {
    if (compact) {
      return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: children
              .expand((child) => [child, const SizedBox(height: 14)])
              .toList());
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children
              .map((child) => Expanded(
                  child: Padding(
                      padding: const EdgeInsets.only(right: 12), child: child)))
              .toList()),
    );
  }

  Widget _policyField(String label, TextEditingController controller,
      {required String hint,
      bool required = false,
      TextInputType? keyboardType,
      String? helper}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: required
              ? (value) => value == null || value.trim().isEmpty ? 'Required' : null
              : null,
          decoration: _policyInput(hint),
        ),
        if (helper != null) ...[
          const SizedBox(height: 5),
          Text(helper, style: TextStyle(color: AppConstant.textSecondary(context))),
        ],
      ],
    );
  }

  Widget _policyDropdown(String label, String value, List<String> items,
      ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          isExpanded: true,
          decoration: _policyInput(''),
          items: items
              .map((item) => DropdownMenuItem(value: item, child: Text(item)))
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _executionMode(PolicyTiming timing, ValueChanged<PolicyTiming> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Execution Mode', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            ChoiceChip(
                label: const Text('Requires Approval'),
                selected: timing == PolicyTiming.requiresApproval,
                onSelected: (_) => onChanged(PolicyTiming.requiresApproval)),
            ChoiceChip(
                label: const Text('Immediate'),
                selected: timing == PolicyTiming.immediate,
                onSelected: (_) => onChanged(PolicyTiming.immediate)),
          ],
        ),
      ],
    );
  }

  InputDecoration _policyInput(String hint) => InputDecoration(
        hintText: hint.isEmpty ? null : hint,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      );
}

/// ----------------------------------------------------------------------
/// POLICY CARD
/// ----------------------------------------------------------------------
class _PolicyCard extends StatelessWidget {
  final ApprovalPolicy policy;
  final VoidCallback onEdit;
  final VoidCallback onPause;
  final VoidCallback onDelete;

  const _PolicyCard({
    required this.policy,
    required this.onEdit,
    required this.onPause,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppConstant.cardBg(context),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: code + title, badges, action icons
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    _CodeChip(text: policy.code),
                    Text(
                      policy.title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppConstant.textPrimary(context),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _SquareIconButton(
                    icon: Icons.edit_outlined,
                    color: AppConstant.textPrimary(context),
                    bgColor: AppConstant.cardBg(context),
                    borderColor: AppConstant.border(context),
                    onTap: onEdit,
                  ),
                  const SizedBox(width: 8),
                  _SquareIconButton(
                    icon: Icons.pause,
                    color: AppConstant.textPrimary(context),
                    bgColor: AppConstant.cardBg(context),
                    borderColor: AppConstant.border(context),
                    onTap: onPause,
                  ),
                  const SizedBox(width: 8),
                  _SquareIconButton(
                    icon: Icons.delete_outline,
                    color: Colors.red,
                    bgColor: Colors.red.shade50,
                    borderColor: Colors.red.shade200,
                    onTap: onDelete,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Badges row
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _StatusBadge(
                label: policy.isActive ? 'ACTIVE' : 'INACTIVE',
                bgColor: policy.isActive
                    ? const Color(0xFFE3F7EA)
                    : Colors.grey.shade200,
                textColor: policy.isActive
                    ? const Color(0xFF1E9E5A)
                    : Colors.grey.shade600,
              ),
              _StatusBadge(
                label: policy.timing == PolicyTiming.immediate
                    ? 'IMMEDIATE'
                    : 'REQUIRES APPROVAL',
                bgColor: policy.timing == PolicyTiming.immediate
                    ? const Color(0xFFE3F7EA)
                    : const Color(0xFFFDF2DA),
                textColor: policy.timing == PolicyTiming.immediate
                    ? const Color(0xFF1E9E5A)
                    : const Color(0xFFB4790B),
              ),
              if (policy.docRequired)
                _StatusBadge(
                  label: 'DOC REQUIRED',
                  bgColor: const Color(0xFFE7F0FE),
                  textColor: const Color(0xFF2D6FE0),
                  icon: Icons.description_outlined,
                ),
            ],
          ),
          const SizedBox(height: 14),
          Divider(height: 1, color: AppConstant.border(context)),
          const SizedBox(height: 14),

          // Details row: Applicable Roles / Owner Type / Amount Range / SLA
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: _DetailColumn(
                  label: 'APPLICABLE ROLES',
                  value: policy.applicableRoles,
                ),
              ),
              Expanded(
                flex: 2,
                child: _DetailColumn(
                  label: 'OWNER TYPE',
                  value: policy.ownerType,
                ),
              ),
              Expanded(
                flex: 2,
                child: _DetailColumn(
                  label: 'AMOUNT RANGE',
                  value: policy.amountRange,
                ),
              ),
              if (policy.sla != null)
                Expanded(
                  flex: 1,
                  child: _DetailColumn(
                    label: 'SLA',
                    value: policy.sla!,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/// ----------------------------------------------------------------------
/// SMALL REUSABLE WIDGETS
/// ----------------------------------------------------------------------
class _CodeChip extends StatelessWidget {
  final String text;
  const _CodeChip({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppConstant.tableHeaderBg(context),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: AppConstant.textSecondary(context),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String label;
  final Color bgColor;
  final Color textColor;
  final IconData? icon;

  const _StatusBadge({
    required this.label,
    required this.bgColor,
    required this.textColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: textColor),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              color: textColor,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailColumn extends StatelessWidget {
  final String label;
  final String value;
  const _DetailColumn({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: AppConstant.textHint(context),
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppConstant.textPrimary(context),
          ),
        ),
      ],
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _CircleIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppConstant.cardBg(context),
          shape: BoxShape.circle,
          border: Border.all(color: AppConstant.border(context)),
        ),
        child: Icon(icon, size: 18, color: AppConstant.textPrimary(context)),
      ),
    );
  }
}

class _SquareIconButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color bgColor;
  final Color borderColor;
  final VoidCallback onTap;

  const _SquareIconButton({
    required this.icon,
    required this.color,
    required this.bgColor,
    required this.borderColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: borderColor),
        ),
        child: Icon(icon, size: 16, color: color),
      ),
    );
  }
}

/// ----------------------------------------------------------------------
/// "New Policy" button — place this in your AppBar/header actions or as
/// a FloatingActionButton.extended, depending on how your layout is set up.
/// ----------------------------------------------------------------------
class NewPolicyButton extends StatelessWidget {
  final VoidCallback onPressed;
  const NewPolicyButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.add, size: 18),
      label: const Text('New Policy'),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF29B6F6),
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}
