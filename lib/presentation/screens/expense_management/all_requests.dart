import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lecture/core/constants/app_colors.dart';
import 'package:lecture/core/widgets/shimmer_widgets.dart';

class ExpenseRequest {
  final int id;
  final String title;
  final double amount;
  final String status;
  final String priority;
  final String category;
  final String date;

  const ExpenseRequest({
    required this.id,
    required this.title,
    required this.amount,
    required this.status,
    required this.priority,
    required this.category,
    required this.date,
  });
}

class AllRequestsScreen extends StatefulWidget {
  const AllRequestsScreen({super.key});

  @override
  State<AllRequestsScreen> createState() => _AllRequestsScreenState();
}

class _AllRequestsScreenState extends State<AllRequestsScreen> {
  int _currentPage = 1;
  int _itemsPerPage = 10;
  String _searchQuery = '';
  String _statusFilter = 'All Status';
  String _priorityFilter = 'All Priorities';
  final List<ExpenseRequest> _requests = [];
  final _searchController = TextEditingController();

  final List<String> _statuses = [
    'All Status',
    'Pending',
    'Approved',
    'Rejected',
    'Draft'
  ];
  final List<String> _priorities = [
    'All Priorities',
    'Low',
    'Medium',
    'High',
    'Urgent'
  ];

