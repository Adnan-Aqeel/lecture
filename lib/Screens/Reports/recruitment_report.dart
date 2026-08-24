import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lecture/appcolor.dart';
import 'package:lecture/widgets/shimmer_widgets.dart';
import 'package:lecture/utils/mobile_file_actions.dart';

class RecruitmentReportScreen extends StatefulWidget {
  const RecruitmentReportScreen({super.key});

  @override
  State<RecruitmentReportScreen> createState() =>
      _RecruitmentReportScreenState();
}

class _RecruitmentReportScreenState extends State<RecruitmentReportScreen> {
  int _selectedTab = 0;
  DateTime? _fromDate;
  DateTime? _toDate;
  String _selectedDepartment = 'All';
  final _departments = [
    'All',
    'Engineering',
    'Marketing',
    'HR',
    'Sales',
    'Finance'
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
              'Recruitment Report',
              style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: AppConstant.textPrimary(context)),
            ),
            Text(
              'Track hiring pipeline, positions, and time-to-hire metrics.',
              style: TextStyle(fontSize: 13, color: AppConstant.textPrimary(context)),
            ),
          ],
        ),
      ),
      body: ScreenShimmerWrapper(
        child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: OutlinedButton.icon(
                    onPressed: () => MobileFileActions.exportPdf(
                      fileName: 'recruitment_dashboard',
                      title: 'Recruitment Dashboard',
                      headers: const ['Metric', 'Value'],
                    ),
                    icon:
                        const Icon(Icons.download, size: 14, color: Colors.red),
                    label: const Text('Dashboard PDF',
                        style: TextStyle(fontSize: 10, color: Colors.red)),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 6),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: OutlinedButton.icon(
                    onPressed: () => MobileFileActions.exportPdf(
                      fileName: 'recruitment_positions',
                      title: 'Recruitment Positions',
                      headers: const ['Position', 'Department', 'Status'],
                    ),
                    icon:
                        const Icon(Icons.download, size: 14, color: Colors.red),
                    label: const Text('Positions PDF',
                        style: TextStyle(fontSize: 10, color: Colors.red)),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 6),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              color: AppConstant.cardBg(context),
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFilters(),
                  const SizedBox(height: 12),
                  _buildTabs(),
                ],
              ),
            ),
            Column(
              children: [
                _buildCandidatePipeline(),
                const SizedBox(height: 12),
                _buildDepartmentMetrics(),
                const SizedBox(height: 12),
                _buildAvgDaysToHire(),
              ],
            ),
          ],
        ),
      ),
      ),
    );
  }

  Widget _buildFilters() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            _buildDateField('From Date', _fromDate,
                (date) => setState(() => _fromDate = date)),
            const SizedBox(width: 12),
            _buildDateField(
                'To Date', _toDate, (date) => setState(() => _toDate = date)),
            const SizedBox(width: 12),
            _buildDepartmentDropdown(),
            const SizedBox(width: 12),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 44,
                child: ElevatedButton.icon(
                  onPressed: () { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Action Performed!'))); },
                  icon: const Icon(Icons.filter_list,
                      size: 18, color: Colors.white),
                  label: const Text('Apply Filters',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w600)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstant.primarycolor,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDateField(
      String label, DateTime? date, ValueChanged<DateTime?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(fontSize: 12, color: AppConstant.textSecondary(context))),
        const SizedBox(height: 6),
        InkWell(
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: date ?? DateTime.now(),
              firstDate: DateTime(2020),
              lastDate: DateTime(2030),
            );
            if (picked != null) onChanged(picked);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              border: Border.all(color: AppConstant.border(context)),
              borderRadius: BorderRadius.circular(8),
              color: AppConstant.inputBg(context),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    date != null
                        ? '${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}/${date.year}'
                        : 'mm/dd/yyyy',
                    style: TextStyle(
                      fontSize: 13,
                      color:
                          date != null ? AppConstant.textPrimary(context) : AppConstant.textHint(context),
                    ),
                  ),
                ),
                Icon(Icons.calendar_today,
                    size: 18, color: AppConstant.textHint(context)),
              ],
            ),
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
            style: TextStyle(fontSize: 12, color: AppConstant.textSecondary(context))),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: _selectedDepartment,
          isExpanded: true,
          isDense: true,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppConstant.border(context))),
            filled: true,
            fillColor: AppConstant.inputBg(context),
          ),
          items: _departments.map((String dept) {
            return DropdownMenuItem<String>(
                value: dept,
                child: Text(dept, style: const TextStyle(fontSize: 13)));
          }).toList(),
          onChanged: (val) => setState(() => _selectedDepartment = val!),
        ),
      ],
    );
  }

  Widget _buildTabs() {
    final tabs = ['Dashboard', 'By Position', 'By Department', 'Time to Hire'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(tabs.length, (index) {
          final isSelected = _selectedTab == index;
          return GestureDetector(
            onTap: () => setState(() => _selectedTab = index),
            child: Padding(
              padding: const EdgeInsets.only(right: 24),
              child: Column(
                children: [
                  Text(
                    tabs[index],
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
                      color: isSelected
                          ? AppConstant.primarycolor
                          : AppConstant.textSecondary(context),
                    ),
                  ),
                  const SizedBox(height: 6),
                  if (isSelected)
                    Container(
                      height: 2,
                      width: tabs[index].length * 7.0,
                      decoration: BoxDecoration(
                        color: AppConstant.primarycolor,
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCandidatePipeline() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.bar_chart, size: 18, color: AppConstant.primarycolor),
              const SizedBox(width: 8),
              const Text('Candidate Pipeline by Position',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 40),
          Center(
            child: Text('No data available',
                style: TextStyle(fontSize: 12, color: AppConstant.textHint(context))),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildDepartmentMetrics() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.grid_on, size: 18, color: AppConstant.primarycolor),
              const SizedBox(width: 8),
              const Text('Department Metrics Comparison',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 40),
          Center(
            child: Text('No data available',
                style: TextStyle(fontSize: 12, color: AppConstant.textHint(context))),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildAvgDaysToHire() {
    return Row(
      children: [
        Expanded(
            child: _buildAvgCard(
                'Avg Days to Hire — By Position', Icons.access_time)),
        const SizedBox(width: 12),
        Expanded(
            child: _buildAvgCard('Avg Days to Hire — By Department',
                Icons.table_chart_outlined)),
      ],
    );
  }

  Widget _buildAvgCard(String title, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: AppConstant.primarycolor),
              const SizedBox(width: 8),
              Expanded(
                child: Text(title,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 40),
          Center(
            child: Text('No data available',
                style: TextStyle(fontSize: 11, color: AppConstant.textHint(context))),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: AppConstant.cardBg(context),
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2)),
      ],
    );
  }
}
