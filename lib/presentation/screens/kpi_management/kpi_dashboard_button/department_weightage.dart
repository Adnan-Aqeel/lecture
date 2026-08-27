import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lecture/core/constants/app_colors.dart';
import 'package:lecture/core/widgets/shimmer_widgets.dart';

class DepartmentWeightage extends StatefulWidget {
  const DepartmentWeightage({super.key});

  @override
  State<DepartmentWeightage> createState() => _DepartmentWeightage();
}

class _DepartmentWeightage extends State<DepartmentWeightage> {
  final _searchCtrl = TextEditingController();
  String? _selectedDepartment;

  final _departments = [
    'IT',
    'HR',
    'Finance',
    'Marketing',
    'Operations',
    'Development',
  ];

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
            const SizedBox(width: 12),
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
            hintText: 'Search departments...',
            hintStyle:
                TextStyle(fontSize: 13, color: AppConstant.textHint(context)),
            prefixIcon: Icon(Icons.search,
                size: 18, color: AppConstant.textHint(context)),
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
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppConstant.cardBg(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppConstant.border(context)),
      ),
      child: Column(
        children: [
          Expanded(
            child: Scrollbar(
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
                          color: AppConstant.textPrimary(context),
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
                        DataColumn(label: Text('ACTIONS')),
                      ],
                      rows: const [],
                    ),
                  ),
                ),
              ),
            ),
          ),
          // ── Empty state ──
          if (true)
            Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
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
        ],
      ),
    );
  }
}
