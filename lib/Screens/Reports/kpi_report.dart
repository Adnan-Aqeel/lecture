import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lecture/appcolor.dart';
import 'package:lecture/widgets/shimmer_widgets.dart';
import 'package:lecture/utils/mobile_file_actions.dart';

class KpiReportScreen extends StatefulWidget {
  const KpiReportScreen({super.key});

  @override
  State<KpiReportScreen> createState() => _KpiReportScreenState();
}

class _KpiReportScreenState extends State<KpiReportScreen> {
  String _selectedYear = '2026';
  String _selectedMonth = 'August';
  String _chartView = 'Monthly';
  final _searchController = TextEditingController();

  final List<String> _years = ['2024', '2025', '2026', '2027'];
  final List<String> _months = [
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

  @override
  void dispose() {
    _searchController.dispose();
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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'KPI Report',
              style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: AppConstant.textPrimary(context)),
            ),
            Text(
              'Monthly and yearly KPI evaluation summaries.',
              style: TextStyle(fontSize: 13, color: AppConstant.textPrimary(context)),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: IconButton(
              onPressed: () { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Action Performed!'))); },
              icon: const Icon(Icons.refresh, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
      body: ScreenShimmerWrapper(
        child: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: OutlinedButton(
                    onPressed: () => MobileFileActions.exportPdf(
                      fileName: 'kpi_yearly_report',
                      title: 'Yearly KPI Report',
                      headers: const ['Employee', 'Department', 'KPI Score', 'Rating'],
                      shareText: 'Yearly KPI PDF export',
                    ),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: AppConstant.primarycolor,
                      foregroundColor: Colors.white,
                      side: const BorderSide(
                        color: Colors.white,
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 6),
                    ),
                    child: const Text('Yearly PDF',
                        style: TextStyle(fontSize: 10)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: ElevatedButton(
                    onPressed: () => MobileFileActions.exportCsv(
                      fileName: 'kpi_yearly_report',
                      headers: const ['Employee', 'Department', 'KPI Score', 'Rating'],
                      shareText: 'Yearly KPI CSV export',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConstant.primarycolor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 6),
                    ),
                    child: const Text('Yearly CSV',
                        style: TextStyle(fontSize: 10)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: OutlinedButton(
                    onPressed: () => MobileFileActions.exportPdf(
                      fileName: 'kpi_report',
                      title: 'KPI Report',
                      headers: const ['Employee', 'Department', 'KPI Score', 'Rating'],
                      shareText: 'KPI PDF export',
                    ),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: AppConstant.primarycolor,
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 6),
                    ),
                    child: const Text('Export PDF',
                        style: TextStyle(fontSize: 10)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: OutlinedButton(
                    onPressed: () => MobileFileActions.exportCsv(
                      fileName: 'kpi_report',
                      headers: const ['Employee', 'Department', 'KPI Score', 'Rating'],
                      shareText: 'KPI CSV export',
                    ),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: AppConstant.primarycolor,
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 6),
                    ),
                    child: const Text('Export CSV',
                        style: TextStyle(fontSize: 10)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _buildFilters(),
            const SizedBox(height: 12),
            _buildSummaryCards(),
            const SizedBox(height: 12),
            _buildKpiDetails(),
            const SizedBox(height: 12),
            _buildChartsSection(),
          ],
        ),
      ),
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppConstant.cardBg(context),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 6,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Search',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search employee...',
              hintStyle: TextStyle(color: AppConstant.textHint(context), fontSize: 12),
              prefixIcon:
                  Icon(Icons.search, color: AppConstant.textHint(context), size: 20),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppConstant.border(context))),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppConstant.border(context))),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                  child: _buildDropdown('Year', _selectedYear, _years,
                      (val) => setState(() => _selectedYear = val!))),
              const SizedBox(width: 12),
              Expanded(
                  child: _buildDropdown('Month', _selectedMonth, _months,
                      (val) => setState(() => _selectedMonth = val!))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(String label, String value, List<String> items,
      ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(fontSize: 11, color: AppConstant.textSecondary(context))),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: value,
          isExpanded: true,
          isDense: true,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppConstant.border(context))),
          ),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
                value: item,
                child: Text(item, style: const TextStyle(fontSize: 12)));
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildSummaryCards() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppConstant.cardBg(context),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 6,
                    offset: const Offset(0, 2)),
              ],
            ),
            child: Column(
              children: [
                Icon(Icons.people_outline,
                    size: 32, color: AppConstant.primarycolor),
                const SizedBox(height: 10),
                Text(
                  '0',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppConstant.primarycolor),
                ),
                const SizedBox(height: 4),
                Text(
                  'Employees Evaluated',
                  style: TextStyle(fontSize: 12, color: AppConstant.textSecondary(context)),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppConstant.cardBg(context),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 6,
                    offset: const Offset(0, 2)),
              ],
            ),
            child: Column(
              children: [
                Icon(Icons.speed_outlined,
                    size: 32, color: AppConstant.primarycolor),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '0',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppConstant.primarycolor),
                    ),
                    Text(
                      '%',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppConstant.primarycolor),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Average Total KPI Score',
                  style: TextStyle(fontSize: 12, color: AppConstant.textSecondary(context)),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildKpiDetails() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppConstant.cardBg(context),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.table_chart_outlined,
                  size: 18, color: AppConstant.primarycolor),
              const SizedBox(width: 8),
              const Text('KPI DETAILS',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 50),
          Center(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppConstant.tableHeaderBg(context),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.show_chart,
                      size: 40, color: AppConstant.textHint(context)),
                ),
                const SizedBox(height: 16),
                Text(
                  'No KPI Results Found',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppConstant.textPrimary(context)),
                ),
                const SizedBox(height: 8),
                Text(
                  'No KPI evaluations match your current filters for the selected period.',
                  style: TextStyle(fontSize: 12, color: AppConstant.textHint(context)),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }

  Widget _buildChartsSection() {
    return Column(
      children: [
        _buildPerformanceDistribution(),
        const SizedBox(height: 12),
        _buildTopScoresChart(),
      ],
    );
  }

  Widget _buildPerformanceDistribution() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppConstant.cardBg(context),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 6,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.pie_chart_outline,
                  size: 18, color: AppConstant.primarycolor),
              const SizedBox(width: 8),
              const Text('Performance Distribution',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 10),
          _chartToggle(),
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

  Widget _chartToggle() {
    return Container(
      decoration: BoxDecoration(
          color: AppConstant.tableHeaderBg(context), borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: ['Weekly', 'Monthly', 'Yearly'].map((view) {
          final isSelected = _chartView == view;
          return InkWell(
            onTap: () => setState(() => _chartView = view),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color:
                    isSelected ? AppConstant.primarycolor : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                view,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected ? Colors.white : AppConstant.textSecondary(context),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTopScoresChart() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppConstant.cardBg(context),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 6,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.leaderboard_outlined,
                  size: 18, color: AppConstant.primarycolor),
              const SizedBox(width: 8),
              const Text('Top 10 KPI Scores',
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
}
