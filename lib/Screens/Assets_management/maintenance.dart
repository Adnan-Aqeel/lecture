import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lecture/appcolor.dart';
import 'package:lecture/widgets/shimmer_widgets.dart';

class MaintenanceScreen extends StatefulWidget {
  const MaintenanceScreen({super.key});

  @override
  State<MaintenanceScreen> createState() => _MaintenanceScreenState();
}

class _MaintenanceScreenState extends State<MaintenanceScreen> {
  final List<_MaintenanceRecord> _records = [];

  Future<void> _openForm({_MaintenanceRecord? record}) async {
    final result = await showModalBottomSheet<_MaintenanceRecord>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _MaintenanceForm(record: record),
    );

    if (!mounted || result == null) return;

    setState(() {
      if (record == null) {
        _records.add(result);
      } else {
        final index = _records.indexOf(record);
        if (index != -1) _records[index] = result;
      }
    });
  }

  Future<void> _delete(_MaintenanceRecord record) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete record?'),
        content: Text(
          'This maintenance record for "${record.asset}" will be removed locally.',
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
      setState(() => _records.remove(record));
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
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Maintenance Records',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppConstant.textPrimary(context))),
          Text('Track asset maintenance and service history',
              style: TextStyle(
                  fontSize: 13, color: AppConstant.textPrimary(context)))
        ]),
      ),
      body: ScreenShimmerWrapper(
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
                        'Add Record',
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
            if (_records.isEmpty)
              const _EmptyState()
            else
              _buildMaintenanceTable(),
            const SizedBox(height: 4),
            _Footer(total: _records.length),
          ],
        ),
      ),
    );
  }

  Widget _buildMaintenanceTable() => Card(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        color: AppConstant.cardBg(context),
        clipBehavior: Clip.antiAlias,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowColor: const WidgetStatePropertyAll(Color(0xFF22D3EE)),
            columns: const [
              DataColumn(label: Text('Asset')),
              DataColumn(label: Text('Description')),
              DataColumn(label: Text('Date')),
              DataColumn(label: Text('Cost')),
              DataColumn(label: Text('Status')),
              DataColumn(label: Text('Actions')),
            ],
            rows: _records
                .map((record) => DataRow(cells: [
                      DataCell(Text(record.asset)),
                      DataCell(Text(record.description)),
                      DataCell(Text(_formatDate(record.date))),
                      DataCell(Text('Rs ${record.cost.toStringAsFixed(0)}')),
                      DataCell(Text(
                          record.description.isEmpty ? 'Pending' : 'Recorded')),
                      DataCell(Row(mainAxisSize: MainAxisSize.min, children: [
                        IconButton(
                            onPressed: () => _openForm(record: record),
                            icon: const Icon(Icons.edit_outlined,
                                color: Color(0xFF0D8ED0))),
                        IconButton(
                            onPressed: () => _delete(record),
                            icon: const Icon(Icons.delete_outline,
                                color: Colors.red)),
                      ])),
                    ]))
                .toList(),
          ),
        ),
      );
}

class _MaintenanceCard extends StatelessWidget {
  const _MaintenanceCard({
    required this.index,
    required this.record,
    required this.onEdit,
    required this.onDelete,
  });

  final int index;
  final _MaintenanceRecord record;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
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
                const Icon(Icons.handyman_outlined, color: Color(0xFF0DB9D8)),
                const SizedBox(width: 9),
                Expanded(
                  child: Text(
                    record.asset,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _ActionButton(icon: Icons.edit_outlined, onPressed: onEdit),
                _ActionButton(
                  icon: Icons.delete_outline,
                  onPressed: onDelete,
                  color: Colors.red,
                ),
              ],
            ),
            const Divider(height: 24),
            _detail('Description', record.description),
            _detail('Date', _formatDate(record.date)),
            _detail('Cost', 'Rs ${record.cost.toStringAsFixed(0)}'),
            const SizedBox(height: 8),
            _statusChip(context, record.description.isEmpty ? false : true),
          ],
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

  Widget _statusChip(BuildContext context, bool ok) => Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
          decoration: BoxDecoration(
            color: ok ? const Color(0xFFE1F5EC) : const Color(0xFFECEFF2),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text(
            ok ? 'Recorded' : 'Pending',
            style: TextStyle(
              color: ok
                  ? Colors.green.shade700
                  : AppConstant.textSecondary(context),
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
        child: Column(
          children: [
            Icon(Icons.handyman_outlined, size: 42, color: Color(0xFF94A3B8)),
            SizedBox(height: 10),
            Text(
              'No maintenance records found',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0F172A),
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Add a maintenance record to get started.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFF657C94),
              ),
            ),
          ],
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

class _MaintenanceForm extends StatefulWidget {
  const _MaintenanceForm({this.record});

  final _MaintenanceRecord? record;

  @override
  State<_MaintenanceForm> createState() => _MaintenanceFormState();
}

class _MaintenanceFormState extends State<_MaintenanceForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _asset;
  late final TextEditingController _description;
  late final TextEditingController _date;
  late final TextEditingController _cost;

  @override
  void initState() {
    super.initState();
    final item = widget.record;
    _asset = TextEditingController(text: item?.asset);
    _description = TextEditingController(text: item?.description);
    _date = TextEditingController(
      text: item == null ? '' : _formatDate(item.date),
    );
    _cost = TextEditingController(
      text: item?.cost.toStringAsFixed(0),
    );
  }

  @override
  void dispose() {
    _asset.dispose();
    _description.dispose();
    _date.dispose();
    _cost.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.pop(
      context,
      _MaintenanceRecord(
        asset: _asset.text.trim(),
        description: _description.text.trim(),
        date: _parseDate(_date.text.trim()) ?? DateTime.now(),
        cost: double.parse(_cost.text.trim()),
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
                    widget.record == null ? 'Add Record' : 'Edit Record',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 18),
                  _field(_asset, 'Asset'),
                  _field(_description, 'Description'),
                  _field(_date, 'Date (yyyy-mm-dd)'),
                  _field(
                    _cost,
                    'Cost',
                    keyboard: TextInputType.number,
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
                      child: const Text('Save Record'),
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
    TextInputType? keyboard,
  }) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: TextFormField(
          controller: controller,
          keyboardType: keyboard,
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return '$label is required';
            }
            if (label == 'Cost' && double.tryParse(value.trim()) == null) {
              return 'Enter a valid number';
            }
            return null;
          },
        ),
      );
}

class _MaintenanceRecord {
  _MaintenanceRecord({
    required this.asset,
    required this.description,
    required this.date,
    required this.cost,
  });

  final String asset;
  final String description;
  final DateTime date;
  final double cost;
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
