import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:lecture/core/constants/app_colors.dart';
import 'package:lecture/core/widgets/shimmer_widgets.dart';
import 'package:lecture/core/utils/mobile_file_actions.dart';

class EmployeeRecord {
  final int id;
  final String name;
  final String department;
  final String joiningDate;
  final String status;
  final int presentDays;
  final String email;
  final String phone;
  final int totalWorkingDays;
  final int attendancePercentage;
  final int attendanceDays;
  final int annualLeaveBalance;
  final int leaveDays;
  final int assignedAssets;
  final int loans;

  const EmployeeRecord({
    required this.id,
    required this.name,
    required this.department,
    required this.joiningDate,
    required this.status,
    required this.presentDays,
    required this.email,
    required this.phone,
    this.totalWorkingDays = 0,
    this.attendancePercentage = 0,
    this.attendanceDays = 0,
    this.annualLeaveBalance = 0,
    this.leaveDays = 0,
    this.assignedAssets = 0,
    this.loans = 0,
  });
}

class EmployeeReportScreen extends StatefulWidget {
  const EmployeeReportScreen({super.key});

  @override
  State<EmployeeReportScreen> createState() => _EmployeeReportScreenState();
}

class _EmployeeReportScreenState extends State<EmployeeReportScreen> {
  String _selectedYear = '2026';
  String _selectedMonth = 'August';
  int _currentPage = 1;
  int _itemsPerPage = 10;
  int? _selectedEmployeeIndex;

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

