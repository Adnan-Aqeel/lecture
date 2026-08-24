import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:lecture/appcolor.dart';
import 'package:lecture/widgets/shimmer_widgets.dart';

/// Employee Shift Model
class EmployeeShiftModel {
  final String id;
  final String name;
  final String department;
  String timeSlot;
  String effectiveFrom;
  bool isSelected;

  EmployeeShiftModel({
    required this.id,
    required this.name,
    required this.department,
    required this.timeSlot,
    required this.effectiveFrom,
    this.isSelected = false,
  });

  String get displayEmp => '$id - $name';
}

class Employeeshift extends StatefulWidget {
  const Employeeshift({super.key});

  @override
  State<Employeeshift> createState() => _EmployeeshiftState();
}

class _EmployeeshiftState extends State<Employeeshift> {
  final TextEditingController timecontroller = TextEditingController();
  final TextEditingController searchController = TextEditingController();

  final ScrollController horizontalcontroller = ScrollController();
  final ScrollController verticalcontroller = ScrollController();

  String selectedBulkSlot = 'Morning';
  String selectedFilterSlot = 'All Slot';
  String searchQuery = '';
  DateTime selectedDate = DateTime(2026, 8, 3);
  bool isAllSelected = false;

  // Direct Inline Initialized List (Prevents LateInitializationError)
  List<EmployeeShiftModel> allEmployees = [
    EmployeeShiftModel(
      id: '1',
      name: 'Ali',
      department: 'IT & Software',
      timeSlot: 'Morning',
      effectiveFrom: '01/08/2026',
    ),
    EmployeeShiftModel(
      id: '2',
      name: 'Zain',
      department: 'Human Resources',
      timeSlot: 'Mid',
      effectiveFrom: '01/08/2026',
    ),
    EmployeeShiftModel(
      id: '1002',
      name: 'Amair',
      department: 'Sales & Marketing',
      timeSlot: 'Morning',
      effectiveFrom: '01/08/2026',
    ),
    EmployeeShiftModel(
      id: '2002',
      name: 'Ehsan',
      department: 'Finance & Accounts',
      timeSlot: 'Mid',
      effectiveFrom: '01/08/2026',
    ),
  ];

  @override
  void initState() {
    super.initState();
    timecontroller.text = DateFormat('dd/MM/yyyy').format(selectedDate);
  }

  @override
  void dispose() {
    timecontroller.dispose();
    searchController.dispose();
    horizontalcontroller.dispose();
    verticalcontroller.dispose();
    super.dispose();
  }

  // Workable Filtered Employees
  List<EmployeeShiftModel> get filteredEmployees {
    return allEmployees.where((emp) {
      // 1. Filter by Time Slot
      final matchesSlot = selectedFilterSlot == 'All Slot' ||
          emp.timeSlot.toLowerCase() == selectedFilterSlot.toLowerCase();

      // 2. Filter by Search Query
      final q = searchQuery.toLowerCase().trim();
      final matchesSearch = q.isEmpty ||
          emp.id.toLowerCase().contains(q) ||
          emp.name.toLowerCase().contains(q) ||
          emp.department.toLowerCase().contains(q);

      return matchesSlot && matchesSearch;
    }).toList();
  }

