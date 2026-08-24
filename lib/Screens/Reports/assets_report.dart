import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:lecture/appcolor.dart';
import 'package:lecture/widgets/shimmer_widgets.dart';
import 'package:lecture/utils/mobile_file_actions.dart';

class AssetRecord {
  final int id;
  final String name;
  final String category;
  final String serialNumber;
  final String status;

  const AssetRecord({
    required this.id,
    required this.name,
    required this.category,
    required this.serialNumber,
    required this.status,
  });
}

class AssetsReportScreen extends StatefulWidget {
  const AssetsReportScreen({super.key});

  @override
  State<AssetsReportScreen> createState() => _AssetsReportScreenState();
}

class _AssetsReportScreenState extends State<AssetsReportScreen> {
  String _searchQuery = '';
  String? _selectedCategory;
  String _selectedStatus = 'All Statuses';
  String _chartView = 'Monthly';
  int _currentPage = 1;
  int _itemsPerPage = 10;
  final _searchController = TextEditingController();

  final List<String> _categories = [
    'All Categories',
    'laptop',
    'desktop',
    'monitor',
    'keyboard',
    'mouse'
  ];
  final List<String> _statuses = [
    'All Statuses',
    'In Use',
    'Available',
    'In Repair',
    'Retired'
  ];

  final List<AssetRecord> _records = [
    const AssetRecord(
        id: 1,
        name: 'HP THINKPAD 5320',
        category: 'laptop',
        serialNumber: 'ph-1',
        status: 'In Use'),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<AssetRecord> get _filteredRecords {
    return _records.where((r) {
      final matchesSearch = _searchQuery.isEmpty ||
          r.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          r.serialNumber.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory = _selectedCategory == null ||
          _selectedCategory == 'All Categories' ||
          r.category == _selectedCategory;
      final matchesStatus =
          _selectedStatus == 'All Statuses' || r.status == _selectedStatus;
      return matchesSearch && matchesCategory && matchesStatus;
    }).toList();
  }

  int get _totalAssets => _records.length;
  int get _inUseAssets => _records.where((r) => r.status == 'In Use').length;
  int get _availableAssets =>
      _records.where((r) => r.status == 'Available').length;
  int get _inRepairAssets =>
      _records.where((r) => r.status == 'In Repair').length;

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
              'Assets Report',
              style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: AppConstant.textPrimary(context)),
            ),
            Text(
              'Overview of all assets with category and status breakdown.',
              style: TextStyle(
                  fontSize: 13, color: AppConstant.textPrimary(context)),
            ),
          ],
        ),
      ),
      body: ScreenShimmerWrapper(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: OutlinedButton.icon(
                  onPressed: () => MobileFileActions.exportPdf(
                    fileName: 'assets_report',
                    title: 'Assets Report',
                    headers: const ['Asset', 'Category', 'Status', 'Assigned To'],
                  ),
                  icon: const Icon(Icons.picture_as_pdf_outlined, size: 14),
                  label:
                      const Text('Export PDF', style: TextStyle(fontSize: 11)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red.shade400,
                    side: BorderSide(color: Colors.red.shade400),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  ),
                ),
              ),
              _buildFilters(),
              const SizedBox(height: 12),
              _buildSummarySection(),
              const SizedBox(height: 12),
              _buildTableCard(),
              const SizedBox(height: 12),
              _buildCategoriesSection(),
              const SizedBox(height: 12),
              _buildChartsSection(),
              const SizedBox(height: 12),
              _buildTablePagination(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppConstant.cardBg(context),
        borderRadius: BorderRadius.circular(12),
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
          const Text('Search',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          TextField(
            controller: _searchController,
            onChanged: (val) => setState(() => _searchQuery = val),
            decoration: InputDecoration(
              hintText: 'Search by Name or Serial Number...',
              hintStyle:
                  TextStyle(color: AppConstant.textHint(context), fontSize: 12),
              prefixIcon: Icon(Icons.search,
                  color: AppConstant.textHint(context), size: 20),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppConstant.border(context))),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppConstant.border(context))),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                  child: _buildDropdown(
                      'Category',
                      _selectedCategory ?? 'All Categories',
                      _categories,
                      (val) => setState(() => _selectedCategory = val))),
              const SizedBox(width: 12),
              Expanded(
                  child: _buildDropdown('Status', _selectedStatus, _statuses,
                      (val) => setState(() => _selectedStatus = val!))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(String label, String value, List<String> items,
      ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 11, color: AppConstant.textSecondary(context))),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: value,
          isExpanded: true,
          isDense: true,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppConstant.border(context))),
          ),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
                value: item,
                child: Text(item, style: const TextStyle(fontSize: 12)));
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildSummarySection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppConstant.cardBg(context),
        borderRadius: BorderRadius.circular(12),
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
          const Text('Summary',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppConstant.primarycolor)),
          const SizedBox(height: 16),
          _summaryRow('Total Assets', _totalAssets, AppConstant.primarycolor),
          _summaryRow('In Use', _inUseAssets, Colors.green),
          _summaryRow('Available', _availableAssets, Colors.blue),
          _summaryRow('In Repair', _inRepairAssets, Colors.orange),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, int count, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: 13, color: color, fontWeight: FontWeight.w500)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12)),
            child: Text('$count',
                style: TextStyle(
                    fontSize: 12, fontWeight: FontWeight.bold, color: color)),
          ),
        ],
      ),
    );
  }

  Widget _buildTableCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppConstant.cardBg(context),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor:
                  WidgetStateProperty.all(AppConstant.primarycolor),
              headingTextStyle: TextStyle(
                  fontWeight: FontWeight.w700,
                    color: AppConstant.textPrimary(context),
                  fontSize: 10),
              dataRowColor:
                  WidgetStateProperty.all(AppConstant.cardBg(context)),
              horizontalMargin: 16,
              columnSpacing: 20,
              columns: const [
                DataColumn(label: Text('#')),
                DataColumn(label: Text('ASSET NAME')),
                DataColumn(label: Text('CATEGORY')),
                DataColumn(label: Text('SERIAL NUMBER')),
                DataColumn(label: Text('STATUS')),
              ],
              rows: _filteredRecords.map((record) {
                return DataRow(cells: [
                  DataCell(Text('${record.id}',
                      style: const TextStyle(fontSize: 11))),
                  DataCell(Text(record.name,
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w600))),
                  DataCell(Text(record.category,
                      style: TextStyle(
                          fontSize: 11,
                          color: AppConstant.textSecondary(context)))),
                  DataCell(Text(record.serialNumber,
                      style: TextStyle(
                          fontSize: 11,
                          color: AppConstant.textSecondary(context)))),
                  DataCell(_statusBadge(record.status)),
                ]);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusBadge(String status) {
    Color bgColor;
    Color textColor;

    switch (status) {
      case 'In Use':
        bgColor = const Color(0xFFE3F7EA);
        textColor = const Color(0xFF1E9E5A);
        break;
      case 'Available':
        bgColor = const Color(0xFFE7F0FE);
        textColor = const Color(0xFF2D6FE0);
        break;
      case 'In Repair':
        bgColor = const Color(0xFFFFF8E1);
        textColor = const Color(0xFFF57C00);
        break;
      case 'Retired':
        bgColor = const Color(0xFFFDECEA);
        textColor = const Color(0xFFD32F2F);
        break;
      default:
        bgColor = AppConstant.tableHeaderBg(context);
        textColor = AppConstant.textSecondary(context);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
          color: bgColor, borderRadius: BorderRadius.circular(12)),
      child: Text(status,
          style: TextStyle(
              fontSize: 10, fontWeight: FontWeight.w600, color: textColor)),
    );
  }

  Widget _buildTablePagination() {
    final totalPages = (_filteredRecords.length / _itemsPerPage).ceil();

    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Show ',
                    style: TextStyle(
                        color: AppConstant.textSecondary(context),
                        fontSize: 12)),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                      border: Border.all(color: AppConstant.border(context)),
                      borderRadius: BorderRadius.circular(4)),
                  child: DropdownButton<int>(
                    value: _itemsPerPage,
                    underline: const SizedBox(),
                    isDense: true,
                    icon: Icon(Icons.arrow_drop_down,
                        color: AppConstant.textSecondary(context), size: 18),
                    items: [10, 25, 50].map((int value) {
                      return DropdownMenuItem<int>(
                          value: value,
                          child: Text('$value',
                              style: const TextStyle(fontSize: 12)));
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
                        color: AppConstant.textSecondary(context),
                        fontSize: 12)),
              ],
            ),
            Text(
              'Current page: $_currentPage – Records: ${_filteredRecords.length} of ${_filteredRecords.length}',
              style: TextStyle(
                  color: AppConstant.textSecondary(context), fontSize: 11),
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
                      borderRadius: BorderRadius.circular(4)),
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

  Widget _buildCategoriesSection() {
    final categoryMap = <String, int>{};
    for (var r in _records) {
      categoryMap[r.category] = (categoryMap[r.category] ?? 0) + 1;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppConstant.cardBg(context),
        borderRadius: BorderRadius.circular(12),
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
          const Text('Categories',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppConstant.primarycolor)),
          const SizedBox(height: 12),
          if (categoryMap.isEmpty)
            Text('No categories',
                style: TextStyle(
                    fontSize: 13, color: AppConstant.textHint(context)))
          else
            ...categoryMap.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(entry.key, style: const TextStyle(fontSize: 13)),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                          color: AppConstant.tableHeaderBg(context),
                          borderRadius: BorderRadius.circular(12)),
                      child: Text('${entry.value}',
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppConstant.textSecondary(context))),
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }

  Widget _buildChartsSection() {
    return Column(
      children: [
        _buildAssetStatusChart(),
        const SizedBox(height: 12),
        _buildCategoryChart(),
      ],
    );
  }

  Widget _buildAssetStatusChart() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppConstant.cardBg(context),
        borderRadius: BorderRadius.circular(12),
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
          Row(
            children: [
              Icon(Icons.pie_chart_outline,
                  size: 18, color: AppConstant.primarycolor),
              const SizedBox(width: 8),
              const Text('Asset Status Distribution',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              const Spacer(),
            ],
          ),
          SizedBox(
            height: 12,
          ),
          _chartToggle(),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 50,
                sections: [
                  PieChartSectionData(
                    value: _inUseAssets.toDouble(),
                    color: const Color(0xFF5C6BC0),
                    radius: 50,
                    title: _inUseAssets > 0 ? '$_inUseAssets' : '',
                    titleStyle: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  PieChartSectionData(
                    value: _availableAssets.toDouble(),
                    color: const Color(0xFF26A69A),
                    radius: 50,
                    title: _availableAssets > 0 ? '$_availableAssets' : '',
                    titleStyle: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  PieChartSectionData(
                    value: _inRepairAssets.toDouble(),
                    color: const Color(0xFFFFA726),
                    radius: 50,
                    title: _inRepairAssets > 0 ? '$_inRepairAssets' : '',
                    titleStyle: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  PieChartSectionData(
                    value: 0,
                    color: const Color(0xFFEF5350),
                    radius: 50,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Column(
              children: [
                const Text('Total',
                    style: TextStyle(fontSize: 12, color: Colors.grey)),
                Text('$_totalAssets',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppConstant.primarycolor)),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _buildChartLegend(),
        ],
      ),
    );
  }

  Widget _chartToggle() {
    return Container(
      decoration: BoxDecoration(
          color: AppConstant.tableHeaderBg(context),
          borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: ['Weekly', 'Monthly', 'Yearly'].map((view) {
          final isSelected = _chartView == view;
          return InkWell(
            onTap: () => setState(() => _chartView = view),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color:
                    isSelected ? AppConstant.primarycolor : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                view,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected
                      ? Colors.white
                      : AppConstant.textSecondary(context),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildChartLegend() {
    final items = [
      {'label': 'In Use', 'color': const Color(0xFF5C6BC0)},
      {'label': 'Available', 'color': const Color(0xFF26A69A)},
      {'label': 'In Repair', 'color': const Color(0xFFFFA726)},
      {'label': 'Retired', 'color': const Color(0xFFEF5350)},
    ];

    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: items.map((item) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                    color: item['color'] as Color, shape: BoxShape.circle)),
            const SizedBox(width: 6),
            Text(item['label'] as String,
                style: TextStyle(
                    fontSize: 11, color: AppConstant.textSecondary(context))),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildCategoryChart() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppConstant.cardBg(context),
        borderRadius: BorderRadius.circular(12),
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
          Row(
            children: [
              Icon(Icons.bar_chart, size: 18, color: AppConstant.primarycolor),
              const SizedBox(width: 8),
              const Text('Assets by Category',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 180,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 2,
                barTouchData: BarTouchData(enabled: true),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final cats = ['laptop'];
                        if (value.toInt() < cats.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(cats[value.toInt()],
                                style: TextStyle(
                                    fontSize: 10,
                                    color: AppConstant.textSecondary(context))),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 20,
                      getTitlesWidget: (value, meta) {
                        return Text('${value.toInt()}',
                            style: TextStyle(
                                fontSize: 10,
                                color: AppConstant.textSecondary(context)));
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 0.5,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                        color: AppConstant.border(context), strokeWidth: 1);
                  },
                ),
                barGroups: [
                  BarChartGroupData(
                    x: 0,
                    barRods: [
                      BarChartRodData(
                        toY: 1,
                        color: const Color(0xFFAB9FF2),
                        width: 60,
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(6)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
