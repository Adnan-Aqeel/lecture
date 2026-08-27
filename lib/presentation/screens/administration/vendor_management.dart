import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lecture/core/constants/app_colors.dart';
import 'package:lecture/core/widgets/shimmer_widgets.dart';

class Vendor {
  Vendor({
    required this.id,
    required this.name,
    required this.code,
    required this.contact,
    required this.phone,
    required this.email,
    required this.taxNumber,
    this.address = '',
    this.notes = '',
    required this.isActive,
  });

  final int id;
  String name;
  String code;
  String contact;
  String phone;
  String email;
  String taxNumber;
  String address;
  String notes;
  bool isActive;
}

class VendorManagement extends StatefulWidget {
  const VendorManagement({super.key});

  @override
  State<VendorManagement> createState() => _VendorManagementState();
}

class _VendorManagementState extends State<VendorManagement> {
  final List<Vendor> _vendors = [];
  final _searchController = TextEditingController();
  String _query = '';
  bool _showInactive = false;

  List<Vendor> get _filteredVendors => _vendors.where((vendor) {
        final query = _query.trim().toLowerCase();
        final matchesQuery = query.isEmpty ||
            [vendor.name, vendor.code, vendor.contact, vendor.email]
                .any((value) => value.toLowerCase().contains(query));
        return matchesQuery && (_showInactive || vendor.isActive);
      }).toList();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _openForm({Vendor? vendor}) async {
    final result = await showDialog<Vendor>(
      context: context,
      builder: (_) => _VendorForm(vendor: vendor),
    );
    if (!mounted || result == null) return;
    setState(() {
      if (vendor == null) {
        _vendors.add(result);
      } else {
        final index = _vendors.indexWhere((item) => item.id == result.id);
        if (index >= 0) _vendors[index] = result;
      }
    });
  }

