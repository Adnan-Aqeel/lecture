import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lecture/core/constants/app_colors.dart';
import 'package:lecture/core/widgets/shimmer_widgets.dart';
import 'package:lecture/presentation/screens/kpi_management/kpi_dashboard_button/bulk_evaluation.dart';
import 'package:lecture/core/utils/mobile_file_actions.dart';

class _EvalData {
  final String name;
  final String email;
  final String department;
  final String empId;
  final String status;
  _EvalData(this.name, this.email, this.department, this.empId, this.status);
}

class EmployeeEvaluationScreen extends StatefulWidget {
  const EmployeeEvaluationScreen({super.key});

  @override
  State<EmployeeEvaluationScreen> createState() =>
      _EmployeeEvaluationScreenState();
}

class _EmployeeEvaluationScreenState extends State<EmployeeEvaluationScreen> {
  final _searchCtrl = TextEditingController();
  String? _selectedDepartment;
  String _selectedMonth = 'August 2026';
  int _currentPage = 1;
  int _entriesPerPage = 10;
  String _searchQuery = '';

  final _departments = [
    'IT',
    'HR',
    'Finance',
    'Marketing',
    'Operations',
    'Development',
    'Bussiness Analyst'
  ];

  final List<_EvalData> _employees = [
    _EvalData('ali', 'aliraza25924@gmail.com', 'Development', '1', 'Active'),
    _EvalData('zain', 'aliexpert48@gmail.com', 'Development', '2', 'Active'),
    _EvalData(
        'amair', 'amair@gmail.com', 'Bussiness Analyst', '1002', 'Active'),
    _EvalData('ehsan', 'ehsan678@gmail.com', 'Development', '2002', 'Active'),
  ];

