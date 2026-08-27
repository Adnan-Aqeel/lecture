import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lecture/core/constants/app_colors.dart';
import 'package:lecture/core/widgets/shimmer_widgets.dart';
import 'package:lecture/core/utils/mobile_file_actions.dart';

class BulkEvaluationScreen extends StatefulWidget {
  const BulkEvaluationScreen({super.key});

  @override
  State<BulkEvaluationScreen> createState() => _BulkEvaluationScreenState();
}

class _BulkEvaluationScreenState extends State<BulkEvaluationScreen> {
  int _selectedTab = 0;
  int _currentStep = 1;
  String? _selectedDepartment;
  String _selectedMonth = 'August 2026';
  String _historyDepartment = 'All Departments';
  String _historyYear = '';
  String _historyMonth = 'All';

  final _departments = [
    'IT',
    'HR',
    'Finance',
    'Marketing',
    'Operations',
    'Development',
    'Bussiness Analyst'
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
        title: Row(
          children: [
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Bulk Department Evaluation',
                      style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: AppConstant.textPrimary(context))),
                  Text('Import KPI evaluations for entire departments at once',
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
            // ── Tabs ──
            _buildTabs(),
            // ── Tab Content ──
            Expanded(
              child: _selectedTab == 0
                  ? _buildBulkImportTab()
                  : _buildImportHistoryTab(),
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════
  //  TABS
  // ═══════════════════════════════════════════
  Widget _buildTabs() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppConstant.cardBg(context),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppConstant.border(context)),
      ),
      child: Row(
        children: [
          _tabButton(0, Icons.upload_file_outlined, 'Bulk Import'),
          _tabButton(1, Icons.history_outlined, 'Import History'),
        ],
      ),
    );
  }

  Widget _tabButton(int index, IconData icon, String label) {
    final isActive = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isActive ? AppConstant.primarycolor : Colors.transparent,
                width: 2.5,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,
                  size: 16,
                  color: isActive
                      ? AppConstant.primarycolor
                      : AppConstant.textSecondary(context)),
              const SizedBox(width: 6),
              Text(label,
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                      color: isActive
                          ? AppConstant.primarycolor
                          : AppConstant.textSecondary(context))),
            ],
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════
  //  BULK IMPORT TAB
  // ═══════════════════════════════════════════
  Widget _buildBulkImportTab() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          // ── Step Indicator ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: _buildStepIndicator(),
          ),
          // ── Step Content ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildStepContent(),
          ),
        ],
      ),
    );
  }

  // ── Step Indicator ──
  Widget _buildStepIndicator() {
    final steps = [
      _StepData(1, 'Select Month\n& Department'),
      _StepData(2, 'Download\nTemplate'),
      _StepData(3, 'Upload\nFilled File'),
      _StepData(4, 'Preview &\nImport'),
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: AppConstant.cardBg(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppConstant.border(context)),
      ),
      child: Column(
        children: [
          Row(
            children: steps.asMap().entries.map((entry) {
              final i = entry.key;
              final step = entry.value;
              final isActive = _currentStep == step.num;
              final isCompleted = _currentStep > step.num;

              return Expanded(
                child: Row(
                  children: [
                    // Circle
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isActive || isCompleted
                            ? AppConstant.primarycolor
                            : AppConstant.border(context),
                      ),
                      child: Center(
                        child: isCompleted
                            ? const Icon(Icons.check,
                                size: 18, color: Colors.white)
                            : Text('${step.num}',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: isActive
                                        ? Colors.white
                                        : AppConstant.textSecondary(context))),
                      ),
                    ),
                    // Line (except last)
                    if (i < steps.length - 1)
                      Expanded(
                        child: Container(
                          height: 2,
                          color: isCompleted
                              ? AppConstant.primarycolor
                              : AppConstant.border(context),
                        ),
                      ),
                  ],
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          // Labels
          Row(
            children: steps.map((step) {
              final isActive = _currentStep == step.num;
              final isCompleted = _currentStep > step.num;
              return Expanded(
                child: Text(step.label,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight:
                            isActive ? FontWeight.w700 : FontWeight.w500,
                        color: isActive || isCompleted
                            ? AppConstant.primarycolor
                            : AppConstant.textHint(context))),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ── Step Content ──
  Widget _buildStepContent() {
    switch (_currentStep) {
      case 1:
        return _buildStep1();
      case 2:
        return _buildStep2();
      case 3:
        return _buildStep3();
      case 4:
        return _buildStep4();
      default:
        return const SizedBox.shrink();
    }
  }

  // Step 1: Select Month & Department
  Widget _buildStep1() {
    return Column(
      children: [
        _buildMonthField(),
        const SizedBox(height: 14),
        _buildDepartmentDropdown(),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => setState(() => _currentStep = 2),
            icon: const Icon(Icons.arrow_forward, size: 18),
            label: const Text('Continue to Download Template',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstant.primarycolor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ),
      ],
    );
  }

  // Step 2: Download Template
  Widget _buildStep2() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppConstant.cardBg(context),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppConstant.border(context)),
          ),
          child: Column(
            children: [
              Icon(Icons.description_outlined,
                  size: 56, color: AppConstant.primarycolor),
              const SizedBox(height: 14),
              Text('Download KPI Template',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppConstant.textPrimary(context))),
              const SizedBox(height: 8),
              Text(
                  'Download the Excel template, fill in KPI scores\nfor all employees in the selected department.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 12, color: AppConstant.textSecondary(context))),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () => MobileFileActions.downloadCsvTemplate(
                  fileName: 'kpi_evaluation_template',
                  headers: const ['Employee ID', 'Employee Name', 'KPI', 'Score', 'Comments'],
                ),
                icon: const Icon(Icons.download_outlined, size: 18),
                label: const Text('Download Template',
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstant.primarycolor,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => setState(() => _currentStep = 1),
                icon: const Icon(Icons.arrow_back, size: 16),
                label: const Text('Back'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppConstant.textSecondary(context),
                  side: BorderSide(color: AppConstant.border(context)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => setState(() => _currentStep = 3),
                icon: const Icon(Icons.arrow_forward, size: 16),
                label: const Text('Continue'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstant.primarycolor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Step 3: Upload Filled File
  Widget _buildStep3() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppConstant.cardBg(context),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppConstant.border(context)),
          ),
          child: Column(
            children: [
              Icon(Icons.cloud_upload_outlined,
                  size: 56, color: AppConstant.primarycolor),
              const SizedBox(height: 14),
              Text('Upload Filled File',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppConstant.textPrimary(context))),
              const SizedBox(height: 8),
              Text(
                  'Upload the completed Excel template with\nKPI evaluations for the department.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 12, color: AppConstant.textSecondary(context))),
              const SizedBox(height: 20),
              DottedBorderWidget(
                child: Column(
                  children: [
                    Icon(Icons.upload_file_outlined,
                        size: 36, color: AppConstant.textHint(context)),
                    const SizedBox(height: 8),
                    Text('Click to upload or drag & drop',
                        style: TextStyle(
                            fontSize: 12,
                            color: AppConstant.textSecondary(context))),
                    const SizedBox(height: 4),
                    Text('Supports .xlsx, .csv',
                        style: TextStyle(
                            fontSize: 11,
                            color: AppConstant.textHint(context))),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => setState(() => _currentStep = 2),
                icon: const Icon(Icons.arrow_back, size: 16),
                label: const Text('Back'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppConstant.textSecondary(context),
                  side: BorderSide(color: AppConstant.border(context)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => setState(() => _currentStep = 4),
                icon: const Icon(Icons.arrow_forward, size: 16),
                label: const Text('Continue'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstant.primarycolor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Step 4: Preview & Import
  Widget _buildStep4() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppConstant.cardBg(context),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppConstant.border(context)),
          ),
          child: Column(
            children: [
              Icon(Icons.preview_outlined,
                  size: 56, color: AppConstant.primarycolor),
              const SizedBox(height: 14),
              Text('Preview & Import',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppConstant.textPrimary(context))),
              const SizedBox(height: 8),
              Text(
                  'Review the uploaded data before importing.\nAll records will be validated.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 12, color: AppConstant.textSecondary(context))),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppConstant.inputBg(context),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline,
                        size: 18, color: AppConstant.primarycolor),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                          'Preview will show employee-wise KPI scores. You can edit individual records before final import.',
                          style: TextStyle(
                              fontSize: 12,
                              color: AppConstant.textSecondary(context))),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => setState(() => _currentStep = 3),
                icon: const Icon(Icons.arrow_back, size: 16),
                label: const Text('Back'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppConstant.textSecondary(context),
                  side: BorderSide(color: AppConstant.border(context)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () async {
                  final file = await MobileFileActions.pickImportFile(
                      allowedExtensions: const ['csv', 'xlsx']);
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(file == null
                          ? 'Import cancelled.'
                          : 'Selected ${file.name} for validation.')));
                },
                icon: const Icon(Icons.check_circle_outline, size: 16),
                label: const Text('Import Evaluations',
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade600,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════
  //  IMPORT HISTORY TAB
  // ═══════════════════════════════════════════
  Widget _buildImportHistoryTab() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          // ── Filters ──
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildHistoryDepartmentDropdown(),
                const SizedBox(height: 12),
                _buildHistoryYearField(),
                const SizedBox(height: 12),
                _buildHistoryMonthDropdown(),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Action Performed!'))); },
                        icon: const Icon(Icons.search, size: 16),
                        label: const Text('Filter',
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w600)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppConstant.primarycolor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            _historyDepartment = 'All Departments';
                            _historyYear = '';
                            _historyMonth = 'All';
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppConstant.textSecondary(context),
                          side: BorderSide(color: AppConstant.border(context)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text('Clear',
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // ── Empty State ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildHistoryEmptyState(),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryDepartmentDropdown() {
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
          value: _historyDepartment,
          isDense: true,
          decoration: InputDecoration(
            hintText: 'All Departments',
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
          items: ['All Departments', ..._departments]
              .map((d) => DropdownMenuItem(
                    value: d,
                    child: Text(d,
                        style: TextStyle(
                            fontSize: 13,
                            color: AppConstant.textPrimary(context))),
                  ))
              .toList(),
          onChanged: (v) {
            if (v != null) setState(() => _historyDepartment = v);
          },
        ),
      ],
    );
  }

  Widget _buildHistoryYearField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Year',
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppConstant.textPrimary(context))),
        const SizedBox(height: 6),
        TextField(
          keyboardType: TextInputType.number,
          style:
              TextStyle(fontSize: 13, color: AppConstant.textPrimary(context)),
          decoration: InputDecoration(
            hintText: 'e.g. 2026',
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
          onChanged: (v) => _historyYear = v,
        ),
      ],
    );
  }

  Widget _buildHistoryMonthDropdown() {
    final months = [
      'All',
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Month',
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppConstant.textPrimary(context))),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: _historyMonth,
          isDense: true,
          decoration: InputDecoration(
            hintText: 'All',
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
          items: months
              .map((m) => DropdownMenuItem(
                    value: m,
                    child: Text(m,
                        style: TextStyle(
                            fontSize: 13,
                            color: AppConstant.textPrimary(context))),
                  ))
              .toList(),
          onChanged: (v) {
            if (v != null) setState(() => _historyMonth = v);
          },
        ),
      ],
    );
  }

  Widget _buildHistoryEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      decoration: BoxDecoration(
        color: AppConstant.cardBg(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppConstant.border(context)),
      ),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppConstant.inputBg(context),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.history_outlined,
                size: 36, color: AppConstant.textHint(context)),
          ),
          const SizedBox(height: 16),
          Text('No import history',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppConstant.textPrimary(context))),
          const SizedBox(height: 8),
          Text(
              'Bulk department imports will appear here after\nthe first import.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 13, color: AppConstant.textHint(context))),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════
  //  SHARED WIDGETS
  // ═══════════════════════════════════════════
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
              final monthNames = [
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
              setState(() =>
                  _selectedMonth = '${monthNames[date.month]} ${date.year}');
            }
          },
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
            hintText: 'Select Department',
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
}

// ═══════════════════════════════════════════
//  HELPER CLASSES
// ═══════════════════════════════════════════
class _StepData {
  final int num;
  final String label;
  _StepData(this.num, this.label);
}

// Dotted border placeholder widget
class DottedBorderWidget extends StatelessWidget {
  final Widget child;
  const DottedBorderWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
      decoration: BoxDecoration(
        color: AppConstant.inputBg(context),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppConstant.border(context),
          width: 1.5,
        ),
      ),
      child: child,
    );
  }
}
