import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lecture/core/constants/app_colors.dart';
import 'package:lecture/core/widgets/shimmer_widgets.dart';
import 'package:lecture/core/utils/mobile_file_actions.dart';

class _StatCardData {
  final String value;
  final String label;
  final Color color;
  _StatCardData(this.value, this.label, this.color);
}

class _PerfItem {
  final String value;
  final String label;
  final String sub;
  final Color color;
  _PerfItem(this.value, this.label, this.sub, this.color);
}

class ViewResultScreen extends StatefulWidget {
  const ViewResultScreen({super.key});

  @override
  State<ViewResultScreen> createState() => _ViewResultScreenState();
}

class _ViewResultScreenState extends State<ViewResultScreen> {
  final _searchCtrl = TextEditingController();
  String? _selectedEmployee;
  String _selectedMonth = 'August 2026';
  int _entriesPerPage = 10;
  String _searchQuery = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
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
        title: Row(
          children: [
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('KPI Results',
                      style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: AppConstant.textPrimary(context))),
                  Text('View calculated KPI results and performance analytics',
                      style: TextStyle(
                          fontSize: 13,
                          color: AppConstant.textSecondary(context))),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton.icon(
            onPressed: () { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Action Performed!'))); },
            icon: Icon(Icons.refresh,
                size: 16, color: AppConstant.textSecondary(context)),
            label: Text('Refresh',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppConstant.textSecondary(context))),
          ),
        ],
      ),
      body: ScreenShimmerWrapper(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              // ── Export Button ──
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 12, right: 16),
                    child: OutlinedButton.icon(
                      onPressed: () {
                        MobileFileActions.exportPdf(
                          fileName: 'kpi_results_${_selectedMonth.replaceAll(' ', '_')}',
                          title: 'KPI Results - $_selectedMonth',
                          headers: ['Employee', 'Department', 'Org Score', 'Func Score', 'Final Score', 'Level', 'Month', 'Status'],
                          rows: [], // Currently empty in UI
                          shareText: 'KPI Results for $_selectedMonth',
                        );
                      },
                      icon: const Icon(Icons.download_outlined, size: 16),
                      label: const Text('Export'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppConstant.primarycolor,
                        side: BorderSide(color: AppConstant.primarycolor),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                      ),
                    ),
                  ),
                ],
              ),
              // ── Filters ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    _buildEmployeeDropdown(),
                    const SizedBox(height: 12),
                    _buildMonthField(),
                    const SizedBox(height: 12),
                    _buildSearchField(),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              // ── Stat Cards ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildStatCards(),
              ),
              const SizedBox(height: 14),
              // ── Performance Overview ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildPerformanceOverview(),
              ),
              const SizedBox(height: 14),
              // ── Scrollable Table ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildScrollableTable(),
              ),
              const SizedBox(height: 14),
              // ── Footer ──
              Padding(
                padding: const EdgeInsets.all(16),
                child: _buildFooter(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Filters ──
  Widget _buildEmployeeDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Employee',
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppConstant.textPrimary(context))),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: _selectedEmployee,
          isDense: true,
          decoration: InputDecoration(
            hintText: '-- Select --',
            hintStyle:
                TextStyle(fontSize: 13, color: AppConstant.textHint(context)),
            filled: true,
            fillColor: AppConstant.inputBg(context),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppConstant.border(context))),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppConstant.border(context))),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    BorderSide(color: AppConstant.primarycolor, width: 1.5)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
          items: ['ali', 'zain', 'amair', 'ehsan']
              .map((e) => DropdownMenuItem(
                    value: e,
                    child: Text(e,
                        style: TextStyle(
                            fontSize: 13,
                            color: AppConstant.textPrimary(context))),
                  ))
              .toList(),
          onChanged: (v) => setState(() => _selectedEmployee = v),
        ),
      ],
    );
  }

  Widget _buildMonthField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Month',
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppConstant.textPrimary(context))),
        const SizedBox(height: 6),
        TextField(
          readOnly: true,
          style:
              TextStyle(fontSize: 13, color: AppConstant.textPrimary(context)),
          decoration: InputDecoration(
            hintText: 'mm/dd/yyyy',
            hintStyle:
                TextStyle(fontSize: 13, color: AppConstant.textHint(context)),
            suffixIcon: Icon(Icons.calendar_today,
                size: 16, color: AppConstant.textHint(context)),
            filled: true,
            fillColor: AppConstant.inputBg(context),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppConstant.border(context))),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppConstant.border(context))),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    BorderSide(color: AppConstant.primarycolor, width: 1.5)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2020),
              lastDate: DateTime(2030),
            );
            if (date != null) {
              final months = [
                '',
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
              setState(
                  () => _selectedMonth = '${months[date.month]} ${date.year}');
            }
          },
        ),
      ],
    );
  }

  Widget _buildSearchField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Search',
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppConstant.textPrimary(context))),
        const SizedBox(height: 6),
        TextField(
          controller: _searchCtrl,
          style:
              TextStyle(fontSize: 13, color: AppConstant.textPrimary(context)),
          decoration: InputDecoration(
            hintText: 'Search by employee name...',
            hintStyle:
                TextStyle(fontSize: 13, color: AppConstant.textHint(context)),
            prefixIcon: Icon(Icons.search,
                size: 18, color: AppConstant.textHint(context)),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: Icon(Icons.clear,
                        size: 16, color: AppConstant.textHint(context)),
                    onPressed: () {
                      _searchCtrl.clear();
                      setState(() => _searchQuery = '');
                    },
                  )
                : null,
            filled: true,
            fillColor: AppConstant.inputBg(context),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppConstant.border(context))),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppConstant.border(context))),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    BorderSide(color: AppConstant.primarycolor, width: 1.5)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
          onChanged: (v) => setState(() => _searchQuery = v),
        ),
      ],
    );
  }

  // ── Stat Cards ──
  Widget _buildStatCards() {
    final stats = [
      _StatCardData('0', 'TOTAL KPIS', AppConstant.primarycolor),
      _StatCardData('0%', 'AVERAGE SCORE', AppConstant.primarycolor),
      _StatCardData('0', 'EXCELLENT (90%+)', Colors.green),
      _StatCardData('0', 'GOOD (80-89%)', Colors.orange),
    ];

    return Row(
      children: stats
          .map((s) => Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding:
                      const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
                  decoration: BoxDecoration(
                    color: AppConstant.cardBg(context),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppConstant.border(context)),
                  ),
                  child: Column(
                    children: [
                      Text(s.value,
                          style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: s.color)),
                      const SizedBox(height: 4),
                      Text(s.label,
                          style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                              color: AppConstant.textHint(context)),
                          textAlign: TextAlign.center),
                    ],
                  ),
                ),
              ))
          .toList(),
    );
  }

  // ── Performance Overview ──
  Widget _buildPerformanceOverview() {
    final items = [
      _PerfItem('0', 'Excellent', '(90%+)', Colors.green),
      _PerfItem('0', 'Good', '(80-89%)', AppConstant.primarycolor),
      _PerfItem('0', 'Average', '(70-79%)', Colors.orange),
      _PerfItem('0', 'Needs', 'Improvement', Colors.red),
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

  // ── Scrollable Table ──
  Widget _buildScrollableTable() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppConstant.cardBg(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppConstant.border(context)),
      ),
      child: Scrollbar(
        thumbVisibility: true,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: DataTable(
                headingRowColor:
                    WidgetStateProperty.all(AppConstant.primarycolor),
                headingTextStyle: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 0.5),
                dataTextStyle: TextStyle(
                    fontSize: 12, color: AppConstant.textPrimary(context)),
                columnSpacing: 20,
                horizontalMargin: 16,
                columns: const [
                  DataColumn(label: Text('EMPLOYEE')),
                  DataColumn(label: Text('DEPARTMENT')),
                  DataColumn(label: Text('ORG. SCORE')),
                  DataColumn(label: Text('FUNC. SCORE')),
                  DataColumn(label: Text('FINAL SCORE')),
                  DataColumn(label: Text('LEVEL')),
                  DataColumn(label: Text('MONTH')),
                  DataColumn(label: Text('STATUS')),
                  DataColumn(label: Text('ACTION')),
                ],
                rows: const [],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Footer ──
  Widget _buildFooter() {
    return Column(
      children: [
        Row(
          children: [
            Text('Show',
                style: TextStyle(
                    fontSize: 12, color: AppConstant.textSecondary(context))),
            const SizedBox(width: 6),
            Container(
              height: 30,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                border: Border.all(color: AppConstant.border(context)),
                borderRadius: BorderRadius.circular(6),
                color: AppConstant.inputBg(context),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  value: _entriesPerPage,
                  isDense: true,
                  items: [5, 10, 15, 25]
                      .map((s) => DropdownMenuItem(
                            value: s,
                            child: Text('$s',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: AppConstant.textPrimary(context))),
                          ))
                      .toList(),
                  onChanged: (v) {
                    if (v != null) setState(() => _entriesPerPage = v);
                  },
                ),
              ),
            ),
            const SizedBox(width: 6),
            Text('entries',
                style: TextStyle(
                    fontSize: 12, color: AppConstant.textSecondary(context))),
            const Spacer(),
          ],
        ),
        Row(
          children: [
            Text(
                'Current page: 1 – Records: 0 of 0 · Month: ${_selectedMonth.split(' ').first.substring(0, 3)} ${_selectedMonth.split(' ').last}',
                style: TextStyle(
                    fontSize: 11, color: AppConstant.textHint(context))),
            const SizedBox(width: 10),
          ],
        ),
        Row(
          children: [
            _pageBtn(Icons.first_page_rounded, false),
            const SizedBox(width: 4),
            _pageBtn(Icons.chevron_left_rounded, false),
            const SizedBox(width: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppConstant.primarycolor,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text('1',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.white)),
            ),
            const SizedBox(width: 4),
            _pageBtn(Icons.chevron_right_rounded, false),
            const SizedBox(width: 4),
            _pageBtn(Icons.last_page_rounded, false),
          ],
        )
      ],
    );
  }

  Widget _pageBtn(IconData icon, bool enabled) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: enabled
            ? AppConstant.inputBg(context)
            : AppConstant.cardBg(context),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppConstant.border(context)),
      ),
      child: Icon(icon,
          size: 16,
          color: enabled
              ? AppConstant.textSecondary(context)
              : AppConstant.textHint(context)),
    );
  }
}
