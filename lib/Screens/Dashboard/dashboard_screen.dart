import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:lecture/theme_provider.dart';
import 'package:lecture/widgets/shimmer_widgets.dart';
import 'package:lecture/Screens/Administration/department.dart';
import 'package:lecture/Screens/Administration/document_type.dart';
import 'package:lecture/Screens/Administration/vendor_management.dart';
import 'package:lecture/Screens/Assets_management/assets.dart';
import 'package:lecture/Screens/Assets_management/assign.dart';
import 'package:lecture/Screens/Assets_management/categories.dart';
import 'package:lecture/Screens/Assets_management/maintenance.dart';
import 'package:lecture/Screens/Document_management/assignment.dart';
import 'package:lecture/Screens/Document_management/audit_log.dart';
import 'package:lecture/Screens/Document_management/templates.dart';
import 'package:lecture/Screens/Expense_Management/all_requests.dart';
import 'package:lecture/Screens/Expense_Management/approval.dart';
import 'package:lecture/Screens/Expense_Management/approval_pipelines.dart';
import 'package:lecture/Screens/Expense_Management/category.dart';
import 'package:lecture/Screens/Expense_Management/create_request.dart';
import 'package:lecture/Screens/Kpi_management/kpi_dashboard.dart';
import 'package:lecture/Screens/Leave_management/apply_leave.dart';
import 'package:lecture/Screens/Leave_management/leave_approval.dart';
import 'package:lecture/Screens/Loan_management/loan.dart';
import 'package:lecture/Screens/Loan_management/loan_type.dart';
import 'package:lecture/Screens/Loan_management/repayments.dart';
import 'package:lecture/Screens/Payroll_management/deductions_rules.dart';
import 'package:lecture/Screens/Payroll_management/payroll_approval.dart';
import 'package:lecture/Screens/Payroll_management/payroll_history.dart';
import 'package:lecture/Screens/Payroll_management/payroll_run.dart';
import 'package:lecture/Screens/Payroll_management/salary_slip.dart';
import 'package:lecture/Screens/Payroll_management/salary_structure.dart';
import 'package:lecture/Screens/Recruitment/dashboard_recruitment.dart';
import 'package:lecture/Screens/Recruitment/interviews.dart';
import 'package:lecture/Screens/Recruitment/job_positions.dart';
import 'package:lecture/Screens/Recruitment/pipeline_board.dart';
import 'package:lecture/Screens/Recruitment/pipeline_builder.dart';
import 'package:lecture/Screens/Reports/assets_report.dart';
import 'package:lecture/Screens/Reports/employee_report.dart';
import 'package:lecture/Screens/Reports/expense_report.dart';
import 'package:lecture/Screens/Reports/kpi_report.dart';
import 'package:lecture/Screens/Reports/loan_report.dart';
import 'package:lecture/Screens/Reports/monthly_attendance.dart';
import 'package:lecture/Screens/Reports/payroll_reports.dart';
import 'package:lecture/Screens/Reports/recruitment_report.dart';
import 'package:lecture/Screens/Wallet_management/all_wallets.dart';
import 'package:lecture/Screens/Wallet_management/bulk_operations.dart';
import 'package:lecture/Screens/Wallet_management/pending_approval.dart';
import 'package:lecture/Screens/Wallet_management/policies.dart';
import 'package:lecture/appcolor.dart';
import 'package:lecture/screens/attendance/attendance_screen.dart';
import 'package:lecture/screens/attendance/employeeshift.dart';
import 'package:lecture/screens/attendance/faceattendance.dart';
import 'package:lecture/screens/attendance/monthlyhour.dart';
import 'package:lecture/screens/attendance/publiccalender.dart';
import 'package:lecture/screens/attendance/timeslot.dart';
import 'package:lecture/screens/login_screen.dart';

