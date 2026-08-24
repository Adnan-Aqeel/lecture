import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:lecture/appcolor.dart';
import 'package:lecture/widgets/shimmer_widgets.dart';
import 'package:lecture/utils/mobile_file_actions.dart';
/// Monthly Hours Employee Model
class MonthlyHourModel {
  final String id;
  final String name;
  final String department;
  final double totalHours;
  final double expectedHours;
  final double incompleteHours;

  MonthlyHourModel({
    required this.id,
    required this.name,
    required this.department,
    required this.totalHours,
    required this.expectedHours,
    required this.incompleteHours,
  });

  String get displayEmp => '$id - $name';
}

class Monthlyhour extends StatefulWidget {
  const Monthlyhour({super.key});

  @override
  State<Monthlyhour> createState() => _MonthlyhourState();
}

class _MonthlyhourState extends State<Monthlyhour> {
  final TextEditingController datecontroller = TextEditingController();
  final TextEditingController searchController = TextEditingController();

  final ScrollController horizontalcontroller = ScrollController();
  final ScrollController verticalcontroller = ScrollController();

  String searchQuery = '';
  DateTime selectedDate = DateTime(2026, 8, 1);
  final int standardHoursPerDay = 9;

  // Direct Inline Initialized List (Fixes LateInitializationError)
  List<MonthlyHourModel> allRecords = [
    MonthlyHourModel(
      id: '1',
      name: 'Ali',
      department: 'IT & Software',
      totalHours: 180.0,
      expectedHours: 198.0,
      incompleteHours: 18.0,
    ),
    MonthlyHourModel(
      id: '2',
      name: 'Zain',
      department: 'Human Resources',
      totalHours: 198.0,
      expectedHours: 198.0,
      incompleteHours: 0.0,
    ),
    MonthlyHourModel(
      id: '1002',
      name: 'Amair',
      department: 'Sales & Marketing',
      totalHours: 160.0,
      expectedHours: 198.0,
      incompleteHours: 38.0,
    ),
    MonthlyHourModel(
      id: '2002',
      name: 'Ehsan',
      department: 'Finance & Accounts',
      totalHours: 190.0,
      expectedHours: 198.0,
      incompleteHours: 8.0,
    ),
  ];

  @override
  void initState() {
    super.initState();
    datecontroller.text = DateFormat('MM/yyyy').format(selectedDate);
  }

  @override
  void dispose() {
    datecontroller.dispose();
    searchController.dispose();
    horizontalcontroller.dispose();
    verticalcontroller.dispose();
    super.dispose();
  }

  // Live Filtered Employees
  List<MonthlyHourModel> get filteredRecords {
    if (searchQuery.trim().isEmpty) {
      return allRecords;
    }
    final q = searchQuery.toLowerCase();
    return allRecords.where((emp) {
      return emp.id.toLowerCase().contains(q) ||
          emp.name.toLowerCase().contains(q) ||
          emp.department.toLowerCase().contains(q);
    }).toList();
  }

  // Pick Month Dialog
  Future<void> _selectMonth(BuildContext context) async {
    final DateTime? pickeddate = await showDatePicker(
      context: context,
      firstDate: DateTime(2026),
      lastDate: DateTime(2050),
      initialDate: selectedDate,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppConstant.primarycolor,
              onPrimary: Colors.white,
              onSurface: const Color(0xFF1E293B),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickeddate != null) {
      setState(() {
        selectedDate = pickeddate;
        datecontroller.text = DateFormat('MM/yyyy').format(pickeddate);
      });
    }
  }