  List<_EvalData> get _filteredEmployees {
    return _employees.where((emp) {
      final matchesSearch = _searchQuery.isEmpty ||
          emp.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          emp.email.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          emp.department.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          emp.empId.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesDept = _selectedDepartment == null ||
          _selectedDepartment!.isEmpty ||
          emp.department == _selectedDepartment;
      return matchesSearch && matchesDept;
    }).toList();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

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
        title: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('KPI Evaluations',
                      style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: AppConstant.textPrimary(context))),
                  Text('Evaluate employees based on defined KPIs',
                      style: TextStyle(
                          fontSize: 13,
                          color: AppConstant.textSecondary(context))),
                ],
              ),
            ),
          ],
        ),
      ),
      body: ScreenShimmerWrapper(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              // ── Buttons Row ──
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const BulkEvaluationScreen()),
                        );
                      },
                      icon: const Icon(Icons.group_add_outlined, size: 14),
                      label: const Text('Bulk Department Eva...'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.green.shade700,
                        side: BorderSide(color: Colors.green.shade400),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                    child: OutlinedButton.icon(
                      onPressed: () => _showAutomatedEvalDialog(),
                      icon: const Icon(Icons.smart_toy_outlined, size: 14),
                      label: const Text('Automated Eva...'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppConstant.primarycolor,
                        side: BorderSide(color: AppConstant.primarycolor),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                      ),
                    ),
                  ),
                ],
              ),
              // ── Filters ──
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildMonthField(),
                    const SizedBox(height: 12),
                    _buildSearchField(),
                    const SizedBox(height: 12),
                    _buildDepartmentDropdown(),
                  ],
                ),
              ),
              // ── Table ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildScrollableTable(),
              ),
              const SizedBox(height: 16),
              // ── Footer ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildFooter(),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMonthField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Evaluation Month',
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppConstant.textPrimary(context))),
        const SizedBox(height: 6),
        TextField(
          readOnly: true,
          style:
              TextStyle(fontSize: 13, color: AppConstant.textPrimary(context)),
          decoration: InputDecoration(
            hintText: 'mm/dd/yyyy',
            hintStyle:
                TextStyle(fontSize: 13, color: AppConstant.textHint(context)),
            suffixIcon: Icon(Icons.calendar_today,
                size: 16, color: AppConstant.textHint(context)),
            filled: true,
            fillColor: AppConstant.inputBg(context),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppConstant.border(context))),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppConstant.border(context))),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    BorderSide(color: AppConstant.primarycolor, width: 1.5)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2020),
              lastDate: DateTime(2030),
            );
            if (date != null) {
              final months = [
                '',
                'January',
                'February',
                'March',
                'April',
                'May',
                'June',
                'July',
                'August',
                'September',
                'October',
                'November',
                'December'
              ];
              setState(
                  () => _selectedMonth = '${months[date.month]} ${date.year}');
            }
          },
        ),
      ],
    );
  }

  Widget _buildSearchField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Search',
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppConstant.textPrimary(context))),
        const SizedBox(height: 6),
        TextField(
          controller: _searchCtrl,
          style:
              TextStyle(fontSize: 13, color: AppConstant.textPrimary(context)),
          decoration: InputDecoration(
            hintText: 'Search employees...',
            hintStyle:
                TextStyle(fontSize: 13, color: AppConstant.textHint(context)),
            prefixIcon: Icon(Icons.search,
                size: 18, color: AppConstant.textHint(context)),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: Icon(Icons.clear,
                        size: 16, color: AppConstant.textHint(context)),
                    onPressed: () {
                      _searchCtrl.clear();
                      setState(() => _searchQuery = '');
                    },
                  )
                : null,
            filled: true,
            fillColor: AppConstant.inputBg(context),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppConstant.border(context))),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppConstant.border(context))),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    BorderSide(color: AppConstant.primarycolor, width: 1.5)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
          onChanged: (v) => setState(() => _searchQuery = v),
        ),
      ],
    );
  }

  Widget _buildDepartmentDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Department',
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppConstant.textPrimary(context))),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: _selectedDepartment,
          isDense: true,
          decoration: InputDecoration(
            hintText: '-- Select --',
            hintStyle:
                TextStyle(fontSize: 13, color: AppConstant.textHint(context)),
            filled: true,
            fillColor: AppConstant.inputBg(context),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppConstant.border(context))),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppConstant.border(context))),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    BorderSide(color: AppConstant.primarycolor, width: 1.5)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
          items: _departments
              .map((d) => DropdownMenuItem(
                    value: d,
                    child: Text(d,
                        style: TextStyle(
                            fontSize: 13,
                            color: AppConstant.textPrimary(context))),
                  ))
              .toList(),
          onChanged: (v) => setState(() => _selectedDepartment = v),
        ),
      ],
    );
  }

  Widget _buildScrollableTable() {
    final filtered = _filteredEmployees;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppConstant.cardBg(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppConstant.border(context)),
      ),
      child: filtered.isEmpty
          ? _buildEmptyState()
          : Scrollbar(
              thumbVisibility: true,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: DataTable(
                      headingRowColor:
                          WidgetStateProperty.all(AppConstant.primarycolor),
                      headingTextStyle: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 0.5),
                      dataTextStyle: TextStyle(
                          fontSize: 12,
                          color: AppConstant.textPrimary(context)),
                      columnSpacing: 20,
                      horizontalMargin: 16,
                      columns: const [
                        DataColumn(label: Text('#')),
                        DataColumn(label: Text('EMPLOYEE NAME')),
                        DataColumn(label: Text('DEPARTMENT')),
                        DataColumn(label: Text('EMPLOYEE ID')),
                        DataColumn(label: Text('STATUS')),
                        DataColumn(label: Text('ACTION')),
                      ],
                      rows: filtered.asMap().entries.map((entry) {
                        final i = entry.key;
                        final emp = entry.value;
                        return DataRow(cells: [
                          DataCell(Row(
                            children: [
                              Icon(Icons.fiber_manual_record,
                                  size: 10, color: AppConstant.primarycolor),
                              const SizedBox(width: 6),
                              Text('${i + 1}'),
                            ],
                          )),
                          DataCell(Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(emp.name,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: AppConstant.textPrimary(context))),
                              Text(emp.email,
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: AppConstant.textHint(context))),
                            ],
                          )),
                          DataCell(Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color:
                                  AppConstant.primarycolor.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                  color: AppConstant.primarycolor
                                      .withValues(alpha: 0.3)),
                            ),
                            child: Text(emp.department,
                                style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                    color: AppConstant.primarycolor)),
                          )),
                          DataCell(Text(emp.empId,
                              style: TextStyle(
                                  color: AppConstant.primarycolor,
                                  fontWeight: FontWeight.w600))),
                          DataCell(Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.green.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                  color: Colors.green.withValues(alpha: 0.3)),
                            ),
                            child: Text(emp.status,
                                style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.green.shade700)),
                          )),
                          DataCell(Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _actionIcon(Icons.edit_outlined, () => _showEditDialog(emp)),
                              const SizedBox(width: 4),
                              _actionIcon(Icons.delete_outline, () => _showDeleteDialog(emp)),
                            ],
                          )),
                        ]);
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_search_outlined,
                size: 48, color: AppConstant.textHint(context)),
            const SizedBox(height: 10),
            Text('No employees found',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppConstant.textSecondary(context))),
            const SizedBox(height: 4),
            Text('Try adjusting your search or filters.',
                style: TextStyle(
                    fontSize: 12, color: AppConstant.textHint(context))),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════
  //  AUTOMATED EVALUATION DIALOG
  // ═══════════════════════════════════════════
  void _showAutomatedEvalDialog() {
    String? dialogDepartment;
    String? dialogEmployee;

    final departments = [
      'IT',
      'HR',
      'Finance',
      'Marketing',
      'Operations',
      'Development',
      'Bussiness Analyst'
    ];
    final employees = ['ali', 'zain', 'amair', 'ehsan'];

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return Dialog(
              backgroundColor: AppConstant.cardBg(ctx),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
              insetPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(ctx).size.width * 0.85,
                  maxHeight: MediaQuery.of(ctx).size.height * 0.8,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // ── Header ──
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 16),
                        decoration: BoxDecoration(
                          color: AppConstant.primarycolor,
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.smart_toy_outlined,
                                color: Colors.white, size: 20),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text('Automated Evaluation',
                                  style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.pop(ctx),
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Icon(Icons.close,
                                    color: Colors.white, size: 18),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // ── Body ──
                      Flexible(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // ── Section 1 ──
                              Text('1. Download KPI Template for a Department',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: AppConstant.textPrimary(ctx))),
                              const SizedBox(height: 6),
                              Text(
                                  "Generates a ready-to-fill score sheet with the department's currently active KPIs.",
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: AppConstant.textSecondary(ctx))),
                              const SizedBox(height: 16),
                              // Department row
                              _dialogDropdown(
                                  ctx,
                                  'Select Department',
                                  departments,
                                  dialogDepartment,
                                  (v) => setDialogState(
                                      () => dialogDepartment = v)),
                              const SizedBox(height: 12),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    final dept = dialogDepartment ?? 'All_Departments';
                                    MobileFileActions.downloadCsvTemplate(
                                      fileName: 'kpi_template_$dept',
                                      headers: ['Employee ID', 'Name', 'Department', 'Goal', 'Score (0-100)', 'Comments'],
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppConstant.primarycolor,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                  ),
                                  child: const Text('Download Template',
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600)),
                                ),
                              ),
                              // ── Divider ──
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20),
                                child: Divider(
                                    height: 1, color: AppConstant.border(ctx)),
                              ),
                              // ── Section 2 ──
                              Text('2. Upload Filled Template for an Employee',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: AppConstant.textPrimary(ctx))),
                              const SizedBox(height: 6),
                              RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: AppConstant.textSecondary(ctx)),
                                  children: const [
                                    TextSpan(
                                        text:
                                            'Select the employee, ensure the '),
                                    TextSpan(
                                        text: 'Evaluation Month',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    TextSpan(
                                        text:
                                            ' above is correct, then upload the filled template. The system will validate, score, and preview the result automatically.'),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                              // Employee dropdown
                              _dialogDropdown(
                                  ctx,
                                  'Select Employee',
                                  employees,
                                  dialogEmployee,
                                  (v) =>
                                      setDialogState(() => dialogEmployee = v)),
                              const SizedBox(height: 12),
                              // File chooser
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: AppConstant.border(ctx)),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 14, vertical: 10),
                                      decoration: BoxDecoration(
                                        color: AppConstant.inputBg(ctx),
                                        border: Border(
                                            right: BorderSide(
                                                color:
                                                    AppConstant.border(ctx))),
                                      ),
                                      child: Text('Choose file',
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: AppConstant.textPrimary(
                                                  ctx))),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text('No file chosen',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color:
                                                  AppConstant.textHint(ctx))),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              // Buttons row
                              Row(
                                children: [
                                  OutlinedButton(
                                    onPressed: () => Navigator.pop(ctx),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor:
                                          AppConstant.textSecondary(ctx),
                                      side: BorderSide(
                                          color: AppConstant.border(ctx)),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 18, vertical: 10),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                    ),
                                    child: const Text('Clear',
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600)),
                                  ),
                                  const SizedBox(width: 10),
                                  ElevatedButton(
                                    onPressed: () { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Action Performed!'))); },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppConstant.primarycolor,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 22, vertical: 10),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                    ),
                                    child: const Text('Analyze',
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _dialogDropdown(BuildContext ctx, String hint, List<String> items,
      String? value, ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      isDense: true,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(fontSize: 13, color: AppConstant.textHint(ctx)),
        filled: true,
        fillColor: AppConstant.inputBg(ctx),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: AppConstant.border(ctx))),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: AppConstant.border(ctx))),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
                BorderSide(color: AppConstant.primarycolor, width: 1.5)),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
      items: items
          .map((e) => DropdownMenuItem(
                value: e,
                child: Text(e,
                    style: TextStyle(
                        fontSize: 13, color: AppConstant.textPrimary(ctx))),
              ))
          .toList(),
      onChanged: onChanged,
    );
  }

  Widget _actionIcon(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: AppConstant.primarycolor.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(6),
          border:
              Border.all(color: AppConstant.primarycolor.withValues(alpha: 0.25)),
        ),
        child: Icon(icon, size: 15, color: AppConstant.primarycolor),
      ),
    );
  }

  void _showEditDialog(_EvalData emp) {
    final nameCtrl = TextEditingController(text: emp.name);
    final emailCtrl = TextEditingController(text: emp.email);
    final empIdCtrl = TextEditingController(text: emp.empId);
    String dept = emp.department;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => Dialog(
          backgroundColor: AppConstant.cardBg(ctx),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(ctx).size.width * 0.85,
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.edit_outlined,
                          color: AppConstant.primarycolor, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text('Edit Employee',
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: AppConstant.textPrimary(ctx))),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(ctx),
                        child: Icon(Icons.close,
                            size: 20, color: AppConstant.textHint(ctx)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _dialogField(ctx, 'Employee Name', nameCtrl),
                  const SizedBox(height: 12),
                  _dialogField(ctx, 'Email', emailCtrl),
                  const SizedBox(height: 12),
                  _dialogDropdown(ctx, 'Department',
                      ['IT', 'HR', 'Finance', 'Marketing', 'Operations', 'Development', 'Bussiness Analyst'],
                      dept, (v) => setDialogState(() => dept = v!)),
                  const SizedBox(height: 12),
                  _dialogField(ctx, 'Employee ID', empIdCtrl),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${nameCtrl.text} updated successfully'),
                            backgroundColor: Colors.green.shade600,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppConstant.primarycolor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('Save Changes',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(_EvalData emp) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: AppConstant.cardBg(ctx),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(ctx).size.width * 0.85,
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.delete_outline,
                      color: Colors.red.shade400, size: 28),
                ),
                const SizedBox(height: 14),
                Text('Delete Employee',
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: AppConstant.textPrimary(ctx))),
                const SizedBox(height: 8),
                Text('Are you sure you want to delete "${emp.name}"?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 13, color: AppConstant.textSecondary(ctx))),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(ctx),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppConstant.textSecondary(ctx),
                          side: BorderSide(color: AppConstant.border(ctx)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${emp.name} deleted'),
                              backgroundColor: Colors.red.shade600,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade600,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text('Delete',
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _dialogField(
      BuildContext ctx, String label, TextEditingController ctrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppConstant.textPrimary(ctx))),
        const SizedBox(height: 6),
        TextField(
          controller: ctrl,
          style: TextStyle(fontSize: 13, color: AppConstant.textPrimary(ctx)),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppConstant.inputBg(ctx),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppConstant.border(ctx))),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppConstant.border(ctx))),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    BorderSide(color: AppConstant.primarycolor, width: 1.5)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppConstant.cardBg(context),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppConstant.border(context)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                  'Month: ${_selectedMonth.split(' ').first.substring(0, 3)} ${_selectedMonth.split(' ').last}',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppConstant.textPrimary(context))),
              const SizedBox(width: 6),
              Text('Show',
                  style: TextStyle(
                      fontSize: 12, color: AppConstant.textSecondary(context))),
              const SizedBox(width: 6),
              Container(
                height: 28,
                padding: const EdgeInsets.symmetric(horizontal: 6),
                decoration: BoxDecoration(
                  border: Border.all(color: AppConstant.border(context)),
                  borderRadius: BorderRadius.circular(6),
                  color: AppConstant.inputBg(context),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    value: _entriesPerPage,
                    isDense: true,
                    items: [5, 10, 15, 25]
                        .map((s) => DropdownMenuItem(
                              value: s,
                              child: Text('$s',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: AppConstant.textPrimary(context))),
                            ))
                        .toList(),
                    onChanged: (v) {
                      if (v != null) setState(() => _entriesPerPage = v);
                    },
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Text('entries',
                  style: TextStyle(
                      fontSize: 12, color: AppConstant.textSecondary(context))),
              const Spacer(),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Row(
            children: [
              Text('Records: ${_filteredEmployees.length} of ${_employees.length}',
                  style: TextStyle(
                      fontSize: 11, color: AppConstant.textHint(context))),
              const SizedBox(width: 10),
              _pageBtn(Icons.first_page_rounded, false),
              const SizedBox(width: 4),
              _pageBtn(Icons.chevron_left_rounded, false),
              const SizedBox(width: 4),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                    color: AppConstant.primarycolor,
                    borderRadius: BorderRadius.circular(6)),
                child: Text('$_currentPage',
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.white)),
              ),
              const SizedBox(width: 4),
              _pageBtn(Icons.chevron_right_rounded, false),
              const SizedBox(width: 4),
              _pageBtn(Icons.last_page_rounded, false),
            ],
          )
        ],
      ),
    );
  }

  Widget _pageBtn(IconData icon, bool enabled) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: enabled
            ? AppConstant.inputBg(context)
            : AppConstant.cardBg(context),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppConstant.border(context)),
      ),
      child: Icon(icon,
          size: 16,
          color: enabled
              ? AppConstant.textSecondary(context)
              : AppConstant.textHint(context)),
    );
  }
}
