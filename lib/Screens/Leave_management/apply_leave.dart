import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lecture/appcolor.dart';
import 'package:lecture/widgets/shimmer_widgets.dart';

class ApplyLeave extends StatefulWidget {
  const ApplyLeave({super.key});

  @override
  State<ApplyLeave> createState() => _ApplyLeaveState();
}

class _ApplyLeaveState extends State<ApplyLeave> {
  final _formKey = GlobalKey<FormState>();
  final _reasonController = TextEditingController();
  String? _employee;
  String? _leaveType;
  DateTime? _fromDate;
  DateTime? _toDate;

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
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
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Leave Management',
              style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: AppConstant.textPrimary(context))),
          Text('Apply for employee leave and view leave balances',
              style: TextStyle(
                  fontSize: 13, color: AppConstant.textPrimary(context))),
        ]),
      ),
      body: ScreenShimmerWrapper(
        child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 28),
            children: [
              _buildRequestCard(),
              const SizedBox(height: 16),
              _buildOverviewCard()
            ]),
      ),
    );
  }

  Widget _buildRequestCard() => Card(
        elevation: 1,
        color: AppConstant.cardBg(context),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: Form(
          key: _formKey,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            _sectionTitle('Quick Request'),
            Padding(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label('Employee'),
                      _dropdown(
                          _employee,
                          ['Ali Ahmed', 'Hamza Khan', 'Zain Malik'],
                          (value) => setState(() => _employee = value),
                          required: true),
                      const SizedBox(height: 16),
                      Row(children: [
                        Expanded(
                            child: _dateField('From Date', _fromDate,
                                (date) => setState(() => _fromDate = date))),
                        const SizedBox(width: 12),
                        Expanded(
                            child: _dateField('To Date', _toDate,
                                (date) => setState(() => _toDate = date)))
                      ]),
                      const SizedBox(height: 16),
                      _label('Leave Type'),
                      _dropdown(
                          _leaveType,
                          [
                            'Annual Leave',
                            'Sick Leave',
                            'Casual Leave',
                            'Unpaid Leave'
                          ],
                          (value) => setState(() => _leaveType = value),
                          required: true),
                      const SizedBox(height: 16),
                      _label('Reason'),
                      TextFormField(
                          controller: _reasonController,
                          maxLines: 4,
                          decoration: const InputDecoration(
                              hintText: 'Add a short note for this request...',
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)))),
                          validator: (value) =>
                              value == null || value.trim().isEmpty
                                  ? 'Reason is required'
                                  : null),
                    ])),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: const BoxDecoration(
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(14))),
              child: Align(
                  alignment: Alignment.centerRight,
                  child: FilledButton(
                      onPressed: _submit,
                      style: FilledButton.styleFrom(
                          backgroundColor: AppConstant.primarycolor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 14)),
                      child: const Text('Submit Request'))),
            )
          ]),
        ),
      );

  Widget _buildOverviewCard() => Card(
        elevation: 1,
        color: AppConstant.cardBg(context),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: SizedBox(
            height: 240,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _sectionTitle('Leave Overview'),
              Expanded(
                  child: Center(
                      child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Text(
                              _employee == null
                                  ? 'Select an employee above to view their leave balance.'
                                  : 'Leave balance for $_employee is not available yet.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: AppConstant.textHint(context), fontSize: 15))))),
            ])),
      );

  Widget _sectionTitle(String title) => Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: AppConstant.divider(context)))),
      child: Text(title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppConstant.textHint(context),
          )));

  Widget _label(String text) => Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text,
          style: TextStyle(
            fontSize: 14,
            color: AppConstant.textSecondary(context),
          )));

  Widget _dropdown(
          String? value, List<String> items, ValueChanged<String?> onChanged,
          {required bool required}) =>
      DropdownButtonFormField<String>(
        value: value,
        isExpanded: true,
        decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)))),
        items: items
            .map((item) => DropdownMenuItem(value: item, child: Text(item)))
            .toList(),
        onChanged: onChanged,
        validator: required
            ? (value) => value == null ? 'Please select an option' : null
            : null,
      );

  Widget _dateField(
          String label, DateTime? date, ValueChanged<DateTime> onSelected) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _label(label),
        TextFormField(
            readOnly: true,
            controller: TextEditingController(
                text: date == null
                    ? ''
                    : '${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}/${date.year}'),
            decoration: const InputDecoration(
                hintText: 'mm/dd/yyyy',
                suffixIcon: Icon(Icons.calendar_today_outlined, size: 18),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)))),
            validator: (_) => date == null ? 'Required' : null,
            onTap: () async {
              final picked = await showDatePicker(
                  context: context,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2035),
                  initialDate: date ?? DateTime.now());
              if (picked != null) onSelected(picked);
            })
      ]);

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Leave request submitted locally.')));
  }
}
