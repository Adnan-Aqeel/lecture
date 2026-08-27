import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lecture/core/constants/app_colors.dart';
import 'package:lecture/core/widgets/shimmer_widgets.dart';

class DocumentTemplates extends StatefulWidget {
  const DocumentTemplates({super.key});

  @override
  State<DocumentTemplates> createState() => _DocumentTemplatesState();
}

class _DocumentTemplatesState extends State<DocumentTemplates> {
  final _searchController = TextEditingController();
  String _category = 'All Categories';
  final _templates = <_TemplateItem>[
    _TemplateItem(
        name: 'bnm',
        category: 'HR',
        status: 'Published',
        version: 'v1.0',
        versions: '1 version')
  ];

  List<_TemplateItem> get _filtered => _templates
      .where((item) =>
          (_category == 'All Categories' || item.category == _category) &&
          (item.name
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase()) ||
              _searchController.text.isEmpty))
      .toList();

  @override
  void dispose() {
    _searchController.dispose();
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
            Text('Document Templates',
                style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: AppConstant.textPrimary(context))),
            Text('Manage policy and document templates for assignment',
                style: TextStyle(
                    fontSize: 13, color: AppConstant.textPrimary(context)))
          ]),
        ),
        body: ScreenShimmerWrapper(
            child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 30),
                children: [
              _buildFilters(),
              const SizedBox(height: 20),
              _buildTemplatesTable()
            ])),
        floatingActionButton: FloatingActionButton.extended(
            backgroundColor: AppConstant.primarycolor,
            foregroundColor: Colors.black,
            onPressed: _newTemplate,
            icon: const Icon(Icons.add),
            label: const Text('New Template')),
      );

  Widget _buildFilters() => Card(
      elevation: 1,
      color: AppConstant.cardBg(context),
      child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(children: [
            TextField(
                controller: _searchController,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                    hintText: 'Search templates...',
                    prefixIcon:
                        const Icon(Icons.search, color: Color(0xFF0DB9D8)),
                    suffixIcon: _searchController.text.isEmpty
                        ? null
                        : IconButton(
                            onPressed: () {
                              _searchController.clear();
                              setState(() {});
                            },
                            icon: const Icon(Icons.clear)),
                    border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))))),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
                value: _category,
                isExpanded: true,
                decoration: const InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 13),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)))),
                items: const [
                  'All Categories',
                  'HR',
                  'Finance',
                  'Administration'
                ]
                    .map((item) =>
                        DropdownMenuItem(value: item, child: Text(item)))
                    .toList(),
                onChanged: (value) =>
                    setState(() => _category = value ?? _category)),
            Align(
                alignment: Alignment.centerRight,
                child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                        '${_filtered.length} template${_filtered.length == 1 ? '' : 's'}',
                        style: const TextStyle(color: Color(0xFF657C94)))))
          ])));

  Widget _buildTemplatesTable() => Card(
        elevation: 1,
        color: AppConstant.cardBg(context),
        clipBehavior: Clip.antiAlias,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowColor: const WidgetStatePropertyAll(Color(0xFF22D3EE)),
            columns: const [
              DataColumn(label: Text('Name')),
              DataColumn(label: Text('Category')),
              DataColumn(label: Text('Status')),
              DataColumn(label: Text('Version')),
              DataColumn(label: Text('Versions')),
              DataColumn(label: Text('Actions')),
            ],
            rows: _filtered.map((item) => DataRow(cells: [
              DataCell(Text(item.name)),
              DataCell(_badge(item.category, const Color(0xFFECECEC), const Color(0xFF65717D))),
              DataCell(_badge(item.status, const Color(0xFFE1F5EC), Colors.green)),
              DataCell(Text(item.version)),
              DataCell(Text(item.versions)),
              DataCell(Row(mainAxisSize: MainAxisSize.min, children: [
                IconButton(onPressed: () => _edit(item), icon: const Icon(Icons.edit_outlined, color: Color(0xFF0DB9D8))),
                IconButton(onPressed: () => _delete(item), icon: const Icon(Icons.delete_outline, color: Colors.red)),
              ])),
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
              color: foreground, fontSize: 12, fontWeight: FontWeight.w600)));
  void _newTemplate() {
    final nameCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    String? category;
    bool requiresSignature = true;
    bool allowRejection = false;

    final categories = [
      '— None —',
      'HR',
      'Finance',
      'Administration',
      'Legal',
      'Operations'
    ];

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => Dialog(
          backgroundColor: AppConstant.cardBg(ctx),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          insetPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(ctx).size.width * 0.85,
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Header ──
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color:
                              AppConstant.primarycolor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Icons.description_outlined,
                            color: AppConstant.primarycolor, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text('New Template',
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: AppConstant.textPrimary(ctx))),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(ctx),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: AppConstant.inputBg(ctx),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Icon(Icons.close,
                              size: 18, color: AppConstant.textHint(ctx)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // ── Template Name ──
                  Row(
                    children: [
                      Text('Template Name',
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppConstant.textPrimary(ctx))),
                      const SizedBox(width: 4),
                      Text('*',
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Colors.red.shade400)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: nameCtrl,
                    style: TextStyle(
                        fontSize: 13, color: AppConstant.textPrimary(ctx)),
                    decoration: InputDecoration(
                      hintText: 'e.g. Employee Confidentiality Agreement',
                      hintStyle: TextStyle(
                          fontSize: 13, color: AppConstant.textHint(ctx)),
                      filled: true,
                      fillColor: AppConstant.inputBg(ctx),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              BorderSide(color: AppConstant.border(ctx))),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              BorderSide(color: AppConstant.border(ctx))),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: AppConstant.primarycolor, width: 1.5)),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                    ),
                  ),
                  const SizedBox(height: 18),
                  // ── Category ──
                  Text('Category',
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppConstant.textPrimary(ctx))),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    value: category,
                    isDense: true,
                    decoration: InputDecoration(
                      hintText: '— None —',
                      hintStyle: TextStyle(
                          fontSize: 13, color: AppConstant.textHint(ctx)),
                      filled: true,
                      fillColor: AppConstant.inputBg(ctx),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              BorderSide(color: AppConstant.border(ctx))),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              BorderSide(color: AppConstant.border(ctx))),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: AppConstant.primarycolor, width: 1.5)),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                    ),
                    items: categories
                        .map((c) => DropdownMenuItem(
                              value: c == '— None —' ? null : c,
                              child: Text(c,
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: AppConstant.textPrimary(ctx))),
                            ))
                        .toList(),
                    onChanged: (v) => setDialogState(() => category = v),
                  ),
                  const SizedBox(height: 18),
                  // ── Description ──
                  Text('Description',
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppConstant.textPrimary(ctx))),
                  const SizedBox(height: 6),
                  TextField(
                    controller: descCtrl,
                    maxLines: 4,
                    style: TextStyle(
                        fontSize: 13, color: AppConstant.textPrimary(ctx)),
                    decoration: InputDecoration(
                      hintText: '',
                      hintStyle: TextStyle(
                          fontSize: 13, color: AppConstant.textHint(ctx)),
                      filled: true,
                      fillColor: AppConstant.inputBg(ctx),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              BorderSide(color: AppConstant.border(ctx))),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              BorderSide(color: AppConstant.border(ctx))),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: AppConstant.primarycolor, width: 1.5)),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Column(
                    children: [
                      // ── Checkboxes ──
                      Checkbox(
                        value: requiresSignature,
                        activeColor: AppConstant.primarycolor,
                        onChanged: (v) =>
                            setDialogState(() => requiresSignature = v ?? true),
                      ),
                      Text('Requires Signature',
                          style: TextStyle(
                              fontSize: 13,
                              color: AppConstant.textPrimary(ctx))),
                      const SizedBox(width: 16),
                      Checkbox(
                        value: allowRejection,
                        activeColor: AppConstant.primarycolor,
                        onChanged: (v) =>
                            setDialogState(() => allowRejection = v ?? false),
                      ),
                      Text('Allow Rejection',
                          style: TextStyle(
                              fontSize: 13,
                              color: AppConstant.textPrimary(ctx))),
                      const SizedBox(height: 20),
                    ],
                  ),
                  // ── Buttons ──
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(ctx),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppConstant.textSecondary(ctx),
                            side: BorderSide(color: AppConstant.border(ctx)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text('Cancel'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            if (nameCtrl.text.trim().isEmpty) return;
                            setState(() {
                              _templates.add(_TemplateItem(
                                name: nameCtrl.text.trim(),
                                category: category ?? 'HR',
                                status: 'Draft',
                                version: 'v1.0',
                                versions: '1 version',
                              ));
                            });
                            Navigator.pop(ctx);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'Template "${nameCtrl.text.trim()}" created'),
                                backgroundColor: AppConstant.primarycolor,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppConstant.primarycolor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text('Create & Edit',
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _edit(_TemplateItem item) => ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text('Editing ${item.name} locally.')));
  Future<void> _delete(_TemplateItem item) async {
    final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
                title: const Text('Delete template?'),
                content: Text('Delete ${item.name}?'),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancel')),
                  FilledButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Delete'))
                ]));
    if (confirmed == true && mounted) setState(() => _templates.remove(item));
  }
}

class _TemplateItem {
  _TemplateItem(
      {required this.name,
      required this.category,
      required this.status,
      required this.version,
      required this.versions});
  final String name;
  final String category;
  final String status;
  final String version;
  final String versions;
}