  // Pick Date Dialog
  Future<void> _selectDate(BuildContext context) async {
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
        timecontroller.text = DateFormat('dd/MM/yyyy').format(pickeddate);
      });
    }
  }

  // Apply Bulk Slot to Selected Employees
  void _applyBulkSlot() {
    final selectedItems =
        filteredEmployees.where((emp) => emp.isSelected).toList();

    if (selectedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one employee from the table.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() {
      for (var emp in selectedItems) {
        emp.timeSlot = selectedBulkSlot;
        if (timecontroller.text.isNotEmpty) {
          emp.effectiveFrom = timecontroller.text;
        }
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF06B6D4),
        content: Text(
          'Updated ${selectedItems.length} employees to $selectedBulkSlot slot  ${timecontroller.text}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // Save Individual Employee Shift
  void _saveIndividualShift(EmployeeShiftModel emp) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppConstant.primarycolor,
        content: Text(
          'Shift saved for ${emp.name} (${emp.timeSlot})!',
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = filteredEmployees;

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
              "Employee Shift Routine",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppConstant.textPrimary(context),
              ),
            ),
            Text(
              "Assign and Manage employee time slot routine",
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
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: AppConstant.primarycolor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Opening Time Slot Management'),
                            ),
                          );
                        },
                        child: const Text(
                          "Manage Time Slot",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF06B6D4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        onPressed: _applyBulkSlot,
                        icon:  Icon(
                          Icons.check_box_outlined,
                    color: AppConstant.textPrimary(context),
                          size: 18,
                        ),
                        label:  Text(
                          "Apply Selected",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                    color: AppConstant.textPrimary(context),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // 1. Bulk Time Slot Dropdown
              const Text(
                "Bulk Time Slot",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                value: selectedBulkSlot,
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
                  hintText: "Select Slot",
                ),
                items: ["Morning", "Mid", "Night"].map((e) {
                  return DropdownMenuItem(value: e, child: Text(e));
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      selectedBulkSlot = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),

              // 2. Effective Date Picker Field
              const Text(
                "Date",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: timecontroller,
                readOnly: true,
                onTap: () => _selectDate(context),
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
                  hintText: "dd/mm/yyyy",
                ),
              ),
              const SizedBox(height: 16),

              // 3. Filter by Time Slot Dropdown
              const Text(
                "Filter by Time Slot",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                value: selectedFilterSlot,
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
                  hintText: "All Slot",
                ),
                items: ["All Slot", "Morning", "Mid", "Night"].map((e) {
                  return DropdownMenuItem(value: e, child: Text(e));
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      selectedFilterSlot = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),

              // 4. Search Employee Field
              const Text(
                "Search",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: Colors.grey,
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
              const SizedBox(height: 20),

              // 5. Bulk Actions Row Buttons

              const SizedBox(height: 24),

              // 6. Styled DataTable or No Records Found
              filtered.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        child: Column(
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
                              dataRowMinHeight: 56,
                              dataRowMaxHeight: 64,
                              horizontalMargin: 16,
                              columnSpacing: 20,
                              columns: [
                                DataColumn(
                                  label: Checkbox(
                                    value: isAllSelected,
                                    activeColor: Colors.white,
                                    checkColor: AppConstant.primarycolor,
                                    onChanged: (val) {
                                      setState(() {
                                        isAllSelected = val ?? false;
                                        for (var emp in filtered) {
                                          emp.isSelected = isAllSelected;
                                        }
                                      });
                                    },
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    "#",
                                    style: TextStyle(
                              color: AppConstant.textPrimary(context),
                                      fontWeight: FontWeight.bold,
                                    ),
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
                                        "TIME SLOT",
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
                                      Icon(Icons.calendar_today,
                                          size: 18, color: Colors.black),
                                      SizedBox(width: 6),
                                      Text(
                                        "EFFECTIVE FROM",
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
                                final emp = filtered[index];
                                return DataRow(
                                  selected: emp.isSelected,
                                  cells: [
                                    // 1. Select Checkbox
                                    DataCell(
                                      Checkbox(
                                        value: emp.isSelected,
                                        activeColor: AppConstant.primarycolor,
                                        onChanged: (val) {
                                          setState(() {
                                            emp.isSelected = val ?? false;
                                          });
                                        },
                                      ),
                                    ),
                                    // 2. Row #
                                    DataCell(
                                      Text(
                                        "${index + 1}",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    // 3. Employee ID - Name
                                    DataCell(
                                      Text(
                                        emp.displayEmp,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    // 4. Department
                                    DataCell(Text(emp.department)),
                                    // 5. Time Slot Dropdown
                                    DataCell(
                                      DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                          value: emp.timeSlot,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            color: Color(0xFF0F172A),
                                            fontWeight: FontWeight.w600,
                                          ),
                                          items: ["Morning", "Mid", "Night"]
                                              .map((s) => DropdownMenuItem(
                                                    value: s,
                                                    child: Text(s),
                                                  ))
                                              .toList(),
                                          onChanged: (val) {
                                            if (val != null) {
                                              setState(() {
                                                emp.timeSlot = val;
                                              });
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                    // 6. Effective Date
                                    DataCell(Text(emp.effectiveFrom)),
                                    // 7. Save Action Button
                                    DataCell(
                                      InkWell(
                                        onTap: () => _saveIndividualShift(emp),
                                        borderRadius: BorderRadius.circular(20),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppConstant.primarycolor,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: const [
                                              Icon(
                                                Icons.save_alt_rounded,
                                                size: 16,
                                                color: Colors.white,
                                              ),
                                              SizedBox(width: 4),
                                              Text(
                                                "Save",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
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
