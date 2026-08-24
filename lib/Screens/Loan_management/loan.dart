import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lecture/appcolor.dart';
import 'package:lecture/widgets/shimmer_widgets.dart';

class LoanManagement extends StatefulWidget {
  const LoanManagement({super.key});

  @override
  State<LoanManagement> createState() => _LoanManagementState();
}

class _LoanManagementState extends State<LoanManagement> {
  final _searchController = TextEditingController();
  final _amountController = TextEditingController();
  final _tenureController = TextEditingController();
  final _purposeController = TextEditingController();
  final _dateController = TextEditingController();
  String _status = 'All Statuses';

  @override
  void dispose() {
    _searchController.dispose();
    _amountController.dispose();
    _tenureController.dispose();
    _purposeController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
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
          elevation: 0,
          title:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Loan Management',
                style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: AppConstant.textPrimary(context))),
            Text('Manage employee and external loan applications',
                style: TextStyle(
                    fontSize: 13, color: AppConstant.textPrimary(context)))
          ]),
        ),
        body: ScreenShimmerWrapper(
            child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 28),
                children: [
              _buildFilters(),
              const SizedBox(height: 16),
              _loanSection('Employee Loans', Icons.account_balance_outlined,
                  'No employee loans found', const Color(0xFF0DB9D8)),
              const SizedBox(height: 18),
              _loanSection('Non-Employee Loans', Icons.person_outline,
                  'No non-employee loans found', Colors.orange)
            ])),
      );

  Widget _buildFilters() =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              height: 50,
              width: MediaQuery.of(context).size.width * 0.5,
              child: Card(
                  color: AppConstant.primarycolor,
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: _applyLoan,
                          icon: const Icon(Icons.add_circle_outline,
                              color: Colors.black)),
                      Text(
                        "Apply for Loan",
                        style: TextStyle(color: Colors.black),
                      )
                    ],
                  )),
            ),
          ],
        ),
        _label('Search'),
        TextField(
            controller: _searchController,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
                hintText: 'Search by employee, loan type, or reason...',
                prefixIcon: const Icon(Icons.search, color: Color(0xFF0DB9D8)),
                suffixIcon: _searchController.text.isEmpty
                    ? null
                    : IconButton(
                        onPressed: () {
                          _searchController.clear();
                          setState(() {});
                        },
                        icon: const Icon(Icons.clear)),
                filled: true,
                fillColor: AppConstant.inputBg(context),
                border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))))),
        const SizedBox(height: 14),
        _label('Status'),
        DropdownButtonFormField<String>(
            value: _status,
            isExpanded: true,
            decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                filled: true,
                fillColor: AppConstant.inputBg(context),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)))),
            items: const ['All Statuses', 'Pending', 'Approved', 'Rejected']
                .map((item) => DropdownMenuItem(value: item, child: Text(item)))
                .toList(),
            onChanged: (value) => setState(() => _status = value ?? _status)),
        const SizedBox(height: 10),
        Align(
            alignment: Alignment.centerRight,
            child: OutlinedButton.icon(
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Loans refreshed locally.'))),
                icon: const Icon(Icons.refresh, size: 17),
                label: const Text('Refresh'))),
      ]);

  Widget _loanSection(
          String title, IconData icon, String emptyText, Color accent) =>
      Card(
          elevation: 0,
          color: AppConstant.cardBg(context),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          child: Column(children: [
            Padding(
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
                child: Row(children: [
                  Icon(icon, size: 18, color: accent),
                  const SizedBox(width: 7),
                  Text(title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF94A3B8),
                      )),
                  const SizedBox(width: 8),
                  Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                          color: accent.withValues(alpha: .12),
                          borderRadius: BorderRadius.circular(12)),
                      child: const Text('0', style: TextStyle(fontSize: 11)))
                ])),
            const Divider(height: 1),
            Container(
                constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.35),
                width: double.infinity,
                color: AppConstant.scaffoldBg(context),
                child: Center(
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Icon(icon, size: 38, color: const Color(0xFF7188A1)),
                  const SizedBox(height: 14),
                  Text(emptyText,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF94A3B8),
                      )),
                  const SizedBox(height: 7),
                  const Text('No loans match your current filters.',
                      style: TextStyle(fontSize: 12, color: Color(0xFF657C94)))
                ])))
          ]));

  Widget _label(String text) => Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Text(text,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF94A3B8),
          )));
  Future<void> _applyLoan() async {
    _amountController.clear();
    _tenureController.clear();
    _purposeController.clear();
    final today = DateTime.now();
    _dateController.text = _formatDate(today);
    String? applicantType;
    String? loanType;
    final formKey = GlobalKey<FormState>();

    final submitted = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: StatefulBuilder(
          builder: (context, setDialogState) => ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900, maxHeight: 760),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 18, 20, 14),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(11),
                          decoration: BoxDecoration(
                              color: const Color(0xFFE7F9FC),
                              borderRadius: BorderRadius.circular(10)),
                          child: const Icon(Icons.account_balance_wallet_outlined,
                              color: Color(0xFF0DB9D8)),
                        ),
                        const SizedBox(width: 14),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Apply for Loan',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF0DB9D8))),
                              SizedBox(height: 3),
                              Text('Loan application form'),
                            ],
                          ),
                        ),
                        IconButton(
                            onPressed: () => Navigator.pop(dialogContext),
                            icon: const Icon(Icons.close)),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final compact = constraints.maxWidth < 600;
                          final applicant = _loanDropdown(
                              'Applicant Type *', applicantType,
                              ['Employee', 'Non-Employee'],
                              (value) => setDialogState(
                                  () => applicantType = value));
                          final type = _loanDropdown(
                              'Loan Type *', loanType,
                              ['Personal', 'Emergency', 'Housing', 'Vehicle', 'Education'],
                              (value) => setDialogState(() => loanType = value));
                          final amount = _loanField('Loan Amount *', _amountController,
                              'Enter loan amount', required: true,
                              keyboardType: TextInputType.number);
                          final tenure = _loanField('Tenure (Months) *', _tenureController,
                              'Enter tenure in months', required: true,
                              keyboardType: TextInputType.number);
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _loanRow([applicant, type], compact),
                              _loanRow([amount, tenure], compact),
                              _dateField(today, setDialogState),
                              const SizedBox(height: 16),
                              _loanLabel('Purpose of Loan *'),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _purposeController,
                                maxLines: 5,
                                validator: (value) => value == null || value.trim().isEmpty
                                    ? 'Required'
                                    : null,
                                decoration: _loanInput(
                                    'Please provide a detailed purpose for the loan application...'),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                  const Divider(height: 1),
                  Padding(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: () => Navigator.pop(dialogContext),
                            child: const Text('Cancel')),
                        const SizedBox(width: 10),
                        FilledButton(
                          onPressed: () {
                            if (applicantType == null || loanType == null) {
                              ScaffoldMessenger.of(dialogContext).showSnackBar(
                                  const SnackBar(
                                      content: Text('Select applicant and loan type.')));
                              return;
                            }
                            if (formKey.currentState!.validate()) {
                              Navigator.pop(dialogContext, true);
                            }
                          },
                          child: const Text('Submit Application'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    if (submitted == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Loan application submitted.')));
    }
  }

  Widget _loanRow(List<Widget> children, bool compact) {
    if (compact) {
      return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: children
              .expand((child) => [child, const SizedBox(height: 14)])
              .toList());
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children
              .map((child) => Expanded(
                  child: Padding(
                      padding: const EdgeInsets.only(right: 12), child: child)))
              .toList()),
    );
  }

  Widget _loanLabel(String text) => Text(text,
      style: const TextStyle(fontWeight: FontWeight.w600));

  Widget _loanField(String label, TextEditingController controller, String hint,
      {bool required = false, TextInputType? keyboardType}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _loanLabel(label),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: required
              ? (value) => value == null || value.trim().isEmpty ? 'Required' : null
              : null,
          decoration: _loanInput(hint),
        ),
      ],
    );
  }

  Widget _loanDropdown(String label, String? value, List<String> items,
      ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _loanLabel(label),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          isExpanded: true,
          decoration: _loanInput('Select ${label.replaceAll(' *', '')}'),
          items: items
              .map((item) => DropdownMenuItem(value: item, child: Text(item)))
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _dateField(DateTime firstDate, StateSetter setDialogState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _loanLabel('Application Date *'),
        const SizedBox(height: 8),
        TextFormField(
          controller: _dateController,
          readOnly: true,
          onTap: () async {
            final date = await showDatePicker(
                context: context,
                firstDate: firstDate,
                lastDate: DateTime(2100),
                initialDate: firstDate);
            if (date != null) {
              setDialogState(() => _dateController.text = _formatDate(date));
            }
          },
          decoration: _loanInput('').copyWith(
              suffixIcon: const Icon(Icons.calendar_today_outlined, size: 18)),
        ),
      ],
    );
  }

  InputDecoration _loanInput(String hint) => InputDecoration(
        hintText: hint.isEmpty ? null : hint,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      );

  String _formatDate(DateTime date) =>
      '${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}/${date.year}';
}
