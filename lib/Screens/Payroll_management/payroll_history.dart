import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lecture/appcolor.dart';
import 'package:lecture/widgets/shimmer_widgets.dart';
import 'package:lecture/utils/mobile_file_actions.dart';

class PayrollHistoryRecord {
  final int id;
  final String period;
  final String dateRange;
  final String status;
  final int employees;
  final double totalBasic;
  final double totalAllowances;
  final double totalEarnings;
  final double totalDeductions;
  final double netSalary;

  const PayrollHistoryRecord({
    required this.id,
    required this.period,
    required this.dateRange,
    required this.status,
    required this.employees,
    required this.totalBasic,
    required this.totalAllowances,
    required this.totalEarnings,
    required this.totalDeductions,
    required this.netSalary,
  });
}

class PayrollHistoryScreen extends StatefulWidget {
  const PayrollHistoryScreen({super.key});

  @override
  State<PayrollHistoryScreen> createState() => _PayrollHistoryScreenState();
}

class _PayrollHistoryScreenState extends State<PayrollHistoryScreen> {
  int _currentPage = 1;
  int _itemsPerPage = 10;

  final List<PayrollHistoryRecord> _records = [
    const PayrollHistoryRecord(
      id: 1,
      period: 'Nov 2026',
      dateRange: '01/11/2026 - 30/11/2026',
      status: 'Processed',
      employees: 2,
      totalBasic: 250000,
      totalAllowances: 16000,
      totalEarnings: 266000,
      totalDeductions: 184350,
      netSalary: 81650,
    ),
    const PayrollHistoryRecord(
      id: 2,
      period: 'Oct 2026',
      dateRange: '01/10/2026 - 31/10/2026',
      status: 'Locked',
      employees: 2,
      totalBasic: 250000,
      totalAllowances: 16000,
      totalEarnings: 266000,
      totalDeductions: 183333,
      netSalary: 82667,
    ),
    const PayrollHistoryRecord(
      id: 3,
      period: 'Sept 2026',
      dateRange: '01/09/2026 - 30/09/2026',
      status: 'Processed',
      employees: 2,
      totalBasic: 250000,
      totalAllowances: 16000,
      totalEarnings: 266000,
      totalDeductions: 183333,
      netSalary: 82667,
    ),
    const PayrollHistoryRecord(
      id: 4,
      period: 'Aug 2026',
      dateRange: '01/08/2026 - 31/08/2026',
      status: 'Processed',
      employees: 2,
      totalBasic: 250000,
      totalAllowances: 16000,
      totalEarnings: 266000,
      totalDeductions: 175000,
      netSalary: 91000,
    ),
    const PayrollHistoryRecord(
      id: 5,
      period: 'Jul 2026',
      dateRange: '01/07/2026 - 31/07/2026',
      status: 'Processed',
      employees: 2,
      totalBasic: 250000,
      totalAllowances: 16000,
      totalEarnings: 266000,
      totalDeductions: 191667,
      netSalary: 74333,
    ),
    const PayrollHistoryRecord(
      id: 6,
      period: 'May 2026',
      dateRange: '01/05/2026 - 31/05/2026',
      status: 'Locked',
      employees: 2,
      totalBasic: 250000,
      totalAllowances: 16000,
      totalEarnings: 266000,
      totalDeductions: 175000,
      netSalary: 91000,
    ),
    const PayrollHistoryRecord(
      id: 7,
      period: 'Apr 2026',
      dateRange: '01/04/2026 - 30/04/2026',
      status: 'Locked',
      employees: 1,
      totalBasic: 180000,
      totalAllowances: 11000,
      totalEarnings: 191000,
      totalDeductions: 132000,
      netSalary: 59000,
    ),
    const PayrollHistoryRecord(
      id: 8,
      period: 'Mar 2026',
      dateRange: '01/03/2026 - 31/03/2026',
      status: 'Processed',
      employees: 1,
      totalBasic: 150000,
      totalAllowances: 21000,
      totalEarnings: 171000,
      totalDeductions: 75500,
      netSalary: 95500,
    ),
    const PayrollHistoryRecord(
      id: 9,
      period: 'Feb 2026',
      dateRange: '01/02/2026 - 28/02/2026',
      status: 'Locked',
      employees: 1,
      totalBasic: 150000,
      totalAllowances: 16000,
      totalEarnings: 166000,
      totalDeductions: 0,
      netSalary: 166000,
    ),
    const PayrollHistoryRecord(
      id: 10,
      period: 'Apr 2025',
      dateRange: '01/04/2025 - 30/04/2025',
      status: 'Processed',
      employees: 1,
      totalBasic: 70000,
      totalAllowances: 5000,
      totalEarnings: 75000,
      totalDeductions: 51333,
      netSalary: 23667,
    ),
    const PayrollHistoryRecord(
      id: 11,
      period: 'Feb 2025',
      dateRange: '01/02/2025 - 28/02/2025',
      status: 'Processed',
      employees: 0,
      totalBasic: 0,
      totalAllowances: 0,
      totalEarnings: 0,
      totalDeductions: 0,
      netSalary: 0,
    ),
    const PayrollHistoryRecord(
      id: 12,
      period: 'Jan 2025',
      dateRange: '01/01/2025 - 31/01/2025',
      status: 'Processed',
      employees: 0,
      totalBasic: 0,
      totalAllowances: 0,
      totalEarnings: 0,
      totalDeductions: 0,
      netSalary: 0,
    ),
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
              'Payroll History',
              style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: AppConstant.textPrimary(context)),
            ),
            Text(
              'View summary of all generated payroll runs.',
              style: TextStyle(
                  fontSize: 13, color: AppConstant.textPrimary(context)),
            ),
          ],
        ),
      ),
      body: ScreenShimmerWrapper(
        child: Column(
          children: [
            SizedBox(
              height: 15,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: OutlinedButton.icon(
                onPressed: () => MobileFileActions.exportPdf(
                  fileName: 'payroll_history',
                  title: 'Payroll History',
                  headers: const ['Employee', 'Period', 'Gross', 'Net', 'Status'],
                ),
                icon: const Icon(Icons.download_outlined, size: 16),
                label:
                    const Text('Download PDF', style: TextStyle(fontSize: 12)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppConstant.primarycolor,
                  side: const BorderSide(color: AppConstant.primarycolor),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                ),
              ),
            ),
            Expanded(child: _buildTableCard()),
            _buildPagination(),
          ],
        ),
      ),
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
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: _buildDataTable(),
    );
  }

  Widget _buildDataTable() {
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = startIndex + _itemsPerPage;
    final visibleItems = _records.sublist(
      startIndex,
      endIndex > _records.length ? _records.length : endIndex,
    );
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor: WidgetStateProperty.all(AppConstant.primarycolor),
        headingTextStyle: TextStyle(
          fontWeight: FontWeight.w700,
                    color: AppConstant.textPrimary(context),
          fontSize: 10,
        ),
        dataRowColor: WidgetStateProperty.all(AppConstant.cardBg(context)),
        horizontalMargin: 16,
        columnSpacing: 20,
        columns: const [
          DataColumn(label: Text('#')),
          DataColumn(label: Text('PERIOD')),
          DataColumn(label: Text('STATUS')),
          DataColumn(label: Text('EMPLOYEES')),
          DataColumn(label: Text('TOTAL BASIC')),
          DataColumn(label: Text('TOTAL ALLOWANCES')),
          DataColumn(label: Text('TOTAL EARNINGS')),
          DataColumn(label: Text('TOTAL DEDUCTIONS')),
          DataColumn(label: Text('NET SALARY')),
          DataColumn(label: Text('ACTIONS')),
        ],
        rows: visibleItems.map((record) {
          return DataRow(
            cells: [
              DataCell(
                  Text('${record.id}', style: const TextStyle(fontSize: 11))),
              DataCell(
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(record.period,
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w600)),
                    Text(record.dateRange,
                        style: TextStyle(
                            fontSize: 10,
                            color: AppConstant.textHint(context))),
                  ],
                ),
              ),
              DataCell(_statusBadge(record.status)),
              DataCell(Text('${record.employees}',
                  style: const TextStyle(fontSize: 11))),
              DataCell(Text('PKR ${record.totalBasic.toStringAsFixed(0)}',
                  style: const TextStyle(fontSize: 11))),
              DataCell(Text('PKR ${record.totalAllowances.toStringAsFixed(0)}',
                  style: const TextStyle(fontSize: 11))),
              DataCell(Text('PKR ${record.totalEarnings.toStringAsFixed(0)}',
                  style: const TextStyle(fontSize: 11))),
              DataCell(Text('PKR ${record.totalDeductions.toStringAsFixed(0)}',
                  style: const TextStyle(fontSize: 11))),
              DataCell(
                Text(
                  'PKR ${record.netSalary.toStringAsFixed(0)}',
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppConstant.primarycolor),
                ),
              ),
              DataCell(
                InkWell(
                  onTap: () => _viewDetails(record),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppConstant.primarycolor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(Icons.visibility_outlined,
                        size: 16, color: AppConstant.primarycolor),
                  ),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _statusBadge(String status) {
    Color bgColor;
    Color textColor;

    if (status == 'Locked') {
      bgColor = Colors.blue.shade100;
      textColor = Colors.blue.shade700;
    } else {
      bgColor = Colors.green.shade100;
      textColor = Colors.green.shade700;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
          color: bgColor, borderRadius: BorderRadius.circular(12)),
      child: Text(status,
          style: TextStyle(
              fontSize: 10, fontWeight: FontWeight.w600, color: textColor)),
    );
  }

  Widget _buildPagination() {
    final totalPages = (_records.length / _itemsPerPage).ceil();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Row(
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
                      child:
                          Text('$value', style: const TextStyle(fontSize: 12)),
                    );
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
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text('$_currentPage',
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12)),
              ),
              _pageButton(Icons.chevron_right, _currentPage < totalPages,
                  () => setState(() => _currentPage++)),
              _pageButton(Icons.last_page, _currentPage < totalPages,
                  () => setState(() => _currentPage = totalPages)),
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

  void _viewDetails(PayrollHistoryRecord record) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text('Payroll Details - ${record.period}'),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.85,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _detailRow('Period', record.period),
              _detailRow('Date Range', record.dateRange),
              _detailRow('Status', record.status),
              _detailRow('Employees', '${record.employees}'),
              const Divider(),
              _detailRow(
                  'Total Basic', 'PKR ${record.totalBasic.toStringAsFixed(0)}'),
              _detailRow('Total Allowances',
                  'PKR ${record.totalAllowances.toStringAsFixed(0)}'),
              _detailRow('Total Earnings',
                  'PKR ${record.totalEarnings.toStringAsFixed(0)}'),
              _detailRow('Total Deductions',
                  'PKR ${record.totalDeductions.toStringAsFixed(0)}'),
              const Divider(),
              _detailRow(
                  'Net Salary', 'PKR ${record.netSalary.toStringAsFixed(0)}',
                  isBold: true),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: 12, color: AppConstant.textSecondary(context))),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              color: isBold
                  ? AppConstant.primarycolor
                  : AppConstant.textPrimary(context),
            ),
          ),
        ],
      ),
    );
  }
}
