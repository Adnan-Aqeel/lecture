import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:lecture/core/constants/app_colors.dart';
import 'package:lecture/core/widgets/shimmer_widgets.dart';

class DocumentType {
  DocumentType({
    required this.id,
    required this.name,
    required this.description,
    required this.maxSizeMb,
    required this.allowedTypes,
    required this.isActive,
    required this.createdDate,
  });

  final int id;
  String name;
  String description;
  double maxSizeMb;
  List<String> allowedTypes;
  bool isActive;
  DateTime createdDate;
}

class DocumentTypeScreen extends StatefulWidget {
  const DocumentTypeScreen({super.key});

  @override
  State<DocumentTypeScreen> createState() => _DocumentTypeScreenState();
}

class _DocumentTypeScreenState extends State<DocumentTypeScreen> {
  final List<DocumentType> _documentTypes = [];

  Future<void> _openForm({DocumentType? documentType}) async {
    final result = await showModalBottomSheet<DocumentType>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _DocumentTypeForm(documentType: documentType),
    );

    if (!mounted || result == null) return;

    setState(() {
      if (documentType == null) {
        result.createdDate = DateTime.now();
        _documentTypes.add(result);
      } else {
        final index = _documentTypes.indexWhere((item) => item.id == result.id);
        if (index != -1) _documentTypes[index] = result;
      }
    });
  }

  Future<void> _deleteDocumentType(DocumentType documentType) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete document type?'),
        content:
            Text('Are you sure you want to delete “${documentType.name}”?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      setState(() => _documentTypes.remove(documentType));
    }
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
            Text('Document Types',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppConstant.textPrimary(context))),
            Text('Create and manage document categories',
                style: TextStyle(
                    fontSize: 13, color: AppConstant.textPrimary(context))),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Add Document Type',
            onPressed: () => _openForm(),
            icon: Icon(Icons.add_circle_outline,
                color: AppConstant.textPrimary(context)),
          ),
        ],
      ),
      body: ScreenShimmerWrapper(
        child:
            _documentTypes.isEmpty ? _buildEmptyState() : _buildDocumentList(),
      ),
      floatingActionButton: _documentTypes.isEmpty
          ? null
          : FloatingActionButton.extended(
              backgroundColor: AppConstant.primarycolor,
              foregroundColor: Colors.black,
              onPressed: () => _openForm(),
              icon: const Icon(Icons.add),
              label: const Text('Add Document Type'),
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppConstant.primarycolor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.description_outlined,
                  size: 58, color: Color(0xFF62809D)),
            ),
            const SizedBox(height: 20),
            const Text('No document types found',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Click Add Document Type to create one.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFF62758A))),
            const SizedBox(height: 24),
            FilledButton.icon(
              style: FilledButton.styleFrom(
                  backgroundColor: AppConstant.primarycolor,
                  foregroundColor: Colors.black),
              onPressed: () => _openForm(),
              icon: const Icon(Icons.add),
              label: const Text('Add Document Type'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentList() => Card(
        margin: const EdgeInsets.fromLTRB(16, 18, 16, 100),
        clipBehavior: Clip.antiAlias,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowColor: const WidgetStatePropertyAll(Color(0xFF22D3EE)),
            columns: const [
              DataColumn(label: Text('Name')),
              DataColumn(label: Text('Description')),
              DataColumn(label: Text('Max Size')),
              DataColumn(label: Text('Allowed Types')),
              DataColumn(label: Text('Status')),
              DataColumn(label: Text('Created')),
              DataColumn(label: Text('Actions')),
            ],
            rows: _documentTypes
                .map((item) => DataRow(cells: [
                      DataCell(Text(item.name)),
                      DataCell(Text(item.description)),
                      DataCell(Text('${item.maxSizeMb.toStringAsFixed(0)} MB')),
                      DataCell(Text(item.allowedTypes.join(', '))),
                      DataCell(Text(item.isActive ? 'Active' : 'Inactive')),
                      DataCell(Text(
                          DateFormat('dd MMM yyyy').format(item.createdDate))),
                      DataCell(PopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == 'edit') _openForm(documentType: item);
                          if (value == 'delete') _deleteDocumentType(item);
                        },
                        itemBuilder: (_) => const [
                          PopupMenuItem(value: 'edit', child: Text('Edit')),
                          PopupMenuItem(value: 'delete', child: Text('Delete')),
                        ],
                      )),
                    ]))
                .toList(),
          ),
        ),
      );
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.label, this.active = false});

  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label,
          style: TextStyle(
              fontSize: 12,
              color: active ? Colors.green.shade800 : const Color(0xFF42627B))),
      backgroundColor: active ? Colors.green.shade50 : const Color(0xFFEAF4F8),
      side: BorderSide.none,
      visualDensity: VisualDensity.compact,
    );
  }
}

