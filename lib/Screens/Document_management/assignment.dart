import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lecture/appcolor.dart';
import 'package:lecture/widgets/shimmer_widgets.dart';

class DocumentAssignments extends StatefulWidget {
  const DocumentAssignments({super.key});

  @override
  State<DocumentAssignments> createState() => _DocumentAssignmentsState();
}

class _DocumentAssignmentsState extends State<DocumentAssignments> {
  String _status = 'All Statuses';
  final _assignments = <_Assignment>[
    _Assignment(number: 3, employee: 'zain', isMandatory: true),
    _Assignment(number: 2, employee: 'amair', isMandatory: false),
    _Assignment(number: 1, employee: 'ali', isMandatory: true),
  ];

  List<_Assignment> get _filtered => _assignments
      .where((item) => _status == 'All Statuses' || item.status == _status)
      .toList();

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
            Text('Document Assignments',
                style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: AppConstant.textPrimary(context))),
            Text(
                'Assign published document versions to employees for review & signing',
                style: TextStyle(
                    fontSize: 13, color: AppConstant.textPrimary(context)))
          ]),
        ),
        body: ScreenShimmerWrapper(
            child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 30),
                children: [
              _buildFilter(),
              const SizedBox(height: 18),
              _buildAssignmentsTable()
            ])),
      );

  Widget _buildFilter() => Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width * 0.5,
                child: ElevatedButton.icon(
                  onPressed: _assignDocument,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstant.primarycolor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  icon: const Icon(Icons.add_circle_outline, color: Colors.black),
                  label: const Text(
                    "Assign Document",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Card(
              elevation: 1,
              color: AppConstant.cardBg(context),
              child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _label('Status'),
                        DropdownButtonFormField<String>(
                            value: _status,
                            isExpanded: true,
                            decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 13),
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)))),
                            items: const [
                              'All Statuses',
                              'Pending',
                              'Signed',
                              'Overdue'
                            ]
                                .map((item) => DropdownMenuItem(
                                    value: item, child: Text(item)))
                                .toList(),
                            onChanged: (value) =>
                                setState(() => _status = value ?? _status)),
                        const SizedBox(height: 10),
                        Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                                '${_filtered.length} assignment${_filtered.length == 1 ? '' : 's'}',
                                style:
                                    const TextStyle(color: Color(0xFF657C94))))
                      ]))),
        ],
      );

  Widget _buildAssignmentsTable() => Card(
        elevation: 1,
        color: AppConstant.cardBg(context),
        clipBehavior: Clip.antiAlias,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowColor: WidgetStateProperty.all(AppConstant.primarycolor),
            columns: const [
              DataColumn(label: Text('Employee')),
              DataColumn(label: Text('Template')),
              DataColumn(label: Text('Version')),
              DataColumn(label: Text('Mandatory')),
              DataColumn(label: Text('Assigned')),
              DataColumn(label: Text('Signed')),
              DataColumn(label: Text('Status')),
              DataColumn(label: Text('Actions')),
            ],
            rows: _filtered.map((item) => DataRow(cells: [
              DataCell(Text(item.employee)),
              DataCell(Text(item.template)),
              DataCell(Text(item.version)),
              DataCell(item.isMandatory
                  ? _badge('Mandatory', const Color(0xFFFBE7EA), Colors.red)
                  : _badge('Optional', const Color(0xFFE9EEF4), const Color(0xFF536477))),
              DataCell(Text(item.assignedDate)),
              DataCell(Text(item.signedDate)),
              DataCell(_badge(item.status, item.status == 'Pending' ? const Color(0xFFE9EEF4) : Colors.green.shade100, item.status == 'Pending' ? const Color(0xFF536477) : Colors.green.shade800)),
              DataCell(IconButton(
                  onPressed: () => _unassign(item),
                  icon: const Icon(Icons.cancel_outlined, color: Colors.red))),
            ])).toList(),
          ),
        ),
      );

  Widget _badge(String text, Color background, Color foreground) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          color: background, borderRadius: BorderRadius.circular(14)),
      child: Text(text,
          style: TextStyle(
              fontSize: 12, color: foreground, fontWeight: FontWeight.w600)));

  Widget _label(String text) => Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Text(text,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppConstant.textSecondary(context))));

  Future<void> _assignDocument() async {
    final result = await showDialog<List<_Assignment>>(
      context: context,
      builder: (BuildContext context) {
        return const AssignDocumentDialog();
      },
    );

    if (result != null && result.isNotEmpty) {
      setState(() {
        _assignments.insertAll(0, result);
      });
    }
  }

  Future<void> _unassign(_Assignment item) async {
    final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
                title: const Text('Unassign document?'),
                content: Text('Remove this assignment from ${item.employee}?'),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancel')),
                  FilledButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Unassign'))
                ]));
    if (confirm == true && mounted) setState(() => _assignments.remove(item));
  }
}

