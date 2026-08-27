import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lecture/core/constants/app_colors.dart';
import 'package:lecture/core/widgets/shimmer_widgets.dart';

class LoanTypeScreen extends StatefulWidget {
  const LoanTypeScreen({super.key});

  @override
  State<LoanTypeScreen> createState() => _LoanTypeScreenState();
}

class _LoanTypeScreenState extends State<LoanTypeScreen> {
  final _loanTypes = <_LoanType>[
    _LoanType(
        name: '',
        maxAmount: 0,
        maxTenure: 'No limit months',
        allowedFor: 'Employee Only',
        isActive: true)
  ];

  Future<void> _openForm({_LoanType? loanType}) async {
    final result = await showModalBottomSheet<_LoanType>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        builder: (_) => _LoanTypeForm(loanType: loanType));
    if (!mounted || result == null) return;
    setState(() {
      if (loanType == null) {
        _loanTypes.add(result);
      } else {
        _loanTypes[_loanTypes.indexOf(loanType)] = result;
      }
    });
  }

  Future<void> _delete(_LoanType loanType) async {
    final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
                title: const Text('Delete loan type?'),
                content: const Text('This loan type will be removed locally.'),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancel')),
                  FilledButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Delete'))
                ]));
    if (confirmed == true && mounted)
      setState(() => _loanTypes.remove(loanType));
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
              Text('Loan Types',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppConstant.textPrimary(context))),
              Text('Manage loan types and their settings',
                  style: TextStyle(
                      fontSize: 13, color: AppConstant.textPrimary(context)))
            ]),
            actions: [
              IconButton(
                  tooltip: 'Add Loan Type',
                  onPressed: () => _openForm(),
                  icon:
                      const Icon(Icons.add_circle_outline, color: Colors.white))
            ]),
        body: ScreenShimmerWrapper(
            child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 28),
                children: [_buildLoanTypesTable()])),
        floatingActionButton: FloatingActionButton.extended(
            backgroundColor: AppConstant.primarycolor,
            foregroundColor: Colors.black,
            onPressed: () => _openForm(),
            icon: const Icon(Icons.add),
            label: const Text('Add Loan Type')),
      );

  Widget _buildLoanTypesTable() => Card(
        elevation: 1,
        color: AppConstant.cardBg(context),
        clipBehavior: Clip.antiAlias,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowColor: const WidgetStatePropertyAll(Color(0xFF22D3EE)),
            columns: const [
              DataColumn(label: Text('Name')),
              DataColumn(label: Text('Max Amount')),
              DataColumn(label: Text('Max Tenure')),
              DataColumn(label: Text('Allowed For')),
              DataColumn(label: Text('Status')),
              DataColumn(label: Text('Actions')),
            ],
            rows: _loanTypes.map((loan) {
              final name = loan.name.isEmpty
                  ? 'Loan Type ${_loanTypes.indexOf(loan) + 1}'
                  : loan.name;
              return DataRow(cells: [
                DataCell(Text(name)),
                DataCell(Text('\$${loan.maxAmount.toStringAsFixed(0)}')),
                DataCell(Text(loan.maxTenure)),
                DataCell(Text(loan.allowedFor)),
                DataCell(_statusChip(loan.isActive)),
                DataCell(Row(mainAxisSize: MainAxisSize.min, children: [
                  _actionButton(
                      Icons.edit_outlined, () => _openForm(loanType: loan)),
                  _actionButton(Icons.delete_outline, () => _delete(loan),
                      color: Colors.red),
                ])),
              ]);
            }).toList(),
          ),
        ),
      );

  Widget _detail(String label, String value) => Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(children: [
        Expanded(
          child: Text(label,
              style: const TextStyle(fontSize: 12, color: Color(0xFF657C94))),
        ),
        Expanded(
            flex: 2,
            child: Text(value,
                style: const TextStyle(fontSize: 14, color: Color(0xFF1E3851))))
      ]));
  Widget _actionButton(IconData icon, VoidCallback onPressed,
          {Color color = const Color(0xFF0D8ED0)}) =>
      IconButton(
          onPressed: onPressed,
          icon: Icon(icon, color: color),
          visualDensity: VisualDensity.compact);
  Widget _statusChip(bool active) => Align(
      alignment: Alignment.centerLeft,
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
          decoration: BoxDecoration(
              color: active ? const Color(0xFFE1F5EC) : const Color(0xFFECEFF2),
              borderRadius: BorderRadius.circular(14)),
          child: Text(active ? 'Active' : 'Inactive',
              style: TextStyle(
                  color: active ? Colors.green.shade700 : Colors.grey.shade700,
                  fontSize: 12,
                  fontWeight: FontWeight.w600))));
}