class _DocumentTypeForm extends StatefulWidget {
  const _DocumentTypeForm({this.documentType});

  final DocumentType? documentType;

  @override
  State<_DocumentTypeForm> createState() => _DocumentTypeFormState();
}

class _DocumentTypeFormState extends State<_DocumentTypeForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _maxSizeController;
  final Set<String> _allowedTypes = {'PDF'};
  late bool _isActive;

  static const _fileTypes = ['PDF', 'DOC', 'DOCX', 'JPG', 'PNG', 'XLSX'];

  @override
  void initState() {
    super.initState();
    final item = widget.documentType;
    _nameController = TextEditingController(text: item?.name);
    _descriptionController = TextEditingController(text: item?.description);
    _maxSizeController =
        TextEditingController(text: item?.maxSizeMb.toStringAsFixed(0) ?? '5');
    _allowedTypes
      ..clear()
      ..addAll(item?.allowedTypes ?? {'PDF'});
    _isActive = item?.isActive ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _maxSizeController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final maxSize = double.parse(_maxSizeController.text.trim());
    final old = widget.documentType;
    Navigator.pop(
      context,
      DocumentType(
        id: old?.id ?? DateTime.now().microsecondsSinceEpoch,
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        maxSizeMb: maxSize,
        allowedTypes: _allowedTypes.toList(),
        isActive: _isActive,
        createdDate: old?.createdDate ?? DateTime.now(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
            20, 16, 20, MediaQuery.viewInsetsOf(context).bottom + 20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                    child: Container(
                        width: 42,
                        height: 4,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade400,
                            borderRadius: BorderRadius.circular(4)))),
                const SizedBox(height: 18),
                Text(
                    widget.documentType == null
                        ? 'Add Document Type'
                        : 'Edit Document Type',
                    style: const TextStyle(
                        fontSize: 21, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                        labelText: 'Document type name',
                        border: OutlineInputBorder()),
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'Name is required'
                        : null),
                const SizedBox(height: 14),
                TextFormField(
                    controller: _descriptionController,
                    maxLines: 2,
                    decoration: const InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder())),
                const SizedBox(height: 14),
                TextFormField(
                    controller: _maxSizeController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                        labelText: 'Maximum size (MB)',
                        border: OutlineInputBorder()),
                    validator: (value) {
                      final size = double.tryParse(value?.trim() ?? '');
                      return size == null || size <= 0
                          ? 'Enter a positive size'
                          : null;
                    }),
                const SizedBox(height: 16),
                const Text('Allowed file types',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                Wrap(
                  spacing: 8,
                  children: _fileTypes
                      .map((type) => FilterChip(
                          label: Text(type),
                          selected: _allowedTypes.contains(type),
                          onSelected: (selected) => setState(() => selected
                              ? _allowedTypes.add(type)
                              : _allowedTypes.remove(type))))
                      .toList(),
                ),
                SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Active'),
                    value: _isActive,
                    onChanged: (value) => setState(() => _isActive = value)),
                const SizedBox(height: 8),
                SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                        onPressed: _submit,
                        style: FilledButton.styleFrom(
                            backgroundColor: AppConstant.primarycolor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14)),
                        child: Text(widget.documentType == null
                            ? 'Create Document Type'
                            : 'Save Changes'))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