  Future<void> _deleteVendor(Vendor vendor) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: AppConstant.cardBg(context),
        title: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Color(0xFFEF4444)),
            const SizedBox(width: 8),
            Text('Delete Vendor',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppConstant.textPrimary(context))),
          ],
        ),
        content: Text('Delete "${vendor.name}"?',
            style: TextStyle(
                fontSize: 13, color: AppConstant.textSecondary(context))),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel',
                style: TextStyle(
                    fontSize: 13,
                    color: AppConstant.textSecondary(context),
                    fontWeight: FontWeight.w600)),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) setState(() => _vendors.remove(vendor));
  }

  @override
  Widget build(BuildContext context) {
    final vendors = _filteredVendors;
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
            Text('Vendor Management',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 19,
                    color: AppConstant.textPrimary(context))),
            Text('Manage suppliers and vendors for expense requests',
                style: TextStyle(
                    fontSize: 13, color: AppConstant.textPrimary(context))),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => _openForm(),
            tooltip: 'Add Vendor',
            icon: Icon(Icons.add_business_outlined,
                color: AppConstant.textPrimary(context)),
          )
        ],
      ),
      body: ScreenShimmerWrapper(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _searchController,
                    onChanged: (value) => setState(() => _query = value),
                    style: TextStyle(
                        fontSize: 13, color: AppConstant.textPrimary(context)),
                    decoration: InputDecoration(
                      labelText: 'Search',
                      hintText: 'Search by name, code, contact or email...',
                      labelStyle:
                          TextStyle(color: AppConstant.textSecondary(context)),
                      hintStyle:
                          TextStyle(color: AppConstant.textHint(context)),
                      prefixIcon: Icon(Icons.search,
                          color: AppConstant.textHint(context)),
                      suffixIcon: _query.isEmpty
                          ? null
                          : IconButton(
                              onPressed: () {
                                _searchController.clear();
                                setState(() => _query = '');
                              },
                              icon: Icon(Icons.clear,
                                  color: AppConstant.textSecondary(context))),
                      filled: true,
                      fillColor: AppConstant.cardBg(context),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              BorderSide(color: AppConstant.border(context))),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              BorderSide(color: AppConstant.border(context))),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                              color: AppConstant.primarycolor, width: 1.5)),
                    ),
                  ),
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    title: Text('Show inactive',
                        style: TextStyle(
                            color: AppConstant.textSecondary(context))),
                    value: _showInactive,
                    onChanged: (value) =>
                        setState(() => _showInactive = value ?? false),
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                ],
              ),
            ),
            Expanded(
                child: vendors.isEmpty
                    ? _buildEmptyState()
                    : _buildVendorList(vendors)),
          ],
        ),
      ),
      floatingActionButton: vendors.isEmpty
          ? null
          : FloatingActionButton.extended(
              backgroundColor: AppConstant.primarycolor,
              foregroundColor: Colors.black,
              onPressed: () => _openForm(),
              icon: const Icon(Icons.add),
              label: const Text('Add Vendor'),
            ),
    );
  }

  Widget _buildEmptyState() => Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: AppConstant.primarycolor.withValues(alpha: .12),
                      borderRadius: BorderRadius.circular(20)),
                  child: Icon(Icons.storefront_outlined,
                      size: 58, color: AppConstant.textHint(context))),
              const SizedBox(height: 18),
              Text('No vendors found',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppConstant.textPrimary(context))),
              const SizedBox(height: 8),
              Text('Try adjusting your search or add a new vendor.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppConstant.textSecondary(context))),
              const SizedBox(height: 22),
              FilledButton.icon(
                  style: FilledButton.styleFrom(
                      backgroundColor: AppConstant.primarycolor,
                      foregroundColor: Colors.black),
                  onPressed: () => _openForm(),
                  icon: const Icon(Icons.add),
                  label: const Text('Add Vendor')),
            ],
          ),
        ),
      );

  Widget _buildVendorList(List<Vendor> vendors) => Card(
        margin: const EdgeInsets.fromLTRB(16, 8, 16, 100),
        color: AppConstant.cardBg(context),
        clipBehavior: Clip.antiAlias,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowColor: const WidgetStatePropertyAll(Color(0xFF22D3EE)),
            columns: const [
              DataColumn(label: Text('Name')),
              DataColumn(label: Text('Code')),
              DataColumn(label: Text('Contact')),
              DataColumn(label: Text('Phone')),
              DataColumn(label: Text('Email')),
              DataColumn(label: Text('Tax Number')),
              DataColumn(label: Text('Status')),
              DataColumn(label: Text('Actions')),
            ],
            rows: vendors
                .map((vendor) => DataRow(cells: [
                      DataCell(Text(vendor.name)),
                      DataCell(Text(vendor.code)),
                      DataCell(Text(vendor.contact)),
                      DataCell(Text(vendor.phone)),
                      DataCell(Text(vendor.email)),
                      DataCell(Text(vendor.taxNumber)),
                      DataCell(Text(vendor.isActive ? 'Active' : 'Inactive')),
                      DataCell(PopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == 'edit') _openForm(vendor: vendor);
                          if (value == 'delete') _deleteVendor(vendor);
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

  Widget _detailRow(IconData icon, String text) => Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Row(children: [
        Icon(icon, size: 18, color: AppConstant.textHint(context)),
        const SizedBox(width: 8),
        Expanded(
            child: Text(text,
                style: TextStyle(color: AppConstant.textPrimary(context))))
      ]));
}

class _VendorForm extends StatefulWidget {
  const _VendorForm({this.vendor});
  final Vendor? vendor;
  @override
  State<_VendorForm> createState() => _VendorFormState();
}

class _VendorFormState extends State<_VendorForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name,
      _code,
      _contact,
      _phone,
      _email,
      _tax,
      _address,
      _notes;
  late bool _isActive;

  @override
  void initState() {
    super.initState();
    final v = widget.vendor;
    _name = TextEditingController(text: v?.name);
    _code = TextEditingController(text: v?.code);
    _contact = TextEditingController(text: v?.contact);
    _phone = TextEditingController(text: v?.phone);
    _email = TextEditingController(text: v?.email);
    _tax = TextEditingController(text: v?.taxNumber);
    _address = TextEditingController(text: v?.address);
    _notes = TextEditingController(text: v?.notes);
    _isActive = v?.isActive ?? true;
  }

  @override
  void dispose() {
    for (final c in [
      _name,
      _code,
      _contact,
      _phone,
      _email,
      _tax,
      _address,
      _notes
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final v = widget.vendor;
    Navigator.pop(
        context,
        Vendor(
            id: v?.id ?? DateTime.now().microsecondsSinceEpoch,
            name: _name.text.trim(),
            code: _code.text.trim(),
            contact: _contact.text.trim(),
            phone: _phone.text.trim(),
            email: _email.text.trim(),
            taxNumber: _tax.text.trim(),
            address: _address.text.trim(),
            notes: _notes.text.trim(),
            isActive: _isActive));
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: AppConstant.cardBg(context),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.85,
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Icon(Icons.storefront_outlined,
                          color: AppConstant.primarycolor, size: 22),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          widget.vendor == null ? 'New Vendor' : 'Edit Vendor',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppConstant.textPrimary(context)),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.close,
                            color: AppConstant.textSecondary(context)),
                        style: IconButton.styleFrom(
                          backgroundColor: AppConstant.inputBg(context),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  _field(_name, 'Vendor Name',
                      required: true, hint: 'e.g. Office Supplies Co.'),
                  _field(_code, 'Vendor Code', hint: 'e.g. VND-001'),
                  _field(_contact, 'Contact Person',
                      hint: 'Primary contact name'),
                  _field(_phone, 'Phone Number',
                      keyboard: TextInputType.phone, hint: '+92 300 0000000'),
                  _field(_email, 'Email',
                      keyboard: TextInputType.emailAddress,
                      email: true,
                      hint: 'vendor@example.com'),
                  _field(_tax, 'Tax / Registration Number',
                      hint: 'NTN / GST / VAT number'),
                  _field(_address, 'Address',
                      maxLines: 3, hint: 'Full business address'),
                  _field(_notes, 'Notes',
                      maxLines: 2, hint: 'Additional notes'),
                  const SizedBox(height: 8),
                  // Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: AppConstant.border(context)),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                        ),
                        child: Text('Cancel',
                            style: TextStyle(
                                color: AppConstant.textSecondary(context),
                                fontWeight: FontWeight.w600)),
                      ),
                      const SizedBox(width: 12),
                      FilledButton(
                        onPressed: _submit,
                        style: FilledButton.styleFrom(
                          backgroundColor: AppConstant.primarycolor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                        ),
                        child: Text(
                            widget.vendor == null
                                ? 'Create Vendor'
                                : 'Save Changes',
                            style:
                                const TextStyle(fontWeight: FontWeight.w600)),
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

  Widget _field(TextEditingController controller, String label,
          {bool required = false,
          TextInputType? keyboard,
          bool email = false,
          int maxLines = 1,
          String? hint}) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(label,
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppConstant.textPrimary(context))),
                if (required)
                  const Text(' *',
                      style: TextStyle(color: Colors.red, fontSize: 13)),
              ],
            ),
            const SizedBox(height: 6),
            TextFormField(
                controller: controller,
                keyboardType: keyboard,
                maxLines: maxLines,
                style: TextStyle(
                    fontSize: 13, color: AppConstant.textPrimary(context)),
                decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: TextStyle(
                        fontSize: 13, color: AppConstant.textHint(context)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            BorderSide(color: AppConstant.border(context))),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            BorderSide(color: AppConstant.border(context))),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                            color: AppConstant.primarycolor, width: 1.5)),
                    filled: true,
                    fillColor: AppConstant.inputBg(context),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10)),
                validator: (value) {
                  if (required && (value == null || value.trim().isEmpty))
                    return '$label is required';
                  if (email &&
                      value != null &&
                      value.trim().isNotEmpty &&
                      !value.contains('@')) return 'Enter a valid email';
                  return null;
                }),
          ],
        ),
      );
}
