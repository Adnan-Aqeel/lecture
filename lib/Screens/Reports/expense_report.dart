import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:lecture/appcolor.dart';
import 'package:lecture/widgets/shimmer_widgets.dart';
import 'package:lecture/utils/mobile_file_actions.dart';

class ExpenseReportScreen extends StatefulWidget {
  const ExpenseReportScreen({super.key});

  @override
  State<ExpenseReportScreen> createState() => _ExpenseReportScreenState();
}

class _ExpenseReportScreenState extends State<ExpenseReportScreen> {
  String _selectedYear = '2026';
  String _selectedMonth = 'August';
  String _selectedStatus = 'All Status';
  String _selectedPriority = 'All Priorities';
  String _viewType = 'Monthly';

  final List<String> _years = ['2024', '2025', '2026', '2027'];
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
  final List<String> _statuses = [
    'All Status',
    'Pending',
    'Approved',
    'Paid',
    'Rejected'
  ];
  final List<String> _priorities = [
    'All Priorities',
    'Low',
    'Medium',
    'High',
    'Urgent'
  ];

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
              'Monthly Expense Report',
              style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: AppConstant.textPrimary(context)),
            ),
            Text(
              'Generate expense summaries.',
              style: TextStyle(fontSize: 13, color: AppConstant.textPrimary(context)),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildViewBtn('Weekly'),
                _buildViewBtn('Monthly'),
                _buildViewBtn('Yearly'),
                const SizedBox(width: 4),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Card(
                    child: IconButton(
                      onPressed: () => MobileFileActions.exportPdf(
                        fileName: 'expense_report',
                        title: 'Expense Report',
                        headers: const ['Employee', 'Category', 'Amount', 'Status'],
                      ),
                      icon: const Icon(Icons.refresh,
                          color: AppConstant.primarycolor, size: 22),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Card(
                    child: IconButton(
                      onPressed: () { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Action Performed!'))); },
                      icon: const Icon(Icons.picture_as_pdf_outlined,
                          color: AppConstant.primarycolor, size: 22),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            _buildFilters(),
            const SizedBox(height: 12),
            _buildSummaryCards(),
            const SizedBox(height: 12),
            _buildExpenseDetails(),
            const SizedBox(height: 12),
            _buildChartsSection(),
          ],
        ),
      ),
      ),
    );
  }

  Widget _buildViewBtn(String type) {
    final isSelected = _viewType == type;
    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: ChoiceChip(
        label: Text(type,
            style: TextStyle(
                fontSize: 11,
                color: isSelected ? Colors.white : AppConstant.textSecondary(context))),
        selected: isSelected,
        selectedColor: AppConstant.primarycolor,
        backgroundColor: AppConstant.cardBg(context),
        onSelected: (val) => setState(() => _viewType = type),
        padding: const EdgeInsets.symmetric(horizontal: 10),
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.all(14),
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
              Expanded(
                  child: _buildDropdown('Year', _selectedYear, _years,
                      (val) => setState(() => _selectedYear = val!))),
              const SizedBox(width: 10),
              Expanded(
                  child: _buildDropdown('Month', _selectedMonth, _months,
                      (val) => setState(() => _selectedMonth = val!))),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                  child: _buildDropdown('Status', _selectedStatus, _statuses,
                      (val) => setState(() => _selectedStatus = val!))),
              const SizedBox(width: 10),
              Expanded(
                  child: _buildDropdown(
                      'Priority',
                      _selectedPriority,
                      _priorities,
                      (val) => setState(() => _selectedPriority = val!))),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.info_outline, size: 14, color: AppConstant.textHint(context)),
              const SizedBox(width: 6),
              Text('Showing 0 of 0 expense requests',
                  style: TextStyle(fontSize: 11, color: AppConstant.textHint(context))),
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
            style: TextStyle(fontSize: 11, color: AppConstant.textSecondary(context))),
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

  Widget _buildSummaryCards() {
    final cards = [
      {
        'value': '0',
        'label': 'Total Requests',
        'icon': Icons.description_outlined,
        'color': Colors.blue
      },
      {
        'value': 'Rs 0',
        'label': 'Total Amount',
        'icon': Icons.attach_money,
        'color': Colors.green
      },
      {
        'value': '0',
        'label': 'Pending',
        'subLabel': 'Rs 0',
        'icon': Icons.access_time,
        'color': Colors.orange
      },
      {
        'value': '0',
        'label': 'Paid',
        'subLabel': 'Rs 0',
        'icon': Icons.check_circle_outline,
        'color': AppConstant.primarycolor
      },
    ];

    return Row(
      children: cards.map((card) {
        return Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppConstant.cardBg(context),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 6,
                    offset: const Offset(0, 2)),
              ],
            ),
            child: Column(
              children: [
                Icon(card['icon'] as IconData,
                    color: card['color'] as Color, size: 24),
                const SizedBox(height: 8),
                Text(
                  card['value'] as String,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: card['color'] as Color),
                ),
                const SizedBox(height: 4),
                Text(
                  card['label'] as String,
                  style: TextStyle(fontSize: 10, color: AppConstant.textSecondary(context)),
                  textAlign: TextAlign.center,
                ),
                if (card['subLabel'] != null)
                  Text(
                    card['subLabel'] as String,
                    style: TextStyle(fontSize: 10, color: AppConstant.textHint(context)),
                  ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildExpenseDetails() {
    return Container(
      padding: const EdgeInsets.all(16),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.table_chart_outlined,
                  size: 18, color: AppConstant.primarycolor),
              const SizedBox(width: 8),
              const Text('EXPENSE DETAILS',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 40),
          Center(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppConstant.tableHeaderBg(context),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.receipt_long_outlined,
                      size: 40, color: AppConstant.textHint(context)),
                ),
                const SizedBox(height: 16),
                Text(
                  'No Expense Records Found',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppConstant.textPrimary(context)),
                ),
                const SizedBox(height: 8),
                Text(
                  'No expense requests match your current filters.',
                  style: TextStyle(fontSize: 12, color: AppConstant.textHint(context)),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _selectedStatus = 'All Status';
                      _selectedPriority = 'All Priorities';
                    });
                  },
                  icon: const Icon(Icons.filter_alt_off_outlined, size: 16),
                  label: const Text('Clear Filters'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstant.primarycolor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildChartsSection() {
    return Column(
      children: [
        _buildStatusDistribution(),
        const SizedBox(height: 12),
        _buildTopCategoriesChart(),
      ],
    );
  }

  Widget _buildStatusDistribution() {
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
              const Text('STATUS DISTRIBUTION',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 40),
          Center(
            child: Text('No data available',
                style: TextStyle(fontSize: 12, color: AppConstant.textHint(context))),
          ),
          const SizedBox(height: 40),
          _buildStatusLegend(),
        ],
      ),
    );
  }

  Widget _buildStatusLegend() {
    final items = [
      {'label': 'Pending', 'color': Colors.orange},
      {'label': 'Approved', 'color': Colors.blue},
      {'label': 'Paid', 'color': Colors.green},
      {'label': 'Rejected', 'color': Colors.red},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: items.map((item) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                      color: item['color'] as Color, shape: BoxShape.circle)),
              const SizedBox(width: 4),
              Text(item['label'] as String,
                  style: TextStyle(fontSize: 11, color: AppConstant.textSecondary(context))),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTopCategoriesChart() {
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
              const Text('TOP CATEGORIES BY AMOUNT',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 6,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Text('${value.toInt()}',
                            style: TextStyle(
                                fontSize: 10, color: AppConstant.textSecondary(context)));
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
                                fontSize: 10, color: AppConstant.textSecondary(context)));
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
                  horizontalInterval: 1,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(color: Colors.grey.shade200, strokeWidth: 1);
                  },
                ),
                barGroups: [],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