class _LoanType {
  _LoanType(
      {required this.name,
      required this.maxAmount,
      required this.maxTenure,
      required this.allowedFor,
      required this.isActive});
  String name;
  double maxAmount;
  String maxTenure;
  String allowedFor;
  bool isActive;
}

class _LoanTypeForm extends StatefulWidget {
  const _LoanTypeForm({this.loanType});
  final _LoanType? loanType;
  @override
  State<_LoanTypeForm> createState() => _LoanTypeFormState();
}

class _LoanTypeFormState extends State<_LoanTypeForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name, _amount, _tenure;
  String _allowedFor = 'Employee Only';
  bool _active = true;

  @override
  void initState() {
    super.initState();
    final item = widget.loanType;
    _name = TextEditingController(text: item?.name);
    _amount = TextEditingController(text: item?.maxAmount.toStringAsFixed(0));
    _tenure = TextEditingController(
        text: item?.maxTenure == 'No limit months' ? '' : item?.maxTenure);
    _allowedFor = item?.allowedFor ?? _allowedFor;
    _active = item?.isActive ?? true;
  }

  @override
  void dispose() {
    _name.dispose();
    _amount.dispose();
    _tenure.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final old = widget.loanType;
    Navigator.pop(
        context,
        _LoanType(
            name: _name.text.trim(),
            maxAmount: double.parse(_amount.text),
            maxTenure: _tenure.text.trim().isEmpty
                ? 'No limit months'
                : '${_tenure.text.trim()} months',
            allowedFor: _allowedFor,
            isActive: _active));
  }

  @override
  Widget build(BuildContext context) => Padding(
      padding: EdgeInsets.fromLTRB(
          20, 20, 20, MediaQuery.viewInsetsOf(context).bottom + 20),
      child: Material(
          color: AppConstant.cardBg(context),
          borderRadius: BorderRadius.circular(20),
          child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                  key: _formKey,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            widget.loanType == null
                                ? 'Add Loan Type'
                                : 'Edit Loan Type',
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 18),
                        _field(_name, 'Name'),
                        _field(_amount, 'Maximum amount',
                            keyboard: TextInputType.number),
                        _field(_tenure, 'Maximum tenure in months',
                            keyboard: TextInputType.number, required: false),
                        DropdownButtonFormField<String>(
                            value: _allowedFor,
                            decoration: const InputDecoration(
                                labelText: 'Allowed for',
                                border: OutlineInputBorder()),
                            items: const [
                              'Employee Only',
                              'All Employees',
                              'Managers Only'
                            ]
                                .map((value) => DropdownMenuItem(
                                    value: value, child: Text(value)))
                                .toList(),
                            onChanged: (value) =>
                                setState(() => _allowedFor = value!)),
                        SwitchListTile(
                            contentPadding: EdgeInsets.zero,
                            title: const Text('Active'),
                            value: _active,
                            onChanged: (value) =>
                                setState(() => _active = value)),
                        SizedBox(
                            width: double.infinity,
                            child: FilledButton(
                                onPressed: _submit,
                                style: FilledButton.styleFrom(
                                    backgroundColor: AppConstant.primarycolor,
                                    foregroundColor: Colors.black),
                                child: const Text('Save Loan Type')))
                      ])))));
  Widget _field(TextEditingController controller, String label,
          {TextInputType? keyboard, bool required = true}) =>
      Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: TextFormField(
              controller: controller,
              keyboardType: keyboard,
              decoration: InputDecoration(
                  labelText: label, border: const OutlineInputBorder()),
              validator: (value) {
                if (required && (value == null || value.trim().isEmpty))
                  return '$label is required';
                if (label == 'Maximum amount' &&
                    double.tryParse(value ?? '') == null)
                  return 'Enter a valid amount';
                return null;
              }));
}
