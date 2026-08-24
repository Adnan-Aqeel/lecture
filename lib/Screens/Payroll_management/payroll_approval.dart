import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lecture/appcolor.dart';
import 'package:lecture/widgets/shimmer_widgets.dart';

class PayrollApprovalItem {
  final int id;
  final String name;
  final double grossSalary;
  final double totalDeductions;
  final double netAmount;
  String status;
  bool isSelected;

  PayrollApprovalItem({
    required this.id,
    required this.name,
    required this.grossSalary,
    required this.totalDeductions,
    required this.netAmount,
    required this.status,
    this.isSelected = false,
  });
}

class PayrollApprovalScreen extends StatefulWidget {
  const PayrollApprovalScreen({super.key});

  @override
  State<PayrollApprovalScreen> createState() => _PayrollApprovalScreenState();
}

class _PayrollApprovalScreenState extends State<PayrollApprovalScreen> {
  String _selectedMonth = 'August';
  String _selectedYear = '2026';
  String _viewMode = 'Pipeline';
  String _searchQuery = '';
  final _searchController = TextEditingController();

  final List<String> _months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  final List<String> _years = ['2024', '2025', '2026', '2027'];
  final List<PayrollApprovalItem> _items = [
    PayrollApprovalItem(
        id: 1,
        name: 'ali',
        grossSalary: 191000,
        totalDeductions: 126000,
        netAmount: 65000,
        status: 'Pending'),
    PayrollApprovalItem(
        id: 2,
        name: 'zain',
        grossSalary: 75000,
        totalDeductions: 49000,
        netAmount: 26000,
        status: 'Pending'),
    PayrollApprovalItem(
        id: 1002,
        name: 'amair',
        grossSalary: 50000,
        totalDeductions: 35000,
        netAmount: 15000,
        status: 'Pending'),
  ];

