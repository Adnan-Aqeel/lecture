import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lecture/core/constants/app_colors.dart';
import 'package:lecture/core/widgets/shimmer_widgets.dart';

class _KpiData {
  final String name;
  final String department;
  final String category;
  final String weight;
  final String status;
  _KpiData(this.name, this.department, this.category, this.weight, this.status);
}

class KpiMasterScreen extends StatefulWidget {
  const KpiMasterScreen({super.key});

  @override
  State<KpiMasterScreen> createState() => _KpiMasterScreenState();
}

class _KpiMasterScreenState extends State<KpiMasterScreen> {
  final _searchCtrl = TextEditingController();
  String? _selectedDepartment;
  String _searchQuery = '';

  final _departments = ['IT', 'HR', 'Finance', 'Marketing', 'Operations', 'Development'];

  final List<_KpiData> _allKpis = [
    _KpiData('Code Quality Score', 'Development', 'Technical', '25%', 'Active'),
    _KpiData('Sprint Velocity', 'Development', 'Performance', '20%', 'Active'),
    _KpiData('Bug Fix Rate', 'Development', 'Quality', '15%', 'Active'),
    _KpiData('Customer Satisfaction', 'HR', 'Service', '30%', 'Active'),
    _KpiData('Recruitment Efficiency', 'HR', 'Process', '20%', 'Active'),
    _KpiData('Budget Accuracy', 'Finance', 'Financial', '35%', 'Active'),
    _KpiData('Cost Reduction', 'Finance', 'Financial', '25%', 'Active'),
    _KpiData('Lead Conversion', 'Marketing', 'Sales', '30%', 'Active'),
    _KpiData('Campaign ROI', 'Marketing', 'Performance', '20%', 'Active'),
    _KpiData('Uptime Percentage', 'IT', 'Technical', '40%', 'Active'),
    _KpiData('Ticket Resolution', 'IT', 'Service', '25%', 'Active'),
    _KpiData('Project Delivery', 'Operations', 'Process', '30%', 'Active'),
  ];

  List<_KpiData> get _filteredKpis {
    return _allKpis.where((kpi) {
      final matchesSearch = _searchQuery.isEmpty ||
          kpi.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          kpi.department.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          kpi.category.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesDept = _selectedDepartment == null ||
          _selectedDepartment!.isEmpty ||
          kpi.department == _selectedDepartment;
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
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('KPI Master',
                      style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: AppConstant.textPrimary(context))),
                  Text('Manage KPI definitions, categories, and weightings',
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
        child: Column(
          children: [
            // ── Filters ──
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildSearchField(),
                  const SizedBox(height: 12),
                  _buildDepartmentDropdown(),
                ],
              ),
            ),
            // ── Table ──
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildScrollableTable(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Search department',
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
            hintText: 'Search KPIs...',
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
    final filtered = _filteredKpis;
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
                      columnSpacing: 24,
                      horizontalMargin: 16,
                      columns: const [
                        DataColumn(label: Text('#')),
                        DataColumn(label: Text('KPI NAME')),
                        DataColumn(label: Text('DEPARTMENT')),
                        DataColumn(label: Text('CATEGORY')),
                        DataColumn(label: Text('WEIGHT')),
                        DataColumn(label: Text('STATUS')),
                        DataColumn(label: Text('ACTION')),
                      ],
                      rows: filtered.asMap().entries.map((entry) {
                        final i = entry.key;
                        final kpi = entry.value;
                        return DataRow(cells: [
                          DataCell(Text('${i + 1}')),
                          DataCell(Text(kpi.name,
                              style: TextStyle(fontWeight: FontWeight.w600))),
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
                            child: Text(kpi.department,
                                style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                    color: AppConstant.primarycolor)),
                          )),
                          DataCell(Text(kpi.category)),
                          DataCell(Text(kpi.weight,
                              style: TextStyle(fontWeight: FontWeight.w600))),
                          DataCell(Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.green.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                  color: Colors.green.withValues(alpha: 0.3)),
                            ),
                            child: Text(kpi.status,
                                style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.green.shade700)),
                          )),
                          DataCell(Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _actionIcon(Icons.edit_outlined, () => _showEditDialog(kpi)),
                              const SizedBox(width: 4),
                              _actionIcon(Icons.delete_outline, () => _showDeleteDialog(kpi)),
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
            Icon(Icons.analytics_outlined,
                size: 48, color: AppConstant.textHint(context)),
            const SizedBox(height: 10),
            Text('No KPI records found',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppConstant.textSecondary(context))),
            const SizedBox(height: 4),
            Text('Add KPI definitions to get started.',
                style: TextStyle(
                    fontSize: 12, color: AppConstant.textHint(context))),
          ],
        ),
      ),
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
          border: Border.all(
              color: AppConstant.primarycolor.withValues(alpha: 0.25)),
        ),
        child: Icon(icon, size: 15, color: AppConstant.primarycolor),
      ),
    );
  }

  void _showEditDialog(_KpiData kpi) {
    final nameCtrl = TextEditingController(text: kpi.name);
    String dept = kpi.department;
    String cat = kpi.category;
    final weightCtrl = TextEditingController(text: kpi.weight);

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
                        child: Text('Edit KPI',
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
                  _dialogField(ctx, 'KPI Name', nameCtrl),
                  const SizedBox(height: 12),
                  _dialogDropdown(ctx, 'Department',
                      ['IT', 'HR', 'Finance', 'Marketing', 'Operations', 'Development'], dept,
                      (v) => setDialogState(() => dept = v!)),
                  const SizedBox(height: 12),
                  _dialogDropdown(ctx, 'Category',
                      ['Technical', 'Performance', 'Quality', 'Service', 'Financial', 'Sales', 'Process'], cat,
                      (v) => setDialogState(() => cat = v!)),
                  const SizedBox(height: 12),
                  _dialogField(ctx, 'Weight', weightCtrl),
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

  void _showDeleteDialog(_KpiData kpi) {
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
                  child: Icon(Icons.delete_outline, color: Colors.red.shade400, size: 28),
                ),
                const SizedBox(height: 14),
                Text('Delete KPI',
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: AppConstant.textPrimary(ctx))),
                const SizedBox(height: 8),
                Text('Are you sure you want to delete "${kpi.name}"?',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13, color: AppConstant.textSecondary(ctx))),
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
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
                              content: Text('${kpi.name} deleted'),
                              backgroundColor: Colors.red.shade600,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade600,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text('Delete',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
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

  Widget _dialogField(BuildContext ctx, String label, TextEditingController ctrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 13, fontWeight: FontWeight.w600, color: AppConstant.textPrimary(ctx))),
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
                borderSide: BorderSide(color: AppConstant.primarycolor, width: 1.5)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
        ),
      ],
    );
  }

  Widget _dialogDropdown(BuildContext ctx, String hint, List<String> items,
      String value, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(hint,
            style: TextStyle(
                fontSize: 13, fontWeight: FontWeight.w600, color: AppConstant.textPrimary(ctx))),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: value,
          isDense: true,
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
                borderSide: BorderSide(color: AppConstant.primarycolor, width: 1.5)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
          items: items
              .map((e) => DropdownMenuItem(
                    value: e,
                    child: Text(e,
                        style: TextStyle(fontSize: 13, color: AppConstant.textPrimary(ctx))),
                  ))
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
