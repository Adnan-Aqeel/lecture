import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lecture/appcolor.dart';
import 'package:lecture/widgets/shimmer_widgets.dart';

class AuditLog extends StatefulWidget {
  const AuditLog({super.key});

  @override
  State<AuditLog> createState() => _AuditLogState();
}

class _AuditLogState extends State<AuditLog> {
  String _entity = 'All';
  final _actionController = TextEditingController();
  final _performedByController = TextEditingController();
  DateTime? _from;
  DateTime? _to;
  final _logs = const [
    _Log(7, 'Assignment', '3', 'Created', 'admin@example.com',
        '02 Aug 2026 21:45', 'Assigned version v1.0 to employee 2'),
    _Log(6, 'Assignment', '2', 'Created', 'admin@example.com',
        '02 Aug 2026 21:45', 'Assigned version v1.0 to employee 1002'),
    _Log(5, 'Assignment', '1', 'Created', 'admin@example.com',
        '02 Aug 2026 21:45', 'Assigned version v1.0 to employee 1'),
    _Log(4, 'TemplateVersion', '1', 'Published', 'admin@example.com',
        '02 Aug 2026 21:44', "Published v1.0 for template 'bnm'"),
    _Log(3, 'Template', '1', 'DraftSaved', 'admin@example.com',
        '02 Aug 2026 21:44', "Working draft saved for 'bnm'"),
    _Log(2, 'Template', '1', 'DraftSaved', 'admin@example.com',
        '02 Aug 2026 21:44', "Working draft saved for 'bnm'"),
    _Log(1, 'Template', '1', 'Created', 'admin@example.com',
        '02 Aug 2026 21:40', "Created template 'bnm'"),
  ];

  @override
  void dispose() {
    _actionController.dispose();
    _performedByController.dispose();
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
              Text('Audit Log',
                  style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: AppConstant.textPrimary(context))),
              Text('All document management activity — immutable trail',
                  style: TextStyle(
                      fontSize: 13, color: AppConstant.textPrimary(context)))
            ])),
        body: ScreenShimmerWrapper(
            child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 30),
                children: [
              Align(
                  alignment: Alignment.centerRight,
                  child: Wrap(spacing: 8, children: [
                    FilledButton(
                        onPressed: () => setState(() {}),
                        style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFF16C4DF),
                            foregroundColor: Colors.black),
                        child: const Text('Filter')),
                    OutlinedButton(
                        onPressed: () {
                          _actionController.clear();
                          _performedByController.clear();
                          setState(() {
                            _entity = 'All';
                            _from = null;
                            _to = null;
                          });
                        },
                        child: const Text('Clear'))
                  ])),
              _buildFilters(),
              const SizedBox(height: 18),
              _buildAuditTable()
            ])),
      );

  Widget _buildFilters() => Card(
      elevation: 1,
      color: AppConstant.cardBg(context),
      child: Padding(
          padding: const EdgeInsets.all(14),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            _label('Entity Type'),
            DropdownButtonFormField<String>(
                value: _entity,
                decoration: const InputDecoration(border: OutlineInputBorder()),
                items: const [
                  'All',
                  'Assignment',
                  'Template',
                  'TemplateVersion'
                ]
                    .map((value) =>
                        DropdownMenuItem(value: value, child: Text(value)))
                    .toList(),
                onChanged: (value) =>
                    setState(() => _entity = value ?? _entity)),
            const SizedBox(height: 12),
            _label('Action'),
            _textField(_actionController, 'e.g. Published'),
            const SizedBox(height: 12),
            _label('Performed By'),
            _textField(_performedByController, 'Email'),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(
                  child: _dateField(
                      'From', _from, (value) => setState(() => _from = value))),
              const SizedBox(width: 10),
              Expanded(
                  child: _dateField(
                      'To', _to, (value) => setState(() => _to = value)))
            ]),
            const SizedBox(height: 14),
          ])));

  Widget _textField(TextEditingController controller, String hint) => TextField(
      controller: controller,
      decoration:
          InputDecoration(hintText: hint, border: const OutlineInputBorder()));
  Widget _dateField(
          String label, DateTime? date, ValueChanged<DateTime> onSelected) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _label(label),
        TextFormField(
            readOnly: true,
            controller: TextEditingController(
                text: date == null
                    ? ''
                    : '${date.month}/${date.day}/${date.year}'),
            decoration: const InputDecoration(
                hintText: 'mm/dd/yyyy',
                suffixIcon: Icon(Icons.calendar_today_outlined, size: 18),
                border: OutlineInputBorder()),
            onTap: () async {
              final picked = await showDatePicker(
                  context: context,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2035),
                  initialDate: date ?? DateTime.now());
              if (picked != null) onSelected(picked);
            })
      ]);
  Widget _buildAuditTable() => Card(
        elevation: 1,
        color: AppConstant.cardBg(context),
        clipBehavior: Clip.antiAlias,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowColor: const WidgetStatePropertyAll(Color(0xFF22D3EE)),
            columns: const [
              DataColumn(label: Text('#')),
              DataColumn(label: Text('Entity')),
              DataColumn(label: Text('Entity ID')),
              DataColumn(label: Text('Action')),
              DataColumn(label: Text('Performed By')),
              DataColumn(label: Text('Date & Time')),
              DataColumn(label: Text('IP')),
              DataColumn(label: Text('Notes')),
            ],
            rows: _logs.map((log) => DataRow(cells: [
              DataCell(Text('#${log.number}')),
              DataCell(Text(log.entity)),
              DataCell(Text(log.entityId)),
              DataCell(_badge(log.action)),
              DataCell(Text(log.performedBy)),
              DataCell(Text(log.dateTime)),
              const DataCell(Text('—')),
              DataCell(Text(log.notes)),
            ])).toList(),
          ),
        ),
      );
  Widget _info(String label, String value) => Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(
            width: 100,
            child: Text(label,
                style:
                    const TextStyle(fontSize: 12, color: Color(0xFF657C94)))),
        Expanded(
            child: Text(value,
                style: const TextStyle(fontSize: 13, color: Color(0xFF1E3851))))
      ]));
  Widget _badge(String text) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
          color: text == 'Published'
              ? const Color(0xFFD9F5FB)
              : const Color(0xFFE1F5EC),
          borderRadius: BorderRadius.circular(14)),
      child: Text(text,
          style: TextStyle(
              fontSize: 11,
              color: text == 'Published'
                  ? const Color(0xFF087C98)
                  : Colors.green.shade700,
              fontWeight: FontWeight.w600)));
  Widget _label(String text) => Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(text,
          style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppConstant.textSecondary(context))));
}

class _Log {
  const _Log(this.number, this.entity, this.entityId, this.action,
      this.performedBy, this.dateTime, this.notes);
  final int number;
  final String entity;
  final String entityId;
  final String action;
  final String performedBy;
  final String dateTime;
  final String notes;
}