class _Assignment {
  _Assignment({
    required this.number,
    required this.employee,
    this.template = 'bnm',
    this.version = 'v1.0',
    this.isMandatory = false,
    this.assignedDate = '02 Aug 2026',
    this.signedDate = '–',
    this.status = 'Pending',
  });
  final int number;
  final String employee;
  final String template;
  final String version;
  final bool isMandatory;
  final String assignedDate;
  final String signedDate;
  String status;
}

class AssignDocumentDialog extends StatefulWidget {
  const AssignDocumentDialog({super.key});

  @override
  State<AssignDocumentDialog> createState() => _AssignDocumentDialogState();
}

class _AssignDocumentDialogState extends State<AssignDocumentDialog> {
  bool isMandatory = true;
  String? selectedTemplate;
  final TextEditingController _employeeIdController = TextEditingController();
  List<String> employeeIds = [];
  final TextEditingController _dueDateController = TextEditingController();
  DateTime? dueDate;
  final TextEditingController _notesController = TextEditingController();

  final List<String> _templates = ['Standard NDA', 'Employment Contract', 'Company Policy v2'];

  @override
  void dispose() {
    _employeeIdController.dispose();
    _dueDateController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      backgroundColor: AppConstant.cardBg(context),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.85,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Header ──
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  children: [
                    Icon(Icons.people_outline,
                        color: AppConstant.primarycolor, size: 22),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text('Assign Document',
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: AppConstant.textPrimary(context))),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppConstant.inputBg(context),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Icon(Icons.close,
                            size: 18, color: AppConstant.textHint(context)),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(height: 1, color: AppConstant.border(context)),

              // ── Body ──
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Template
                      _buildLabel('Template (Published)'),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: selectedTemplate,
                        isDense: true,
                        hint: Text('— Select a template —',
                            style: TextStyle(
                                fontSize: 13, color: AppConstant.textHint(context))),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppConstant.inputBg(context),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: AppConstant.border(context))),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: AppConstant.border(context))),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  color: AppConstant.primarycolor, width: 1.5)),
                        ),
                        items: _templates
                            .map((t) => DropdownMenuItem(
                                  value: t,
                                  child: Text(t,
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: AppConstant.textPrimary(context))),
                                ))
                            .toList(),
                        onChanged: (v) => setState(() => selectedTemplate = v),
                      ),
                      const SizedBox(height: 18),

                      // Employee IDs
                      _buildLabel('Employee IDs'),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _employeeIdController,
                              style: TextStyle(
                                  fontSize: 13,
                                  color: AppConstant.textPrimary(context)),
                              decoration: InputDecoration(
                                hintText: 'Enter employee ID',
                                hintStyle: TextStyle(
                                    fontSize: 13, color: AppConstant.textHint(context)),
                                filled: true,
                                fillColor: AppConstant.inputBg(context),
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: AppConstant.border(context))),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: AppConstant.border(context))),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: AppConstant.primarycolor, width: 1.5)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          OutlinedButton(
                            onPressed: () {
                              if (_employeeIdController.text.trim().isNotEmpty) {
                                setState(() {
                                  employeeIds.add(_employeeIdController.text.trim());
                                  _employeeIdController.clear();
                                });
                              }
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppConstant.primarycolor,
                              side: BorderSide(color: AppConstant.primarycolor),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                            ),
                            child: const Text('Add',
                                style: TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),
                      if (employeeIds.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: employeeIds
                              .map((id) => Chip(
                                    label: Text(id,
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: AppConstant.textPrimary(context))),
                                    deleteIcon: Icon(Icons.cancel,
                                        size: 18,
                                        color: AppConstant.textHint(context)),
                                    onDeleted: () {
                                      setState(() => employeeIds.remove(id));
                                    },
                                    backgroundColor:
                                        AppConstant.primarycolor.withValues(alpha: 0.08),
                                    side: BorderSide(
                                        color: AppConstant.primarycolor
                                            .withValues(alpha: 0.3)),
                                  ))
                              .toList(),
                        ),
                      ],
                      const SizedBox(height: 18),

                      // Due Date + Mandatory
                      _buildLabel('Due Date'),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _dueDateController,
                              readOnly: true,
                              style: TextStyle(
                                  fontSize: 13,
                                  color: AppConstant.textPrimary(context)),
                              onTap: () async {
                                final picked = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(2100),
                                );
                                if (picked != null) {
                                  setState(() {
                                    dueDate = picked;
                                    _dueDateController.text =
                                        '${picked.month}/${picked.day}/${picked.year}';
                                  });
                                }
                              },
                              decoration: InputDecoration(
                                hintText: 'mm/dd/yyyy',
                                hintStyle: TextStyle(
                                    fontSize: 13, color: AppConstant.textHint(context)),
                                suffixIcon: Icon(Icons.calendar_today_outlined,
                                    size: 16, color: AppConstant.textHint(context)),
                                filled: true,
                                fillColor: AppConstant.inputBg(context),
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: AppConstant.border(context))),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: AppConstant.border(context))),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: AppConstant.primarycolor, width: 1.5)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Checkbox(
                            value: isMandatory,
                            activeColor: AppConstant.primarycolor,
                            onChanged: (v) =>
                                setState(() => isMandatory = v ?? true),
                          ),
                          Text('Mandatory',
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppConstant.textPrimary(context))),
                        ],
                      ),
                      const SizedBox(height: 18),

                      // Notes
                      _buildLabel('Notes'),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _notesController,
                        maxLines: 3,
                        style: TextStyle(
                            fontSize: 13,
                            color: AppConstant.textPrimary(context)),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppConstant.inputBg(context),
                          contentPadding: const EdgeInsets.all(12),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: AppConstant.border(context))),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: AppConstant.border(context))),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  color: AppConstant.primarycolor, width: 1.5)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Divider(height: 1, color: AppConstant.border(context)),

              // ── Footer ──
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppConstant.textSecondary(context),
                        side: BorderSide(color: AppConstant.border(context)),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                      ),
                      child: const Text('Cancel',
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w600)),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () {
                        if (selectedTemplate == null ||
                            employeeIds.isEmpty ||
                            dueDate == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text(
                                  'Please select a template, add an employee ID, and set a due date.'),
                              backgroundColor: Colors.red.shade600,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                          );
                          return;
                        }

                        const months = [
                          'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                          'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
                        ];
                        final formattedDate =
                            '${dueDate!.day.toString().padLeft(2, '0')} ${months[dueDate!.month - 1]} ${dueDate!.year}';

                        List<_Assignment> newAssignments = employeeIds
                            .map((id) => _Assignment(
                                  number: DateTime.now().millisecondsSinceEpoch,
                                  employee: id,
                                  template: selectedTemplate!,
                                  version: 'v1.0',
                                  isMandatory: isMandatory,
                                  assignedDate: formattedDate,
                                  signedDate: '–',
                                  status: 'Pending',
                                ))
                            .toList();

                        Navigator.of(context).pop(newAssignments);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Document successfully assigned!'),
                            backgroundColor: Colors.green.shade600,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppConstant.primarycolor,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                      ),
                      child: const Text('Assign',
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(text,
        style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppConstant.textPrimary(context)));
  }
}