import '../Employee_management/employee_management.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String currentDate = DateFormat('EEEE, MMMM d, yyyy').format(DateTime.now());
  int selectedIndex = 1;
  int _attendanceSelectedTab = 0;
  int _financialSelectedTab = 0;
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
        title: Text(
          "Executive Dashboard",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppConstant.textPrimary(context)),
        ),
      ),
      drawerEnableOpenDragGesture: true,
      drawerEdgeDragWidth: 80, // Optional
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: AppConstant.appBarBg(context)),
              accountName: Text(
                "Adnan Aqeel",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppConstant.textPrimary(context)),
              ),
              accountEmail: Text(
                "adnan@gmail.com",
                style: TextStyle(color: AppConstant.textPrimary(context)),
              ),
              currentAccountPicture: CircleAvatar(
                radius: 35,
                backgroundColor: Colors.black,
                child: ClipOval(
                  child: Image.asset(
                    "assets/magnitude.png",
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            ListTile(
              dense: true,
              minTileHeight: 40,
              visualDensity: const VisualDensity(vertical: -3),
              leading: Icon(Icons.dashboard, color: Color(0xFF2563EB)),
              title: const Text("Dashboard", style: TextStyle(fontSize: 15)),
              onTap: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => DashboardScreen()));
              },
            ),
            ListTile(
              dense: true,
              minTileHeight: 40,
              visualDensity: const VisualDensity(vertical: -3),
              leading: Icon(Icons.people, color: Color(0xFF8B5CF6)),
              title: const Text("Employee Management",
                  style: TextStyle(fontSize: 15)),
              onTap: () async {
                await Future.delayed(const Duration(milliseconds: 150));
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Employeemanagement()));
              },
            ),
            ListTile(
              dense: true,
              minTileHeight: 40,
              visualDensity: const VisualDensity(vertical: -3),
              leading: Icon(Icons.my_location, color: Color(0xFF7C3AED)),
              title:
                  const Text("KPI Management", style: TextStyle(fontSize: 15)),
              onTap: () async {
                await Future.delayed(const Duration(milliseconds: 150));
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => KpiDashboardScreen()));
              },
            ),
            ExpansionTile(
              visualDensity: const VisualDensity(vertical: -3),
              leading:
                  const Icon(Icons.add_home_outlined, color: Color(0xFFF97316)),
              title: const Text(
                "Administration",
                style: TextStyle(fontSize: 15),
              ),
              childrenPadding: const EdgeInsets.only(left: 35),
              tilePadding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                ListTile(
                  dense: true,
                  minTileHeight: 40,
                  visualDensity: const VisualDensity(vertical: -3),
                  leading: Icon(Icons.fact_check_outlined,
                      size: 18, color: Color(0xFFF59E0B)),
                  title: const Text("Department"),
                  onTap: () async {
                    await Future.delayed(const Duration(milliseconds: 150));
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DepartmentScreen()));
                  },
                ),
                ListTile(
                  dense: true,
                  minTileHeight: 40,
                  visualDensity: const VisualDensity(vertical: -3),
                  leading: Icon(Icons.dashboard_customize,
                      size: 18, color: Color(0xFFF97316)),
                  title: const Text("Document Type"),
                  onTap: () async {
                    await Future.delayed(const Duration(milliseconds: 150));
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DocumentTypeScreen()));
                  },
                ),
                ListTile(
                  dense: true,
                  minTileHeight: 40,
                  visualDensity: const VisualDensity(vertical: -3),
                  leading: Icon(Icons.shopping_cart,
                      size: 18, color: Color(0xFFEA580C)),
                  title: const Text("Vendor"),
                  onTap: () async {
                    await Future.delayed(const Duration(milliseconds: 150));
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => VendorManagement()));
                  },
                ),
              ],
            ),
            ExpansionTile(
              visualDensity: const VisualDensity(vertical: -3),
              leading: const Icon(Icons.access_time, color: Color(0xFF16A34A)),
              title: const Text(
                "Attendance Tracking",
                style: TextStyle(fontSize: 15),
              ),
              childrenPadding: const EdgeInsets.only(left: 35),
              tilePadding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                ListTile(
                  dense: true,
                  minTileHeight: 40,
                  visualDensity: const VisualDensity(vertical: -3),
                  leading: Icon(Icons.fact_check_outlined,
                      size: 18, color: Color(0xFFF59E0B)),
                  title: const Text("Attendance Record"),
                  onTap: () async {
                    await Future.delayed(const Duration(milliseconds: 150));
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AttendanceScreen()));
                  },
                ),
                ListTile(
                  dense: true,
                  minTileHeight: 40,
                  visualDensity: const VisualDensity(vertical: -3),
                  leading: Icon(Icons.calendar_month_outlined,
                      size: 18, color: Color(0xFF0D9488)),
                  title: const Text("Public Calendar"),
                  onTap: () async {
                    await Future.delayed(const Duration(milliseconds: 150));
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Publiccalender()));
                  },
                ),
                ListTile(
                  dense: true,
                  minTileHeight: 40,
                  visualDensity: const VisualDensity(vertical: -3),
                  leading: Icon(Icons.schedule_outlined,
                      size: 18, color: Color(0xFF059669)),
                  title: const Text("Monthly Hours Record"),
                  onTap: () async {
                    await Future.delayed(const Duration(milliseconds: 150));
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Monthlyhour()));
                  },
                ),
                ListTile(
                  dense: true,
                  minTileHeight: 40,
                  visualDensity: const VisualDensity(vertical: -3),
                  leading: Icon(Icons.groups_outlined,
                      size: 18, color: Color(0xFF22C55E)),
                  title: const Text("Employees Shift Record"),
                  onTap: () async {
                    await Future.delayed(const Duration(milliseconds: 150));
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Employeeshift()));
                  },
                ),
                ListTile(
                  dense: true,
                  minTileHeight: 40,
                  visualDensity: const VisualDensity(vertical: -3),
                  leading: Icon(Icons.more_time_outlined,
                      size: 18, color: Color(0xFF14B8A6)),
                  title: const Text("Time Slots"),
                  onTap: () async {
                    await Future.delayed(Duration(milliseconds: 150));
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Timeslot()));
                  },
                ),
                ListTile(
                  dense: true,
                  minTileHeight: 40,
                  visualDensity: const VisualDensity(vertical: -3),
                  leading: Icon(Icons.face_outlined,
                      size: 18, color: Color(0xFF10B981)),
                  title: const Text("Face Attendance"),
                  onTap: () async {
                    await Future.delayed(const Duration(milliseconds: 150));
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Faceattendance()));
                  },
                ),
              ],
            ),
            ExpansionTile(
              visualDensity: const VisualDensity(vertical: -3),
              leading:
                  const Icon(Icons.receipt_outlined, color: Color(0xFFDB2777)),
              title: const Text(
                "Recruitment",
                style: TextStyle(fontSize: 15),
              ),
              childrenPadding: const EdgeInsets.only(left: 35),
              tilePadding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                ListTile(
                  dense: true,
                  minTileHeight: 40,
                  visualDensity: const VisualDensity(vertical: -3),
                  leading:
                      Icon(Icons.bar_chart, size: 18, color: Color(0xFFEC4899)),
                  title: const Text("Dashboard"),
                  onTap: () async {
                    await Future.delayed(const Duration(milliseconds: 150));
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RecruitmentDashboard()));
                  },
                ),
                ListTile(
                  dense: true,
                  minTileHeight: 40,
                  visualDensity: const VisualDensity(vertical: -3),
                  leading: Icon(Icons.bookmark_add_rounded,
                      size: 18, color: Color(0xFFBE185D)),
                  title: const Text("Pipeline Board"),
                  onTap: () async {
                    await Future.delayed(const Duration(milliseconds: 150));
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PipelineBoard()));
                  },
                ),
                ListTile(
                  dense: true,
                  minTileHeight: 40,
                  visualDensity: const VisualDensity(vertical: -3),
                  leading:
                      Icon(Icons.tab_sharp, size: 18, color: Color(0xFFF43F5E)),
                  title: const Text("Pipeline Templates"),
                  onTap: () async {
                    await Future.delayed(const Duration(milliseconds: 150));
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PipelineBuilder()));
                  },
                ),
                ListTile(
                  dense: true,
                  minTileHeight: 40,
                  visualDensity: const VisualDensity(vertical: -3),
                  leading: Icon(Icons.point_of_sale,
                      size: 18, color: Color(0xFFE11D48)),
                  title: const Text("Job Positions"),
                  onTap: () async {
                    await Future.delayed(const Duration(milliseconds: 150));
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => JobPositions()));
                  },
                ),
                ListTile(
                  dense: true,
                  minTileHeight: 40,
                  visualDensity: const VisualDensity(vertical: -3),
                  leading: Icon(Icons.interpreter_mode,
                      size: 18, color: Color(0xFF9D174D)),
                  title: const Text("Interviews"),
                  onTap: () async {
                    await Future.delayed(const Duration(milliseconds: 150));
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Interviews()));
                  },
                ),
              ],
            ),
            ExpansionTile(
              visualDensity: const VisualDensity(vertical: -3),
              leading: const Icon(Icons.access_time, color: Color(0xFFF59E0B)),
              title: const Text(
                "Leave Management",
                style: TextStyle(fontSize: 15),
              ),
              childrenPadding: const EdgeInsets.only(left: 35),
              tilePadding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                ListTile(
                  dense: true,
                  minTileHeight: 40,
                  visualDensity: const VisualDensity(vertical: -3),
                  leading: Icon(Icons.leaderboard,
                      size: 18, color: Color(0xFFF59E0B)),
                  title: const Text("Apply Leave"),
                  onTap: () async {
                    await Future.delayed(const Duration(milliseconds: 150));
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ApplyLeave()));
                  },
                ),
                ListTile(
                  dense: true,
                  minTileHeight: 40,
                  visualDensity: const VisualDensity(vertical: -3),
                  leading: Icon(Icons.add_circle_outline_sharp,
                      size: 18, color: Color(0xFFD97706)),
                  title: const Text("Leave Approval"),
                  onTap: () async {
                    await Future.delayed(const Duration(milliseconds: 150));
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LeaveApproval()));
                  },
                ),
              ],
            ),
            ExpansionTile(
              visualDensity: const VisualDensity(vertical: -3),
              title: Text("Assets Management", style: TextStyle(fontSize: 15)),
              leading:
                  Icon(Icons.calendar_month_outlined, color: Color(0xFFF97316)),
              childrenPadding: EdgeInsets.only(left: 35),
              tilePadding: EdgeInsets.symmetric(horizontal: 16),
              children: [
                ListTile(
                  dense: true,
                  minTileHeight: 40,
                  visualDensity: const VisualDensity(vertical: -3),
                  leading: const Icon(Icons.category,
                      size: 18, color: Color(0xFFF97316)),
                  title: const Text("Categories"),
                  onTap: () async {
                    await Future.delayed(const Duration(milliseconds: 150));
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CategoriesScreen()));
                  },
                ),
                ListTile(
                  dense: true,
                  minTileHeight: 40,
                  visualDensity: const VisualDensity(vertical: -3),
                  leading: const Icon(Icons.assessment_sharp,
                      size: 18, color: Color(0xFFEA580C)),
                  title: const Text("Assets"),
                  onTap: () async {
                    await Future.delayed(const Duration(milliseconds: 150));
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AssetsScreen()));
                  },
                ),
                ListTile(
                  dense: true,
                  minTileHeight: 40,
                  visualDensity: const VisualDensity(vertical: -3),
                  leading: const Icon(Icons.person_add_alt,
                      size: 18, color: Color(0xFFFB923C)),
                  title: const Text("Assignment"),
                  onTap: () async {
                    await Future.delayed(const Duration(milliseconds: 150));
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AssignScreen()));
                  },
                ),
                ListTile(
                  dense: true,
                  minTileHeight: 40,
                  visualDensity: const VisualDensity(vertical: -3),
                  leading: const Icon(Icons.recommend,
                      size: 18, color: Color(0xFFDC2626)),
                  title: const Text("Maintenance"),
                  onTap: () async {
                    await Future.delayed(const Duration(milliseconds: 150));
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MaintenanceScreen()));
                  },
                ),
              ],
            ),
            ExpansionTile(
              visualDensity: const VisualDensity(vertical: -3),
              title: Text("Wallet Management", style: TextStyle(fontSize: 15)),
              leading: Icon(Icons.wallet, color: Color(0xFF16A34A)),
              childrenPadding: EdgeInsets.only(left: 35),
              tilePadding: EdgeInsets.symmetric(horizontal: 16),
              children: [
                ListTile(
                  dense: true,
                  minTileHeight: 40,
                  visualDensity: const VisualDensity(vertical: -3),
                  leading: const Icon(Icons.wallet_giftcard,
                      size: 18, color: Color(0xFF22C55E)),
                  title: const Text("All Wallets"),
                  onTap: () async {
                    await Future.delayed(const Duration(milliseconds: 150));
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WalletManagementScreen()));
                  },
                ),
                ListTile(
                  dense: true,
                  minTileHeight: 40,
                  visualDensity: const VisualDensity(vertical: -3),
                  leading: const Icon(Icons.pending_actions,
                      size: 18, color: Color(0xFFCA8A04)),
                  title: const Text("Pending Approvals"),
                  onTap: () async {
                    await Future.delayed(const Duration(milliseconds: 150));
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ApprovalQueueScreen()));
                  },
                ),
                ListTile(
                  dense: true,
                  minTileHeight: 40,
                  visualDensity: const VisualDensity(vertical: -3),
                  leading: const Icon(Icons.open_in_new_rounded,
                      size: 18, color: Color(0xFF65A30D)),
                  title: const Text("Bulk Operations"),
                  onTap: () async {
                    await Future.delayed(const Duration(milliseconds: 150));
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BulkOperationsScreen()));
                  },
                ),
                ListTile(
                  dense: true,
                  minTileHeight: 40,
                  visualDensity: const VisualDensity(vertical: -3),
                  leading: const Icon(Icons.policy,
                      size: 18, color: Color(0xFF15803D)),
                  title: const Text("Policies"),
                  onTap: () async {
                    await Future.delayed(const Duration(milliseconds: 150));
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ApprovalPoliciesScreen()));
                  },
                ),
              ],
            ),
            ExpansionTile(
              visualDensity: const VisualDensity(vertical: -3),
              title: Text("Loan Management", style: TextStyle(fontSize: 15)),
              leading: Icon(Icons.work_outline, color: Color(0xFF2563EB)),
              childrenPadding: EdgeInsets.only(left: 35),
              tilePadding: EdgeInsets.symmetric(horizontal: 16),
              children: [
                ListTile(
                  dense: true,
                  minTileHeight: 40,
                  visualDensity: const VisualDensity(vertical: -3),
                  leading: const Icon(Icons.description_outlined,
                      size: 18, color: Color(0xFF3B82F6)),
                  title: const Text("Loan Types"),
                  onTap: () async {
                    await Future.delayed(const Duration(milliseconds: 150));
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LoanTypeScreen()));
                  },
                ),
                ListTile(
                  dense: true,
                  minTileHeight: 40,
                  visualDensity: const VisualDensity(vertical: -3),
                  leading: const Icon(Icons.description_outlined,
                      size: 18, color: Color(0xFF3B82F6)),
                  title: const Text("Loan"),
                  onTap: () async {
                    await Future.delayed(const Duration(milliseconds: 150));
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LoanManagement()));
                  },
                ),
                ListTile(
                  dense: true,
                  minTileHeight: 40,
                  visualDensity: const VisualDensity(vertical: -3),
                  leading: const Icon(Icons.money_off_outlined,
                      size: 18, color: Color(0xFF1D4ED8)),
                  title: const Text("Repayments"),
                  onTap: () async {
                    await Future.delayed(const Duration(milliseconds: 150));
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Repayments()));
                  },
                ),
              ],
            ),
            ExpansionTile(
              visualDensity: const VisualDensity(vertical: -3),
              title: Text("Expense Management", style: TextStyle(fontSize: 15)),
              leading:
                  Icon(Icons.description_outlined, color: Color(0xFFEF4444)),
              childrenPadding: EdgeInsets.only(left: 35),
              tilePadding: EdgeInsets.symmetric(horizontal: 16),
              children: [
                ListTile(
                  dense: true,
                  minTileHeight: 40,
                  visualDensity: const VisualDensity(vertical: -3),
                  leading: const Icon(Icons.category_sharp,
                      size: 18, color: Color(0xFFEF4444)),
                  title: const Text("category"),
                  onTap: () async {
                    await Future.delayed(const Duration(milliseconds: 150));
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CategoryScreen()));
                  },
                ),
                ListTile(
                  dense: true,
                  minTileHeight: 40,
                  visualDensity: const VisualDensity(vertical: -3),
                  leading: const Icon(Icons.request_page,
                      size: 18, color: Color(0xFFF97316)),
                  title: const Text("Requests"),
                  onTap: () async {
                    await Future.delayed(const Duration(milliseconds: 150));
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                CreateExpenseRequestScreen()));
                  },
                ),
                ListTile(
                  dense: true,
                  minTileHeight: 40,
                  visualDensity: const VisualDensity(vertical: -3),
                  leading: const Icon(Icons.request_quote_rounded,
                      size: 18, color: Color(0xFFEA580C)),
                  title: const Text("All Requests"),
                  onTap: () async {
                    await Future.delayed(const Duration(milliseconds: 150));
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AllRequestsScreen()));
                  },
                ),
                ListTile(
                  dense: true,
                  minTileHeight: 40,
                  visualDensity: const VisualDensity(vertical: -3),
                  leading: const Icon(Icons.pin_end_outlined,
                      size: 18, color: Color(0xFFDC2626)),
                  title: const Text("Approval Pipeline"),
                  onTap: () async {
                    await Future.delayed(const Duration(milliseconds: 150));
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ApprovalPipelinesScreen()));
                  },
                ),
                ListTile(
                  dense: true,
                  minTileHeight: 40,
                  visualDensity: const VisualDensity(vertical: -3),
                  leading: const Icon(Icons.approval,
                      size: 18, color: Color(0xFFB91C1C)),
                  title: const Text("Approvals"),
                  onTap: () async {
                    await Future.delayed(const Duration(milliseconds: 150));
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ApprovalScreen()));
                  },
                ),
              ],
            ),
            ExpansionTile(
              visualDensity: const VisualDensity(vertical: -3),
              title: Text("Pyroll Management", style: TextStyle(fontSize: 15)),
              leading: Icon(Icons.attach_money, color: Color(0xFF0D9488)),
              childrenPadding: EdgeInsets.only(left: 35),
              tilePadding: EdgeInsets.symmetric(horizontal: 16),
              children: [
                ListTile(
                  dense: true,
                  minTileHeight: 40,
                  visualDensity: const VisualDensity(vertical: -3),
                  leading: const Icon(Icons.money,
                      size: 18, color: Color(0xFF14B8A6)),
                  title: const Text("Salary Structure"),
                  onTap: () async {
                    await Future.delayed(const Duration(milliseconds: 150));
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SalaryStructureScreen()));
                  },
                ),
                ListTile(
                  dense: true,
                  minTileHeight: 40,
                  visualDensity: const VisualDensity(vertical: -3),
                  leading: const Icon(Icons.request_page, size: 18),
                  title: const Text("Payroll Run"),
                  onTap: () async {
                    await Future.delayed(const Duration(milliseconds: 150));
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PayrollRunScreen()));
                  },
                ),
                ListTile(
                  dense: true,
                  minTileHeight: 40,
                  visualDensity: const VisualDensity(vertical: -3),
                  leading: const Icon(Icons.request_quote_rounded, size: 18),
                  title: const Text("Payroll Approval"),
                  onTap: () async {
                    await Future.delayed(const Duration(milliseconds: 150));
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PayrollApprovalScreen()));
                  },
                ),
                ListTile(
                  dense: true,
                  minTileHeight: 40,
                  visualDensity: const VisualDensity(vertical: -3),
                  leading: const Icon(Icons.chat_bubble,
                      size: 18, color: Color(0xFF0891B2)),
                  title: const Text("Salary Slip"),
                  onTap: () async {
                    await Future.delayed(const Duration(milliseconds: 150));
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SalarySlipScreen()));
                  },
                ),
                ListTile(
                  dense: true,
                  minTileHeight: 40,
                  visualDensity: const VisualDensity(vertical: -3),
                  leading: const Icon(Icons.history,
                      size: 18, color: Color(0xFF0E7490)),
                  title: const Text("Payroll History"),
                  onTap: () async {
                    await Future.delayed(const Duration(milliseconds: 150));
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PayrollHistoryScreen()));
                  },
                ),
                ListTile(
                  dense: true,
                  minTileHeight: 40,
                  visualDensity: const VisualDensity(vertical: -3),
                  leading: const Icon(Icons.density_medium,
                      size: 18, color: Color(0xFF155E75)),
                  title: const Text("Deduction Rules"),
                  onTap: () async {
                    await Future.delayed(const Duration(milliseconds: 150));
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DeductionsRulesScreen()));
                  },
                ),
              ],
            ),
            ExpansionTile(
              visualDensity: const VisualDensity(vertical: -3),
              leading: const Icon(Icons.document_scanner_rounded,
                  color: Color(0xFF0891B2)),
              title: const Text(
                "Document Management",
                style: TextStyle(fontSize: 15),
              ),
              childrenPadding: const EdgeInsets.only(left: 35),
              tilePadding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                ListTile(
                  dense: true,
                  minTileHeight: 40,
                  visualDensity: const VisualDensity(vertical: -3),
                  leading: const Icon(Icons.leaderboard,
                      size: 18, color: Color(0xFF0D9488)),
                  title: const Text("Templates"),
                  onTap: () async {
                    await Future.delayed(const Duration(milliseconds: 150));
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DocumentTemplates()));
                  },
                ),
                ListTile(
                  dense: true,
                  minTileHeight: 40,
                  visualDensity: const VisualDensity(vertical: -3),
                  leading: const Icon(Icons.add_circle_outline_sharp,
                      size: 18, color: Color(0xFF14B8A6)),
                  title: const Text("Assignment"),
                  onTap: () async {
                    await Future.delayed(const Duration(milliseconds: 150));
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DocumentAssignments()));
                  },
                ),
                ListTile(
                  dense: true,
                  minTileHeight: 40,
                  visualDensity: const VisualDensity(vertical: -3),
                  leading: const Icon(Icons.add_circle_outline_sharp,
                      size: 18, color: Color(0xFF0E7490)),
                  title: const Text("Audit Log"),
                  onTap: () async {
                    await Future.delayed(const Duration(milliseconds: 150));
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AuditLog()));
                  },
                ),
              ],
            ),
            ExpansionTile(
              visualDensity: const VisualDensity(vertical: -3),
              title: Text("Report", style: TextStyle(fontSize: 15)),
              leading: Icon(Icons.report, color: Color(0xFF7C3AED)),
              childrenPadding: EdgeInsets.only(left: 35),
              tilePadding: EdgeInsets.symmetric(horizontal: 16),
              children: [
                ListTile(
                  dense: true,
                  minTileHeight: 40,
                  visualDensity: const VisualDensity(vertical: -3),
                  leading: const Icon(Icons.report,
                      size: 18, color: Color(0xFF7C3AED)),
                  title: const Text("Payroll Report"),
                  onTap: () async {
                    await Future.delayed(const Duration(milliseconds: 150));
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PayrollReportsScreen()));
                  },
                ),
                ListTile(
                  dense: true,
                  minTileHeight: 40,
                  visualDensity: const VisualDensity(vertical: -3),
                  leading: const Icon(Icons.report,
                      size: 18, color: Color(0xFF8B5CF6)),
                  title: const Text("Monthly Attendance"),
                  onTap: () async {
                    await Future.delayed(const Duration(milliseconds: 150));
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MonthlyAttendanceScreen()));
                  },
                ),
                ListTile(
                  dense: true,
                  minTileHeight: 40,
                  visualDensity: const VisualDensity(vertical: -3),
                  leading: const Icon(Icons.report,
                      size: 18, color: Color(0xFFF97316)),
                  title: const Text("Assets Report"),
                  onTap: () async {
                    await Future.delayed(const Duration(milliseconds: 150));
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AssetsReportScreen()));
                  },
                ),
                ListTile(
                  dense: true,
                  minTileHeight: 40,
                  visualDensity: const VisualDensity(vertical: -3),
                  leading: const Icon(Icons.report,
                      size: 18, color: Color(0xFFEA580C)),
                  title: const Text("Employees Report"),
                  onTap: () async {
                    await Future.delayed(const Duration(milliseconds: 150));
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EmployeeReportScreen()));
                  },
                ),
                ListTile(
                  dense: true,
                  minTileHeight: 40,
                  visualDensity: const VisualDensity(vertical: -3),
                  leading: const Icon(Icons.report,
                      size: 18, color: Color(0xFF2563EB)),
                  title: const Text("Loan Report"),
                  onTap: () async {
                    await Future.delayed(const Duration(milliseconds: 150));
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LoanReportScreen()));
                  },
                ),
                ListTile(
                  dense: true,
                  minTileHeight: 40,
                  visualDensity: const VisualDensity(vertical: -3),
                  leading: const Icon(Icons.report,
                      size: 18, color: Color(0xFF1D4ED8)),
                  title: const Text("Expense Report"),
                  onTap: () async {
                    await Future.delayed(const Duration(milliseconds: 150));
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ExpenseReportScreen()));
                  },
                ),
                ListTile(
                  dense: true,
                  minTileHeight: 40,
                  visualDensity: const VisualDensity(vertical: -3),
                  leading: const Icon(Icons.report,
                      size: 18, color: Color(0xFFDC2626)),
                  title: const Text("KPI Report"),
                  onTap: () async {
                    await Future.delayed(const Duration(milliseconds: 150));
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => KpiReportScreen()));
                  },
                ),
                ListTile(
                  dense: true,
                  minTileHeight: 40,
                  visualDensity: const VisualDensity(vertical: -3),
                  leading: const Icon(Icons.report,
                      size: 18, color: Color(0xFF16A34A)),
                  title: const Text("Recruitment Report"),
                  onTap: () async {
                    await Future.delayed(const Duration(milliseconds: 150));
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RecruitmentReportScreen()));
                  },
                ),
              ],
            ),
            const Divider(),
            Consumer<ThemeProvider>(
              builder: (context, themeProvider, child) {
                return ListTile(
                  dense: true,
                  minTileHeight: 40,
                  visualDensity: const VisualDensity(vertical: -3),
                  leading: Icon(
                    themeProvider.isDark ? Icons.dark_mode : Icons.light_mode,
                    color: themeProvider.isDark ? Colors.amber : Colors.blue,
                  ),
                  title: Text(
                    themeProvider.isDark ? "Dark Mode" : "Light Mode",
                    style: const TextStyle(fontSize: 15),
                  ),
                  trailing: Switch(
                    value: themeProvider.isDark,
                    onChanged: (_) => themeProvider.toggleTheme(),
                    activeColor: AppConstant.primarycolor,
                  ),
                  onTap: () => themeProvider.toggleTheme(),
                );
              },
            ),
            ListTile(
              dense: true,
              minTileHeight: 40,
              visualDensity: const VisualDensity(vertical: -3),
              leading: const Icon(
                Icons.logout,
                color: Colors.red,
              ),
              title: const Text(
                "Logout",
                style: TextStyle(color: Colors.red, fontSize: 15),
              ),
              onTap: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
            ),
          ],
        ),
      ),
      body: ScreenShimmerWrapper(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 12, bottom: 4),
                    child: Text(
                      currentDate,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = 0;
                      });
                    },
                    child: Container(
                      height: 40.h,
                      width: (MediaQuery.sizeOf(context).width * .42)
                          .clamp(132.0, 220.0)
                          .toDouble(),
                      decoration: BoxDecoration(
                        color: selectedIndex == 0
                            ? const Color(0xFF22D3EE)
                            : Colors.transparent,
                        border: Border.all(color: const Color(0xFF22D3EE)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Icon(
                            Icons.alarm,
                            color: selectedIndex == 0
                                ? Colors.white
                                : const Color(0xFF22D3EE),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          AttendanceScreen()));
                            },
                            child: Text(
                              "Attendance",
                              style: TextStyle(
                                color: selectedIndex == 0
                                    ? Colors.white
                                    : const Color(0xFF22D3EE),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = 1;
                      });
                    },
                    child: Container(
                      height: 40.h,
                      width: (MediaQuery.sizeOf(context).width * .42)
                          .clamp(132.0, 220.0)
                          .toDouble(),
                      decoration: BoxDecoration(
                        color: selectedIndex == 1
                            ? const Color(0xFF22D3EE)
                            : Colors.transparent,
                        border: Border.all(color: const Color(0xFF22D3EE)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Icon(
                            Icons.people,
                            color: selectedIndex == 1
                                ? Colors.white
                                : const Color(0xFF22D3EE),
                          ),
                          Text(
                            "Workforce",
                            style: TextStyle(
                              color: selectedIndex == 1
                                  ? Colors.white
                                  : const Color(0xFF22D3EE),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 200.h,
                      width: ((MediaQuery.sizeOf(context).width - 48) / 2)
                          .clamp(130.0, 180.0)
                          .toDouble(),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        color: AppConstant.cardBg(context),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "TOTAL ",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "EMPLOYEES",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Text(
                                "4",
                                style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF22D3EE)),
                              ),
                              Container(
                                height: 30,
                                width: 100,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.blue),
                                    borderRadius: BorderRadius.circular(15)),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 4, top: 3),
                                  child: Text(
                                    "0 active today",
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 200.h,
                      width: ((MediaQuery.sizeOf(context).width - 48) / 2)
                          .clamp(130.0, 180.0)
                          .toDouble(),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        color: AppConstant.cardBg(context),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "PRESENT",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "TODAY",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Text(
                                "0",
                                style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green),
                              ),
                              Container(
                                height: 30,
                                width: 80,
                                decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.greenAccent),
                                    borderRadius: BorderRadius.circular(15)),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 4, top: 3),
                                  child: Text(
                                    "  0 % rate",
                                    style: TextStyle(color: Colors.greenAccent),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 200.h,
                      width: ((MediaQuery.sizeOf(context).width - 48) / 2)
                          .clamp(130.0, 180.0)
                          .toDouble(),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        color: AppConstant.cardBg(context),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "TOTAL ",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "ASSETS",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Text(
                                "1",
                                style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF22D3EE)),
                              ),
                              Container(
                                height: 30,
                                width: 100,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.blue),
                                    borderRadius: BorderRadius.circular(15)),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 4, top: 3),
                                  child: Text(
                                    "Rs 250K value",
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 200.h,
                      width: ((MediaQuery.sizeOf(context).width - 48) / 2)
                          .clamp(130.0, 180.0)
                          .toDouble(),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        color: AppConstant.cardBg(context),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "AVAILABLE ",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "ASSETS",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Text(
                                "0",
                                style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green),
                              ),
                              Container(
                                height: 30,
                                width: 100,
                                decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.greenAccent),
                                    borderRadius: BorderRadius.circular(15)),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 4, top: 3),
                                  child: Text(
                                    "  1 assigned",
                                    style: TextStyle(color: Colors.greenAccent),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 200.h,
                      width: ((MediaQuery.sizeOf(context).width - 48) / 2)
                          .clamp(130.0, 180.0)
                          .toDouble(),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        color: AppConstant.cardBg(context),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "TOTAL LOAN ",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "DISBURSED",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Text(
                                "RS 0",
                                style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.deepPurple),
                              ),
                              Container(
                                height: 20,
                                width: 60,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.deepPurpleAccent),
                                    borderRadius: BorderRadius.circular(15)),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 4, bottom: 2),
                                  child: Text(
                                    "0 active",
                                    style: TextStyle(
                                        color: Colors.deepPurpleAccent),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 200.h,
                      width: ((MediaQuery.sizeOf(context).width - 48) / 2)
                          .clamp(130.0, 180.0)
                          .toDouble(),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        color: AppConstant.cardBg(context),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "PENDING ",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "APPROVALS",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Text(
                                "2",
                                style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange),
                              ),
                              Container(
                                height: 20,
                                width: 60,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.amber),
                                    borderRadius: BorderRadius.circular(15)),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 4,
                                  ),
                                  child: Text(
                                    "0 leave",
                                    style: TextStyle(color: Colors.amber),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 7,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 200.h,
                      width: ((MediaQuery.sizeOf(context).width - 48) / 2)
                          .clamp(130.0, 180.0)
                          .toDouble(),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        shadowColor: Colors.black,
                        color: AppConstant.cardBg(context),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "OPEN ",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "POSITION",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Text(
                                "0",
                                style: TextStyle(
                                    fontSize: 35,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.lightBlue),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              _buildAttendanceAnalytics(),
              SizedBox(
                height: 20,
              ),
              _buildOperationsDashboard(),
              SizedBox(
                height: 20,
              ),
              _buildAdminApprovalCenter(),
              SizedBox(
                height: 20,
              ),
              _buildActionCenter(),
              SizedBox(
                height: 20,
              ),
              _buildLiveAttendance(),
              SizedBox(
                height: 20,
              ),
              _buildEmployeeClearance(),
              SizedBox(
                height: 20,
              ),
              _buildFinancialAndRecruitment(),
              SizedBox(
                height: 20,
              ),
              _buildTodaysInterview(),
              SizedBox(
                height: 20,
              ),
              _buildUpcomingEvents(),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAttendanceAnalytics() {
    final teams = ['Development', 'Bussiness Analyst'];
    final days = ['SAT', 'SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI'];

    return StatefulBuilder(
      builder: (context, setState) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            color: AppConstant.cardBg(context),
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    children: [
                      Icon(Icons.show_chart,
                          color: AppConstant.primarycolor, size: 20),
                      const SizedBox(width: 10),
                      Text(
                        'ATTENDANCE ANALYTICS',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            color: AppConstant.textPrimary(context)),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.green.shade200),
                        ),
                        child: Row(
                          children: [
                            Container(
                                width: 6,
                                height: 6,
                                decoration: const BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle)),
                            const SizedBox(width: 4),
                            Text('LIVE',
                                style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green.shade700)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Text(
                    'Presence rate by team × weekday · last 7 days · darker = higher attendance',
                    style: TextStyle(
                        fontSize: 11,
                        color: AppConstant.textSecondary(context)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    children: [
                      Text('LOW',
                          style: TextStyle(
                              fontSize: 10,
                              color: AppConstant.textHint(context))),
                      const SizedBox(width: 8),
                      ...List.generate(
                          7,
                          (i) => Container(
                                margin: const EdgeInsets.only(right: 3),
                                width: 18,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: Colors.blue[100 + (i * 100)],
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              )),
                      const SizedBox(width: 8),
                      Text('HIGH',
                          style: TextStyle(
                              fontSize: 10,
                              color: AppConstant.textHint(context))),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppConstant.divider(context),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: ['TODAY', 'WEEKLY', 'MONTHLY']
                          .asMap()
                          .entries
                          .map((entry) {
                        final idx = entry.key;
                        final label = entry.value;
                        final isSelected = _attendanceSelectedTab == idx;
                        return Expanded(
                          child: GestureDetector(
                            onTap: () =>
                                setState(() => _attendanceSelectedTab = idx),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppConstant.primarycolor
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  label,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: isSelected
                                        ? Colors.white
                                        : AppConstant.textSecondary(context),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _buildAttendanceTabContent(teams, days),
                const SizedBox(height: 15),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAttendanceTabContent(List<String> teams, List<String> days) {
    if (_attendanceSelectedTab == 0) {
      return _buildTodayAttendance(teams);
    } else if (_attendanceSelectedTab == 1) {
      return _buildWeeklyAttendance(teams, days);
    } else {
      return _buildMonthlyAttendance(teams);
    }
  }

  Widget _buildTodayAttendance(List<String> teams) {
    final hours = [
      '8:00',
      '9:00',
      '10:00',
      '11:00',
      '12:00',
      '13:00',
      '14:00',
      '15:00',
      '16:00',
      '17:00',
      '18:00'
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const SizedBox(width: 110),
              ...hours.map((h) => SizedBox(
                    width: 52,
                    child: Center(
                      child: Text(h,
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: AppConstant.textSecondary(context))),
                    ),
                  )),
              SizedBox(
                width: 52,
                child: Center(
                  child: Text('AVG',
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: AppConstant.primarycolor)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...teams.map((team) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    SizedBox(
                      width: 110,
                      child: Text(team,
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w500)),
                    ),
                    ...List.generate(
                        11,
                        (i) => Container(
                              width: 52,
                              height: 36,
                              margin: const EdgeInsets.only(right: 3),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Center(
                                child: Text('0%',
                                    style: TextStyle(
                                        fontSize: 10, color: Colors.blue)),
                              ),
                            )),
                    Container(
                      width: 52,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Center(
                        child: Text('0%',
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue)),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildWeeklyAttendance(List<String> teams, List<String> days) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const SizedBox(width: 110),
              ...days.map((d) => SizedBox(
                    width: 58,
                    child: Center(
                      child: Text(d,
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppConstant.textSecondary(context))),
                    ),
                  )),
              SizedBox(
                width: 58,
                child: Center(
                  child: Text('AVG',
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AppConstant.primarycolor)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...teams.map((team) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    SizedBox(
                      width: 110,
                      child: Text(team,
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w500)),
                    ),
                    ...List.generate(7, (i) {
                      final percentages = [85, 90, 78, 92, 88, 95, 0];
                      final pct = i < 7 ? percentages[i] : 0;
                      return Container(
                        width: 58,
                        height: 36,
                        margin: const EdgeInsets.only(right: 4),
                        decoration: BoxDecoration(
                          color: _getAttendanceColor(pct),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Center(
                          child: Text('$pct%',
                              style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color:
                                      pct > 50 ? Colors.white : Colors.blue)),
                        ),
                      );
                    }),
                    Container(
                      width: 58,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Center(
                        child: Text('76%',
                            style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue)),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildMonthlyAttendance(List<String> teams) {
    final weeks = ['W1', 'W2', 'W3', 'W4'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const SizedBox(width: 110),
              ...weeks.map((w) => SizedBox(
                    width: 70,
                    child: Center(
                      child: Text(w,
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppConstant.textSecondary(context))),
                    ),
                  )),
              SizedBox(
                width: 70,
                child: Center(
                  child: Text('AVG',
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AppConstant.primarycolor)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...teams.map((team) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    SizedBox(
                      width: 110,
                      child: Text(team,
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w500)),
                    ),
                    ...List.generate(4, (i) {
                      final percentages = [82, 88, 79, 91];
                      final pct = percentages[i];
                      return Container(
                        width: 70,
                        height: 36,
                        margin: const EdgeInsets.only(right: 4),
                        decoration: BoxDecoration(
                          color: _getAttendanceColor(pct),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Center(
                          child: Text('$pct%',
                              style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color:
                                      pct > 50 ? Colors.white : Colors.blue)),
                        ),
                      );
                    }),
                    Container(
                      width: 70,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Center(
                        child: Text('85%',
                            style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue)),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Color _getAttendanceColor(int pct) {
    if (pct >= 90) return Colors.green.shade600;
    if (pct >= 75) return Colors.blue.shade400;
    if (pct >= 50) return Colors.orange.shade400;
    if (pct > 0) return Colors.red.shade300;
    return Colors.grey.shade200;
  }

  Widget _buildOperationsDashboard() {
    final cards = [
      _OpCardData(
          Icons.person_outline,
          Colors.grey.shade700,
          'No Attendance Recorded Today',
          'No check-ins have been registered for today.',
          'View Attendance →',
          AppConstant.primarycolor),
      _OpCardData(
          Icons.check_circle_outline,
          Colors.teal,
          'All Approvals Up to Date',
          'Leaves: 0 · Loans: 0 · Expenses: 0',
          'Review Approvals →',
          AppConstant.primarycolor),
      _OpCardData(
          Icons.people_outline,
          AppConstant.primarycolor,
          '4 Active Employees',
          '1 new hire joined this month',
          'Manage Employees →',
          AppConstant.primarycolor),
      _OpCardData(
          Icons.payment,
          Colors.teal,
          'Payroll In Progress — 1 Run',
          '2 employees included · Rs 0 unpaid',
          'Manage Payroll →',
          AppConstant.primarycolor),
      _OpCardData(
          Icons.work_outline,
          Colors.teal,
          'No Active Recruitment',
          'No open positions or active candidates found.',
          'Open Recruitment →',
          AppConstant.primarycolor),
      _OpCardData(
          Icons.event_busy,
          AppConstant.primarycolor,
          'No Pending Leave Requests',
          '0 employees on leave today',
          'Manage Leave →',
          AppConstant.primarycolor),
      _OpCardData(
          Icons.inventory_2_outlined,
          AppConstant.primarycolor,
          '1 Total Assets',
          '1 assigned · 0 available · 0 in maintenance',
          'Manage Assets →',
          AppConstant.primarycolor),
      _OpCardData(
          Icons.receipt_long,
          AppConstant.primarycolor,
          'No Pending Expense Claims',
          'No approved expenses this period',
          'Review Expenses →',
          AppConstant.primarycolor),
      _OpCardData(
          Icons.account_balance,
          AppConstant.primarycolor,
          '0 Active Loans',
          'No pending requests · Outstanding: Rs 0',
          'Manage Loans →',
          AppConstant.primarycolor),
      _OpCardData(
          Icons.face,
          Colors.teal,
          'AI Face Attendance Active',
          'Face recognition system is online and waiting for attendance records.',
          'View AI Attendance →',
          AppConstant.primarycolor),
    ];

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: AppConstant.cardBg(context),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                children: [
                  Icon(Icons.dashboard_customize,
                      color: AppConstant.primarycolor, size: 20),
                  const SizedBox(width: 10),
                  Text(
                    'OPERATIONS DASHBOARD',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: AppConstant.textPrimary(context)),
                  ),
                  const Spacer(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.teal.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.teal.shade200),
                ),
                child: Text('Live Data',
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Colors.teal.shade700)),
              ),
            ),
            const Divider(height: 1),
            SizedBox(
              height: 160,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                itemCount: cards.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (context, index) => SizedBox(
                  width: 180,
                  child: _buildOpCard(cards[index]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOpCard(_OpCardData card) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppConstant.cardBg(context),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppConstant.border(context)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 4,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(card.icon, color: card.iconColor, size: 22),
          const SizedBox(height: 10),
          Expanded(
            child: Text(
              card.title,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            card.subtitle,
            style:
                TextStyle(fontSize: 10, color: AppConstant.textHint(context)),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Text(
            card.action,
            style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: card.actionColor),
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialAndRecruitment() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          _buildRecruitmentPipelineCard(),
          const SizedBox(height: 10),
          _buildFinancialOverviewCard(),
        ],
      ),
    );
  }

  Widget _buildRecruitmentPipelineCard() {
    return Card(
      color: AppConstant.cardBg(context),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Icon(Icons.filter_list,
                    color: AppConstant.primarycolor, size: 18),
                const SizedBox(width: 8),
                const Text(
                  'RECRUITMENT PIPELINE',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppConstant.primarycolor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RecruitmentDashboard()));
                    },
                    child: Text('View All',
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppConstant.primarycolor)),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          const SizedBox(height: 60),
          Center(
            child: Column(
              children: [
                Icon(Icons.filter_list, size: 40, color: Colors.grey.shade400),
                const SizedBox(height: 12),
                Text('No pipeline data available',
                    style: TextStyle(
                        fontSize: 13, color: AppConstant.textHint(context))),
              ],
            ),
          ),
          const SizedBox(height: 60),
        ],
      ),
    );
  }

  Widget _buildFinancialOverviewCard() {
    return StatefulBuilder(
      builder: (context, setInnerState) {
        final tabLabels = ['Expenses', 'Loans', 'Assets'];
        return Card(
          color: AppConstant.cardBg(context),
          elevation: 3,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Icon(Icons.work, color: AppConstant.primarycolor, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      'FINANCIAL OVERVIEW',
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppConstant.textPrimary(context)),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppConstant.divider(context),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: tabLabels.asMap().entries.map((entry) {
                      final idx = entry.key;
                      final label = entry.value;
                      final isSelected = _financialSelectedTab == idx;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () =>
                              setInnerState(() => _financialSelectedTab = idx),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppConstant.primarycolor
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                label,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected
                                      ? Colors.white
                                      : AppConstant.textSecondary(context),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: _buildTabContent(_financialSelectedTab),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTabContent(int index) {
    if (index == 1) {
      return _buildLoansTab();
    } else if (index == 2) {
      return _buildAssetsTab();
    } else {
      return _buildExpensesTab();
    }
  }

  Widget _buildExpensesTab() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
                child: _financeStat(
                    'Rs 0', 'TOTAL REQUESTED', Colors.grey.shade800)),
            const SizedBox(width: 8),
            Expanded(
                child: _financeStat('Rs 0', 'APPROVED AMOUNT', Colors.green)),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
                child: _financeStat('0', 'PENDING REPORTS', Colors.orange)),
            const SizedBox(width: 8),
            Expanded(
                child: _financeStat(
                    '0', 'TOTAL REPORTS', AppConstant.primarycolor)),
          ],
        ),
      ],
    );
  }

  Widget _buildLoansTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
                child: _financeStat('Rs 0', 'TOTAL DISBURSED', Colors.blue)),
            const SizedBox(width: 8),
            Expanded(child: _financeStat('Rs 0', 'TOTAL REPAID', Colors.green)),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: _financeStat('Rs 0', 'OUTSTANDING', Colors.red)),
            const SizedBox(width: 8),
            Expanded(
                child: _financeStat('0%', 'COLLECTION RATE', Colors.orange)),
          ],
        ),
        const SizedBox(height: 16),
        Text('LOANS BY DEPARTMENT',
            style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: AppConstant.textSecondary(context))),
        const SizedBox(height: 8),
        SizedBox(height: 150, child: _buildLoansByDepartmentBarChart()),
        const SizedBox(height: 16),
        Text('REPAYMENT PROGRESS',
            style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: AppConstant.textSecondary(context))),
        const SizedBox(height: 8),
        _buildRepaymentProgressItem('Engineering', 0.12),
        const SizedBox(height: 6),
        _buildRepaymentProgressItem('HR', 0.03),
        const SizedBox(height: 6),
        _buildRepaymentProgressItem('Finance', 0.0),
        const SizedBox(height: 16),
        Text('ACTIVE LOANS BY TYPE',
            style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: AppConstant.textSecondary(context))),
        const SizedBox(height: 8),
        SizedBox(height: 160, child: _buildActiveLoansByTypeDoughnut()),
      ],
    );
  }

  Widget _buildLoansByDepartmentBarChart() {
    final data = [
      ('Engineering', 0.0),
      ('HR', 0.0),
      ('Finance', 0.0),
      ('Marketing', 0.0),
      ('Operations', 0.0),
    ];
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 100,
        barTouchData: BarTouchData(enabled: false),
        titlesData: FlTitlesData(
          show: true,
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
              getTitlesWidget: (value, meta) {
                final labels = ['Eng', 'HR', 'Fin', 'Mkt', 'Ops'];
                return Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(labels[value.toInt()],
                      style: TextStyle(
                          fontSize: 9,
                          color: AppConstant.textSecondary(context))),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
              getTitlesWidget: (value, meta) {
                return Text('${value.toInt()}',
                    style: TextStyle(
                        fontSize: 9, color: AppConstant.textHint(context)));
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 25,
          getDrawingHorizontalLine: (value) =>
              FlLine(color: AppConstant.border(context), strokeWidth: 0.5),
        ),
        barGroups: data.asMap().entries.map((entry) {
          return BarChartGroupData(
            x: entry.key,
            barRods: [
              BarChartRodData(
                toY: entry.value.$2 * 100,
                color: AppConstant.primarycolor,
                width: 20,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(4)),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildRepaymentProgressItem(String dept, double progress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(dept,
                style: TextStyle(
                    fontSize: 10, color: AppConstant.textSecondary(context))),
            Text('${(progress * 100).toInt()}%',
                style: TextStyle(
                    fontSize: 10, color: AppConstant.textHint(context))),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 6,
            backgroundColor: AppConstant.border(context),
            valueColor: AlwaysStoppedAnimation<Color>(AppConstant.primarycolor),
          ),
        ),
      ],
    );
  }

  Widget _buildActiveLoansByTypeDoughnut() {
    return Row(
      children: [
        Expanded(
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 30,
              sections: [
                PieChartSectionData(
                  value: 33,
                  color: Colors.blue,
                  radius: 20,
                  title: '33%',
                  titleStyle: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                PieChartSectionData(
                  value: 33,
                  color: Colors.orange,
                  radius: 20,
                  title: '33%',
                  titleStyle: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                PieChartSectionData(
                  value: 34,
                  color: Colors.teal,
                  radius: 20,
                  title: '34%',
                  titleStyle: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _doughnutLegend(Colors.blue, 'Personal Loan'),
            const SizedBox(height: 6),
            _doughnutLegend(Colors.orange, 'Emergency Loan'),
            const SizedBox(height: 6),
            _doughnutLegend(Colors.teal, 'Housing Loan'),
          ],
        ),
      ],
    );
  }

  Widget _buildAssetsTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: _financeStat('1', 'TOTAL ASSETS', Colors.blue)),
            const SizedBox(width: 8),
            Expanded(child: _financeStat('0', 'ASSIGNED', Colors.green)),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: _financeStat('0', 'IN MAINTENANCE', Colors.orange)),
            const SizedBox(width: 8),
            Expanded(child: _financeStat('0', 'RETIRED', Colors.red)),
          ],
        ),
        const SizedBox(height: 16),
        Text('ASSET DISTRIBUTION BY DEPARTMENT',
            style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: AppConstant.textSecondary(context))),
        const SizedBox(height: 8),
        SizedBox(height: 150, child: _buildAssetDistributionBarChart()),
        const SizedBox(height: 16),
        Text('MAINTENANCE STATUS',
            style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: AppConstant.textSecondary(context))),
        const SizedBox(height: 8),
        SizedBox(height: 160, child: _buildMaintenanceStatusDoughnut()),
      ],
    );
  }

  Widget _buildAssetDistributionBarChart() {
    final data = [
      ('Engineering', 0.0),
      ('HR', 0.0),
      ('Finance', 0.0),
      ('Marketing', 0.0),
      ('Operations', 0.0),
    ];
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 100,
        barTouchData: BarTouchData(enabled: false),
        titlesData: FlTitlesData(
          show: true,
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
              getTitlesWidget: (value, meta) {
                final labels = ['Eng', 'HR', 'Fin', 'Mkt', 'Ops'];
                return Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(labels[value.toInt()],
                      style: TextStyle(
                          fontSize: 9,
                          color: AppConstant.textSecondary(context))),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
              getTitlesWidget: (value, meta) {
                return Text('${value.toInt()}',
                    style: TextStyle(
                        fontSize: 9, color: AppConstant.textHint(context)));
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 25,
          getDrawingHorizontalLine: (value) =>
              FlLine(color: AppConstant.border(context), strokeWidth: 0.5),
        ),
        barGroups: data.asMap().entries.map((entry) {
          return BarChartGroupData(
            x: entry.key,
            barRods: [
              BarChartRodData(
                toY: entry.value.$2 * 100,
                color: AppConstant.primarycolor,
                width: 20,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(4)),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMaintenanceStatusDoughnut() {
    return Row(
      children: [
        Expanded(
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 30,
              sections: [
                PieChartSectionData(
                  value: 100,
                  color: Colors.green,
                  radius: 20,
                  title: '100%',
                  titleStyle: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _doughnutLegend(Colors.green, 'Available'),
            const SizedBox(height: 6),
            _doughnutLegend(Colors.blue, 'Assigned'),
            const SizedBox(height: 6),
            _doughnutLegend(Colors.orange, 'In Maintenance'),
            const SizedBox(height: 6),
            _doughnutLegend(Colors.red, 'Retired'),
          ],
        ),
      ],
    );
  }

  Widget _doughnutLegend(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
                color: color, borderRadius: BorderRadius.circular(2))),
        const SizedBox(width: 6),
        Text(label,
            style: TextStyle(
                fontSize: 10, color: AppConstant.textSecondary(context))),
      ],
    );
  }

  Widget _financeStat(String value, String label, Color valueColor) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppConstant.inputBg(context),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppConstant.border(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: valueColor)),
          const SizedBox(height: 4),
          Text(label,
              style: TextStyle(
                  fontSize: 9,
                  color: AppConstant.textHint(context),
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildTodaysInterview() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Card(
        color: AppConstant.cardBg(context),
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Icon(Icons.work_outline,
                      color: AppConstant.primarycolor, size: 18),
                  const SizedBox(width: 8),
                  const Text(
                    "TODAY'S INTERVIEW SCHEDULE",
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                  border: Border.all(color: AppConstant.primarycolor),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Interviews()));
                  },
                  child: Text('Full Calendar',
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppConstant.primarycolor)),
                ),
              ),
            ),
            const Divider(height: 1),
            const SizedBox(height: 50),
            Center(
              child: Column(
                children: [
                  Icon(Icons.event_busy, size: 40, color: Colors.grey.shade400),
                  const SizedBox(height: 12),
                  Text('No interviews scheduled for today',
                      style: TextStyle(
                          fontSize: 13, color: AppConstant.textHint(context))),
                ],
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCenter() {
    final items = [
      _ActionItem(
          Icons.bolt,
          Colors.orange,
          'Probation Review Required',
          '21 - Development - 180 days counting',
          'Overdue',
          'In33 days',
          Colors.red),
      _ActionItem(
          Icons.bolt,
          Colors.orange,
          'Contract Renewal Required',
          '15 - Marketing - 606 days counting',
          'Overdue',
          'In 119 days',
          Colors.red),
      _ActionItem(
          Icons.person_off,
          Colors.red,
          'Complete Missing Attendance',
          "4 employees haven't marked attendance",
          'Action Required',
          'Aug 1...',
          Colors.red),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Card(
        color: AppConstant.cardBg(context),
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Icon(Icons.bolt, color: Colors.orange, size: 20),
                  const SizedBox(width: 8),
                  const Text('ACTION CENTER',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const Divider(height: 1),
            ...items.map((item) => _buildActionItem(item)),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminApprovalCenter() {
    final approvals = [
      _ApprovalItem('Leave Requests', 'Review employee leave requests',
          Icons.event_available_outlined, Colors.orange, LeaveApproval()),
      _ApprovalItem('Expense Requests', 'Review submitted expense claims',
          Icons.receipt_long_outlined, Colors.purple, ApprovalScreen()),
      _ApprovalItem('Payroll Approval', 'Review payroll before processing',
          Icons.payments_outlined, Colors.green, PayrollApprovalScreen()),
      _ApprovalItem(
          'Wallet Approval',
          'Review pending wallet transactions',
          Icons.account_balance_wallet_outlined,
          Colors.blue,
          ApprovalQueueScreen()),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Card(
        color: AppConstant.cardBg(context),
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Icon(Icons.pending_actions_outlined,
                  color: Colors.orange, size: 20),
              const SizedBox(width: 8),
              Expanded(
                  child: Text('ADMIN APPROVALS',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppConstant.textPrimary(context)))),
              Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                      color: Colors.orange.withValues(alpha: .12),
                      borderRadius: BorderRadius.circular(8)),
                  child: const Text('REVIEW',
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange))),
            ]),
            const SizedBox(height: 12),
            LayoutBuilder(builder: (context, constraints) {
              final columns = constraints.maxWidth >= 600 ? 4 : 2;
              final width =
                  (constraints.maxWidth - ((columns - 1) * 10)) / columns;
              return Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: approvals
                      .map((item) => SizedBox(
                          width: width,
                          child: InkWell(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => item.screen)),
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: AppConstant.border(context)),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                            width: 34,
                                            height: 34,
                                            decoration: BoxDecoration(
                                                color: item.color
                                                    .withValues(alpha: .12),
                                                borderRadius:
                                                    BorderRadius.circular(8)),
                                            child: Icon(item.icon,
                                                size: 18, color: item.color)),
                                        const SizedBox(height: 8),
                                        Text(item.title,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: AppConstant.textPrimary(
                                                    context))),
                                        const SizedBox(height: 3),
                                        Text(item.subtitle,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: 10,
                                                color: AppConstant.textHint(
                                                    context))),
                                        const SizedBox(height: 8),
                                        Text('Open review →',
                                            style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w600,
                                                color: item.color))
                                      ])))))
                      .toList());
            }),
          ]),
        ),
      ),
    );
  }

  Widget _buildActionItem(_ActionItem item) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppConstant.divider(context))),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: item.iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(item.icon, color: item.iconColor, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title,
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(item.subtitle,
                    style: TextStyle(
                        fontSize: 10, color: AppConstant.textHint(context))),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: item.badgeColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(item.badge,
                          style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                              color: item.badgeColor)),
                    ),
                    const SizedBox(width: 6),
                    Text(item.time,
                        style: TextStyle(
                            fontSize: 9, color: AppConstant.textHint(context))),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLiveAttendance() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Card(
        color: AppConstant.cardBg(context),
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                        color: Colors.green, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 8),
                  const Text('LIVE ATTENDANCE',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.green.shade200),
                    ),
                    child: Text('LIVE',
                        style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade700)),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            const SizedBox(height: 20),
            Center(
              child: SizedBox(
                width: 120,
                height: 120,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 120,
                      height: 120,
                      child: CircularProgressIndicator(
                        value: 0,
                        strokeWidth: 10,
                        backgroundColor: AppConstant.border(context),
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(Colors.red),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('0%',
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold)),
                        Text('TODAY',
                            style: TextStyle(
                                fontSize: 10,
                                color: AppConstant.textHint(context))),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _attendanceLegend(Colors.blue, 'Present', '0'),
                  const SizedBox(height: 8),
                  _attendanceLegend(Colors.orange, 'Late', '0'),
                  const SizedBox(height: 8),
                  _attendanceLegend(Colors.green, 'On Leave', '0'),
                  const SizedBox(height: 8),
                  _attendanceLegend(Colors.red, 'Absent', '4'),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _attendanceLegend(Color color, String label, String count) {
    return Row(
      children: [
        Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 10),
        Text(label,
            style: TextStyle(
                fontSize: 12, color: AppConstant.textSecondary(context))),
        const Spacer(),
        Text(count,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildUpcomingEvents() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Card(
        color: AppConstant.cardBg(context),
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Icon(Icons.calendar_today,
                      color: AppConstant.primarycolor, size: 18),
                  const SizedBox(width: 8),
                  const Text('UPCOMING EVENTS',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const Divider(height: 1),
            const SizedBox(height: 40),
            Center(
              child: Column(
                children: [
                  Icon(Icons.event_busy, size: 40, color: Colors.grey.shade400),
                  const SizedBox(height: 12),
                  Text('No upcoming events',
                      style: TextStyle(
                          fontSize: 13, color: AppConstant.textHint(context))),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildEmployeeClearance() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Card(
        color: AppConstant.cardBg(context),
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Icon(Icons.assignment_outlined,
                      color: AppConstant.primarycolor, size: 18),
                  const SizedBox(width: 8),
                  const Text('EMPLOYEE CLEARANCE',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppConstant.primarycolor),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Employeemanagement()));
                      },
                      child: Text('View All',
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppConstant.primarycolor)),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                children: [
                  _clearanceStat('0', 'Pending', Colors.orange),
                  const SizedBox(width: 20),
                  _clearanceStat('0', 'Cleared', Colors.teal),
                  const SizedBox(width: 20),
                  _clearanceStat('0', 'Asset Pending', Colors.orange),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                        color: Colors.green, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 8),
                  Text('All clear',
                      style: TextStyle(
                          fontSize: 12,
                          color: AppConstant.textSecondary(context))),
                  const SizedBox(width: 8),
                  Text('No pending clearances',
                      style: TextStyle(
                          fontSize: 12, color: AppConstant.textHint(context))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _clearanceStat(String value, String label, Color color) {
    return Column(
      children: [
        Text(value,
            style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.bold, color: color)),
        const SizedBox(height: 2),
        Text(label,
            style: TextStyle(
                fontSize: 11, color: AppConstant.textSecondary(context))),
      ],
    );
  }
}

class _ActionItem {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String badge;
  final String time;
  final Color badgeColor;

  _ActionItem(this.icon, this.iconColor, this.title, this.subtitle, this.badge,
      this.time, this.badgeColor);
}

class _ApprovalItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final Widget screen;

  _ApprovalItem(this.title, this.subtitle, this.icon, this.color, this.screen);
}

class _OpCardData {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String action;
  final Color actionColor;

  _OpCardData(this.icon, this.iconColor, this.title, this.subtitle, this.action,
      this.actionColor);
}
