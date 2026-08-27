import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lecture/core/constants/app_colors.dart';
import 'package:lecture/core/widgets/shimmer_widgets.dart';

class SalaryStructureScreen extends StatefulWidget {
  const SalaryStructureScreen({super.key});

  @override
  State<SalaryStructureScreen> createState() => _SalaryStructureScreenState();
}

class _SalaryStructureScreenState extends State<SalaryStructureScreen> {
  bool _isAuthenticated = false;
  final _passwordController = TextEditingController();
  String? _passwordError;
  String? _selectedEmployee;

  final List<String> _employees = [
    'Ahmed Khan',
    'Fatima Ali',
    'Hassan Raza',
    'Sara Malik',
    'Usman Ahmed',
  ];

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  void _verifyPassword() {
    if (_passwordController.text == 'admin123') {
      setState(() {
        _isAuthenticated = true;
        _passwordError = null;
      });
    } else {
      setState(() {
        _passwordError = 'Invalid password. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isAuthenticated) {
      return _buildPasswordScreen();
    }
    return _buildSalaryStructureScreen();
  }

  Widget _buildPasswordScreen() {
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
        title: Text(
          'Access Verification',
          style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: AppConstant.textPrimary(context)),
        ),
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.all(24),
          constraints: const BoxConstraints(maxWidth: 400),
          decoration: BoxDecoration(
            color: AppConstant.cardBg(context),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F8F5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.security_outlined,
                      size: 48, color: AppConstant.primarycolor),
                ),
                const SizedBox(height: 20),
                Text(
                  'Salary Structure Access',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppConstant.textPrimary(context)),
                ),
                const SizedBox(height: 8),
                Text(
                  'Enter password to access salary data',
                  style: TextStyle(
                      fontSize: 13, color: AppConstant.textSecondary(context)),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  onSubmitted: (_) => _verifyPassword(),
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter access password',
                    prefixIcon: const Icon(Icons.lock_outline, size: 20),
                    errorText: _passwordError,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 14),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _verifyPassword,
                    icon: const Icon(Icons.login, size: 18),
                    label: const Text('Verify Password'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConstant.primarycolor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Hint: admin123',
                  style: TextStyle(
                      fontSize: 11, color: AppConstant.textHint(context)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSalaryStructureScreen() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstant.appBarBg(context),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: AppConstant.statusBarColor(context),
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Salary Structure',
              style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: AppConstant.textPrimary(context)),
            ),
            Text(
              'Manage per-employee basic salary, allowances, and effective dates.',
              style: TextStyle(
                  fontSize: 13, color: AppConstant.textSecondary(context)),
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
              _buildEmployeeSelector(),
              const SizedBox(height: 16),
              if (_selectedEmployee == null)
                _buildInfoMessage()
              else
                _buildSalaryDetails(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmployeeSelector() {
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
            'Employee',
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppConstant.textPrimary(context)),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedEmployee,
                  isExpanded: true,
                  decoration: InputDecoration(
                    hintText: '-- Select Employee --',
                    hintStyle: TextStyle(
                        color: AppConstant.textHint(context), fontSize: 13),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          BorderSide(color: AppConstant.border(context)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          BorderSide(color: AppConstant.border(context)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          const BorderSide(color: AppConstant.primarycolor),
                    ),
                  ),
                  items: _employees.map((String emp) {
                    return DropdownMenuItem<String>(
                        value: emp,
                        child: Text(emp, style: const TextStyle(fontSize: 13)));
                  }).toList(),
                  onChanged: (val) => setState(() => _selectedEmployee = val),
                ),
              ),
              const SizedBox(width: 12),
               OutlinedButton.icon(
                onPressed: () { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Action Performed!'))); },
                icon: const Icon(Icons.refresh, size: 16),
                label: const Text('Reload'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppConstant.textSecondary(context),
                  side: BorderSide(color: AppConstant.border(context)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
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
              'Select an employee to view and manage salary structure.',
              style: TextStyle(
                  fontSize: 13, color: AppConstant.textSecondary(context)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSalaryDetails() {
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
          Row(
            children: [
              Icon(Icons.person_outline,
                  color: AppConstant.primarycolor, size: 20),
              const SizedBox(width: 8),
              Text(
                _selectedEmployee!,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppConstant.textPrimary(context)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 12),
          _buildSalaryRow('Basic Salary', 'Rs 50,000'),
          _buildSalaryRow('House Allowance', 'Rs 15,000'),
          _buildSalaryRow('Transport Allowance', 'Rs 8,000'),
          _buildSalaryRow('Medical Allowance', 'Rs 5,000'),
          _buildSalaryRow('Food Allowance', 'Rs 5,000'),
          const Divider(height: 24),
          _buildSalaryRow('Gross Salary', 'Rs 83,000', isBold: true),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Action Performed!'))); },
                  icon: const Icon(Icons.edit_outlined, size: 16),
                  label: const Text('Edit Structure'),
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
                  icon: const Icon(Icons.save_outlined, size: 16),
                  label: const Text('Save Changes'),
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
          ),
        ],
      ),
    );
  }

  Widget _buildSalaryRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: AppConstant.textSecondary(context),
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
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
