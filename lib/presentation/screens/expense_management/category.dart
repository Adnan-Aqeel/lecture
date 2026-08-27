import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lecture/core/constants/app_colors.dart';
import 'package:lecture/core/widgets/shimmer_widgets.dart';

class ExpenseCategory {
  final int id;
  final String name;
  final String description;
  final String status;
  final String created;
  final bool isActive;

  const ExpenseCategory({
    required this.id,
    required this.name,
    required this.description,
    required this.status,
    required this.created,
    this.isActive = true,
  });
}

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  int _currentPage = 1;
  int _itemsPerPage = 10;
  final List<ExpenseCategory> _categories = [];

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
            Text(
              'Expense Categories',
              style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: AppConstant.textPrimary(context)),
            ),
            Text(
              'Manage expense category definitions',
              style: TextStyle(
                  fontSize: 13, color: AppConstant.textPrimary(context)),
            ),
          ],
        ),
      ),
      body: ScreenShimmerWrapper(
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: 12,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: ElevatedButton.icon(
                  onPressed: _showCreateDialog,
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Create Category',
                      style: TextStyle(fontSize: 12)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstant.primarycolor,
                    foregroundColor: Colors.black,
                    elevation: 0,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
                  ),
                ),
              Expanded(child: _buildTableCard()),
              _buildPagination(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTableCard() {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      decoration: BoxDecoration(
        color: AppConstant.cardBg(context),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: _categories.isEmpty ? _buildEmptyState() : _buildDataTable(),
    );
  }

  Widget _buildDataTable() {
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = startIndex + _itemsPerPage;
    final visibleItems = _categories.sublist(
      startIndex,
      endIndex > _categories.length ? _categories.length : endIndex,
    );

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(AppConstant.primarycolor),
          headingTextStyle: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 11,
            color: AppConstant.textPrimary(context),
          ),
          dataRowColor: WidgetStateProperty.all(AppConstant.cardBg(context)),
          dataTextStyle: TextStyle(
              color: AppConstant.textSecondary(context), fontSize: 12),
          horizontalMargin: 16,
          columnSpacing: 24,
          columns: const [
            DataColumn(
                label: Text(
              '#',
            )),
            DataColumn(label: Text('NAME')),
            DataColumn(label: Text('DESCRIPTION')),
            DataColumn(label: Text('STATUS')),
            DataColumn(label: Text('CREATED')),
            DataColumn(label: Text('ACTIONS')),
          ],
          rows: visibleItems.asMap().entries.map((entry) {
            final index = entry.key;
            final category = entry.value;
            final rowNumber = startIndex + index + 1;

            return DataRow(
              cells: [
                DataCell(Text('$rowNumber',
                    style: TextStyle(
                        color: AppConstant.textHint(context), fontSize: 12))),
                DataCell(
                  Text(
                    category.name,
                    style: TextStyle(
                        color: AppConstant.textSecondary(context),
                        fontWeight: FontWeight.w600,
                        fontSize: 12),
                  ),
                ),
                DataCell(
                  SizedBox(
                    width: 180,
                    child: Text(
                      category.description,
                      style: TextStyle(
                          color: AppConstant.textSecondary(context),
                          fontSize: 12),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                DataCell(
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: category.isActive
                          ? const Color(0xFFE3F7EA)
                          : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      category.status.toUpperCase(),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: category.isActive
                            ? const Color(0xFF1E9E5A)
                            : Colors.grey.shade600,
                      ),
                    ),
                  ),
                ),
                DataCell(
                  Text(category.created,
                      style: TextStyle(
                          color: AppConstant.textSecondary(context),
                          fontSize: 11)),
                ),
                DataCell(
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _actionButton(
                          icon: Icons.edit_outlined,
                          color: AppConstant.primarycolor,
                          onTap: () => _editCategory(category)),
                      _actionButton(
                          icon: Icons.pause,
                          color: Colors.orange,
                          onTap: () => _toggleCategory(category)),
                      _actionButton(
                          icon: Icons.delete_outline,
                          color: Colors.red,
                          onTap: () => _deleteCategory(category)),
                    ],
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _actionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 6),
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, size: 14, color: color),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.folder_outlined,
              size: 56, color: AppConstant.textHint(context)),
          const SizedBox(height: 16),
          const Text(
            'No categories found',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A2E)),
          ),
          const SizedBox(height: 8),
          Text(
            'Create your first expense category to get started.',
            style:
                TextStyle(fontSize: 13, color: AppConstant.textHint(context)),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _showCreateDialog,
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Create Category'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstant.primarycolor,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPagination() {
    final totalPages = (_categories.length / _itemsPerPage).ceil();
    if (totalPages == 0) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Show ',
                  style: TextStyle(
                      color: AppConstant.textSecondary(context), fontSize: 12)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: AppConstant.border(context)),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: DropdownButton<int>(
                  value: _itemsPerPage,
                  underline: const SizedBox(),
                  isDense: true,
                  icon: Icon(Icons.arrow_drop_down,
                      color: AppConstant.textSecondary(context), size: 18),
                  items: [10, 25, 50, 100].map((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child:
                          Text('$value', style: const TextStyle(fontSize: 12)),
                    );
                  }).toList(),
                  onChanged: (int? newValue) {
                    setState(() {
                      _itemsPerPage = newValue!;
                      _currentPage = 1;
                    });
                  },
                ),
              ),
              Text(' entries',
                  style: TextStyle(
                      color: AppConstant.textSecondary(context), fontSize: 12)),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _pageButton(Icons.chevron_left, _currentPage > 1,
                  () => setState(() => _currentPage--)),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppConstant.primarycolor,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text('$_currentPage',
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12)),
              ),
              _pageButton(Icons.chevron_right, _currentPage < totalPages,
                  () => setState(() => _currentPage++)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _pageButton(IconData icon, bool enabled, VoidCallback onTap) {
    return InkWell(
      onTap: enabled ? onTap : null,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: enabled
              ? AppConstant.cardBg(context)
              : AppConstant.tableHeaderBg(context),
          border: Border.all(color: AppConstant.border(context)),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(icon,
            size: 16,
            color: enabled
                ? AppConstant.textSecondary(context)
                : AppConstant.textHint(context)),
      ),
    );
  }

  void _showCreateDialog() {
    final nameController = TextEditingController();
    final descController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: AppConstant.cardBg(context),
        title: const Text('Create Expense Category'),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.85,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Category Name',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                maxLines: 2,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel',
                  style: TextStyle(color: AppConstant.textSecondary(context)))),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                setState(() {
                  _categories.add(ExpenseCategory(
                    id: _categories.length + 1,
                    name: nameController.text,
                    description: descController.text,
                    status: 'Active',
                    created: DateTime.now().toString().substring(0, 10),
                  ));
                });
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: AppConstant.primarycolor,
                foregroundColor: Colors.black),
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _editCategory(ExpenseCategory category) {
    final nameController = TextEditingController(text: category.name);
    final descController = TextEditingController(text: category.description);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: AppConstant.cardBg(context),
        title: const Text('Edit Expense Category'),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.85,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Category Name',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel',
                  style: TextStyle(color: AppConstant.textSecondary(context)))),
          ElevatedButton(
            onPressed: () {
              setState(() {
                final index =
                    _categories.indexWhere((c) => c.id == category.id);
                if (index != -1) {
                  _categories[index] = ExpenseCategory(
                    id: category.id,
                    name: nameController.text,
                    description: descController.text,
                    status: category.status,
                    created: category.created,
                    isActive: category.isActive,
                  );
                }
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: AppConstant.primarycolor,
                foregroundColor: Colors.white),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _toggleCategory(ExpenseCategory category) {
    setState(() {
      final index = _categories.indexWhere((c) => c.id == category.id);
      if (index != -1) {
        _categories[index] = ExpenseCategory(
          id: category.id,
          name: category.name,
          description: category.description,
          status: category.isActive ? 'Inactive' : 'Active',
          created: category.created,
          isActive: !category.isActive,
        );
      }
    });
  }

  void _deleteCategory(ExpenseCategory category) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: AppConstant.cardBg(context),
        title: const Text('Delete Category'),
        content: Text('Are you sure you want to delete "${category.name}"?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel',
                  style: TextStyle(color: AppConstant.textSecondary(context)))),
          ElevatedButton(
            onPressed: () {
              setState(
                  () => _categories.removeWhere((c) => c.id == category.id));
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, foregroundColor: Colors.white),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
