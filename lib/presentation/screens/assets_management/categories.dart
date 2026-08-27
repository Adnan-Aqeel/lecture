import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lecture/core/constants/app_colors.dart';
import 'package:lecture/core/widgets/shimmer_widgets.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final _categories = <String>['laptop'];

  Future<void> _openForm({String? category}) async {
    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _CategoryForm(category: category),
    );

    if (!mounted || result == null) return;

    setState(() {
      if (category == null) {
        _categories.add(result);
      } else {
        _categories[_categories.indexOf(category)] = result;
      }
    });
  }

  Future<void> _delete(String category) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete category?'),
        content: Text('This category "$category" will be removed locally.'),
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
      setState(() => _categories.remove(category));
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
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
                Text('Categories',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppConstant.textPrimary(context))),
                Text('Manage asset and expense categories',
                    style: TextStyle(fontSize: 13, color: AppConstant.textPrimary(context)))
              ]),
        ),
        body: ScreenShimmerWrapper(
          child: Column(
            children: [
              SizedBox(
                height: 15,
              ),
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
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () => _openForm(),
                        icon: const Icon(Icons.add_rounded, size: 18),
                        label: const Text(
                          'Add New Category',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (_categories.isEmpty)
                const _EmptyState()
              else
                _buildCategoriesTable(),
              const SizedBox(height: 4),
              _Footer(total: _categories.length),
            ],
          ),
        ),
      );

  Widget _buildCategoriesTable() => Card(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        color: AppConstant.cardBg(context),
        clipBehavior: Clip.antiAlias,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowColor: const WidgetStatePropertyAll(Color(0xFF22D3EE)),
            columns: const [
              DataColumn(label: Text('No.')),
              DataColumn(label: Text('Category Name')),
              DataColumn(label: Text('Actions')),
            ],
            rows: _categories.asMap().entries.map((entry) => DataRow(cells: [
              DataCell(Text('${entry.key + 1}')),
              DataCell(Text(entry.value)),
              DataCell(Row(mainAxisSize: MainAxisSize.min, children: [
                IconButton(onPressed: () => _openForm(category: entry.value), icon: const Icon(Icons.edit_outlined, color: Color(0xFF0D8ED0))),
                IconButton(onPressed: () => _delete(entry.value), icon: const Icon(Icons.delete_outline, color: Colors.red)),
              ])),
            ])).toList(),
          ),
        ),
      );
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({
    required this.index,
    required this.name,
    required this.onEdit,
    required this.onDelete,
  });

  final int index;
  final String name;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      color: AppConstant.cardBg(context),
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.sell_outlined, color: Color(0xFF0DB9D8)),
                const SizedBox(width: 9),
                Expanded(
                  child: Text(
                    name,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _actionButton(Icons.edit_outlined, onEdit),
                _actionButton(Icons.delete_outline, onDelete,
                    color: Colors.red),
              ],
            ),
            const Divider(height: 24),
            _detail('Category No.', '${index + 1}'),
            _detail('Category Name', name),
            const SizedBox(height: 8),
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

  Widget _actionButton(
    IconData icon,
    VoidCallback onPressed, {
    Color color = const Color(0xFF0D8ED0),
  }) =>
      IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: color),
        visualDensity: VisualDensity.compact,
      );
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      color: AppConstant.cardBg(context),
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          'No categories yet. Tap the add button to create one.',
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

  Widget _pageButton(BuildContext context, IconData icon, bool active) => Container(
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

class _CategoryForm extends StatefulWidget {
  const _CategoryForm({this.category});

  final String? category;

  @override
  State<_CategoryForm> createState() => _CategoryFormState();
}

class _CategoryFormState extends State<_CategoryForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.category ?? '');
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.pop(context, _name.text.trim());
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
                    widget.category == null ? 'Add Category' : 'Edit Category',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 18),
                  TextFormField(
                    controller: _name,
                    autofocus: true,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      labelText: 'Category Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Category name is required';
                      }
                      return null;
                    },
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
                      child: const Text('Save Category'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
