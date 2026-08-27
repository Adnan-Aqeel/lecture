import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lecture/core/constants/app_colors.dart';
import 'package:lecture/core/widgets/shimmer_widgets.dart';

class AssignScreen extends StatefulWidget {
  const AssignScreen({super.key});

  @override
  State<AssignScreen> createState() => _AssignScreenState();
}

class _AssignScreenState extends State<AssignScreen> {
  final List<_Assignment> _assignments = [
    _Assignment(
      assetName: 'HP THINKPAD 5320',
      assignedTo: 'zain',
      assignedDate: DateTime(2026, 5, 20),
      returnDate: null,
      category: 'laptop',
      status: 'Active',
    ),
  ];

  String _query = '';
  String _selectedCategory = 'All';
  String _selectedStatus = 'All';

  List<_Assignment> get _filteredAssignments {
    return _assignments.where((assignment) {
      final matchesQuery = _query.trim().isEmpty ||
          assignment.assetName
              .toLowerCase()
              .contains(_query.trim().toLowerCase()) ||
          assignment.assignedTo
              .toLowerCase()
              .contains(_query.trim().toLowerCase());
      final matchesCategory = _selectedCategory == 'All' ||
          assignment.category == _selectedCategory;
      final matchesStatus =
          _selectedStatus == 'All' || assignment.status == _selectedStatus;
      return matchesQuery && matchesCategory && matchesStatus;
    }).toList();
  }

  Future<void> _openForm({_Assignment? assignment}) async {
    final result = await showModalBottomSheet<_Assignment>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AssignmentForm(assignment: assignment),
    );

    if (!mounted || result == null) return;

    setState(() {
      if (assignment == null) {
        _assignments.add(result);
      } else {
        final index = _assignments.indexOf(assignment);
        if (index != -1) _assignments[index] = result;
      }
    });
  }

  Future<void> _delete(_Assignment assignment) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete assignment?'),
        content: Text(
          'This assignment for "${assignment.assetName}" will be removed locally.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      setState(() => _assignments.remove(assignment));
    }
  }

  Future<void> _markReturned(_Assignment assignment) async {
    final returned = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Mark as returned?'),
        content: const Text(
          'This will set the return date to today and update status locally.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Return'),
          ),
        ],
      ),
    );

    if (returned != true || !mounted) return;

    setState(() {
      assignment.returnDate = DateTime.now();
      assignment.status = 'Returned';
    });
  }

  @override
  Widget build(BuildContext context) {
    final assignments = _filteredAssignments;

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
          Text('Asset Assignments',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppConstant.textPrimary(context))),
          Text('Manage asset assignments to employees',
              style: TextStyle(
                  fontSize: 13, color: AppConstant.textPrimary(context)))
        ]),
      ),
      body: ScreenShimmerWrapper(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 42,
                      child: FilledButton.icon(
                        style: FilledButton.styleFrom(
                          backgroundColor: AppConstant.primarycolor,
                          foregroundColor: Colors.black87,
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () => _openForm(),
                        icon: const Icon(Icons.add_rounded, size: 18),
                        label: const Text(
                          'Add Assignment',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _FilterSearchRow(
                query: _query,
                selectedCategory: _selectedCategory,
                selectedStatus: _selectedStatus,
                onQueryChanged: (value) => setState(() => _query = value),
                onCategoryChanged: (value) =>
                    setState(() => _selectedCategory = value),
                onStatusChanged: (value) =>
                    setState(() => _selectedStatus = value),
              ),
              const SizedBox(height: 16),
              if (assignments.isEmpty)
                const _EmptyState()
              else
                _buildAssignmentsTable(assignments),
              const SizedBox(height: 4),
              _Footer(total: _assignments.length),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAssignmentsTable(List<_Assignment> assignments) => Card(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        color: AppConstant.cardBg(context),
        clipBehavior: Clip.antiAlias,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowColor: const WidgetStatePropertyAll(Color(0xFF22D3EE)),
            columns: const [
              DataColumn(label: Text('Asset')),
              DataColumn(label: Text('Assigned To')),
              DataColumn(label: Text('Assigned Date')),
              DataColumn(label: Text('Return Date')),
              DataColumn(label: Text('Category')),
              DataColumn(label: Text('Status')),
              DataColumn(label: Text('Actions')),
            ],
            rows: assignments.map((item) => DataRow(cells: [
              DataCell(Text(item.assetName)),
              DataCell(Text(item.assignedTo)),
              DataCell(Text(_formatDate(item.assignedDate))),
              DataCell(Text(item.returnDate == null ? 'Not Returned' : _formatDate(item.returnDate!))),
              DataCell(Text(item.category)),
              DataCell(Text(item.status)),
              DataCell(Row(mainAxisSize: MainAxisSize.min, children: [
                IconButton(onPressed: () => _openForm(assignment: item), icon: const Icon(Icons.edit_outlined, color: Color(0xFF0D8ED0))),
                IconButton(onPressed: item.returnDate == null ? () => _markReturned(item) : null, icon: const Icon(Icons.keyboard_return_rounded, color: Colors.blueGrey)),
                IconButton(onPressed: () => _delete(item), icon: const Icon(Icons.delete_outline, color: Colors.red)),
              ])),
            ])).toList(),
          ),
        ),
      );
}

class _FilterSearchRow extends StatelessWidget {
  const _FilterSearchRow({
    required this.query,
    required this.selectedCategory,
    required this.selectedStatus,
    required this.onQueryChanged,
    required this.onCategoryChanged,
    required this.onStatusChanged,
  });

  final String query;
  final String selectedCategory;
  final String selectedStatus;
  final ValueChanged<String> onQueryChanged;
  final ValueChanged<String> onCategoryChanged;
  final ValueChanged<String> onStatusChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12),
          child: const Text(
            'Search',
            style: TextStyle(
              color: Color(0xFF94A3B8),
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: 10),
        LayoutBuilder(
          builder: (context, constraints) {
            final narrow = constraints.maxWidth < 720;
            return Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: narrow
                        ? constraints.maxWidth
                        : constraints.maxWidth * 0.52,
                    child:
                        _SearchField(query: query, onChanged: onQueryChanged),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: narrow
                        ? constraints.maxWidth
                        : constraints.maxWidth * 0.22,
                    child: _FilterDropdown(
                      label: 'Category',
                      value: selectedCategory,
                      items: const [
                        'All',
                        'laptop',
                        'desktop',
                        'printer',
                        'other'
                      ],
                      onChanged: onCategoryChanged,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: narrow
                        ? constraints.maxWidth
                        : constraints.maxWidth * 0.22,
                    child: _FilterDropdown(
                      label: 'Status',
                      value: selectedStatus,
                      items: const ['All', 'Active', 'Returned', 'Inactive'],
                      onChanged: onStatusChanged,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({
    required this.query,
    required this.onChanged,
  });

  final String query;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: TextEditingController(text: query),
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: 'Search by asset or employee...',
        prefixIcon: const Icon(Icons.search_rounded),
        filled: true,
        fillColor: AppConstant.cardBg(context),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFD6E1EA)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFD6E1EA)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppConstant.primarycolor),
        ),
      ),
    );
  }
}

