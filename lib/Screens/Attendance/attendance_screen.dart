import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:lecture/appcolor.dart';
import 'package:lecture/widgets/shimmer_widgets.dart';

/// Employee Attendance Status Enum
enum AttendanceStatus { present, wfh, absent, leave }

/// Employee Attendance Model
class EmployeeAttendance {
  final String id;
  final String name;
  AttendanceStatus status;
  String? checkIn;
  String? checkOut;

  EmployeeAttendance({
    required this.id,
    required this.name,
    required this.status,
    this.checkIn,
    this.checkOut,
  });

  String get displayEmp => '$id - $name';
}

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({Key? key}) : super(key: key);

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  DateTime _selectedDate = DateTime(2026, 8, 3);
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  int _rowsPerPage = 10;
  int _currentPage = 1;

  // Initial employee list
  late List<EmployeeAttendance> _employees;

  @override
  void initState() {
    super.initState();
    _employees = [
      EmployeeAttendance(
        id: '1',
        name: 'Ali',
        status: AttendanceStatus.absent,
      ),
      EmployeeAttendance(
        id: '2',
        name: 'Zain',
        status: AttendanceStatus.absent,
      ),
      EmployeeAttendance(
        id: '1002',
        name: 'Amair',
        status: AttendanceStatus.absent,
      ),
      EmployeeAttendance(
        id: '2002',
        name: 'Ehsan',
        status: AttendanceStatus.absent,
      ),
    ];
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Filtered employees list based on search query
  List<EmployeeAttendance> get _filteredEmployees {
    if (_searchQuery.trim().isEmpty) {
      return _employees;
    }
    final q = _searchQuery.toLowerCase();
    return _employees.where((emp) {
      return emp.id.toLowerCase().contains(q) ||
          emp.name.toLowerCase().contains(q);
    }).toList();
  }

  // Pick Date Dialog
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppConstant.primarycolor,
              onPrimary: Colors.white,
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // Save Attendance Action
  void _saveAttendance() {
    final presentCount =
        _employees.where((e) => e.status == AttendanceStatus.present).length;
    final wfhCount =
        _employees.where((e) => e.status == AttendanceStatus.wfh).length;
    final absentCount =
        _employees.where((e) => e.status == AttendanceStatus.absent).length;
    final leaveCount =
        _employees.where((e) => e.status == AttendanceStatus.leave).length;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppConstant.primarycolor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        content: Text(
          'Attendance Saved Successfully!\nPresent: $presentCount | WFH: $wfhCount | Absent: $absentCount | Leave: $leaveCount',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  // Reset Status for Single Employee
  void _resetEmployeeStatus(EmployeeAttendance emp) {
    setState(() {
      emp.status = AttendanceStatus.absent;
      emp.checkIn = null;
      emp.checkOut = null;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Reset status for ${emp.name}'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  // View Attendance Detail Dialog
  void _viewAttendanceDetail(EmployeeAttendance emp) {
    final statusLabel = emp.status.name.toUpperCase();
    final statusColor = emp.status == AttendanceStatus.present
        ? Colors.green
        : emp.status == AttendanceStatus.wfh
            ? Colors.blue
            : emp.status == AttendanceStatus.leave
                ? Colors.orange
                : Colors.red;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppConstant.primarycolor.withValues(alpha: 0.15),
              child: Text(emp.name[0].toUpperCase(),
                  style: TextStyle(color: AppConstant.primarycolor, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(emp.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text('ID: ${emp.id}', style: TextStyle(fontSize: 12, color: AppConstant.textSecondary(ctx))),
              ],
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Divider(),
            _detailRow(ctx, 'Status', statusLabel, valueColor: statusColor),
            _detailRow(ctx, 'Check-In', emp.checkIn ?? 'N/A'),
            _detailRow(ctx, 'Check-Out', emp.checkOut ?? 'N/A'),
            _detailRow(ctx, 'Date', DateFormat('dd MMM yyyy').format(_selectedDate)),
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

  Widget _detailRow(BuildContext ctx, String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 13, color: AppConstant.textSecondary(ctx))),
          Text(value,
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: valueColor ?? AppConstant.textPrimary(ctx))),
        ],
      ),
    );
  }

  // Edit / Assign Check-In & Check-Out Dialog
  void _editAttendance(EmployeeAttendance emp) {
    final checkInCtrl = TextEditingController(text: emp.checkIn ?? '');
    final checkOutCtrl = TextEditingController(text: emp.checkOut ?? '');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: Text('Edit Attendance – ${emp.name}',
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: checkInCtrl,
              decoration: InputDecoration(
                labelText: 'Check-In Time',
                hintText: 'e.g. 09:00 AM',
                prefixIcon: const Icon(Icons.login_rounded),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: checkOutCtrl,
              decoration: InputDecoration(
                labelText: 'Check-Out Time',
                hintText: 'e.g. 06:00 PM',
                prefixIcon: const Icon(Icons.logout_rounded),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: TextStyle(color: AppConstant.textSecondary(ctx))),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: AppConstant.primarycolor, foregroundColor: Colors.white),
            onPressed: () {
              setState(() {
                emp.checkIn = checkInCtrl.text.trim().isEmpty ? null : checkInCtrl.text.trim();
                emp.checkOut = checkOutCtrl.text.trim().isEmpty ? null : checkOutCtrl.text.trim();
              });
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Attendance updated for ${emp.name}'),
                  backgroundColor: AppConstant.primarycolor,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredEmployees;

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
            Text(
              "Attendance",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppConstant.textPrimary(context),
              ),
            ),
            Text(
              "Manage daily employee attendance",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppConstant.textPrimary(context),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: AppConstant.scaffoldBg(context),
      body: ScreenShimmerWrapper(
        child: SafeArea(
          child: SingleChildScrollView(
            padding:  EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Save Attendance Button
                ElevatedButton.icon(
                  onPressed: _saveAttendance,
                  icon:  Icon(
                    Icons.check_circle_outline,
                    size: 18,
                    color: AppConstant.textPrimary(context),
                  ),
                  label:  Text(
                    'Save Attendance',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    color: AppConstant.textPrimary(context),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstant.primarycolor,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                ),
                const SizedBox(height: 16),

                // Search & Date Filters
                _buildFilterSection(),
                const SizedBox(height: 16),

                // Attendance Data Table
                _buildTableCard(filtered),
                const SizedBox(height: 16),

                // Footer Pagination
                _buildFooter(filtered.length),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Mobile Filters Section (Search & Date Picker)
  Widget _buildFilterSection() {
    final dateStr = DateFormat('dd/MM/yyyy').format(_selectedDate);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Search Input Field
        Text(
          'Search',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppConstant.textPrimary(context),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          height: 55,
          decoration: BoxDecoration(
            color: AppConstant.cardBg(context),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppConstant.border(context)),
          ),
          child: TextField(
            controller: _searchController,
            onChanged: (val) {
              setState(() {
                _searchQuery = val;
              });
            },
            decoration: InputDecoration(
              hintText: 'Search by name or ID',
              hintStyle: TextStyle(
                fontSize: 15,
                color: AppConstant.textHint(context),
              ),
              prefixIcon: Icon(
                Icons.search,
                size: 20,
                color: AppConstant.primarycolor,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Date Picker Field
        Text(
          'Date',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppConstant.textPrimary(context),
          ),
        ),
        const SizedBox(height: 6),
        InkWell(
          onTap: () => _selectDate(context),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            height: 55,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: AppConstant.cardBg(context),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppConstant.border(context)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  dateStr,
                  style: TextStyle(
                    fontSize: 16,
                    color: AppConstant.textHint(context),
                  ),
                ),
                Icon(
                  Icons.calendar_today_outlined,
                  size: 18,
                  color: AppConstant.textSecondary(context),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Attendance Table Card
  Widget _buildTableCard(List<EmployeeAttendance> filteredList) {
    return Container(
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
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 900),
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(
                AppConstant.primarycolor,
              ),
              headingRowHeight: 48,
              dataRowMinHeight: 56,
              dataRowMaxHeight: 64,
              horizontalMargin: 20,
              columnSpacing: 24,
              dividerThickness: 0.5,
              columns:  [
                DataColumn(
                  label: Text(
                    '#',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                          color: AppConstant.textPrimary(context),
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'EMPLOYEE',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                          color: AppConstant.textPrimary(context),
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'STATUS',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                          color: AppConstant.textPrimary(context),
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'CHECK-IN',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                          color: AppConstant.textPrimary(context),
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'CHECK-OUT',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                          color: AppConstant.textPrimary(context),
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'ACTION',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                          color: AppConstant.textPrimary(context),
                    ),
                  ),
                ),
              ],
              rows: List.generate(filteredList.length, (index) {
                final emp = filteredList[index];
                final rowIndex = index + 1;

                return DataRow(
                  cells: [
                    // Row Index
                    DataCell(
                      Text(
                        '$rowIndex',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppConstant.textPrimary(context),
                          fontSize: 13,
                        ),
                      ),
                    ),

                    // Employee ID & Name
                    DataCell(
                      Text(
                        emp.displayEmp,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: AppConstant.textPrimary(context),
                          fontSize: 13,
                        ),
                      ),
                    ),

                    // Status Radio Buttons
                    DataCell(_buildStatusRadioGroup(emp)),

                    // Check-In Time
                    DataCell(
                      Text(
                        emp.checkIn ?? 'N/A',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppConstant.textSecondary(context),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    // Check-Out Time
                    DataCell(
                      Text(
                        emp.checkOut ?? 'N/A',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppConstant.textSecondary(context),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    // Action Buttons (View, Edit, Reset)
                    DataCell(_buildActionButtons(emp)),
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  /// Status Radio Buttons Row
  Widget _buildStatusRadioGroup(EmployeeAttendance emp) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildCustomRadioOption(
          label: 'Present',
          status: AttendanceStatus.present,
          emp: emp,
        ),
        const SizedBox(width: 14),
        _buildCustomRadioOption(
          label: 'WFH',
          status: AttendanceStatus.wfh,
          emp: emp,
        ),
        const SizedBox(width: 14),
        _buildCustomRadioOption(
          label: 'Absent',
          status: AttendanceStatus.absent,
          emp: emp,
        ),
        const SizedBox(width: 14),
        _buildCustomRadioOption(
          label: 'Leave',
          status: AttendanceStatus.leave,
          emp: emp,
        ),
      ],
    );
  }

  /// Individual Custom Radio Widget
  Widget _buildCustomRadioOption({
    required String label,
    required AttendanceStatus status,
    required EmployeeAttendance emp,
  }) {
    final isSelected = emp.status == status;

    return InkWell(
      onTap: () {
        setState(() {
          emp.status = status;
          if (status == AttendanceStatus.present ||
              status == AttendanceStatus.wfh) {
            emp.checkIn = '09:00 AM';
            emp.checkOut = '06:00 PM';
          } else {
            emp.checkIn = null;
            emp.checkOut = null;
          }
        });
      },
      borderRadius: BorderRadius.circular(16),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected
                    ? AppConstant.primarycolor
                    : AppConstant.border(context),
                width: isSelected ? 5 : 1.5,
              ),
              color: AppConstant.cardBg(context),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              color: isSelected
                  ? AppConstant.textPrimary(context)
                  : AppConstant.textSecondary(context),
            ),
          ),
        ],
      ),
    );
  }

  /// Action Buttons (View, Edit, Reset)
  Widget _buildActionButtons(EmployeeAttendance emp) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildIconButton(
          icon: Icons.remove_red_eye_outlined,
          tooltip: 'View',
          onTap: () => _viewAttendanceDetail(emp),
        ),
        const SizedBox(width: 6),
        _buildIconButton(
          icon: Icons.person_add_alt_1_outlined,
          tooltip: 'Edit / Assign',
          onTap: () => _editAttendance(emp),
        ),
        const SizedBox(width: 6),
        _buildIconButton(
          icon: Icons.refresh_rounded,
          tooltip: 'Reset',
          onTap: () => _resetEmployeeStatus(emp),
        ),
      ],
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onTap,
  }) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: AppConstant.cardBg(context),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: AppConstant.border(context)),
          ),
          child: Icon(
            icon,
            size: 16,
            color: AppConstant.primarycolor,
          ),
        ),
      ),
    );
  }

  /// Mobile Footer & Pagination Bar
  Widget _buildFooter(int totalRecords) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Show Entries & Summary Info
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Show',
              style: TextStyle(fontSize: 13, color: AppConstant.textSecondary(context)),
            ),
            const SizedBox(width: 8),
            Container(
              height: 32,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: AppConstant.cardBg(context),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: AppConstant.border(context)),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  value: _rowsPerPage,
                  icon: const Icon(Icons.keyboard_arrow_down, size: 16),
                  style: TextStyle(
                    fontSize: 13,
                    color: AppConstant.textHint(context),
                    fontWeight: FontWeight.w500,
                  ),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        _rowsPerPage = val;
                      });
                    }
                  },
                  items: [10, 25, 50, 100].map((int val) {
                    return DropdownMenuItem<int>(
                      value: val,
                      child: Text('$val'),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'entries',
              style: TextStyle(fontSize: 13, color: AppConstant.textSecondary(context)),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Current page: $_currentPage – Records: $totalRecords of $totalRecords',
          style: TextStyle(
            fontSize: 13,
            color: AppConstant.textHint(context),
          ),
        ),
        const SizedBox(height: 12),

        // Pagination Buttons (Centered for Mobile)
        Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildPaginationBtn('«'),
              const SizedBox(width: 4),
              _buildPaginationBtn('<'),
              const SizedBox(width: 4),
              _buildPaginationBtn('1', isSelected: true),
              const SizedBox(width: 4),
              _buildPaginationBtn('>'),
              const SizedBox(width: 4),
              _buildPaginationBtn('»'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaginationBtn(String text, {bool isSelected = false}) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color:
            isSelected ? AppConstant.primarycolor : AppConstant.cardBg(context),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isSelected
              ? AppConstant.primarycolor
              : AppConstant.border(context),
        ),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? Colors.white : AppConstant.textHint(context),
          ),
        ),
      ),
    );
  }
}
