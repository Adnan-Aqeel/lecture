import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lecture/core/constants/app_colors.dart';
import 'package:lecture/core/widgets/shimmer_widgets.dart';
import 'package:lecture/core/utils/mobile_file_actions.dart';

class PayrollEmployee {
  final int sno;
  final String employeeId;
  final String name;
  final String doj;
  final int monthDays;
  final int workingDays;
  final int present;
  final int absent;
  final int paidDays;
  final int unpaidDays;
  final int expectedHours;
  final int actualHours;
  final int extraHours;
  final double basicSalary;
  final double salaryPerDay;
  final double salaryPerHour;
  final double houseAllow;
  final double medicalAllow;
  final double travelAllow;

  const PayrollEmployee({
    required this.sno,
    required this.employeeId,
    required this.name,
    required this.doj,
    required this.monthDays,
    required this.workingDays,
    required this.present,
    required this.absent,
    required this.paidDays,
    required this.unpaidDays,
    required this.expectedHours,
    required this.actualHours,
    required this.extraHours,
    required this.basicSalary,
    required this.salaryPerDay,
    required this.salaryPerHour,
    required this.houseAllow,
    required this.medicalAllow,
    required this.travelAllow,
  });
}

class PayrollRunScreen extends StatefulWidget {
  const PayrollRunScreen({super.key});

  @override
  State<PayrollRunScreen> createState() => _PayrollRunScreenState();
}

class _PayrollRunScreenState extends State<PayrollRunScreen> {
  String _selectedMonth = 'August';
  String _selectedYear = '2026';
  String _filterStatus = 'All';

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
  final List<String> _years = ['2024', '2025', '2026', '2027'];

  final List<PayrollEmployee> _employees = [
    const PayrollEmployee(
      sno: 1,
      employeeId: '1',
      name: 'ali',
      doj: '09/12/2025',
      monthDays: 31,
      workingDays: 21,
      present: 0,
      absent: 21,
      paidDays: 0,
      unpaidDays: 21,
      expectedHours: 168,
      actualHours: 0,
      extraHours: 0,
      basicSalary: 180000,
      salaryPerDay: 6000,
      salaryPerHour: 750,
      houseAllow: 5000,
      medicalAllow: 5000,
      travelAllow: 1000,
    ),
    const PayrollEmployee(
      sno: 2,
      employeeId: '2',
      name: 'zain',
      doj: '01/01/2026',
      monthDays: 31,
      workingDays: 21,
      present: 0,
      absent: 21,
      paidDays: 0,
      unpaidDays: 21,
      expectedHours: 168,
      actualHours: 0,
      extraHours: 0,
      basicSalary: 70000,
      salaryPerDay: 2333.33,
      salaryPerHour: 291.6662,
      houseAllow: 0,
      medicalAllow: 5000,
      travelAllow: 0,
    ),
  ];