  // Workable Export Excel Function
  Future<void> _exportExcel() async {
    final monthStr = datecontroller.text.isEmpty
        ? DateFormat('MM/yyyy').format(selectedDate)
        : datecontroller.text;

    // Sanitize: replace '/' with '-' so filename is valid
    final safeMonth = monthStr.replaceAll('/', '-');
    final recordsToExport = filteredRecords;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF06B6D4),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: const Duration(seconds: 2),
        content: Row(
          children: const [
            Icon(Icons.file_download, color: Colors.white),
            SizedBox(width: 10),
            Text('Preparing export...', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );

    await MobileFileActions.exportCsv(
      fileName: 'monthly_hours_$safeMonth',
      headers: ['Employee ID', 'Name', 'Department', 'Total Hours', 'Expected Hours', 'Incomplete Hours'],
      rows: recordsToExport.map((emp) => [
        emp.id,
        emp.name,
        emp.department,
        emp.totalHours,
        emp.expectedHours,
        emp.incompleteHours,
      ]).toList(),
      shareText: 'Monthly Hours Report for $monthStr',
    );
  }

  // View Monthly Hours Detail Dialog
  void _viewMonthlyDetail(MonthlyHourModel item) {
    final attendancePercent = item.expectedHours > 0
        ? ((item.totalHours / item.expectedHours) * 100).toStringAsFixed(1)
        : '0.0';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppConstant.primarycolor.withValues(alpha: 0.15),
              child: Text(item.name[0].toUpperCase(),
                  style: TextStyle(color: AppConstant.primarycolor, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text('ID: ${item.id}  |  ${item.department}',
                      style: TextStyle(fontSize: 11, color: AppConstant.textSecondary(ctx)),
                      overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Divider(),
            _hourRow(ctx, 'Total Hours Worked', '${item.totalHours.toStringAsFixed(0)} hrs', Colors.green),
            _hourRow(ctx, 'Expected Hours', '${item.expectedHours.toStringAsFixed(0)} hrs', AppConstant.primarycolor),
            _hourRow(ctx, 'Incomplete Hours', '${item.incompleteHours.toStringAsFixed(0)} hrs',
                item.incompleteHours > 0 ? Colors.orange : Colors.green),
            _hourRow(ctx, 'Attendance %', '$attendancePercent%',
                double.parse(attendancePercent) >= 90 ? Colors.green : Colors.orange),
            _hourRow(ctx, 'Month', datecontroller.text, AppConstant.textPrimary(ctx)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Close', style: TextStyle(color: AppConstant.primarycolor)),
          ),
        ],
      ),
    );
  }

  Widget _hourRow(BuildContext ctx, String label, String value, Color valueColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 13, color: AppConstant.textSecondary(ctx))),
          Text(value,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: valueColor)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = filteredRecords;

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Monthly Hours Report",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppConstant.textPrimary(context),
              ),
            ),
            Text(
              "View employee attendance hours per month",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: AppConstant.textPrimary(context),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: AppConstant.scaffoldBg(context),
      body: ScreenShimmerWrapper(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 48,
                    width: 170,
                    child: Material(
                      color: const Color(0xFF06B6D4),
                      borderRadius: BorderRadius.circular(12),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: _exportExcel,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:  [
                            Icon(Icons.file_download_outlined,
                                color: Colors.black),
                            SizedBox(width: 8),
                            Text(
                              "Export Excel",
                              style: TextStyle(
                    color: AppConstant.textPrimary(context),
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              // 1. Select Month Field
              const Text(
                "Select Month",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: Color(0xFF94A3B8),
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: datecontroller,
                readOnly: true,
                onTap: () => _selectMonth(context),
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppConstant.primarycolor),
                  ),
                  suffixIcon: Icon(
                    Icons.calendar_month,
                    color: AppConstant.primarycolor,
                  ),
                  hintText: "mm/yyyy",
                ),
              ),
              const SizedBox(height: 16),

              // 2. Search Employee Field (Workable)
              const Text(
                "Search Employee",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: Color(0xFF94A3B8),
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: searchController,
                onChanged: (val) {
                  setState(() {
                    searchQuery = val;
                  });
                },
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppConstant.primarycolor),
                  ),
                  prefixIcon: const Icon(Icons.search),
                  hintText: "Search name or email",
                ),
              ),
              const SizedBox(height: 16),

              // 3. Standard Hours / Day Box
              const Text(
                "Standard Hours/Day",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: Color(0xFF94A3B8),
                ),
              ),
              const SizedBox(height: 6),
              Container(
                height: 55,
                width: double.infinity,
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  color: AppConstant.cardBg(context),
                  border: Border.all(color: AppConstant.border(context)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    "$standardHoursPerDay",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: Color(0xFF94A3B8),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 4. Workable Export Excel Button

              const SizedBox(height: 24),

              // 5. Data Table Section or No Records Found
              filtered.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.people_outline,
                              size: 48,
                              color: Color(0xFF94A3B8),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "No Records are Found",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Container(
                      decoration: BoxDecoration(
                        color: AppConstant.cardBg(context),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppConstant.border(context)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.02),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Scrollbar(
                          thumbVisibility: true,
                          controller: horizontalcontroller,
                          child: SingleChildScrollView(
                            controller: horizontalcontroller,
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              headingRowColor: WidgetStateProperty.all(
                                AppConstant.primarycolor,
                              ),
                              headingRowHeight: 48,
                              dataRowMinHeight: 52,
                              dataRowMaxHeight: 60,
                              horizontalMargin: 16,
                              columnSpacing: 20,
                              columns:  [
                                DataColumn(
                                  label: Row(
                                    children: [
                                      Icon(Icons.numbers,
                                          size: 18, color: Colors.white),
                                      SizedBox(width: 6),
                                      Text(
                                        "#",
                                        style: TextStyle(
                          color: AppConstant.textPrimary(context),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                DataColumn(
                                  label: Row(
                                    children: [
                                      Icon(Icons.person,
                                          size: 18, color: Colors.black),
                                      SizedBox(width: 6),
                                      Text(
                                        "EMPLOYEE",
                                        style: TextStyle(
                          color: AppConstant.textPrimary(context),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                DataColumn(
                                  label: Row(
                                    children: [
                                      Icon(Icons.dashboard_customize,
                                          size: 18, color: Colors.black),
                                      SizedBox(width: 6),
                                      Text(
                                        "DEPARTMENT",
                                        style: TextStyle(
                          color: AppConstant.textPrimary(context),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                DataColumn(
                                  label: Row(
                                    children: [
                                      Icon(Icons.access_time,
                                          size: 18, color: Colors.black),
                                      SizedBox(width: 6),
                                      Text(
                                        "TOTAL HOURS",
                                        style: TextStyle(
                          color: AppConstant.textPrimary(context),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                DataColumn(
                                  label: Row(
                                    children: [
                                      Icon(Icons.check_box_outlined,
                                          size: 18, color: Colors.black),
                                      SizedBox(width: 6),
                                      Text(
                                        "EXPECTED HOURS",
                                        style: TextStyle(
                          color: AppConstant.textPrimary(context),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                DataColumn(
                                  label: Row(
                                    children: [
                                      Icon(Icons.warning,
                                          size: 18, color: Colors.black),
                                      SizedBox(width: 6),
                                      Text(
                                        "INCOMPLETE HOURS",
                                        style: TextStyle(
                          color: AppConstant.textPrimary(context),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                DataColumn(
                                  label: Row(
                                    children: [
                                      Icon(Icons.settings,
                                          size: 18, color: Colors.black),
                                      SizedBox(width: 6),
                                      Text(
                                        "ACTIONS",
                                        style: TextStyle(
                          color: AppConstant.textPrimary(context),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                              rows: List.generate(filtered.length, (index) {
                                final item = filtered[index];
                                return DataRow(
                                  cells: [
                                    DataCell(
                                      Text(
                                        "${index + 1}",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Text(
                                        item.displayEmp,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    DataCell(Text(item.department)),
                                    DataCell(
                                      Text(
                                        "${item.totalHours.toStringAsFixed(0)} hrs",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF0F172A),
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Text(
                                        "${item.expectedHours.toStringAsFixed(0)} hrs",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: item.incompleteHours > 0
                                              ? Colors.amber.shade50
                                              : Colors.green.shade50,
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          "${item.incompleteHours.toStringAsFixed(0)} hrs",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: item.incompleteHours > 0
                                                ? Colors.amber.shade900
                                                : Colors.green.shade700,
                                          ),
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Row(
                                        children: [
                                          IconButton(
                                            icon: Icon(
                                              Icons.remove_red_eye_outlined,
                                              size: 18,
                                              color: AppConstant.primarycolor,
                                            ),
                                            tooltip: 'View Details',
                                            onPressed: () => _viewMonthlyDetail(item),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              }),
                            ),
                          ),
                        ),
                      ),
                    ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