class _FilterDropdown extends StatelessWidget {
  const _FilterDropdown({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final String label;
  final String value;
  final List<String> items;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF94A3B8),
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),
        DropdownButtonFormField<String>(
          value: value,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppConstant.cardBg(context),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFD6E1EA)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFD6E1EA)),
            ),
          ),
          items: items
              .map(
                (item) => DropdownMenuItem(value: item, child: Text(item)),
              )
              .toList(),
          onChanged: (value) {
            if (value != null) onChanged(value);
          },
        ),
      ],
    );
  }
}

class _AssignmentCard extends StatelessWidget {
  const _AssignmentCard({
    required this.index,
    required this.assignment,
    required this.onEdit,
    required this.onReturn,
    required this.onDelete,
  });

  final int index;
  final _Assignment assignment;
  final VoidCallback onEdit;
  final VoidCallback? onReturn;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 1,
        color: AppConstant.cardBg(context),
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.inventory_2_outlined,
                      color: Color(0xFF0DB9D8)),
                  const SizedBox(width: 9),
                  Expanded(
                    child: Text(
                      assignment.assetName,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  _ActionButton(icon: Icons.edit_outlined, onPressed: onEdit),
                  const SizedBox(width: 6),
                  _ActionButton(
                    icon: Icons.keyboard_return_rounded,
                    onPressed: onReturn,
                    color: Colors.blueGrey,
                  ),
                  const SizedBox(width: 6),
                  _ActionButton(
                    icon: Icons.delete_outline,
                    onPressed: onDelete,
                    color: Colors.red,
                  ),
                ],
              ),
              const Divider(height: 24),
              _detail('Assigned To', assignment.assignedTo),
              _detail('Assigned Date', _formatDate(assignment.assignedDate)),
              _detail(
                'Return Date',
                assignment.returnDate == null
                    ? 'Not Returned'
                    : _formatDate(assignment.returnDate!),
              ),
              _detail('Category', assignment.category),
              const SizedBox(height: 8),
              _statusChip(context, assignment.status),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detail(String label, String value) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF657C94),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF1E3851),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );

  Widget _statusChip(BuildContext context, String status) => Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
          decoration: BoxDecoration(
            color: status == 'Returned'
                ? const Color(0xFFECEFF2)
                : const Color(0xFFE1F5EC),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text(
            status,
            style: TextStyle(
              color: status == 'Returned'
                  ? AppConstant.textSecondary(context)
                  : Colors.green.shade700,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.onPressed,
    this.color = const Color(0xFF0D8ED0),
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon, color: color),
      visualDensity: VisualDensity.compact,
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      color: AppConstant.cardBg(context),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          'No assignments yet. Tap Add Assignment to create one.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF657C94),
          ),
        ),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({required this.total});

  final int total;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          const Text(
            'Show 10 entries',
            style: TextStyle(fontSize: 13, color: Color(0xFF40536B)),
          ),
          Text(
            'Current page: 1 - Records: ${total == 0 ? 0 : 1} of $total',
            style: const TextStyle(fontSize: 13, color: Color(0xFF40536B)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(width: 8),
              _pageButton(context, Icons.first_page, false),
              const SizedBox(width: 6),
              _pageButton(context, Icons.chevron_left, false),
              const SizedBox(width: 6),
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppConstant.primarycolor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  '1',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              _pageButton(context, Icons.chevron_right, false),
              const SizedBox(width: 6),
              _pageButton(context, Icons.last_page, false),
            ],
          )
        ],
      );

  Widget _pageButton(BuildContext context, IconData icon, bool active) =>
      Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppConstant.cardBg(context),
          border: Border.all(color: const Color(0xFFE5EDF4)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          size: 18,
          color: active ? const Color(0xFF40536B) : const Color(0xFFC2CBD6),
        ),
      );
}