  final List<EmployeeRecord> _records = [
    const EmployeeRecord(
      id: 1,
      name: 'ali',
      department: 'Development',
      joiningDate: 'Dec 9, 2025',
      status: 'Active',
      presentDays: 0,
      email: 'aliraza25924@gmail.com',
      phone: '03055985858',
      totalWorkingDays: 23,
      attendancePercentage: 0,
      attendanceDays: 2,
      annualLeaveBalance: 14,
      leaveDays: 0,
    ),
    const EmployeeRecord(
      id: 2,
      name: 'zain',
      department: 'Development',
      joiningDate: 'Jan 1, 2026',
      status: 'Active',
      presentDays: 0,
      email: 'aliexpert48@gmail.com',
      phone: '03123456789',
      totalWorkingDays: 23,
      attendancePercentage: 0,
      attendanceDays: 2,
      annualLeaveBalance: 14,
      leaveDays: 0,
    ),
    const EmployeeRecord(
      id: 3,
      name: 'amair',
      department: 'Business Analyst',
      joiningDate: 'Jan 1, 2026',
      status: 'Active',
      presentDays: 0,
      email: 'amair@gmail.com',
      phone: '03211234567',
      totalWorkingDays: 23,
      attendancePercentage: 0,
      attendanceDays: 2,
      annualLeaveBalance: 14,
      leaveDays: 0,
    ),
    const EmployeeRecord(
      id: 4,
      name: 'ehsan',
      department: 'Development',
      joiningDate: 'Aug 2, 2026',
      status: 'Active',
      presentDays: 0,
      email: 'ehsan678@gmail.com',
      phone: '03331234567',
      totalWorkingDays: 23,
      attendancePercentage: 0,
      attendanceDays: 2,
      annualLeaveBalance: 14,
      leaveDays: 0,
    ),
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
              'Employee Report',
              style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: AppConstant.textPrimary(context)),
            ),
            Text(
              'Monthly attendance and employee performance summary.',
              style: TextStyle(
                  fontSize: 13, color: AppConstant.textPrimary(context)),
            ),
          ],
        ),
      ),
      body: ScreenShimmerWrapper(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: OutlinedButton.icon(
                  onPressed: () => MobileFileActions.exportPdf(
                    fileName: 'employee_report',
                    title: 'Employee Report',
                    headers: const ['Employee', 'Department', 'Status'],
                  ),
                  icon: const Icon(Icons.picture_as_pdf_outlined, size: 14),
                  label:
                      const Text('Export PDF', style: TextStyle(fontSize: 11)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red.shade400,
                    side: BorderSide(color: Colors.red.shade400),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  ),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              _buildFilters(),
              const SizedBox(height: 12),
              _buildTableCard(),
              if (_selectedEmployeeIndex != null) ...[
                const SizedBox(height: 12),
                _buildEmployeeDetails(),
              ],
              const SizedBox(height: 12),
              _buildChartsSection(),
              const SizedBox(height: 12),
              _buildTablePagination(),
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
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: DataTable(
                headingRowColor:
                    WidgetStateProperty.all(AppConstant.primarycolor),
                headingTextStyle: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppConstant.textPrimary(context),
                    fontSize: 10),
                dataRowColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return AppConstant.primarycolor.withValues(alpha: 0.1);
                  }
                  return AppConstant.cardBg(context);
                }),
                horizontalMargin: 16,
                columnSpacing: 20,
                columns: const [
                  DataColumn(label: Text('#')),
                  DataColumn(label: Text('EMPLOYEE NAME')),
                  DataColumn(label: Text('DEPARTMENT')),
                  DataColumn(label: Text('JOINING DATE')),
                  DataColumn(label: Text('STATUS')),
                  DataColumn(label: Text('PRESENT DAYS')),
                ],
                rows: List.generate(_records.length, (index) {
                  final record = _records[index];
                  final isSelected = _selectedEmployeeIndex == index;
                  return DataRow(
                    selected: isSelected,
                    onSelectChanged: (val) {
                      setState(() {
                        _selectedEmployeeIndex = isSelected ? null : index;
                      });
                    },
                    cells: [
                      DataCell(Text('${record.id}',
                          style: const TextStyle(fontSize: 11))),
                      DataCell(Text(record.name,
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w600))),
                      DataCell(Text(record.department,
                          style: TextStyle(
                              fontSize: 11,
                              color: AppConstant.textSecondary(context)))),
                      DataCell(Text(record.joiningDate,
                          style: TextStyle(
                              fontSize: 11,
                              color: AppConstant.textSecondary(context)))),
                      DataCell(_statusBadge(record.status)),
                      DataCell(Text('${record.presentDays}',
                          style: const TextStyle(fontSize: 11))),
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

  Widget _statusBadge(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: status == 'Active'
            ? const Color(0xFFE3F7EA)
            : AppConstant.tableHeaderBg(context),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: status == 'Active'
              ? const Color(0xFF1E9E5A)
              : AppConstant.textSecondary(context),
        ),
      ),
    );
  }

  Widget _buildTablePagination() {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Show ',
                    style: TextStyle(
                        color: AppConstant.textSecondary(context),
                        fontSize: 12)),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                      border: Border.all(color: AppConstant.border(context)),
                      borderRadius: BorderRadius.circular(4)),
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
                        color: AppConstant.textSecondary(context),
                        fontSize: 12)),
              ],
            ),
            Text(
              'Current page: $_currentPage – Records: ${_records.length} of ${_records.length}',
              style: TextStyle(
                  color: AppConstant.textSecondary(context), fontSize: 11),
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

  Widget _buildEmployeeDetails() {
    final emp = _records[_selectedEmployeeIndex!];

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
              Icon(Icons.person_outline,
                  size: 20, color: AppConstant.primarycolor),
              const SizedBox(width: 8),
              Text(emp.name,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Joining Date',
                      style: TextStyle(
                          fontSize: 10, color: AppConstant.textHint(context))),
                  Text(emp.joiningDate,
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w600)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          _infoRow(Icons.business_outlined, emp.department),
          _infoRow(Icons.email_outlined, emp.email),
          _infoRow(Icons.phone_outlined, emp.phone),
          _infoRowWithBadge(Icons.circle, 'Status', emp.status, Colors.green),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 12),
          Text('Monthly Summary for $_selectedMonth $_selectedYear',
              style:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _summaryGrid(emp),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 12),
          const Text('Employee Assets & Loans',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _assetsAndLoans(emp),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppConstant.textHint(context)),
          const SizedBox(width: 8),
          Text(value,
              style: TextStyle(
                  fontSize: 12, color: AppConstant.textSecondary(context))),
        ],
      ),
    );
  }

  Widget _infoRowWithBadge(
      IconData icon, String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 8, color: color),
          const SizedBox(width: 8),
          Text('$label: ',
              style: TextStyle(
                  fontSize: 12, color: AppConstant.textHint(context))),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8)),
            child: Text(value,
                style: TextStyle(
                    fontSize: 11, fontWeight: FontWeight.w600, color: color)),
          ),
        ],
      ),
    );
  }

  Widget _summaryGrid(EmployeeRecord emp) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
                child: _summaryItem('Total Working Days',
                    '${emp.totalWorkingDays}', Colors.blue)),
            const SizedBox(width: 12),
            Expanded(
                child: _summaryItem('Attendance Percentage',
                    '${emp.attendancePercentage}%', Colors.blue)),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
                child: _summaryItem(
                    'Attendance Days', '${emp.attendanceDays}', Colors.red)),
            const SizedBox(width: 12),
            Expanded(
                child: _summaryItem('Annual Leave Balance',
                    '${emp.annualLeaveBalance}', Colors.blue)),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
                child: _summaryItem(
                    'Leave Days', '${emp.leaveDays}', Colors.green)),
            const SizedBox(width: 12),
            const Expanded(child: SizedBox()),
          ],
        ),
      ],
    );
  }

  Widget _summaryItem(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: 11, color: AppConstant.textSecondary(context))),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
                color: color, borderRadius: BorderRadius.circular(12)),
            child: Text(value,
                style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _assetsAndLoans(EmployeeRecord emp) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppConstant.tableHeaderBg(context),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Assigned Assets',
                    style:
                        TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.circle,
                        size: 8, color: AppConstant.primarycolor),
                    const SizedBox(width: 6),
                    Text('${emp.assignedAssets} active assignments',
                        style: TextStyle(
                            fontSize: 11,
                            color: AppConstant.textSecondary(context))),
                  ],
                ),
                const SizedBox(height: 4),
                Text('No assets assigned.',
                    style: TextStyle(
                        fontSize: 10, color: AppConstant.textHint(context))),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppConstant.tableHeaderBg(context),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Loans',
                    style:
                        TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.circle,
                        size: 8, color: AppConstant.primarycolor),
                    const SizedBox(width: 6),
                    Text('${emp.loans} total loans',
                        style: TextStyle(
                            fontSize: 11,
                            color: AppConstant.textSecondary(context))),
                  ],
                ),
                const SizedBox(height: 4),
                Text('No loans found.',
                    style: TextStyle(
                        fontSize: 10, color: AppConstant.textHint(context))),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChartsSection() {
    return Column(
      children: [
        _buildGenderChart(),
        const SizedBox(height: 12),
        _buildAttendanceChart(),
      ],
    );
  }

  Widget _buildGenderChart() {
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
              const Text('Gender Distribution',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
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
                    value: 4,
                    color: const Color(0xFF5C6BC0),
                    radius: 50,
                    title: '',
                  ),
                  PieChartSectionData(
                    value: 0,
                    color: const Color(0xFFEF5350),
                    radius: 50,
                  ),
                  PieChartSectionData(
                    value: 0,
                    color: const Color(0xFF26A69A),
                    radius: 50,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Column(
              children: [
                const Text('Total',
                    style: TextStyle(fontSize: 12, color: Colors.grey)),
                Text('${_records.length}',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppConstant.primarycolor)),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _buildGenderLegend(),
        ],
      ),
    );
  }

  Widget _buildGenderLegend() {
    final items = [
      {'label': 'Male', 'color': const Color(0xFF5C6BC0)},
      {'label': 'Female', 'color': const Color(0xFFEF5350)},
      {'label': 'Other', 'color': const Color(0xFF26A69A)},
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
                      color: item['color'] as Color, shape: BoxShape.circle)),
              const SizedBox(width: 6),
              Text(item['label'] as String,
                  style: TextStyle(
                      fontSize: 11, color: AppConstant.textSecondary(context))),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAttendanceChart() {
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
              Icon(Icons.bar_chart, size: 18, color: AppConstant.primarycolor),
              const SizedBox(width: 8),
              const Text('Top 10 by Attendance',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 40),
          Center(
            child: Text(
              'No attendance data available',
              style:
                  TextStyle(fontSize: 12, color: AppConstant.textHint(context)),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