  List<PayrollApprovalItem> get _filteredItems {
    return _items.where((item) {
      return _searchQuery.isEmpty ||
          item.name.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  int get _selectedCount => _items.where((i) => i.isSelected).length;

  List<PayrollApprovalItem> _getItemsByStatus(String status) {
    return _filteredItems.where((i) => i.status == status).toList();
  }

  double _getTotalByStatus(String status) {
    return _getItemsByStatus(status).fold(0, (sum, i) => sum + i.netAmount);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
            Text(
              'Payroll Approval',
              style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: AppConstant.textPrimary(context)),
            ),
            Text(
              'Review submitted payroll runs and approve or mark paid.',
              style: TextStyle(
                  fontSize: 13, color: AppConstant.textPrimary(context)),
            ),
          ],
        ),
      ),
      body: ScreenShimmerWrapper(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildViewModeBtn('Pipeline'),
                _buildViewModeBtn('Sheet'),
                _buildViewModeBtn('Individual'),
                _buildViewModeBtn('Group'),
                const SizedBox(width: 8),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: 90,
                  child: DropdownButtonFormField<String>(
                    value: _selectedMonth,
                    isExpanded: true,
                    isDense: true,
                    dropdownColor: AppConstant.cardBg(context),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 8),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6)),
                      filled: true,
                      fillColor: AppConstant.cardBg(context),
                    ),
                    items: _months
                        .map((m) => DropdownMenuItem(
                            value: m,
                            child:
                                Text(m, style: const TextStyle(fontSize: 11))))
                        .toList(),
                    onChanged: (val) => setState(() => _selectedMonth = val!),
                  ),
                ),
                const SizedBox(width: 6),
                SizedBox(
                  width: 70,
                  child: DropdownButtonFormField<String>(
                    value: _selectedYear,
                    isExpanded: true,
                    isDense: true,
                    dropdownColor: AppConstant.cardBg(context),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 8),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6)),
                      filled: true,
                      fillColor: AppConstant.cardBg(context),
                    ),
                    items: _years
                        .map((y) => DropdownMenuItem(
                            value: y,
                            child:
                                Text(y, style: const TextStyle(fontSize: 11))))
                        .toList(),
                    onChanged: (val) => setState(() => _selectedYear = val!),
                  ),
                ),
                const SizedBox(width: 8),
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: IconButton(
                    onPressed: () { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Action Performed!'))); },
                    icon: const Icon(Icons.refresh,
                        color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
            _buildSearchAndActions(),
            Expanded(
              child: _viewMode == 'Pipeline'
                  ? _buildKanbanBoard()
                  : _viewMode == 'Sheet'
                      ? _buildSheetView()
                      : _buildKanbanBoard(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildViewModeBtn(String mode) {
    final isSelected = _viewMode == mode;
    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: ChoiceChip(
        label: Text(mode,
            style: TextStyle(
                fontSize: 11,
                color: isSelected
                    ? Colors.white
                    : AppConstant.textSecondary(context))),
        selected: isSelected,
        selectedColor: AppConstant.primarycolor,
        backgroundColor: AppConstant.cardBg(context),
        onSelected: (val) => setState(() => _viewMode = mode),
        padding: const EdgeInsets.symmetric(horizontal: 10),
      ),
    );
  }

  Widget _buildSearchAndActions() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppConstant.cardBg(context),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 6,
                offset: const Offset(0, 2)),
          ],
        ),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              onChanged: (val) => setState(() => _searchQuery = val),
              decoration: InputDecoration(
                hintText: 'Search employee (name / code / id)',
                hintStyle: TextStyle(
                    color: AppConstant.textHint(context), fontSize: 12),
                prefixIcon: Icon(Icons.search,
                    color: AppConstant.textSecondary(context), size: 20),
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
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text('Selected: $_selectedCount',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppConstant.textSecondary(context))),
                const SizedBox(width: 12),
                _actionChip(
                    'Approve', Colors.green, () => _bulkAction('Approved')),
                _actionChip(
                    'Reject', Colors.red, () => _bulkAction('Rejected')),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    setState(() {
                      for (var item in _items) {
                        item.isSelected = false;
                      }
                    });
                  },
                  child: const Text('Clear', style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
            Row(
              children: [
                _actionChip(
                    'On Hold', Colors.orange, () => _bulkAction('On Hold')),
                _actionChip('Paid', Colors.blue, () => _bulkAction('Paid')),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _actionChip(String label, Color color, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ActionChip(
        label: Text(label, style: TextStyle(fontSize: 11, color: color)),
        backgroundColor: color.withValues(alpha: 0.1),
        side: BorderSide(color: color.withValues(alpha: 0.3)),
        onPressed: onTap,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }

  // ═══════════════════════════════════════════
  //  SHEET VIEW (DataTable)
  // ═══════════════════════════════════════════
  Widget _buildSheetView() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppConstant.cardBg(context),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppConstant.border(context)),
        ),
        child: Scrollbar(
          thumbVisibility: true,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: DataTable(
                  headingRowColor: WidgetStateProperty.all(
                    AppConstant.primarycolor,
                  ),
                  headingTextStyle: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    color: AppConstant.textPrimary(context),
                      letterSpacing: 0.5),
                  dataTextStyle: TextStyle(
                      fontSize: 12, color: AppConstant.textPrimary(context)),
                  dataRowMaxHeight: 56,
                  columnSpacing: 24,
                  horizontalMargin: 16,
                  dividerThickness: 0.5,
                  columns: const [
                    DataColumn(label: Text('EMPLOYEE')),
                    DataColumn(label: Text('STATUS')),
                    DataColumn(label: Text('GROSS SALARY')),
                    DataColumn(label: Text('TOTAL DEDUCTIONS')),
                    DataColumn(label: Text('NET SALARY')),
                    DataColumn(label: Text('ACTIONS')),
                  ],
                  rows: _filteredItems.map((item) {
                    return DataRow(cells: [
                      DataCell(Text('${item.id} - ${item.name}',
                          style: TextStyle(fontWeight: FontWeight.w600))),
                      DataCell(_statusBadge(item.status)),
                      DataCell(
                          Text('PKR ${item.grossSalary.toStringAsFixed(0)}')),
                      DataCell(Text(
                          'PKR ${item.totalDeductions.toStringAsFixed(0)}')),
                      DataCell(Text('PKR ${item.netAmount.toStringAsFixed(0)}',
                          style: TextStyle(fontWeight: FontWeight.w600))),
                      DataCell(
                        GestureDetector(
                          onTap: () => _processItem(item),
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: AppConstant.primarycolor
                                  .withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                  color: AppConstant.primarycolor
                                      .withValues(alpha: 0.25)),
                            ),
                            child: Icon(Icons.visibility_outlined,
                                size: 15, color: AppConstant.primarycolor),
                          ),
                        ),
                      ),
                    ]);
                  }).toList(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _statusBadge(String status) {
    Color color;
    switch (status) {
      case 'Approved':
        color = Colors.green;
        break;
      case 'Paid':
        color = Colors.blue;
        break;
      case 'On Hold':
        color = Colors.grey;
        break;
      case 'Rejected':
        color = Colors.red;
        break;
      default:
        color = Colors.orange;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(status,
          style: TextStyle(
              fontSize: 11, fontWeight: FontWeight.w600, color: color)),
    );
  }

  Widget _buildKanbanBoard() {
    final statuses = ['Pending', 'Approved', 'Paid', 'On Hold', 'Rejected'];
    final statusColors = {
      'Pending': Colors.orange,
      'Approved': Colors.green,
      'Paid': Colors.blue,
      'On Hold': Colors.grey,
      'Rejected': Colors.red,
    };

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: statuses.map((status) {
          final items = _getItemsByStatus(status);
          final total = _getTotalByStatus(status);
          final color = statusColors[status]!;

          return SingleChildScrollView(
            child: Container(
              width: 220,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: AppConstant.cardBg(context),
                borderRadius: BorderRadius.circular(12),
                border:
                    Border.all(color: color.withValues(alpha: 0.3), width: 2),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 6,
                      offset: const Offset(0, 2)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildColumnHeader(
                      status, items.length, color, status == 'Pending'),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.45),
                    child: items.isEmpty
                        ? _buildEmptyColumn(status, color)
                        : ListView.builder(
                            padding: const EdgeInsets.all(8),
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              return _buildItemCard(items[index], color);
                            },
                          ),
                  ),
                  _buildColumnFooter(total, color),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildColumnHeader(
      String status, int count, Color color, bool showSelectAll) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: color.withValues(alpha: 0.2))),
      ),
      child: Row(
        children: [
          if (showSelectAll)
            Checkbox(
              value: _getItemsByStatus(status).isNotEmpty &&
                  _getItemsByStatus(status).every((i) => i.isSelected),
              onChanged: (val) {
                setState(() {
                  for (var item in _getItemsByStatus(status)) {
                    item.isSelected = val ?? false;
                  }
                });
              },
              activeColor: color,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
            ),
          Text('Select ',
              style: TextStyle(
                  fontSize: 11, color: AppConstant.textSecondary(context))),
          Text(status,
              style: TextStyle(
                  fontSize: 12, fontWeight: FontWeight.bold, color: color)),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10)),
            child: Text('$count',
                style: TextStyle(
                    fontSize: 11, fontWeight: FontWeight.bold, color: color)),
          ),
        ],
      ),
    );
  }

  Widget _buildItemCard(PayrollApprovalItem item, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppConstant.cardBg(context),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppConstant.border(context)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 4,
              offset: const Offset(0, 1)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Checkbox(
                value: item.isSelected,
                onChanged: (val) {
                  setState(() {
                    item.isSelected = val ?? false;
                  });
                },
                activeColor: color,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
              ),
              Text('Select',
                  style: TextStyle(
                      fontSize: 10, color: AppConstant.textSecondary(context))),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text('${item.id} - ${item.name}',
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.bold)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                    color: AppConstant.tableHeaderBg(context),
                    borderRadius: BorderRadius.circular(8)),
                child: Text('None',
                    style: TextStyle(
                        fontSize: 9,
                        color: AppConstant.textSecondary(context))),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text('Net: PKR ${item.netAmount.toStringAsFixed(0)}',
              style: TextStyle(
                  fontSize: 11, color: AppConstant.textSecondary(context))),
          const SizedBox(height: 8),
          Row(
            children: [
              _linkBtn('View', AppConstant.primarycolor, () {}),
              Text(' | ',
                  style: TextStyle(color: AppConstant.textHint(context))),
              _linkBtn('Process', AppConstant.primarycolor,
                  () => _processItem(item)),
              Text(' | ',
                  style: TextStyle(color: AppConstant.textHint(context))),
              _linkBtn('History', AppConstant.primarycolor, () {}),
            ],
          ),
        ],
      ),
    );
  }

  Widget _linkBtn(String label, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Text(label,
          style: TextStyle(
              fontSize: 11, color: color, fontWeight: FontWeight.w500)),
    );
  }

  Widget _buildEmptyColumn(String status, Color color) {
    String message;
    switch (status) {
      case 'Approved':
        message = 'No approved items';
        break;
      case 'Paid':
        message = 'No paid items';
        break;
      case 'On Hold':
        message = 'No items on hold';
        break;
      case 'Rejected':
        message = 'No rejected items';
        break;
      default:
        message = 'No items';
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          message,
          style: TextStyle(fontSize: 12, color: color.withValues(alpha: 0.7)),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildColumnFooter(double total, Color color) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: color.withValues(alpha: 0.2))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Total',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
          Text(
            'PKR ${total.toStringAsFixed(0)}',
            style: TextStyle(
                fontSize: 12, fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }

  void _processItem(PayrollApprovalItem item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text('Process: ${item.name}'),
        content: Text(
            'Process payroll for ${item.name} (PKR ${item.netAmount.toStringAsFixed(0)})?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel',
                style: TextStyle(color: AppConstant.textSecondary(context))),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                item.status = 'Approved';
                item.isSelected = false;
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${item.name} approved'),
                  backgroundColor: Colors.green.shade600,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, foregroundColor: Colors.white),
            child: const Text('Approve'),
          ),
        ],
      ),
    );
  }

  void _bulkAction(String status) {
    if (_selectedCount == 0) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text('$status Selected Items'),
        content: Text(
            'Are you sure you want to $status $_selectedCount selected items?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel',
                style: TextStyle(color: AppConstant.textSecondary(context))),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                for (var item in _items.where((i) => i.isSelected)) {
                  item.status = status;
                  item.isSelected = false;
                }
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Items marked as $status'),
                  backgroundColor: Colors.green.shade600,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  status == 'Rejected' ? Colors.red : AppConstant.primarycolor,
              foregroundColor: Colors.white,
            ),
            child: Text(status),
          ),
        ],
      ),
    );
  }
}
