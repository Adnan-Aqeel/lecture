import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:lecture/core/constants/app_colors.dart';
import 'package:lecture/core/widgets/shimmer_widgets.dart';
import 'package:lecture/core/utils/mobile_file_actions.dart';

class AttendanceRecord {
  final int id;
  final String name;
  final String email;
  final String department;
  final int totalDays;
  final int daysPresent;
  final int daysAbsent;
  final int lateDays;
  final int leavesTaken;
  final int holidayWorkedDays;
  final int holidayWorkedHours;
  final int expectedHours;
  final int totalHoursWorked;

  const AttendanceRecord({
    required this.id,
    required this.name,
    required this.email,
    required this.department,
    required this.totalDays,
    required this.daysPresent,
    required this.daysAbsent,
    required this.lateDays,
    required this.leavesTaken,
    required this.holidayWorkedDays,
    required this.holidayWorkedHours,
    required this.expectedHours,
    required this.totalHoursWorked,
  });
}

class MonthlyAttendanceScreen extends StatefulWidget {
  const MonthlyAttendanceScreen({super.key});

  @override
  State<MonthlyAttendanceScreen> createState() =>
      _MonthlyAttendanceScreenState();
}

class _MonthlyAttendanceScreenState extends State<MonthlyAttendanceScreen> {
  String _selectedYear = '2026';
  String _selectedMonth = 'August';
  String _summaryView = 'Monthly';
  int _currentPage = 1;
  int _itemsPerPage = 10;

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

  final List<AttendanceRecord> _records = [
    const AttendanceRecord(
        id: 1,
        name: 'ali',
        email: 'aliraza25924@gmail.com',
        department: 'Development',
        totalDays: 21,
        daysPresent: 0,
        daysAbsent: 0,
        lateDays: 0,
        leavesTaken: 0,
        holidayWorkedDays: 0,
        holidayWorkedHours: 0,
        expectedHours: 168,
        totalHoursWorked: 0),
    const AttendanceRecord(
        id: 2,
        name: 'zain',
        email: 'aliexpert48@gmail.com',
        department: 'Development',
        totalDays: 21,
        daysPresent: 0,
        daysAbsent: 0,
        lateDays: 0,
        leavesTaken: 0,
        holidayWorkedDays: 0,
        holidayWorkedHours: 0,
        expectedHours: 168,
        totalHoursWorked: 0),
    const AttendanceRecord(
        id: 3,
        name: 'amair',
        email: 'amair@gmail.com',
        department: 'Business Analyst',
        totalDays: 21,
        daysPresent: 0,
        daysAbsent: 0,
        lateDays: 0,
        leavesTaken: 0,
        holidayWorkedDays: 0,
        holidayWorkedHours: 0,
        expectedHours: 168,
        totalHoursWorked: 0),
    const AttendanceRecord(
        id: 4,
        name: 'ehsan',
        email: 'ehsan678@gmail.com',
        department: 'Development',
        totalDays: 21,
        daysPresent: 0,
        daysAbsent: 0,
        lateDays: 0,
        leavesTaken: 0,
        holidayWorkedDays: 0,
        holidayWorkedHours: 0,
        expectedHours: 168,
        totalHoursWorked: 0),
  ];

