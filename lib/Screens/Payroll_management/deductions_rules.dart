import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lecture/appcolor.dart';
import 'package:lecture/widgets/shimmer_widgets.dart';

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

class DeductionsRulesScreen extends StatefulWidget {
  const DeductionsRulesScreen({super.key});

  @override
  State<DeductionsRulesScreen> createState() => _DeductionsRulesScreenState();
}

class _DeductionsRulesScreenState extends State<DeductionsRulesScreen> {
  final List<DeductionRule> _rules = [
    const DeductionRule(
        id: 1,
        rule: 'absent',
        condition: 'Absent',
        value: '100%',
        type: '% of Day Salary'),
    const DeductionRule(
        id: 2,
        rule: 'HALF DAY',
        condition: 'Half Day',
        value: '50%',
        type: '% of Day Salary'),
    const DeductionRule(
        id: 3,
        rule: 'SHORT HOURS',
        condition: 'Short Hours',
        value: '0.25%',
        type: '% of Day Salary'),
    const DeductionRule(
        id: 4,
        rule: 'WFH',
        condition: 'WFH',
        value: '30%',
        type: '% of Day Salary'),
    const DeductionRule(
        id: 5,
        rule: 'late',
        condition: 'Late',
        value: 'PKR 500',
        type: 'Fixed Amount'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstant.scaffoldBg(context),
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
              'Deduction Rules',
              style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: AppConstant.textPrimary(context)),
            ),
            Text(
              'Current payroll deduction rules configuration.',
              style: TextStyle(
                  fontSize: 13, color: AppConstant.textPrimary(context)),
            ),
          ],
        ),
      ),
      body: ScreenShimmerWrapper(
        child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton.icon(
                    onPressed: _showAddRuleDialog,
                    icon: const Icon(Icons.add, size: 16),
                    label:
                        const Text('Add Rule', style: TextStyle(fontSize: 12)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConstant.primarycolor,
                      foregroundColor: Colors.black,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                _buildTableCard(),
              ],
            )),
      ),
    );
  }

  Widget _buildTableCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppConstant.cardBg(context),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(
            AppConstant.primarycolor,
          ),
          headingTextStyle: TextStyle(
            fontWeight: FontWeight.w700,
                    color: AppConstant.textPrimary(context),
            fontSize: 11,
          ),
          dataRowColor: WidgetStateProperty.all(AppConstant.cardBg(context)),
          horizontalMargin: 16,
          columnSpacing: 24,
          columns: const [
            DataColumn(label: Text('RULE')),
            DataColumn(label: Text('CONDITION')),
            DataColumn(label: Text('VALUE')),
            DataColumn(label: Text('TYPE')),
            DataColumn(label: Text('ACTIVE')),
            DataColumn(label: Text('ACTIONS')),
          ],
          rows: _rules.map((rule) {
            return DataRow(
              cells: [
                DataCell(
                  Text(rule.rule,
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w600)),
                ),
                DataCell(
                  Text(rule.condition,
                      style: TextStyle(
                          fontSize: 12,
                          color: AppConstant.textSecondary(context))),
                ),
                DataCell(
                  Text(rule.value,
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w500)),
                ),
                DataCell(
                  Text(rule.type,
                      style: TextStyle(
                          fontSize: 12,
                          color: AppConstant.textSecondary(context))),
                ),
                DataCell(
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: rule.isActive
                          ? const Color(0xFFE3F7EA)
                          : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      rule.isActive ? 'Yes' : 'No',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: rule.isActive
                            ? const Color(0xFF1E9E5A)
                            : Colors.grey.shade600,
                      ),
                    ),
                  ),
                ),
                DataCell(
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _actionButton(
                        icon: Icons.edit_outlined,
                        color: AppConstant.primarycolor,
                        onTap: () => _editRule(rule),
                      ),
                      const SizedBox(width: 8),
                      _actionButton(
                        icon: Icons.delete_outline,
                        color: Colors.red,
                        onTap: () => _deleteRule(rule),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _actionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Icon(icon, size: 16, color: color),
      ),
    );
  }

  void _showAddRuleDialog() {
    final ruleController = TextEditingController();
    final conditionController = TextEditingController();
    final valueController = TextEditingController();
    String selectedType = '% of Day Salary';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Row(
            children: [
              Icon(Icons.add_circle_outline,
                  color: AppConstant.primarycolor, size: 22),
              const SizedBox(width: 8),
              const Text('Add Deduction Rule',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.85,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: ruleController,
                    decoration: InputDecoration(
                      labelText: 'Rule Name *',
                      hintText: 'e.g. absent',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: conditionController,
                    decoration: InputDecoration(
                      labelText: 'Condition *',
                      hintText: 'e.g. Absent',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: valueController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Value *',
                      hintText: selectedType == 'Fixed Amount' ? '500' : '100',
                      prefixText:
                          selectedType == 'Fixed Amount' ? 'PKR ' : null,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: selectedType,
                    isExpanded: true,
                    decoration: InputDecoration(
                      labelText: 'Type *',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 12),
                    ),
                    items: ['% of Day Salary', 'Fixed Amount'].map((String t) {
                      return DropdownMenuItem<String>(
                          value: t,
                          child: Text(t, style: const TextStyle(fontSize: 13)));
                    }).toList(),
                    onChanged: (val) {
                      setDialogState(() {
                        selectedType = val!;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel',
                  style: TextStyle(color: AppConstant.textSecondary(context))),
            ),
            ElevatedButton(
              onPressed: () {
                if (ruleController.text.isNotEmpty &&
                    conditionController.text.isNotEmpty &&
                    valueController.text.isNotEmpty) {
                  setState(() {
                    String displayValue = valueController.text;
                    if (selectedType == '% of Day Salary' &&
                        !displayValue.contains('%')) {
                      displayValue = '$displayValue%';
                    } else if (selectedType == 'Fixed Amount' &&
                        !displayValue.contains('PKR')) {
                      displayValue = 'PKR $displayValue';
                    }

                    _rules.add(DeductionRule(
                      id: _rules.length + 1,
                      rule: ruleController.text,
                      condition: conditionController.text,
                      value: displayValue,
                      type: selectedType,
                    ));
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Rule added successfully!'),
                      backgroundColor: Colors.green.shade600,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstant.primarycolor,
                foregroundColor: Colors.white,
              ),
              child: const Text('Add Rule'),
            ),
          ],
        ),
      ),
    );
  }

  void _editRule(DeductionRule rule) {
    final ruleController = TextEditingController(text: rule.rule);
    final conditionController = TextEditingController(text: rule.condition);
    final valueController = TextEditingController(
        text: rule.value.replaceAll('PKR ', '').replaceAll('%', ''));
    String selectedType = rule.type;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: const Text('Edit Deduction Rule',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.85,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: ruleController,
                    decoration: InputDecoration(
                      labelText: 'Rule Name *',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: conditionController,
                    decoration: InputDecoration(
                      labelText: 'Condition *',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: valueController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Value *',
                      prefixText:
                          selectedType == 'Fixed Amount' ? 'PKR ' : null,
                      suffixText:
                          selectedType == '% of Day Salary' ? '%' : null,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: selectedType,
                    isExpanded: true,
                    decoration: InputDecoration(
                      labelText: 'Type *',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 12),
                    ),
                    items: ['% of Day Salary', 'Fixed Amount'].map((String t) {
                      return DropdownMenuItem<String>(
                          value: t,
                          child: Text(t, style: const TextStyle(fontSize: 13)));
                    }).toList(),
                    onChanged: (val) {
                      setDialogState(() {
                        selectedType = val!;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel',
                  style: TextStyle(color: AppConstant.textSecondary(context))),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  final index = _rules.indexWhere((r) => r.id == rule.id);
                  if (index != -1) {
                    String displayValue = valueController.text;
                    if (selectedType == '% of Day Salary' &&
                        !displayValue.contains('%')) {
                      displayValue = '$displayValue%';
                    } else if (selectedType == 'Fixed Amount' &&
                        !displayValue.contains('PKR')) {
                      displayValue = 'PKR $displayValue';
                    }

                    _rules[index] = DeductionRule(
                      id: rule.id,
                      rule: ruleController.text,
                      condition: conditionController.text,
                      value: displayValue,
                      type: selectedType,
                      isActive: rule.isActive,
                    );
                  }
                });
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstant.primarycolor,
                foregroundColor: Colors.white,
              ),
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void _deleteRule(DeductionRule rule) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('Delete Rule'),
        content: Text('Are you sure you want to delete "${rule.rule}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel',
                style: TextStyle(color: AppConstant.textSecondary(context))),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() => _rules.removeWhere((r) => r.id == rule.id));
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Rule deleted'),
                  backgroundColor: Colors.red.shade600,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, foregroundColor: Colors.white),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
