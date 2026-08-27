import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:lecture/core/constants/app_colors.dart';
import 'package:lecture/core/widgets/shimmer_widgets.dart';
import 'package:lecture/core/utils/mobile_file_actions.dart';

class LoanReportScreen extends StatefulWidget {
  const LoanReportScreen({super.key});

  @override
  State<LoanReportScreen> createState() => _LoanReportScreenState();
}

class _LoanReportScreenState extends State<LoanReportScreen> {
  String _viewType = 'Summary';
  String _filterType = 'All Employees';
  String _loanType = 'All Types';
  final _searchController = TextEditingController();

  final List<String> _filterTypes = [
    'All Employees',
    'Active Loans',
    'Multiple Loans',
    'Overdue'
  ];
  final List<String> _loanTypes = [
    'All Types',
    'Personal',
    'Emergency',
    'Housing',
    'Vehicle',
    'Education'
  ];

  final int _employeesWithLoans = 0;
  final int _totalLoans = 0;
  final int _multipleLoanHolders = 0;
  final double _totalLoanAmount = 0;
  final double _totalPaid = 0;
  final double _totalApplied = 0;
  final double _totalDue = 0;
  final double _totalOverdue = 0;

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
              'Loan Report',
              style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: AppConstant.textPrimary(context)),
            ),
            Text(
              'Employee and non-employee loan summary, breakdowns, and annual view.',
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
              Row(
                children: [
                  _buildViewBtn('Summary'),
                  _buildViewBtn('Annual'),
                  const SizedBox(width: 4),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: IconButton(
                      onPressed: () => MobileFileActions.exportPdf(
                        fileName: 'loan_report',
                        title: 'Loan Report',
                        headers: const ['Employee', 'Loan Type', 'Amount', 'Paid', 'Due'],
                        shareText: 'Loan report PDF export',
                      ),
                      icon: const Icon(Icons.picture_as_pdf_outlined,
                          color: AppConstant.primarycolor, size: 22),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: IconButton(
                      onPressed: () => MobileFileActions.exportCsv(
                        fileName: 'loan_report',
                        headers: const ['Employee', 'Loan Type', 'Amount', 'Paid', 'Due'],
                        shareText: 'Loan report CSV export',
                      ),
                      icon: const Icon(Icons.download_outlined,
                          color: AppConstant.primarycolor, size: 22),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: IconButton(
                      onPressed: () { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Action Performed!'))); },
                      icon: const Icon(Icons.refresh,
                          color: AppConstant.primarycolor, size: 22),
                    ),
                  ),
                ],
              ),
              if (_viewType == 'Annual')
                _buildAnnualView()
              else ...[
                _buildSummaryCards(),
                const SizedBox(height: 12),
                _buildFilters(),
                const SizedBox(height: 12),
                _buildMainTable(),
                const SizedBox(height: 12),
                _buildChartsSection(),
                const SizedBox(height: 12),
                _buildDetailedBreakdown(),
                const SizedBox(height: 12),
                _buildPagination(),
              ],
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
                color: isSelected
                    ? Colors.black
                    : AppConstant.textSecondary(context))),
        selected: isSelected,
        selectedColor: AppConstant.primarycolor,
        backgroundColor: AppConstant.cardBg(context),
        onSelected: (val) => setState(() => _viewType = type),
        padding: const EdgeInsets.symmetric(horizontal: 10),
      ),
    );
  }

  Widget _buildSummaryCards() {
    final cards = [
      {
        'value': '$_employeesWithLoans',
        'label': 'Employees with Loans',
        'color': Colors.blue
      },
      {'value': '$_totalLoans', 'label': 'Total Loans', 'color': Colors.green},
      {
        'value': '$_multipleLoanHolders',
        'label': 'Multiple Loan Holders',
        'color': Colors.orange
      },
      {
        'value': 'Rs ${_totalLoanAmount.toStringAsFixed(0)}',
        'label': 'Total Loan Amount',
        'color': AppConstant.primarycolor
      },
      {
        'value': 'Rs ${_totalPaid.toStringAsFixed(0)}',
        'label': 'Total Paid',
        'color': Colors.green
      },
      {
        'value': 'Rs ${_totalApplied.toStringAsFixed(0)}',
        'label': 'Total Applied',
        'color': Colors.blue
      },
      {
        'value': 'Rs ${_totalDue.toStringAsFixed(0)}',
        'label': 'Total Due',
        'color': Colors.orange
      },
      {
        'value': 'Rs ${_totalOverdue.toStringAsFixed(0)}',
        'label': 'Total Overdue',
        'color': Colors.red
      },
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: cards.map((card) {
          return Container(
            width: 120,
            margin: const EdgeInsets.only(right: 8),
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  (card['value'] as String),
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: card['color'] as Color),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  (card['label'] as String),
                  style: TextStyle(
                      fontSize: 9, color: AppConstant.textSecondary(context)),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAnnualView() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 700;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
        _buildAnnualPanel(
          title: 'Disbursed Amount',
          subtitle: 'Loans disbursed in 2026 — grouped by loan type & month',
          child: _buildAnnualEmptyState('No disbursed loans found for 2026.'),
        ),
        const SizedBox(height: 12),
        _buildAnnualPanel(
          title: 'Repayment Summary',
          subtitle: 'Month-wise repayment activity in 2026',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  _buildStatusBadge('Paid', Colors.green),
                  _buildStatusBadge('Partial', Colors.amber),
                  _buildStatusBadge('Overdue', Colors.red),
                  _buildStatusBadge('Pending', Colors.blueGrey),
                  Text('— no installment this month',
                      style: TextStyle(
                          fontSize: 10,
                          color: AppConstant.textSecondary(context))),
                ],
              ),
              const SizedBox(height: 20),
              _buildAnnualEmptyState('No repayment data found for 2026.'),
            ],
          ),
        ),
        const SizedBox(height: 12),
            if (isMobile) ...[
              _buildMonthlyAnnualChart(),
              const SizedBox(height: 12),
              _buildOutstandingBalanceChart(),
            ] else
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildMonthlyAnnualChart()),
                  const SizedBox(width: 12),
                  Expanded(child: _buildOutstandingBalanceChart()),
                ],
              ),
          ],
        );
      },
    );
  }

  Widget _buildAnnualPanel({
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppConstant.cardBg(context),
        border: Border.all(color: AppConstant.border(context)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text(subtitle,
              style: TextStyle(
                  fontSize: 10, color: AppConstant.textSecondary(context))),
          const Divider(height: 18),
          child,
        ],
      ),
    );
  }

  Widget _buildAnnualEmptyState(String message) {
    return SizedBox(
      height: 92,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined,
                size: 26, color: AppConstant.textHint(context)),
            const SizedBox(height: 8),
            Text(message,
                style: TextStyle(
                    fontSize: 10, color: AppConstant.textSecondary(context))),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(label,
          style: TextStyle(fontSize: 9, color: color, fontWeight: FontWeight.w600)),
    );
  }

  Widget _buildMonthlyAnnualChart() {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return _buildChartPanel(
      title: 'Monthly Disbursement vs Repayment',
      child: SizedBox(
        height: 190,
        child: LineChart(LineChartData(
          minY: 0,
          maxY: 2,
          lineBarsData: [
            _zeroLine(Colors.indigo),
            _zeroLine(Colors.teal),
          ],
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 28)),
            bottomTitles: AxisTitles(sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget: (value, meta) => Text(
                value >= 0 && value < 12 ? months[value.toInt()] : '',
                style: const TextStyle(fontSize: 8),
              ),
            )),
          ),
          gridData: FlGridData(show: true, drawVerticalLine: false),
          borderData: FlBorderData(show: false),
        )),
      ),
    );
  }

  LineChartBarData _zeroLine(Color color) {
    return LineChartBarData(
      spots: List.generate(12, (index) => FlSpot(index.toDouble(), 0)),
      isCurved: false,
      color: color,
      barWidth: 1,
      dotData: const FlDotData(show: true),
    );
  }

  Widget _buildOutstandingBalanceChart() {
    return _buildChartPanel(
      title: 'Outstanding Balance by Loan Types',
      child: SizedBox(
        height: 190,
        child: BarChart(BarChartData(
          minY: 0,
          maxY: 10,
          barGroups: List.generate(_loanTypes.length - 1, (index) => BarChartGroupData(
            x: index,
            barRods: [BarChartRodData(toY: 0, color: AppConstant.primarycolor, width: 10)],
          )),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 25)),
            bottomTitles: AxisTitles(sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) => Text(
                value >= 0 && value < _loanTypes.length - 1 ? _loanTypes[value.toInt()] : '',
                style: const TextStyle(fontSize: 8),
              ),
            )),
          ),
          gridData: FlGridData(show: true, drawVerticalLine: false),
          borderData: FlBorderData(show: false),
        )),
      ),
    );
  }

  Widget _buildChartPanel({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppConstant.cardBg(context),
        border: Border.all(color: AppConstant.border(context)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
          ),
          const Divider(height: 18),
          child,
        ],
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
          const Text('Search',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          TextField(
            controller: _searchController,
            onChanged: (val) {},
            decoration: InputDecoration(
              hintText: 'Search by employee name...',
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
                      'Filter Type',
                      _filterType,
                      _filterTypes,
                      (val) => setState(() => _filterType = val!))),
              const SizedBox(width: 12),
              Expanded(
                  child: _buildDropdown('Loan Type', _loanType, _loanTypes,
                      (val) => setState(() => _loanType = val!))),
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

  Widget _buildMainTable() {
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
              headingRowColor: WidgetStateProperty.all(
                AppConstant.primarycolor,
              ),
              headingTextStyle: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  fontSize: 10),
              dataRowColor:
                  WidgetStateProperty.all(AppConstant.cardBg(context)),
              horizontalMargin: 16,
              columnSpacing: 16,
              columns: const [
                DataColumn(label: Text('EMPLOYEE NAME')),
                DataColumn(label: Text('TOTAL LOANS')),
                DataColumn(label: Text('LOAN TYPES')),
                DataColumn(label: Text('TOTAL AMOUNT')),
                DataColumn(label: Text('TOTAL PAID')),
                DataColumn(label: Text('TOTAL REMAINING')),
                DataColumn(label: Text('ACTIVE LOANS')),
                DataColumn(label: Text('STATUS')),
                DataColumn(label: Text('ACTIONS')),
              ],
              rows: [
                DataRow(cells: [
                  DataCell(SizedBox(
                    width: 300,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('No loan data found matching your criteria.',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: AppConstant.textHint(context))),
                        ],
                      ),
                    ),
                  )),
                  const DataCell(SizedBox()),
                  const DataCell(SizedBox()),
                  const DataCell(SizedBox()),
                  const DataCell(SizedBox()),
                  const DataCell(SizedBox()),
                  const DataCell(SizedBox()),
                  const DataCell(SizedBox()),
                  const DataCell(SizedBox()),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPagination() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Column(
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
                    borderRadius: BorderRadius.circular(4)),
                child: DropdownButton<int>(
                  value: 10,
                  underline: const SizedBox(),
                  isDense: true,
                  items: [10, 25, 50].map((int value) {
                    return DropdownMenuItem<int>(
                        value: value,
                        child: Text('$value',
                            style: const TextStyle(fontSize: 12)));
                  }).toList(),
                  onChanged: (val) {},
                ),
              ),
              Text(' entries',
                  style: TextStyle(
                      color: AppConstant.textSecondary(context), fontSize: 12)),
            ],
          ),
          Text('Current page: 1 – Records: 0 of 0',
              style: TextStyle(
                  color: AppConstant.textSecondary(context), fontSize: 11)),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _pageButton(Icons.first_page, false, () {}),
              _pageButton(Icons.chevron_left, false, () {}),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                    color: AppConstant.primarycolor,
                    borderRadius: BorderRadius.circular(4)),
                child: const Text('1',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12)),
              ),
              _pageButton(Icons.chevron_right, false, () {}),
              _pageButton(Icons.last_page, false, () {}),
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

  Widget _buildChartsSection() {
    return Column(
      children: [
        _buildLoanStatusChart(),
        const SizedBox(height: 12),
        _buildTopEmployeesChart(),
      ],
    );
  }

  Widget _buildLoanStatusChart() {
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
              const Text('Loan Status Distribution',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 40),
          Center(
            child: Text('No loan data available',
                style: TextStyle(
                    fontSize: 12, color: AppConstant.textHint(context))),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildTopEmployeesChart() {
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
              const Text('Top 10 Employees by Loan Amount',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 10,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
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
                  horizontalInterval: 2,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                        color: AppConstant.border(context), strokeWidth: 1);
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

  Widget _buildDetailedBreakdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
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
                  Icon(Icons.list_alt,
                      size: 18, color: AppConstant.primarycolor),
                  const SizedBox(width: 8),
                  const Text('Detailed Loan Breakdown',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 16),
              _buildSubSection(
                  'Employee Loans',
                  [
                    'EMPLOYEE',
                    'LOAN TYPE',
                    'APPLIED AMOUNT',
                    'DISBURSED AMOUNT'
                  ],
                  'No employee loan data available.'),
              const SizedBox(height: 16),
              _buildSubSection(
                  'Non-Employee Loans',
                  [
                    'APPLICANT',
                    'LOAN TYPE',
                    'APPLIED AMOUNT',
                    'DISBURSED AMOUNT',
                    'ACTIONS'
                  ],
                  'No non-employee loan data available.'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSubSection(
      String title, List<String> columns, String emptyMessage) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(title,
                style:
                    const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
            const Spacer(),
            IconButton(
              onPressed: () { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Action Performed!'))); },
              icon: const Icon(Icons.picture_as_pdf_outlined,
                  size: 16, color: Colors.red),
            ),
            IconButton(
              onPressed: () { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Action Performed!'))); },
              icon: const Icon(Icons.download_outlined,
                  size: 16, color: AppConstant.primarycolor),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowColor: WidgetStateProperty.all(
              AppConstant.primarycolor,
            ),
            headingTextStyle: TextStyle(
                fontWeight: FontWeight.w700, color: Colors.white, fontSize: 9),
            horizontalMargin: 12,
            columnSpacing: 16,
            columns: columns.map((c) => DataColumn(label: Text(c))).toList(),
            rows: [
              DataRow(cells: [
                DataCell(SizedBox(
                  width: 250,
                  child: Center(
                    child: Text(emptyMessage,
                        style: TextStyle(
                            fontSize: 11,
                            color: AppConstant.textHint(context))),
                  ),
                )),
                ...List.generate(
                    columns.length - 1, (_) => const DataCell(SizedBox())),
              ]),
            ],
          ),
        ),
      ],
    );
  }
}