  double get _totalBasic => _employees.fold(0, (sum, e) => sum + e.basicSalary);
  double get _totalAllowances => _employees.fold(
      0, (sum, e) => sum + e.houseAllow + e.medicalAllow + e.travelAllow);
  double get _totalDeductions => 175000;
  double get _netPayable => _totalBasic + _totalAllowances - _totalDeductions;

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
              'Payroll',
              style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: AppConstant.textPrimary(context)),
            ),
            Text(
              'Generate, review and finalize monthly payroll runs.',
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
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: OutlinedButton(
                      onPressed: () => MobileFileActions.exportCsv(
                        fileName: 'payroll_run',
                        headers: const ['Employee', 'Gross', 'Deductions', 'Net', 'Status'],
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppConstant.primarycolor,
                        side: const BorderSide(
                          color: AppConstant.primarycolor,
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 6),
                      ),
                      child:
                          const Text('Export', style: TextStyle(fontSize: 11)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: ElevatedButton(
                      onPressed: () { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Action Performed!'))); },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppConstant.primarycolor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 6),
                      ),
                      child: const Text('Run new payroll',
                          style: TextStyle(fontSize: 11, color: Colors.black)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: OutlinedButton(
                      onPressed: () { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Action Performed!'))); },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red.shade400,
                        side: BorderSide(color: Colors.red.shade400),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 6),
                      ),
                      child: const Text('Close Month',
                          style: TextStyle(fontSize: 11)),
                    ),
                  ),
                ],
              ),
              _buildSummaryCards(),
              _buildMonthSummary(),
              _buildPayrollRunsSection(),
              _buildDataTable(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCards() {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Expanded(
              child: _summaryCard(
                  'TOTAL BASIC',
                  'PKR ${_totalBasic.toStringAsFixed(0)}',
                  '2 employees',
                  Colors.green.shade700)),
          const SizedBox(width: 8),
          Expanded(
              child: _summaryCard(
                  'ALLOWANCES',
                  'PKR ${_totalAllowances.toStringAsFixed(0)}',
                  'Earnings',
                  Colors.orange.shade700)),
          const SizedBox(width: 8),
          Expanded(
              child: _summaryCard(
                  'DEDUCTIONS',
                  'PKR ${_totalDeductions.toStringAsFixed(0)}',
                  'Tax + EOBI + Loans',
                  Colors.red.shade700)),
          const SizedBox(width: 8),
          Expanded(
              child: _summaryCard(
                  'NET PAYABLE',
                  'PKR ${_netPayable.toStringAsFixed(0)}',
                  'August 2026 cycle',
                  AppConstant.primarycolor)),
        ],
      ),
    );
  }

  Widget _summaryCard(
      String title, String amount, String subtitle, Color amountColor) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppConstant.cardBg(context),
        border: Border.all(color: const Color.fromARGB(255, 193, 200, 201)),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(blurRadius: 6, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade600)),
          const SizedBox(height: 6),
          Text(amount,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: amountColor)),
          const SizedBox(height: 2),
          Text(subtitle,
              style:
                  TextStyle(fontSize: 9, color: AppConstant.textHint(context))),
        ],
      ),
    );
  }

  Widget _buildMonthSummary() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppConstant.cardBg(context),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 6,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text('$_selectedMonth $_selectedYear Summary',
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w600)),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(10)),
                child: Text('Partial',
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Colors.orange.shade700)),
              ),
              const Spacer(),
              _summaryMini('1', 'Active Runs'),
            ],
          ),
          Row(
            children: [
              const SizedBox(width: 16),
              _summaryMini('PKR 266,000', 'Total Paid'),
              const SizedBox(width: 16),
              _summaryMini('PKR 0', 'Remaining'),
              const SizedBox(width: 16),
              _summaryMini('2', 'Employees'),
            ],
          )
        ],
      ),
    );
  }

  Widget _summaryMini(String value, String label) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        Text(label,
            style:
                TextStyle(fontSize: 9, color: AppConstant.textHint(context))),
      ],
    );
  }

  Widget _buildPayrollRunsSection() {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppConstant.cardBg(context),
        borderRadius: BorderRadius.circular(10),
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
              const Text('Payroll Runs',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              const SizedBox(width: 8),
              Text('$_selectedMonth $_selectedYear',
                  style: TextStyle(
                      fontSize: 12, color: AppConstant.textSecondary(context))),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(10)),
                child: const Text('1 runs',
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue)),
              ),
            ],
          ),
          SizedBox(
            height: 12,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                width: 100,
                child: DropdownButtonFormField<String>(
                  value: _selectedMonth,
                  isExpanded: true,
                  isDense: true,
                  decoration: InputDecoration(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6)),
                  ),
                  items: _months
                      .map((m) => DropdownMenuItem(
                          value: m,
                          child: Text(m, style: const TextStyle(fontSize: 11))))
                      .toList(),
                  onChanged: (val) => setState(() => _selectedMonth = val!),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 80,
                child: DropdownButtonFormField<String>(
                  value: _selectedYear,
                  isExpanded: true,
                  isDense: true,
                  decoration: InputDecoration(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6)),
                  ),
                  items: _years
                      .map((y) => DropdownMenuItem(
                          value: y,
                          child: Text(y, style: const TextStyle(fontSize: 11))))
                      .toList(),
                  onChanged: (val) => setState(() => _selectedYear = val!),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppConstant.cardBg(context),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('RUN #1',
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue)),
                    const Text('Regular',
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                          color: AppConstant.tableHeaderBg(context),
                          borderRadius: BorderRadius.circular(8)),
                      child: Text('Draft',
                          style: TextStyle(
                              fontSize: 9,
                              color: AppConstant.textSecondary(context))),
                    ),
                  ],
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('PKR ${_netPayable.toStringAsFixed(0)}',
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppConstant.primarycolor)),
                    Text('2 emp • 31 Mar',
                        style: TextStyle(
                            fontSize: 10,
                            color: AppConstant.textSecondary(context))),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataTable() {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 16),
      decoration: BoxDecoration(
        color: AppConstant.cardBg(context),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 6,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          _buildTableHeader(),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: _buildDataTableContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppConstant.tableHeaderBg(context),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Text('STATUS ',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(8)),
                child: Text('In Process',
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Colors.orange.shade700)),
              ),
              const SizedBox(width: 12),
              const Text('FILTER ',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600)),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: AppConstant.border(context)),
                  borderRadius: BorderRadius.circular(6),
                ),
                child:
                    Text(_filterStatus, style: const TextStyle(fontSize: 11)),
              ),
              const Spacer(),
            ],
          ),
          Text('01 Aug 2026 – 31 Aug 2026 • 2 employees',
              style: TextStyle(
                  fontSize: 10, color: AppConstant.textSecondary(context))),
          const SizedBox(height: 10),
          Row(
            children: [
              _headerActionBtn(Icons.save_outlined, 'Save (0)',
                  AppConstant.textSecondary(context)),
              _headerActionBtn(Icons.send_outlined, 'Submit Missing',
                  AppConstant.textSecondary(context)),
              _headerActionBtn(Icons.calculate_outlined, 'Recalculate',
                  AppConstant.primarycolor),
            ],
          ),
          Row(
            children: [
              _headerActionBtn(
                  Icons.lock_outline, 'Finalize & Lock', Colors.green),
              _headerActionBtn(Icons.send, 'Submit', Colors.blue),
            ],
          )
        ],
      ),
    );
  }

  Widget _headerActionBtn(IconData icon, String label, Color color) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: OutlinedButton.icon(
        onPressed: () { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Action Performed!'))); },
        icon: Icon(icon, size: 14, color: color),
        label: Text(label, style: TextStyle(fontSize: 10, color: color)),
        style: OutlinedButton.styleFrom(
          foregroundColor: color,
          side: BorderSide(color: color.withValues(alpha: 0.3)),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        ),
      ),
    );
  }

  Widget _buildDataTableContent() {
    return DataTable(
      headingRowColor: WidgetStateProperty.all(AppConstant.primarycolor),
      headingTextStyle: TextStyle(
          fontWeight: FontWeight.w700, color: AppConstant.textPrimary(context), fontSize: 10),
      dataRowColor: WidgetStateProperty.all(AppConstant.cardBg(context)),
      horizontalMargin: 12,
      columnSpacing: 16,
      columns: const [
        DataColumn(label: Text('S. NO.')),
        DataColumn(label: Text('EMPLOYEE ID')),
        DataColumn(label: Text('NAME')),
        DataColumn(label: Text('DOJ')),
        DataColumn(label: Text('MONTH DAYS')),
        DataColumn(label: Text('WORKING DAYS')),
        DataColumn(label: Text('PRESENT')),
        DataColumn(label: Text('ABSENT')),
        DataColumn(label: Text('PAID DAYS')),
        DataColumn(label: Text('UNPAID DAYS')),
        DataColumn(label: Text('EXPECTED HOURS')),
        DataColumn(label: Text('ACTUAL HOURS')),
        DataColumn(label: Text('EXTRA HOURS')),
        DataColumn(label: Text('BASIC SALARY')),
        DataColumn(label: Text('SALARY / DAY')),
        DataColumn(label: Text('SALARY / HOUR')),
        DataColumn(label: Text('HOUSE ALLOW.')),
        DataColumn(label: Text('MEDICAL ALLOW.')),
        DataColumn(label: Text('TRAVEL ALLOW.')),
      ],
      rows: _employees.map((emp) {
        return DataRow(cells: [
          DataCell(Text('${emp.sno}', style: const TextStyle(fontSize: 11))),
          DataCell(Text(emp.employeeId, style: const TextStyle(fontSize: 11))),
          DataCell(Text(emp.name,
              style:
                  const TextStyle(fontSize: 11, fontWeight: FontWeight.w600))),
          DataCell(Text(emp.doj, style: const TextStyle(fontSize: 10))),
          DataCell(_editCell('${emp.monthDays}')),
          DataCell(_editCell('${emp.workingDays}')),
          DataCell(_editCell('${emp.present}')),
          DataCell(_editCell('${emp.absent}')),
          DataCell(_editCell('${emp.paidDays}')),
          DataCell(_editCell('${emp.unpaidDays}')),
          DataCell(_editCell('${emp.expectedHours}')),
          DataCell(_editCell('${emp.actualHours}')),
          DataCell(_editCell('${emp.extraHours}')),
          DataCell(Text('Rs ${emp.basicSalary.toStringAsFixed(0)}',
              style:
                  const TextStyle(fontSize: 10, fontWeight: FontWeight.w600))),
          DataCell(Text('${emp.salaryPerDay.toStringAsFixed(0)}',
              style: const TextStyle(fontSize: 10))),
          DataCell(Text('${emp.salaryPerHour.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 10))),
          DataCell(_editCell('${emp.houseAllow.toStringAsFixed(0)}')),
          DataCell(_editCell('${emp.medicalAllow.toStringAsFixed(0)}')),
          DataCell(_editCell('${emp.travelAllow.toStringAsFixed(0)}')),
        ]);
      }).toList(),
    );
  }

  Widget _editCell(String value) {
    return Container(
      width: 60,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: AppConstant.border(context)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(value,
          style: const TextStyle(fontSize: 10), textAlign: TextAlign.center),
    );
  }
}
