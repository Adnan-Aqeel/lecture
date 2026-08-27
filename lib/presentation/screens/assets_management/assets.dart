import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lecture/core/constants/app_colors.dart';
import 'package:lecture/core/widgets/shimmer_widgets.dart';

class AssetsScreen extends StatefulWidget {
  const AssetsScreen({super.key});

  @override
  State<AssetsScreen> createState() => _AssetsScreenState();
}

class _AssetsScreenState extends State<AssetsScreen> {
  final _assets = <_Asset>[
    _Asset(
      name: 'HP THINKPAD 5320',
      serialNumber: 'ph -1',
      category: 'laptop',
      status: true,
      totalValue: 250000,
    ),
  ];

  String _query = '';

  List<_Asset> get _filteredAssets {
    if (_query.trim().isEmpty) return _assets;
    final q = _query.trim().toLowerCase();
    return _assets.where((asset) {
      return asset.name.toLowerCase().contains(q) ||
          asset.serialNumber.toLowerCase().contains(q) ||
          asset.category.toLowerCase().contains(q);
    }).toList();
  }

  Future<void> _openForm({_Asset? asset}) async {
    final result = await showModalBottomSheet<_Asset>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AssetForm(asset: asset, existingAssets: _assets),
    );

    if (!mounted || result == null) return;

    setState(() {
      if (asset == null) {
        _assets.add(result);
      } else {
        final index = _assets.indexOf(asset);
        if (index != -1) {
          _assets[index] = result;
        }
      }
    });
  }

  Future<void> _delete(_Asset asset) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete asset?'),
        content: Text('This asset "${asset.name}" will be removed locally.'),
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
      setState(() => _assets.remove(asset));
    }
  }

  @override
  Widget build(BuildContext context) {
    final assets = _filteredAssets;

    return Scaffold(
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
          Text('Asset List',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppConstant.textPrimary(context))),
          Text('Manage and track all company assets',
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
                        'Add Asset',
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
            _SearchField(
              query: _query,
              onChanged: (value) => setState(() => _query = value),
            ),
            const SizedBox(height: 16),
            if (assets.isEmpty)
              const _EmptyState()
            else
              _buildAssetsTable(assets),
            const SizedBox(height: 4),
            _Footer(total: _assets.length),
          ],
        ),
      ),
    );
  }

  Widget _buildAssetsTable(List<_Asset> assets) => Card(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        color: AppConstant.cardBg(context),
        clipBehavior: Clip.antiAlias,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowColor: const WidgetStatePropertyAll(Color(0xFF22D3EE)),
            columns: const [
              DataColumn(label: Text('Name')),
              DataColumn(label: Text('Serial Number')),
              DataColumn(label: Text('Category')),
              DataColumn(label: Text('Total Value')),
              DataColumn(label: Text('Status')),
              DataColumn(label: Text('Actions')),
            ],
            rows: assets
                .map((asset) => DataRow(cells: [
                      DataCell(Text(asset.name)),
                      DataCell(Text(asset.serialNumber)),
                      DataCell(Text(asset.category)),
                      DataCell(
                          Text('Rs ${asset.totalValue.toStringAsFixed(0)}')),
                      DataCell(Text(asset.status ? 'Active' : 'Inactive')),
                      DataCell(Row(mainAxisSize: MainAxisSize.min, children: [
                        IconButton(
                            onPressed: () => _openForm(asset: asset),
                            icon: const Icon(Icons.edit_outlined,
                                color: Color(0xFF0D8ED0))),
                        IconButton(
                            onPressed: () => _delete(asset),
                            icon: const Icon(Icons.delete_outline,
                                color: Colors.red)),
                      ])),
                    ]))
                .toList(),
          ),
        ),
      );
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
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: TextEditingController(text: query),
            onChanged: onChanged,
            decoration: InputDecoration(
              hintText: 'Search by asset name...',
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
          ),
        ),
      ],
    );
  }
}

