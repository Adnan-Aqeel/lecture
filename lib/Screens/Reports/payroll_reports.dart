import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:lecture/appcolor.dart';
import 'package:lecture/widgets/shimmer_widgets.dart';
import 'package:lecture/utils/mobile_file_actions.dart';

class PayrollReportsScreen extends StatefulWidget {
  const PayrollReportsScreen({super.key});

  @override
  State<PayrollReportsScreen> createState() => _PayrollReportsScreenState();
}

class _PayrollReportsScreenState extends State<PayrollReportsScreen> {
  String _selectedYear = '2026';
  String _selectedMonth = 'August';
  String _selectedPayrollRun = 'Run #1003 (2 employees)';
  String _reportType = 'Monthly';
  int _selectedTab = 0;

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
  final List<String> _payrollRuns = [
    'Run #1003 (2 employees)',
    'Run #1002 (3 employees)',
    'Run #1001 (1 employee)',
  ];
  final List<String> _tabs = [
    'Summary',
    'Detail',
    'Slip Register',
    'Payments',
    'Deductions',
    'Audit'
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
              'Payroll Reports',
              style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: AppConstant.textPrimary(context)),
            ),
            Text(
              'Generate monthly and annual payroll summaries and reports.',
              style: TextStyle(
                  fontSize: 13, color: AppConstant.textPrimary(context)),
            ),
          ],
        ),
      ),
      body: ScreenShimmerWrapper(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                  _buildTypeBtn('Monthly'),
                  _buildTypeBtn('Annual'),
                  const SizedBox(width: 8),
                  OutlinedButton.icon(
                      onPressed: () => MobileFileActions.exportCsv(
                        fileName: 'payroll_report',
                        headers: const ['Employee', 'Payroll Run', 'Gross', 'Net', 'Status'],
                        shareText: 'Payroll report export',
                      ),
                      icon: const Icon(Icons.download_outlined, size: 14),
                      label: const Text('Export CSV',
                          style: TextStyle(fontSize: 11)),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppConstant.primarycolor,
                        side: const BorderSide(
                          color: AppConstant.primarycolor,
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                      ),
                  ),
                ],
              ),
            ),
              _buildFilters(),
              _buildTabs(),
              _buildTabContent(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeBtn(String type) {
    final isSelected = _reportType == type;
    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: ChoiceChip(
        label: Text(type,
            style: TextStyle(
                fontSize: 11,
                color: isSelected
                    ? Colors.black
                    : AppConstant.textSecondary(context))),
        selected: isSelected,
        selectedColor: AppConstant.primarycolor,
        backgroundColor: AppConstant.cardBg(context),
        onSelected: (val) => setState(() => _reportType = type),
        padding: const EdgeInsets.symmetric(horizontal: 10),
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppConstant.cardBg(context),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 6,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          _buildDropdown('Year', _selectedYear, _years,
              (val) => setState(() => _selectedYear = val!)),
          const SizedBox(width: 12),
          _buildDropdown('Month', _selectedMonth, _months,
              (val) => setState(() => _selectedMonth = val!)),
          const SizedBox(width: 12),
          _buildDropdown('Payroll Run', _selectedPayrollRun, _payrollRuns,
              (val) => setState(() => _selectedPayrollRun = val!)),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Period',
                    style: TextStyle(
                        fontSize: 11,
                        color: AppConstant.textSecondary(context))),
              ),
              const SizedBox(height: 8),
              Text(
                '$_selectedMonth $_selectedYear',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppConstant.textPrimary(context)),
              ),
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
            style: TextStyle(
                fontSize: 11, color: AppConstant.textSecondary(context))),
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

  Widget _buildTabs() {
    return Container(
      decoration: BoxDecoration(
        color: AppConstant.cardBg(context),
        border: Border(bottom: BorderSide(color: AppConstant.border(context))),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(_tabs.length, (index) {
            final isSelected = _selectedTab == index;
            return InkWell(
              onTap: () => setState(() => _selectedTab = index),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: isSelected
                          ? AppConstant.primarycolor
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                ),
                child: Text(
                  _tabs[index],
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.normal,
                    color: isSelected
                        ? AppConstant.primarycolor
                        : AppConstant.textSecondary(context),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTab) {
      case 0:
        return _buildSummaryTab();
      case 1:
        return _buildDetailTab();
      case 2:
        return _buildSlipRegisterTab();
      case 3:
        return _buildPaymentsTab();
      case 4:
        return _buildDeductionsTab();
      case 5:
        return _buildAuditTab();
      default:
        return _buildSummaryTab();
    }
  }

  Widget _buildSummaryTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSummaryHeader(),
          const SizedBox(height: 16),
          _buildSummaryTable(),
          const SizedBox(height: 20),
          _buildChartsRow(),
        ],
      ),
    );
  }

  Widget _buildSummaryHeader() {
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
      child: Row(
        children: [
          const Text('Payroll Summary',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          const Spacer(),
          Text('Run #1003 · 2 employees',
              style: TextStyle(
                  fontSize: 12, color: AppConstant.textSecondary(context))),
        ],
      ),
    );
  }

  Widget _buildSummaryTable() {
    return Container(
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
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: DataTable(
            headingRowColor: WidgetStateProperty.all(
              AppConstant.primarycolor,
            ),
            headingTextStyle: TextStyle(
                fontWeight: FontWeight.w700, color: AppConstant.textPrimary(context), fontSize: 10),
            horizontalMargin: 16,
            columnSpacing: 20,
            columns: const [
              DataColumn(label: Text('PERIOD')),
              DataColumn(label: Text('EMPLOYEES')),
              DataColumn(label: Text('TOTAL BASIC')),
              DataColumn(label: Text('TOTAL ALLOWANCES')),
              DataColumn(label: Text('TOTAL EARNINGS (GROSS)')),
              DataColumn(label: Text('TOTAL DEDUCTIONS')),
              DataColumn(label: Text('NET SALARY')),
            ],
            rows: [
              DataRow(cells: [
                DataCell(Text('$_selectedMonth $_selectedYear',
                    style: const TextStyle(fontSize: 12))),
                DataCell(Text('2', style: const TextStyle(fontSize: 12))),
                DataCell(Text('250,000', style: const TextStyle(fontSize: 12))),
                DataCell(Text('16,000', style: const TextStyle(fontSize: 12))),
                DataCell(Text('266,000', style: const TextStyle(fontSize: 12))),
                DataCell(
                    Text('174,999.93', style: const TextStyle(fontSize: 12))),
                DataCell(Text('91,000.07',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppConstant.primarycolor))),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChartsRow() {
    return Column(
      children: [
        _buildEarningsPieChart(),
        const SizedBox(height: 16),
        _buildTopSalariesBarChart(),
      ],
    );
  }

  Widget _buildEarningsPieChart() {
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
                  size: 16, color: AppConstant.primarycolor),
              const SizedBox(width: 6),
              const Text('EARNINGS COMPOSITION',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 50,
                sections: [
                  PieChartSectionData(
                    value: 47.6,
                    color: const Color(0xFF5C6BC0),
                    radius: 50,
                    title: '47.6%',
                    titleStyle: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  PieChartSectionData(
                    value: 2.6,
                    color: const Color(0xFF26A69A),
                    radius: 50,
                    title: '2.6%',
                    titleStyle: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  PieChartSectionData(
                    value: 32.9,
                    color: const Color(0xFFEF5350),
                    radius: 50,
                    title: '32.9%',
                    titleStyle: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  PieChartSectionData(
                    value: 17.1,
                    color: const Color(0xFFFFA726),
                    radius: 50,
                    title: '17.1%',
                    titleStyle: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildLegend(),
        ],
      ),
    );
  }

  Widget _buildLegend() {
    final items = [
      {'label': 'Basic Salaries', 'color': const Color(0xFF5C6BC0)},
      {'label': 'Allowances', 'color': const Color(0xFF26A69A)},
      {'label': 'Deductions', 'color': const Color(0xFFEF5350)},
      {'label': 'Net Salary', 'color': const Color(0xFFFFA726)},
    ];

    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: items.map((item) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                  color: item['color'] as Color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 6),
            Text(item['label'] as String,
                style: TextStyle(
                    fontSize: 11, color: AppConstant.textSecondary(context))),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildTopSalariesBarChart() {
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
              Icon(Icons.bar_chart, size: 16, color: AppConstant.primarycolor),
              const SizedBox(width: 6),
              const Text('TOP 10 NET SALARIES',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 220,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 80000,
                barTouchData: BarTouchData(enabled: true),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final employees = ['ali', 'zain'];
                        if (value.toInt() < employees.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(employees[value.toInt()],
                                style: TextStyle(
                                    fontSize: 11,
                                    color: AppConstant.textSecondary(context))),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${(value / 1000).toStringAsFixed(0)}k',
                          style: TextStyle(
                              fontSize: 10,
                              color: AppConstant.textSecondary(context)),
                        );
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 20000,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                        color: AppConstant.border(context), strokeWidth: 1);
                  },
                ),
                barGroups: [
                  BarChartGroupData(
                    x: 0,
                    barRods: [
                      BarChartRodData(
                        toY: 65000,
                        color: const Color(0xFF26A69A),
                        width: 40,
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(6)),
                      ),
                    ],
                  ),
                  BarChartGroupData(
                    x: 1,
                    barRods: [
                      BarChartRodData(
                        toY: 26000,
                        color: const Color(0xFF26A69A),
                        width: 40,
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(6)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailTab() {
    return _buildComingSoon('Detail Report');
  }

  Widget _buildSlipRegisterTab() {
    return _buildComingSoon('Slip Register');
  }

  Widget _buildPaymentsTab() {
    return _buildComingSoon('Payments Report');
  }

  Widget _buildDeductionsTab() {
    return _buildComingSoon('Deductions Report');
  }

  Widget _buildAuditTab() {
    return _buildComingSoon('Audit Report');
  }

  Widget _buildComingSoon(String tabName) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.construction,
                size: 56, color: AppConstant.textHint(context)),
            const SizedBox(height: 16),
            Text(
              '$tabName',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppConstant.textPrimary(context)),
            ),
            const SizedBox(height: 8),
            Text(
              'Coming soon...',
              style:
                  TextStyle(fontSize: 13, color: AppConstant.textHint(context)),
            ),
          ],
        ),
      ),
    );
  }
}