  List<ExpenseRequest> get _filteredRequests {
    return _requests.where((r) {
      final matchesSearch = _searchQuery.isEmpty ||
          r.title.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesStatus =
          _statusFilter == 'All Status' || r.status == _statusFilter;
      final matchesPriority =
          _priorityFilter == 'All Priorities' || r.priority == _priorityFilter;
      return matchesSearch && matchesStatus && matchesPriority;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showCreateRequestDialog() {
    final titleController = TextEditingController();
    final amountController = TextEditingController();
    final descriptionController = TextEditingController();
    String priority = 'Medium';
    String? category;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: AppConstant.cardBg(context),
        title: Row(
          children: [
            Icon(Icons.add_circle_outline,
                color: AppConstant.primarycolor, size: 22),
            const SizedBox(width: 8),
            const Text('Create Expense Request',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.85,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: 'Title *',
                    hintText: 'Enter expense title',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: amountController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))
                  ],
                  decoration: InputDecoration(
                    labelText: 'Amount *',
                    hintText: '0.00',
                    prefixText: 'PKR ',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descriptionController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Description *',
                    hintText: 'Describe the expense',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: priority,
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: 'Priority',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12),
                  ),
                  items: ['Low', 'Medium', 'High', 'Urgent'].map((String p) {
                    return DropdownMenuItem<String>(value: p, child: Text(p));
                  }).toList(),
                  onChanged: (val) => priority = val!,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: category,
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: 'Category *',
                    hintText: 'Select category',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12),
                  ),
                  items: [
                    'Travel',
                    'Food',
                    'Office Supplies',
                    'Utilities',
                    'Other'
                  ].map((String c) {
                    return DropdownMenuItem<String>(value: c, child: Text(c));
                  }).toList(),
                  onChanged: (val) => category = val,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel',
                style: TextStyle(color: AppConstant.textSecondary(context))),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isNotEmpty &&
                  amountController.text.isNotEmpty &&
                  category != null) {
                setState(() {
                  _requests.add(ExpenseRequest(
                    id: _requests.length + 1,
                    title: titleController.text,
                    amount: double.tryParse(amountController.text) ?? 0,
                    status: 'Pending',
                    priority: priority,
                    category: category!,
                    date: DateTime.now().toString().substring(0, 10),
                  ));
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content:
                        const Text('Expense request created successfully!'),
                    backgroundColor: Colors.green.shade600,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstant.primarycolor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showRequestDetails(ExpenseRequest request) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(request.title),
        content: Text(
          'Amount: Rs ${request.amount.toStringAsFixed(0)}\n'
          'Status: ${request.status}\n'
          'Priority: ${request.priority}\n'
          'Category: ${request.category}\n'
          'Date: ${request.date}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteRequest(ExpenseRequest request) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete expense request?'),
        content: Text('Delete "${request.title}"?'),
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
      setState(() => _requests.remove(request));
    }
  }

  void _editRequest(ExpenseRequest request) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Edit selected for ${request.title}')),
    );
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
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Expense Requests',
                    style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        color: AppConstant.textPrimary(context)),
                  ),
                  Text(
                    'Create and manage expense requests',
                    style: TextStyle(
                        fontSize: 13, color: AppConstant.textPrimary(context)),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton(
              onPressed: () { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Action Performed!'))); },
              icon: const Icon(Icons.refresh, color: Colors.white, size: 22),
              tooltip: 'Refresh',
            ),
          ),
        ],
      ),
      body: ScreenShimmerWrapper(
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
                onPressed: _showCreateRequestDialog,
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Create Request',
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
            SizedBox(
              height: 12,
            ),
            _buildFilters(),
            Expanded(child: _buildTableCard()),
            _buildPagination(),
          ],
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppConstant.cardBg(context),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Search',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppConstant.textSecondary(context),
              )),
          const SizedBox(height: 8),
          TextField(
            controller: _searchController,
            onChanged: (val) => setState(() => _searchQuery = val),
            decoration: InputDecoration(
              hintText: 'Search by title, description, or request',
              hintStyle:
                  TextStyle(color: AppConstant.textHint(context), fontSize: 12),
              prefixIcon: Icon(Icons.search,
                  color: AppConstant.textHint(context), size: 20),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppConstant.border(context)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppConstant.border(context)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppConstant.primarycolor),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Status',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppConstant.textSecondary(context),
                        )),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _statusFilter,
                      isExpanded: true,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              BorderSide(color: AppConstant.border(context)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              BorderSide(color: AppConstant.border(context)),
                        ),
                      ),
                      items: _statuses.map((String s) {
                        return DropdownMenuItem<String>(
                            value: s,
                            child:
                                Text(s, style: const TextStyle(fontSize: 12)));
                      }).toList(),
                      onChanged: (val) => setState(() => _statusFilter = val!),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Priority',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1A1A2E))),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _priorityFilter,
                      isExpanded: true,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              BorderSide(color: AppConstant.border(context)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              BorderSide(color: AppConstant.border(context)),
                        ),
                      ),
                      items: _priorities.map((String p) {
                        return DropdownMenuItem<String>(
                            value: p,
                            child:
                                Text(p, style: const TextStyle(fontSize: 12)));
                      }).toList(),
                      onChanged: (val) =>
                          setState(() => _priorityFilter = val!),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
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
      child: _buildDataTable(),
    );
  }

  Widget _buildDataTable() {
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = startIndex + _itemsPerPage;
    final visibleItems = _filteredRequests.sublist(
      startIndex,
      endIndex > _filteredRequests.length ? _filteredRequests.length : endIndex,
    );

    if (visibleItems.isEmpty) {
      return _buildEmptyDataTable();
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor: WidgetStateProperty.all(AppConstant.primarycolor),
        headingTextStyle: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 11,
        ),
        dataRowColor: WidgetStateProperty.all(Colors.white),
        horizontalMargin: 16,
        columnSpacing: 16,
        columns: const [
          DataColumn(label: Text('TITLE')),
          DataColumn(label: Text('AMOUNT')),
          DataColumn(label: Text('STATUS')),
          DataColumn(label: Text('PRIORITY')),
          DataColumn(label: Text('CATEGORY')),
          DataColumn(label: Text('DATE')),
          DataColumn(label: Text('ACTIONS')),
        ],
        rows: visibleItems.map((request) {
          return DataRow(
            cells: [
              DataCell(
                SizedBox(
                  width: 130,
                  child: Text(request.title,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 12),
                      overflow: TextOverflow.ellipsis),
                ),
              ),
              DataCell(
                Text('Rs ${request.amount.toStringAsFixed(0)}',
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w500)),
              ),
              DataCell(_statusBadge(request.status)),
              DataCell(_priorityBadge(request.priority)),
              DataCell(Text(request.category,
                  style: TextStyle(
                      fontSize: 12,
                      color: AppConstant.textSecondary(context)))),
              DataCell(Text(request.date,
                  style: TextStyle(
                      fontSize: 11,
                      color: AppConstant.textSecondary(context)))),
              DataCell(
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _actionButton(
                        icon: Icons.visibility_outlined,
                        color: AppConstant.primarycolor,
                        onTap: () => _showRequestDetails(request)),
                    _actionButton(
                        icon: Icons.edit_outlined,
                        color: Colors.orange,
                        onTap: () => _editRequest(request)),
                    _actionButton(
                        icon: Icons.delete_outline,
                        color: Colors.red,
                        onTap: () => _deleteRequest(request)),
                  ],
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildEmptyDataTable() {
    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowColor: WidgetStateProperty.all(AppConstant.primarycolor),
            headingTextStyle: TextStyle(
                fontWeight: FontWeight.w700, fontSize: 11, color: Colors.black),
            horizontalMargin: 16,
            columnSpacing: 16,
            columns: const [
              DataColumn(label: Text('TITLE')),
              DataColumn(label: Text('AMOUNT')),
              DataColumn(label: Text('STATUS')),
              DataColumn(label: Text('PRIORITY')),
              DataColumn(label: Text('CATEGORY')),
              DataColumn(label: Text('DATE')),
              DataColumn(label: Text('ACTIONS')),
            ],
            rows: const [],
          ),
        ),
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppConstant.textSecondary(context),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.receipt_long_outlined,
                      size: 40, color: AppConstant.textHint(context)),
                ),
                const SizedBox(height: 12),
                const Text('No requests found',
                    style:
                        TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                const SizedBox(height: 4),
                Text('No expense requests match your current filters.',
                    style: TextStyle(
                        fontSize: 12, color: AppConstant.textHint(context))),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _statusBadge(String status) {
    Color bgColor;
    Color textColor;

    switch (status) {
      case 'Approved':
        bgColor = const Color(0xFFE3F7EA);
        textColor = const Color(0xFF1E9E5A);
        break;
      case 'Rejected':
        bgColor = const Color(0xFFFDECEA);
        textColor = const Color(0xFFD32F2F);
        break;
      case 'Pending':
        bgColor = const Color(0xFFFFF8E1);
        textColor = const Color(0xFFF57C00);
        break;
      default:
        bgColor = Colors.grey.shade200;
        textColor = AppConstant.textSecondary(context);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
          color: bgColor, borderRadius: BorderRadius.circular(12)),
      child: Text(status,
          style: TextStyle(
              fontSize: 9, fontWeight: FontWeight.w700, color: textColor)),
    );
  }

  Widget _priorityBadge(String priority) {
    Color bgColor;
    Color textColor;

    switch (priority) {
      case 'High':
      case 'Urgent':
        bgColor = const Color(0xFFFDECEA);
        textColor = const Color(0xFFD32F2F);
        break;
      case 'Medium':
        bgColor = const Color(0xFFFFF8E1);
        textColor = const Color(0xFFF57C00);
        break;
      default:
        bgColor = const Color(0xFFE3F7EA);
        textColor = const Color(0xFF1E9E5A);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
          color: bgColor, borderRadius: BorderRadius.circular(12)),
      child: Text(priority,
          style: TextStyle(
              fontSize: 9, fontWeight: FontWeight.w700, color: textColor)),
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
        margin: const EdgeInsets.only(right: 4),
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Icon(icon, size: 13, color: color),
      ),
    );
  }

  Widget _buildPagination() {
    final filtered = _filteredRequests;
    final totalPages = (filtered.length / _itemsPerPage).ceil();

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
              _pageButton(Icons.first_page, _currentPage > 1,
                  () => setState(() => _currentPage = 1)),
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
              _pageButton(Icons.last_page, _currentPage < totalPages,
                  () => setState(() => _currentPage = totalPages)),
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
        margin: const EdgeInsets.symmetric(horizontal: 2),
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
}