class _AssetCard extends StatelessWidget {
  const _AssetCard({
    required this.index,
    required this.asset,
    required this.onEdit,
    required this.onDelete,
  });

  final int index;
  final _Asset asset;
  final VoidCallback onEdit;
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
                      asset.name,
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
              _detail('Serial Number', asset.serialNumber),
              _detail('Category', asset.category),
              _detail(
                  'Total Value', 'Rs ${asset.totalValue.toStringAsFixed(0)}'),
              _detail('Status', asset.status ? 'Active' : 'Inactive'),
              const SizedBox(height: 8),
              _statusChip(context, asset.status),
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

  Widget _statusChip(BuildContext context, bool active) => Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
          decoration: BoxDecoration(
            color: active ? const Color(0xFFE1F5EC) : const Color(0xFFECEFF2),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text(
            active ? 'Active' : 'Inactive',
            style: TextStyle(
              color: active
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
  final VoidCallback onPressed;
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
          'No assets yet. Tap Add Asset to create one.',
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
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF94A3B8),
            ),
          ),
          Text(
            'Current page: 1 - Records: ${total == 0 ? 0 : 1} of $total',
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF94A3B8),
            ),
            // overflow: TextOverflow.ellipsis,
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

class _AssetForm extends StatefulWidget {
  const _AssetForm({
    this.asset,
    required this.existingAssets,
  });

  final _Asset? asset;
  final List<_Asset> existingAssets;

  @override
  State<_AssetForm> createState() => _AssetFormState();
}

class _AssetFormState extends State<_AssetForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _serialNumber;
  late final TextEditingController _totalValue;
  String _category = 'laptop';
  bool _status = true;

  @override
  void initState() {
    super.initState();
    final item = widget.asset;
    _name = TextEditingController(text: item?.name);
    _serialNumber = TextEditingController(text: item?.serialNumber);
    _totalValue = TextEditingController(
      text: item?.totalValue.toStringAsFixed(0),
    );
    _category = item?.category ?? _category;
    _status = item?.status ?? true;
  }

  @override
  void dispose() {
    _name.dispose();
    _serialNumber.dispose();
    _totalValue.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.pop(
      context,
      _Asset(
        name: _name.text.trim(),
        serialNumber: _serialNumber.text.trim(),
        category: _category,
        status: _status,
        totalValue: double.parse(_totalValue.text.trim()),
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
                    widget.asset == null ? 'Add Asset' : 'Edit Asset',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 18),
                  _field(_name, 'Asset Name'),
                  _field(_serialNumber, 'Serial Number'),
                  _field(
                    _totalValue,
                    'Total Value',
                    keyboard: TextInputType.number,
                    inputFormatter: [FilteringTextInputFormatter.digitsOnly],
                  ),
                  DropdownButtonFormField<String>(
                    value: _category,
                    decoration: const InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(),
                    ),
                    items: const ['laptop', 'desktop', 'printer', 'other']
                        .map((value) =>
                            DropdownMenuItem(value: value, child: Text(value)))
                        .toList(),
                    onChanged: (value) => setState(() => _category = value!),
                  ),
                  const SizedBox(height: 14),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Active'),
                    value: _status,
                    onChanged: (value) => setState(() => _status = value),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _submit,
                      style: FilledButton.styleFrom(
                        backgroundColor: AppConstant.primarycolor,
                        foregroundColor: Colors.black,
                      ),
                      child: const Text('Save Asset'),
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
    List<TextInputFormatter>? inputFormatter,
  }) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: TextFormField(
          controller: controller,
          keyboardType: keyboard,
          inputFormatters: inputFormatter,
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return '$label is required';
            }
            if (label == 'Total Value' &&
                double.tryParse(value.trim()) == null) {
              return 'Enter a valid number';
            }
            return null;
          },
        ),
      );
}

class _Asset {
  _Asset({
    required this.name,
    required this.serialNumber,
    required this.category,
    required this.status,
    required this.totalValue,
  });

  final String name;
  final String serialNumber;
  final String category;
  final bool status;
  final double totalValue;
}
