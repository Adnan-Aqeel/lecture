import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lecture/core/constants/app_colors.dart';
import 'package:lecture/core/widgets/shimmer_widgets.dart';

class LeaveApproval extends StatefulWidget {
  const LeaveApproval({super.key});

  @override
  State<LeaveApproval> createState() => _LeaveApprovalState();
}

class _LeaveApprovalState extends State<LeaveApproval> {
  String _status = 'All';
  DateTime? _fromDate;
  DateTime? _toDate;
  final _requests = <_LeaveRequest>[
    _LeaveRequest('ali', 'Sick', '7/1/26', '7/12/26', 'thkhgkj', 'Approved',
        'System Admin'),
    _LeaveRequest('ali', 'Annual', '3/5/26', '3/10/26', '324t5325', 'Approved',
        'System Admin'),
  ];

  List<_LeaveRequest> get _filtered => _requests
      .where((item) => _status == 'All' || item.status == _status)
      .toList();

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
          Text('Leave Requests Management',
              style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: AppConstant.textPrimary(context))),
          Text('Review and action employee leave requests',
              style: TextStyle(
                  fontSize: 13, color: AppConstant.textPrimary(context))),
        ]),
      ),
      body: ScreenShimmerWrapper(
        child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 28),
            children: [
              _buildFilters(),
              const SizedBox(height: 18),
              _buildRequestsTable()
            ]),
      ),
    );
  }

  Widget _buildFilters() =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
            items: const ['All', 'Pending', 'Approved', 'Rejected']
                .map((item) => DropdownMenuItem(value: item, child: Text(item)))
                .toList(),
            onChanged: (value) => setState(() => _status = value ?? _status)),
        const SizedBox(height: 14),
        Row(children: [
          Expanded(
              child: _dateFilter('From Date', _fromDate,
                  (value) => setState(() => _fromDate = value))),
          const SizedBox(width: 12),
          Expanded(
              child: _dateFilter('To Date', _toDate,
                  (value) => setState(() => _toDate = value)))
        ]),
      ]);

  Widget _dateFilter(
          String label, DateTime? value, ValueChanged<DateTime> onSelected) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _label(label),
        TextFormField(
            readOnly: true,
            controller: TextEditingController(
                text: value == null
                    ? ''
                    : '${value.month}/${value.day}/${value.year}'),
            decoration: InputDecoration(
                hintText: 'mm/dd/yyyy',
                suffixIcon: Icon(Icons.calendar_today_outlined, size: 18),
                filled: true,
                fillColor: AppConstant.inputBg(context),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)))),
            onTap: () async {
              final picked = await showDatePicker(
                  context: context,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2035),
                  initialDate: value ?? DateTime.now());
              if (picked != null) onSelected(picked);
            })
      ]);

  Widget _buildRequestsTable() => Card(
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
              DataColumn(label: Text('Employee')),
              DataColumn(label: Text('Leave Type')),
              DataColumn(label: Text('Dates')),
              DataColumn(label: Text('Reason')),
              DataColumn(label: Text('Status')),
              DataColumn(label: Text('Action By')),
              DataColumn(label: Text('Actions')),
            ],
            rows: _filtered.map((request) => DataRow(cells: [
              DataCell(Text(request.employee)),
              DataCell(Text(request.leaveType)),
              DataCell(Text('${request.from} – ${request.to}')),
              DataCell(Text(request.reason)),
              DataCell(_statusChip(request.status)),
              DataCell(Text(request.actionBy)),
              DataCell(PopupMenuButton<String>(
                onSelected: (value) => _updateStatus(request, value),
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'Approved', child: Text('Approve')),
                  PopupMenuItem(value: 'Rejected', child: Text('Reject')),
                ],
              )),
            ])).toList(),
          ),
        ),
      );

  Widget _info(IconData icon, String label, String value) => Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(icon, size: 18, color: const Color(0xFF7890A5)),
        const SizedBox(width: 9),
        SizedBox(
            width: 78,
            child: Text(label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF94A3B8),
                ))),
        Expanded(
            child: Text(value,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF94A3B8),
                )))
      ]));

  Widget _statusChip(String status) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          color: status == 'Approved'
              ? const Color(0xFFE1F5EC)
              : const Color(0xFFFFE7E7),
          borderRadius: BorderRadius.circular(14)),
      child: Text(status,
          style: TextStyle(
              fontSize: 12,
              color: status == 'Approved'
                  ? Colors.green.shade700
                  : Colors.red.shade700,
              fontWeight: FontWeight.w600)));

  Widget _label(String text) => Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF94A3B8),
          )));

  void _updateStatus(_LeaveRequest request, String status) {
    setState(() {
      request.status = status;
      request.actionBy = 'System Admin';
    });
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Request marked $status.')));
  }
}

class _LeaveRequest {
  _LeaveRequest(this.employee, this.leaveType, this.from, this.to, this.reason,
      this.status, this.actionBy);
  final String employee;
  final String leaveType;
  final String from;
  final String to;
  final String reason;
  String status;
  String actionBy;
}