class _AssignmentForm extends StatefulWidget {
  const _AssignmentForm({this.assignment});

  final _Assignment? assignment;

  @override
  State<_AssignmentForm> createState() => _AssignmentFormState();
}

class _AssignmentFormState extends State<_AssignmentForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _assetName;
  late final TextEditingController _assignedTo;
  late final TextEditingController _date;
  late final TextEditingController _returnDate;
  String _category = 'laptop';
  String _status = 'Active';

  @override
  void initState() {
    super.initState();
    final item = widget.assignment;
    _assetName = TextEditingController(text: item?.assetName);
    _assignedTo = TextEditingController(text: item?.assignedTo);
    _date = TextEditingController(
        text: item == null ? '' : _formatDate(item.assignedDate));
    _returnDate = TextEditingController(
      text: item?.returnDate == null ? '' : _formatDate(item!.returnDate!),
    );
    _category = item?.category ?? _category;
    _status = item?.status ?? _status;
  }

  @override
  void dispose() {
    _assetName.dispose();
    _assignedTo.dispose();
    _date.dispose();
    _returnDate.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    Navigator.pop(
      context,
      _Assignment(
        assetName: _assetName.text.trim(),
        assignedTo: _assignedTo.text.trim(),
        assignedDate: _parseDate(_date.text.trim()) ?? DateTime.now(),
        returnDate: _returnDate.text.trim().isEmpty
            ? null
            : _parseDate(_returnDate.text.trim()),
        category: _category,
        status: _status,
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          20,
          20,
          MediaQuery.viewInsetsOf(context).bottom + 20,
        ),
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
                    widget.assignment == null
                        ? 'Add Assignment'
                        : 'Edit Assignment',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 18),
                  _field(_assetName, 'Asset Name'),
                  _field(_assignedTo, 'Assigned To'),
                  _field(
                    _date,
                    'Assigned Date (yyyy-mm-dd)',
                  ),
                  _field(
                    _returnDate,
                    'Return Date (yyyy-mm-dd)',
                    required: false,
                  ),
                  DropdownButtonFormField<String>(
                    value: _category,
                    decoration: const InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(),
                    ),
                    items: const ['laptop', 'desktop', 'printer', 'other']
                        .map(
                          (value) => DropdownMenuItem(
                              value: value, child: Text(value)),
                        )
                        .toList(),
                    onChanged: (value) => setState(() => _category = value!),
                  ),
                  const SizedBox(height: 14),
                  DropdownButtonFormField<String>(
                    value: _status,
                    decoration: const InputDecoration(
                      labelText: 'Status',
                      border: OutlineInputBorder(),
                    ),
                    items: const ['Active', 'Returned', 'Inactive']
                        .map(
                          (value) => DropdownMenuItem(
                              value: value, child: Text(value)),
                        )
                        .toList(),
                    onChanged: (value) => setState(() => _status = value!),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _submit,
                      style: FilledButton.styleFrom(
                        backgroundColor: AppConstant.primarycolor,
                        foregroundColor: Colors.black,
                      ),
                      child: const Text('Save Assignment'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  Widget _field(
    TextEditingController controller,
    String label, {
    bool required = true,
  }) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
          ),
          validator: (value) {
            if (required && (value == null || value.trim().isEmpty)) {
              return '$label is required';
            }
            return null;
          },
        ),
      );
}

class _Assignment {
  _Assignment({
    required this.assetName,
    required this.assignedTo,
    required this.assignedDate,
    required this.returnDate,
    required this.category,
    required this.status,
  });

  final String assetName;
  final String assignedTo;
  final DateTime assignedDate;
  DateTime? returnDate;
  final String category;
  String status;
}

String _formatDate(DateTime date) {
  return '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';
}

DateTime? _parseDate(String input) {
  try {
    final parts = input.split('-');
    if (parts.length != 3) return null;
    return DateTime(
      int.parse(parts[0]),
      int.parse(parts[1]),
      int.parse(parts[2]),
    );
  } catch (_) {
    return null;
  }
}
