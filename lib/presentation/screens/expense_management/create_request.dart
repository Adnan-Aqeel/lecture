import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lecture/core/constants/app_colors.dart';
import 'package:lecture/core/widgets/shimmer_widgets.dart';

class CreateExpenseRequestScreen extends StatefulWidget {
  const CreateExpenseRequestScreen({super.key});

  @override
  State<CreateExpenseRequestScreen> createState() =>
      _CreateExpenseRequestScreenState();
}

class _CreateExpenseRequestScreenState
    extends State<CreateExpenseRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _showGuidelines = false;

  // Controllers
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  final _justificationController = TextEditingController();

  // Dropdown values
  String _priority = 'Medium';
  String? _selectedCategory;
  String? _selectedSubCategory;
  String? _selectedPipeline;
  String? _selectedVendor;
  String? _selectedWallet;

  // Date values
  DateTime? _requiredByDate;
  DateTime? _dateIncurred;

  final List<String> _priorities = ['Low', 'Medium', 'High', 'Urgent'];
  final List<String> _categories = [
    'Travel',
    'Food',
    'Office Supplies',
    'Utilities',
    'Other'
  ];
  final List<String> _subCategories = ['Local', 'International', 'Domestic'];
  final List<String> _pipelines = [];
  final List<String> _vendors = ['No vendor', 'Vendor A', 'Vendor B'];
  final List<String> _wallets = [
    'Auto-select from department configuration',
    'Wallet A',
    'Wallet B'
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _amountController.dispose();
    _justificationController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isRequiredBy) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        if (isRequiredBy) {
          _requiredByDate = picked;
        } else {
          _dateIncurred = picked;
        }
      });
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'mm/dd/yyyy';
    return '${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}/${date.year}';
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
              'Create Expense Request',
              style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: AppConstant.textPrimary(context)),
            ),
            Text(
              'Submit a new expense request',
              style: TextStyle(
                  fontSize: 13, color: AppConstant.textPrimary(context)),
            ),
          ],
        ),
      ),
      body: ScreenShimmerWrapper(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildGuidelinesSection(),
                      const SizedBox(height: 16),
                      _buildFormSection(),
                    ],
                  ),
                ),
              ),
              _buildBottomButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGuidelinesSection() {
    return Container(
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
        children: [
          InkWell(
            onTap: () => setState(() => _showGuidelines = !_showGuidelines),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.info_outline,
                      color: AppConstant.primarycolor, size: 20),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'GUIDELINES',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                  ),
                  Icon(
                    _showGuidelines
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: AppConstant.textSecondary(context),
                  ),
                ],
              ),
            ),
          ),
          if (_showGuidelines) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppConstant.cardBg(context),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFB3D9F2)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Expense Request Tips:',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppConstant.textSecondary(context),
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildTipItem(
                            'Select both a category and a sub-category'),
                        _buildTipItem(
                            'Choose the appropriate approval pipeline — submission is blocked without one'),
                        _buildTipItem(
                            'Provide a clear title and detailed description'),
                        _buildTipItem(
                            'Receipts can only be uploaded after full approval, unless the expense was already incurred'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppConstant.cardBg(context),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFFFE082)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Approval Process:',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppConstant.textSecondary(context),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Your request will pass through each stage of the selected pipeline in order. You will receive notifications at each stage.',
                          style: TextStyle(
                              fontSize: 11,
                              color: AppConstant.textSecondary(context)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTipItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ',
              style: TextStyle(
                  color: AppConstant.primarycolor,
                  fontWeight: FontWeight.bold)),
          Expanded(
            child: Text(text,
                style: TextStyle(
                    fontSize: 11, color: AppConstant.textSecondary(context))),
          ),
        ],
      ),
    );
  }

  Widget _buildFormSection() {
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
            'EXPENSE REQUEST DETAILS',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: AppConstant.textSecondary(context),
            ),
          ),
          const SizedBox(height: 20),
          _buildTextField(
            label: 'Title',
            controller: _titleController,
            hint: 'Enter expense title',
            isRequired: true,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'Description',
            controller: _descriptionController,
            hint: 'Describe the expense in detail',
            isRequired: true,
            maxLines: 4,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildAmountField(),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildDropdown(
                  label: 'Priority',
                  value: _priority,
                  items: _priorities,
                  isRequired: true,
                  onChanged: (val) => setState(() => _priority = val!),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildDropdown(
                  label: 'Category',
                  value: _selectedCategory,
                  items: _categories,
                  isRequired: true,
                  hint: 'Select category',
                  onChanged: (val) => setState(() => _selectedCategory = val),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildDropdown(
                  label: 'Sub-Category',
                  value: _selectedSubCategory,
                  items: _subCategories,
                  isRequired: true,
                  hint: 'Select sub-category',
                  onChanged: (val) =>
                      setState(() => _selectedSubCategory = val),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildDropdown(
            label: 'Approval Pipeline',
            value: _selectedPipeline,
            items: _pipelines,
            isRequired: true,
            hint: '(0 stages)',
            onChanged: (val) => setState(() => _selectedPipeline = val),
          ),
          if (_pipelines.isEmpty) ...[
            const SizedBox(height: 6),
            Text(
              'No active approval pipelines available. Contact an admin to configure one before submitting.',
              style: TextStyle(fontSize: 11, color: Colors.red.shade700),
            ),
          ],
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildDropdown(
                  label: 'Vendor',
                  value: _selectedVendor,
                  items: _vendors,
                  hint: '— No vendor —',
                  onChanged: (val) => setState(() => _selectedVendor = val),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildDateField(
                  label: 'Required By Date',
                  date: _requiredByDate,
                  onTap: () => _selectDate(context, true),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildDateField(
            label:
                'Date Expense Was Incurred (leave blank if not yet incurred)',
            date: _dateIncurred,
            onTap: () => _selectDate(context, false),
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'Justification',
            controller: _justificationController,
            hint: 'Provide business justification for this expense',
            maxLines: 4,
          ),
          const SizedBox(height: 16),
          _buildDropdown(
            label: 'Wallet(optional — auto-selected based on department)',
            value: _selectedWallet,
            items: _wallets,
            hint: 'Auto-select from department configuration',
            onChanged: (val) => setState(() => _selectedWallet = val),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String hint,
    bool isRequired = false,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppConstant.textSecondary(context),
                )),
            if (isRequired)
              const Text(' *',
                  style: TextStyle(color: Colors.red, fontSize: 12)),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
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
          validator: isRequired
              ? (val) {
                  if (val == null || val.isEmpty)
                    return 'This field is required';
                  return null;
                }
              : null,
        ),
      ],
    );
  }

  Widget _buildAmountField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Amount',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppConstant.textSecondary(context),
                )),
            Text(' *', style: TextStyle(color: Colors.red, fontSize: 12)),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _amountController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
          ],
          decoration: InputDecoration(
            prefixText: 'PKR ',
            prefixStyle: TextStyle(
                color: AppConstant.textSecondary(context),
                fontSize: 13,
                fontWeight: FontWeight.w500),
            hintText: '0.00',
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
          validator: (val) {
            if (val == null || val.isEmpty) return 'Amount is required';
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    bool isRequired = false,
    String? hint,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(
              child: Text(label,
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppConstant.textSecondary(context),
                  )),
            ),
            if (isRequired)
              const Text(' *',
                  style: TextStyle(color: Colors.red, fontSize: 12)),
          ],
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          isExpanded: true,
          decoration: InputDecoration(
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
          hint: hint != null
              ? Text(hint,
                  style: TextStyle(
                      color: AppConstant.textHint(context), fontSize: 13))
              : null,
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item, style: const TextStyle(fontSize: 13)),
            );
          }).toList(),
          onChanged: onChanged,
          validator: isRequired
              ? (val) {
                  if (val == null || val.isEmpty)
                    return 'This field is required';
                  return null;
                }
              : null,
        ),
      ],
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppConstant.textSecondary(context),
            )),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          child: InputDecorator(
            decoration: InputDecoration(
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
              suffixIcon: Icon(Icons.calendar_today_outlined,
                  color: AppConstant.textHint(context), size: 18),
            ),
            child: Text(
              _formatDate(date),
              style: TextStyle(
                fontSize: 13,
                color: date != null
                    ? AppConstant.textPrimary(context)
                    : AppConstant.textHint(context),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomButtons() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppConstant.cardBg(context),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.grey.shade700,
                side: BorderSide(color: Colors.grey.shade300),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Cancel'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: _submitForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstant.primarycolor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Create Request',
                  style: TextStyle(fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Expense request created successfully!'),
          backgroundColor: Colors.green.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
      Navigator.pop(context);
    }
  }
}