  int get _totalPages => (_records.length / _itemsPerPage).ceil();

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
              'Monthly Attendance Report',
              style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: AppConstant.textPrimary(context)),
            ),
            Text(
              'View attendance by month',
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
              Wrap(
                alignment: WrapAlignment.end,
                spacing: 8,
                runSpacing: 8,
                children: [
                  OutlinedButton.icon(
                      onPressed: () => MobileFileActions.exportPdf(
                        fileName: 'monthly_attendance_report',
                        title: 'Monthly Attendance Report',
                        headers: const ['Employee', 'Present', 'Absent', 'Late', 'Hours'],
                        shareText: 'Monthly attendance PDF export',
                      ),
                      icon: const Icon(Icons.picture_as_pdf_outlined, size: 14),
                      label: const Text('Export PDF',
                          style: TextStyle(fontSize: 11)),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red.shade400,
                        side: BorderSide(color: Colors.red.shade400),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                      ),
                    ),
            ]),
                  OutlinedButton.icon(
                      onPressed: () => MobileFileActions.exportCsv(
                        fileName: 'monthly_attendance_report',
                        headers: const ['Employee', 'Present', 'Absent', 'Late', 'Hours'],
                        shareText: 'Monthly attendance CSV export',
                      ),
                      icon: const Icon(Icons.download_outlined, size: 14),
                      label: const Text('Export CSV',
                          style: TextStyle(fontSize: 11)),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppConstant.primarycolor,
                        side: const BorderSide(color: AppConstant.primarycolor),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                      ),
           ) ,
              _buildFilters(),
              Column(
                children: [
                  _buildTableCard(),
                  _buildChartsSection(),
                ],
              ),
              _buildPagination(),
        ],
              ),
           
                      ),
      ));
  
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
      child: Row(
        children: [
          Expanded(
              child: _buildDropdown('Year', _selectedYear, _years,
                  (val) => setState(() => _selectedYear = val!))),
          const SizedBox(width: 16),
          Expanded(
              child: _buildDropdown('Month', _selectedMonth, _months,
                  (val) => setState(() => _selectedMonth = val!))),
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

  Widget _buildTableCard() {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
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
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: DataTable(
            headingRowColor: WidgetStateProperty.all(AppConstant.primarycolor),
            headingTextStyle: TextStyle(
                fontWeight: FontWeight.w700, color: AppConstant.textPrimary(context), fontSize: 10),
            dataRowColor: WidgetStateProperty.all(AppConstant.cardBg(context)),
            horizontalMargin: 16,
            columnSpacing: 16,
            columns: const [
              DataColumn(label: Text('#')),
              DataColumn(label: Text('EMPLOYEE NAME')),
              DataColumn(label: Text('EMAIL')),
              DataColumn(label: Text('DEPARTMENT')),
              DataColumn(label: Text('TOTAL DAYS')),
              DataColumn(label: Text('DAYS PRESENT')),
              DataColumn(label: Text('DAYS ABSENT')),
              DataColumn(label: Text('LATE DAYS')),
              DataColumn(label: Text('LEAVES TAKEN')),
              DataColumn(label: Text('HOLIDAY WORKED DAYS')),
              DataColumn(label: Text('HOLIDAY WORKED HOURS')),
              DataColumn(label: Text('EXPECTED HOURS')),
              DataColumn(label: Text('TOTAL HOURS WORKED')),
            ],
            rows: _records.map((record) {
              return DataRow(cells: [
                DataCell(
                    Text('${record.id}', style: const TextStyle(fontSize: 11))),
                DataCell(Text(record.name,
                    style: const TextStyle(
                        fontSize: 11, fontWeight: FontWeight.w600))),
                DataCell(Text(record.email,
                    style: TextStyle(
                        fontSize: 10,
                        color: AppConstant.textSecondary(context)))),
                DataCell(Text(record.department,
                    style: TextStyle(
                        fontSize: 11,
                        color: AppConstant.textSecondary(context)))),
                DataCell(Text('${record.totalDays}',
                    style: const TextStyle(fontSize: 11))),
                DataCell(Text('${record.daysPresent}',
                    style: const TextStyle(fontSize: 11))),
                DataCell(Text('${record.daysAbsent}',
                    style: const TextStyle(fontSize: 11))),
                DataCell(Text('${record.lateDays}',
                    style: const TextStyle(fontSize: 11))),
                DataCell(Text('${record.leavesTaken}',
                    style: const TextStyle(fontSize: 11))),
                DataCell(Text('${record.holidayWorkedDays}',
                    style: const TextStyle(fontSize: 11))),
                DataCell(_hoursBadge(
                    '${record.holidayWorkedHours}h',
                    AppConstant.border(context),
                    AppConstant.textSecondary(context))),
                DataCell(_hoursBadge('${record.expectedHours}h',
                    Colors.blue.shade100, Colors.blue.shade700)),
                DataCell(_hoursBadge('${record.totalHoursWorked}h',
                    Colors.red.shade100, Colors.red.shade700)),
              ]);
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _hoursBadge(String text, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
          color: bgColor, borderRadius: BorderRadius.circular(12)),
      child: Text(text,
          style: TextStyle(
              fontSize: 10, fontWeight: FontWeight.w600, color: textColor)),
    );
  }

  Widget _buildChartsSection() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          _buildAttendanceSummary(),
          const SizedBox(height: 12),
          _buildTopAttendanceChart(),
        ],
      ),
    );
  }

  Widget _buildAttendanceSummary() {
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
              Icon(Icons.pie_chart_outline,
                  size: 18, color: AppConstant.primarycolor),
              const SizedBox(width: 8),
              const Text('Attendance Summary',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 14),
          _viewToggle(),
          const SizedBox(height: 24),
          Center(
            child: Column(
              children: [
                Text('Total Days',
                    style: TextStyle(
                        fontSize: 14, color: AppConstant.textHint(context))),
                const SizedBox(height: 8),
                Text(
                  '${_records.fold(0, (sum, r) => sum + r.totalDays)}',
                  style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppConstant.primarycolor),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _buildSummaryLegend(),
        ],
      ),
    );
  }

  Widget _viewToggle() {
    return Container(
      decoration: BoxDecoration(
        color: AppConstant.tableHeaderBg(context),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: ['Weekly', 'Monthly', 'Yearly'].map((view) {
          final isSelected = _summaryView == view;
          return InkWell(
            onTap: () => setState(() => _summaryView = view),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color:
                    isSelected ? AppConstant.primarycolor : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                view,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected
                      ? Colors.white
                      : AppConstant.textSecondary(context),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSummaryLegend() {
    final items = [
      {'label': 'Present', 'color': const Color(0xFF26A69A)},
      {'label': 'Absent', 'color': const Color(0xFFEF5350)},
      {'label': 'Late', 'color': const Color(0xFFFFA726)},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: items.map((item) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
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
                      fontSize: 12, color: AppConstant.textSecondary(context))),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTopAttendanceChart() {
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
              Icon(Icons.bar_chart, size: 18, color: AppConstant.primarycolor),
              const SizedBox(width: 8),
              const Text('Top 10 by Attendance Rate',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 2.0,
                barTouchData: BarTouchData(enabled: true),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final employees = ['ali', 'zain', 'amair', 'ehsan'];
                        if (value.toInt() < employees.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(employees[value.toInt()],
                                style: TextStyle(
                                    fontSize: 10,
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
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) {
                        return Text('${value.toStringAsFixed(1)}',
                            style: TextStyle(
                                fontSize: 10,
                                color: AppConstant.textSecondary(context)));
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
                  horizontalInterval: 0.5,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                        color: AppConstant.border(context), strokeWidth: 1);
                  },
                ),
                barGroups: List.generate(4, (index) {
                  final rates = [0.0, 0.0, 0.0, 0.0];
                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: rates[index],
                        color: AppConstant.primarycolor,
                        width: 30,
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(6)),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPagination() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Show ',
                  style: TextStyle(
                      color: AppConstant.textSecondary(context), fontSize: 12)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: AppConstant.border(context)),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: DropdownButton<int>(
                  value: _itemsPerPage,
                  underline: const SizedBox(),
                  isDense: true,
                  icon: Icon(Icons.arrow_drop_down,
                      color: AppConstant.textSecondary(context), size: 18),
                  items: [10, 25, 50].map((int value) {
                    return DropdownMenuItem<int>(
                        value: value,
                        child: Text('$value',
                            style: const TextStyle(fontSize: 12)));
                  }).toList(),
                  onChanged: (int? newValue) {
                    setState(() {
                      _itemsPerPage = newValue!;
                      _currentPage = 1;
                    });
                  },
                ),
              ),
              Text(' entries',
                  style: TextStyle(
                      color: AppConstant.textSecondary(context), fontSize: 12)),
            ],
          ),
          Text(
            'Current page: $_currentPage – Records: ${_records.length} of ${_records.length}',
            style: TextStyle(
                color: AppConstant.textSecondary(context), fontSize: 12),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _pageButton(Icons.first_page, _currentPage > 1,
                  () => setState(() => _currentPage = 1)),
              _pageButton(Icons.chevron_left, _currentPage > 1,
                  () => setState(() => _currentPage--)),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                    color: AppConstant.primarycolor,
                    borderRadius: BorderRadius.circular(4)),
                child: Text('$_currentPage',
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12)),
              ),
              _pageButton(Icons.chevron_right, _currentPage < _totalPages,
                  () => setState(() => _currentPage++)),
              _pageButton(Icons.last_page, _currentPage < _totalPages,
                  () => setState(() => _currentPage = _totalPages)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _pageButton(IconData icon, bool enabled, VoidCallback onTap) {
    return InkWell(
      onTap: enabled ? onTap : null,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2),
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: enabled
              ? AppConstant.cardBg(context)
              : AppConstant.tableHeaderBg(context),
          border: Border.all(color: AppConstant.border(context)),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(icon,
            size: 16,
            color: enabled
                ? AppConstant.textSecondary(context)
                : AppConstant.textHint(context)),
      ),
    );
  }
}
