import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lecture/core/constants/app_colors.dart';
import 'package:lecture/core/widgets/shimmer_widgets.dart';
import 'package:lecture/core/utils/mobile_file_actions.dart';

class SalarySlipScreen extends StatefulWidget {
  const SalarySlipScreen({super.key});

  @override
  State<SalarySlipScreen> createState() => _SalarySlipScreenState();
}

class _SalarySlipScreenState extends State<SalarySlipScreen> {
  String? _selectedPayrollRun;
  String? _selectedEmployee;

  final List<String> _payrollRuns = [
    'August 2026 - Regular',
    'July 2026 - Regular',
    'June 2026 - Regular',
    'May 2026 - Regular',
  ];

  final List<String> _employees = [
    'Ahmed Khan (EMP001)',
    'Fatima Ali (EMP002)',
    'Hassan Raza (EMP003)',
    'Sara Malik (EMP004)',
    'Usman Ahmed (EMP005)',
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
              'Salary Slip',
              style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: AppConstant.textPrimary(context)),
            ),
            Text(
              'View monthly salary slip for each employee from processed payroll runs.',
              style: TextStyle(
                  fontSize: 13, color: AppConstant.textPrimary(context)),
            ),
          ],
        ),
      ),
      body: ScreenShimmerWrapper(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFilters(),
              const SizedBox(height: 16),
              if (_selectedPayrollRun == null || _selectedEmployee == null)
                _buildInfoMessage()
              else
                _buildSalarySlip(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payroll Run',
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppConstant.textSecondary(context)),
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            value: _selectedPayrollRun,
            isExpanded: true,
            decoration: InputDecoration(
              hintText: 'Select month',
              hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppConstant.primarycolor),
              ),
            ),
            items: _payrollRuns.map((String run) {
              return DropdownMenuItem<String>(
                value: run,
                child: Text(run, style: const TextStyle(fontSize: 13)),
              );
            }).toList(),
            onChanged: (val) => setState(() => _selectedPayrollRun = val),
          ),
          const SizedBox(height: 16),
          Text(
            'Employee',
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppConstant.textSecondary(context)),
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            value: _selectedEmployee,
            isExpanded: true,
            decoration: InputDecoration(
              hintText: 'Select employee',
              hintStyle:
                  TextStyle(color: AppConstant.textHint(context), fontSize: 13),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppConstant.border(context)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppConstant.border(context)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppConstant.primarycolor),
              ),
            ),
            items: _employees.map((String emp) {
              return DropdownMenuItem<String>(
                value: emp,
                child: Text(emp, style: const TextStyle(fontSize: 13)),
              );
            }).toList(),
            onChanged: (val) => setState(() => _selectedEmployee = val),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoMessage() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppConstant.cardBg(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFB3E5D5)),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: AppConstant.primarycolor, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Select a payroll run and employee to view salary slip.',
              style: TextStyle(
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSalarySlip() {
    return Container(
      padding: const EdgeInsets.all(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSlipHeader(),
          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 16),
          _buildEmployeeInfo(),
          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 16),
          _buildEarningsSection(),
          const SizedBox(height: 16),
          _buildDeductionsSection(),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),
          _buildNetSalary(),
          const SizedBox(height: 20),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildSlipHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F8F5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.receipt_long_outlined,
              color: AppConstant.primarycolor, size: 28),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Salary Slip',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A2E)),
              ),
              Text(
                _selectedPayrollRun ?? '',
                style: TextStyle(
                    fontSize: 12, color: AppConstant.textSecondary(context)),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.green.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            'Processed',
            style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.green.shade700),
          ),
        ),
      ],
    );
  }

  Widget _buildEmployeeInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Employee Information',
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppConstant.textPrimary(context)),
        ),
        const SizedBox(height: 12),
        _infoRow('Name', _selectedEmployee?.split('(').first.trim() ?? ''),
        _infoRow('Employee ID',
            _selectedEmployee?.replaceAll(RegExp(r'.*\(|\)'), '') ?? ''),
        _infoRow('Department', 'Engineering'),
        _infoRow('Designation', 'Software Engineer'),
        _infoRow('Join Date', '01/01/2024'),
        _infoRow('Pay Period', _selectedPayrollRun ?? ''),
      ],
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                  fontSize: 12, color: AppConstant.textSecondary(context)),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A2E)),
          ),
        ],
      ),
    );
  }

  Widget _buildEarningsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.trending_up, size: 18, color: Colors.green.shade600),
            const SizedBox(width: 6),
            const Text(
              'Earnings',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.green),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _earningRow('Basic Salary', '50,000'),
        _earningRow('House Allowance', '15,000'),
        _earningRow('Transport Allowance', '8,000'),
        _earningRow('Medical Allowance', '5,000'),
        _earningRow('Food Allowance', '5,000'),
        const Divider(),
        _earningRow('Total Earnings', '83,000', isBold: true),
      ],
    );
  }

  Widget _earningRow(String label, String amount, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isBold
                  ? const Color(0xFF1A1A2E)
                  : AppConstant.textSecondary(context),
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            'Rs $amount',
            style: TextStyle(
              fontSize: 12,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              color: isBold ? Colors.green.shade700 : const Color(0xFF1A1A2E),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeductionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.trending_down, size: 18, color: Colors.red.shade600),
            const SizedBox(width: 6),
            const Text(
              'Deductions',
              style: TextStyle(
                  fontSize: 14, fontWeight: FontWeight.bold, color: Colors.red),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _deductionRow('Income Tax', '12,000'),
        _deductionRow('EOBI', '3,000'),
        _deductionRow('Loan Deduction', '0'),
        _deductionRow('Provident Fund', '5,000'),
        const Divider(),
        _deductionRow('Total Deductions', '20,000', isBold: true),
      ],
    );
  }

  Widget _deductionRow(String label, String amount, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isBold
                  ? const Color(0xFF1A1A2E)
                  : AppConstant.textSecondary(context),
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            'Rs $amount',
            style: TextStyle(
              fontSize: 12,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              color: isBold ? Colors.red.shade700 : const Color(0xFF1A1A2E),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNetSalary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppConstant.primarycolor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border:
            Border.all(color: AppConstant.primarycolor.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Net Salary',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppConstant.textPrimary(context)),
          ),
          Text(
            'Rs 63,000',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppConstant.primarycolor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => MobileFileActions.exportPdf(
              fileName: 'salary_slip',
              title: 'Salary Slip',
              headers: const ['Employee', 'Period', 'Gross Salary', 'Net Salary'],
            ),
            icon: const Icon(Icons.print_outlined, size: 18),
            label: const Text('Print Slip'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppConstant.primarycolor,
              side: const BorderSide(color: AppConstant.primarycolor),
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Action Performed!'))); },
            icon: const Icon(Icons.download_outlined, size: 18),
            label: const Text('Download PDF'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstant.primarycolor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ),
      ],
    );
  }
}
