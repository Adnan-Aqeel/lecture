import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:lecture/appcolor.dart';
import 'package:lecture/widgets/shimmer_widgets.dart';
import 'package:lecture/Screens/Kpi_management/Kpi_dashboard_button/kpi_master.dart';
import 'package:lecture/Screens/Kpi_management/Kpi_dashboard_button/employee_evaluation.dart';
import 'package:lecture/Screens/Kpi_management/Kpi_dashboard_button/view_result.dart';
import 'package:lecture/Screens/Kpi_management/Kpi_dashboard_button/department_weightage.dart';

class KpiDashboardScreen extends StatefulWidget {
  const KpiDashboardScreen({super.key});

  @override
  State<KpiDashboardScreen> createState() => _KpiDashboardScreenState();
}

class _KpiDashboardScreenState extends State<KpiDashboardScreen> {
  @override
  Widget build(BuildContext context) {
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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('KPI Dashboard',
                style: TextStyle(
                  fontSize: 19,
                  color: AppConstant.textPrimary(context),
                  fontWeight: FontWeight.bold,
                )),
            Text('Employee KPI Management overview',
                style: TextStyle(
                  fontSize: 13,
                  color: AppConstant.textPrimary(context),
                )),
          ],
        ),
      ),
      body: ScreenShimmerWrapper(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(14),
          child: Column(
            children: [
              _buildRefreshButton(),
              const SizedBox(height: 14),
              _buildStatCards(),
              const SizedBox(height: 14),
              _buildQuickActions(),
              const SizedBox(height: 14),
              _buildPerformanceOverview(),
              const SizedBox(height: 14),
              _buildKpiCategories(),
              const SizedBox(height: 14),
              _buildMonthlyTrends(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // ── Refresh Button ──
  Widget _buildRefreshButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppConstant.cardBg(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppConstant.border(context)),
      ),
      child: Row(
        children: [
          Icon(Icons.refresh, size: 18, color: AppConstant.textHint(context)),
          const SizedBox(width: 8),
          Text('Refresh',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppConstant.textSecondary(context))),
        ],
      ),
    );
  }

  // ── Stat Cards ──
  Widget _buildStatCards() {
    final stats = [
      _StatData(Icons.people_outline, '4', 'TOTAL EMPLOYEES',
          AppConstant.primarycolor),
      _StatData(Icons.list_alt, '0', 'TOTAL KPIS', AppConstant.primarycolor),
      _StatData(Icons.check_circle_outline, '0', 'ACTIVE KPIS', Colors.orange),
      _StatData(Icons.bar_chart, '0', 'EVALUATIONS', Colors.purple),
      _StatData(Icons.access_time, '4', 'PENDING', Colors.orange),
      _StatData(Icons.percent, '0%', 'AVG SCORE', Colors.red),
    ];

    return Column(
      children: [
        Row(
          children:
              stats.take(3).map((s) => Expanded(child: _statCard(s))).toList(),
        ),
        const SizedBox(height: 10),
        Row(
          children:
              stats.skip(3).map((s) => Expanded(child: _statCard(s))).toList(),
        ),
      ],
    );
  }

  Widget _statCard(_StatData data) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: AppConstant.cardBg(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppConstant.border(context)),
      ),
      child: Column(
        children: [
          Icon(data.icon, color: data.color, size: 24),
          const SizedBox(height: 8),
          Text(data.value,
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppConstant.textPrimary(context))),
          const SizedBox(height: 4),
          Text(data.label,
              style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  color: AppConstant.textHint(context)),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }

  // ── Quick Actions ──
  Widget _buildQuickActions() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppConstant.cardBg(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppConstant.border(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Quick Actions',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppConstant.textPrimary(context))),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _actionButton(
                  Icons.settings_outlined, 'Manage KPI ...', AppConstant.primarycolor,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const KpiMasterScreen())),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _actionButton(
                  Icons.people_outline, 'Employee Ev...', Colors.teal,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EmployeeEvaluationScreen())),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _actionButton(
                  Icons.bar_chart, 'View Results', Colors.blue.shade700,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ViewResultScreen())),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _actionButton(
                  Icons.public, 'Department ...', Colors.orange,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DepartmentWeightage())),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _actionButton(IconData icon, String label, Color color, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withValues(alpha: 0.4)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 6),
            Flexible(
              child: Text(label,
                  style: TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w600, color: color),
                  overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      ),
    );
  }

  // ── KPI Performance Overview ──
  Widget _buildPerformanceOverview() {
    final items = [
      _PerfData('0', 'Excellent', '(90%+)', Colors.green),
      _PerfData('0', 'Good', '(80-89%)', AppConstant.primarycolor),
      _PerfData('0', 'Average', '(70-79%)', Colors.orange),
      _PerfData('0', 'Needs', 'Improvement', Colors.red),
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppConstant.cardBg(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppConstant.border(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('KPI Performance Overview',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppConstant.textPrimary(context))),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: items
                .map((item) => Column(
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: item.color.withValues(alpha: 0.12),
                            border: Border.all(
                                color: item.color.withValues(alpha: 0.3)),
                          ),
                          child: Center(
                            child: Text(item.value,
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: item.color)),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(item.label,
                            style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppConstant.textPrimary(context)),
                            textAlign: TextAlign.center),
                        Text(item.sub,
                            style: TextStyle(
                                fontSize: 10,
                                color: AppConstant.textHint(context)),
                            textAlign: TextAlign.center),
                      ],
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  // ── KPI Categories ──
  Widget _buildKpiCategories() {
    final cats = [
      _CatData('Organizational:', '0', AppConstant.primarycolor),
      _CatData('Functional:', '0', Colors.lightBlue),
      _CatData('Active KPIs:', '0', Colors.teal),
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppConstant.cardBg(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppConstant.border(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('KPI Categories',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppConstant.textPrimary(context))),
          const SizedBox(height: 16),
          ...cats.map((cat) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(cat.label,
                        style: TextStyle(
                            fontSize: 14,
                            color: AppConstant.textSecondary(context))),
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: cat.color.withValues(alpha: 0.12),
                        border:
                            Border.all(color: cat.color.withValues(alpha: 0.3)),
                      ),
                      child: Center(
                        child: Text(cat.value,
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: cat.color)),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  // ── Monthly KPI Trends ──
  Widget _buildMonthlyTrends() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppConstant.cardBg(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppConstant.border(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Monthly KPI Trends',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppConstant.textPrimary(context))),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: AppConstant.primarycolor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: AppConstant.primarycolor.withValues(alpha: 0.3)),
                ),
                child: Text('2024',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppConstant.primarycolor)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 220,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 10,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  show: true,
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      getTitlesWidget: (value, meta) {
                        final months = [
                          'Jan',
                          'Feb',
                          'Mar',
                          'Apr',
                          'May',
                          'Jun'
                        ];
                        return Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(months[value.toInt()],
                              style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: AppConstant.textHint(context))),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      getTitlesWidget: (value, meta) {
                        if (value % 5 == 0) {
                          return Text('${value.toInt()}',
                              style: TextStyle(
                                  fontSize: 11,
                                  color: AppConstant.textHint(context)));
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 5,
                  getDrawingHorizontalLine: (value) => FlLine(
                      color: AppConstant.border(context), strokeWidth: 0.5),
                ),
                barGroups: [
                  _barGroup(0, 4, AppConstant.primarycolor),
                  _barGroup(1, 6, Colors.purple),
                  _barGroup(2, 3, Colors.teal),
                  _barGroup(3, 7, Colors.orange),
                  _barGroup(4, 5, AppConstant.primarycolor),
                  _barGroup(5, 8, Colors.purple),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  BarChartGroupData _barGroup(int x, double y, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: color,
          width: 22,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
        ),
      ],
    );
  }
}

class _StatData {
  final IconData icon;
  final String value;
  final String label;
  final Color color;
  _StatData(this.icon, this.value, this.label, this.color);
}

class _PerfData {
  final String value;
  final String label;
  final String sub;
  final Color color;
  _PerfData(this.value, this.label, this.sub, this.color);
}

class _CatData {
  final String label;
  final String value;
  final Color color;
  _CatData(this.label, this.value, this.color);
}
