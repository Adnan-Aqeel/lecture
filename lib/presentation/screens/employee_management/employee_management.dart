import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lecture/core/constants/app_colors.dart';
import 'package:lecture/data/models/base_models.dart';
import 'package:lecture/core/widgets/shimmer_widgets.dart';
// ignore_for_file: unused_field

class Employeemanagement extends StatefulWidget {
  const Employeemanagement({super.key});

  @override
  State<Employeemanagement> createState() => _EmployeemanagementState();
}

class _EmployeemanagementState extends State<Employeemanagement> {
  //---------------------------------------------
  /// Scroll Controllers
  //---------------------------------------------

  final ScrollController horizontalcontroller = ScrollController();
  final ScrollController verticalcontroller = ScrollController();

  //---------------------------------------------
  /// Search Controller
  //---------------------------------------------

  final TextEditingController searchController = TextEditingController();

  //---------------------------------------------
  /// Add/Edit Controllers
  //---------------------------------------------

  final TextEditingController nameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController phoneController = TextEditingController();

  final TextEditingController departmentController = TextEditingController();

  final TextEditingController designationController = TextEditingController();

  //---------------------------------------------
  /// Dropdown Values
  //---------------------------------------------

  String selectedRoutine = "Morning";

  String selectedStatus = "Active";

  String filterStatus = "All Status";

  //---------------------------------------------
  /// Edit Index
  //---------------------------------------------

  int? editingIndex;

  //---------------------------------------------
  /// Employee List
  //---------------------------------------------

  List<UserModel> users = [
    UserModel(
      id: 1,
      name: "Ali Ahmed",
      email: "ali@gmail.com",
      phone: "03001234567",
      department: "IT",
      designation: "Flutter Developer",
      routine: "Morning",
      status: "Active",
    ),
    UserModel(
      id: 2,
      name: "Hamza Khan",
      email: "hamza@gmail.com",
      phone: "03021234567",
      department: "HR",
      designation: "HR Manager",
      routine: "Evening",
      status: "Active",
    ),
  ];

  //---------------------------------------------
  /// Filtered List
  //---------------------------------------------

  List<UserModel> filteredUsers = [];

  //---------------------------------------------
  /// initState
  //---------------------------------------------

  @override
  void initState() {
    super.initState();

    filteredUsers = List.from(users);

    searchController.addListener(searchEmployee);
  }

  //---------------------------------------------
  /// Dispose
  //---------------------------------------------

  @override
  void dispose() {
    horizontalcontroller.dispose();

    verticalcontroller.dispose();

    searchController.dispose();

    nameController.dispose();

    emailController.dispose();

    phoneController.dispose();

    departmentController.dispose();

    designationController.dispose();

    super.dispose();
  }

  //---------------------------------------------
  /// Search Employee
  //---------------------------------------------

  void searchEmployee() {
    setState(() {
      filteredUsers = users.where((employee) {
        final keyword = searchController.text.toLowerCase();

        return employee.name.toLowerCase().contains(keyword) ||
            employee.email.toLowerCase().contains(keyword);
      }).toList();

      if (filterStatus != "All Status") {
        filteredUsers = filteredUsers.where((employee) {
          return employee.status == filterStatus;
        }).toList();
      }
    });
  }

  //---------------------------------------------
  /// Clear Controllers
  //---------------------------------------------

  void clearControllers() {
    nameController.clear();

    emailController.clear();

    phoneController.clear();

    departmentController.clear();

    designationController.clear();

    selectedRoutine = "Morning";

    selectedStatus = "Active";

    editingIndex = null;
  }

  //---------------------------------------------
  /// Add Employee
  //---------------------------------------------

  void addEmployee() {
    users.add(
      UserModel(
        id: users.length + 1,
        name: nameController.text,
        email: emailController.text,
        phone: phoneController.text,
        department: departmentController.text,
        designation: designationController.text,
        routine: selectedRoutine,
        status: selectedStatus,
      ),
    );

    searchEmployee();
  }

  //---------------------------------------------
  /// Edit Employee
  //---------------------------------------------

  void loadEmployee(UserModel employee, int index) {
    editingIndex = index;

    nameController.text = employee.name;

    emailController.text = employee.email;

    phoneController.text = employee.phone;

    departmentController.text = employee.department;

    designationController.text = employee.designation;

    selectedRoutine = employee.routine;

    selectedStatus = employee.status;
  }

  //---------------------------------------------
  /// Update Employee
  //---------------------------------------------
  void updateEmployee() {
    if (editingIndex == null) return;

    users[editingIndex!] = UserModel(
      id: users[editingIndex!].id,
      name: nameController.text,
      email: emailController.text,
      phone: phoneController.text,
      department: departmentController.text,
      designation: designationController.text,
      routine: selectedRoutine,
      status: selectedStatus,
    );

    searchEmployee();
  }

  //---------------------------------------------
  /// Delete Employee
  //---------------------------------------------

  void deleteEmployee(int index) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text("Delete Employee"),
          content: Text(
            "Are you sure you want to delete ${filteredUsers[index].name} ?",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () {
                setState(() {
                  users.removeWhere(
                    (element) => element.id == filteredUsers[index].id,
                  );

                  searchEmployee();
                });

                Navigator.pop(context);
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  //---------------------------------------------
  /// View Employee
  //---------------------------------------------

  void viewEmployee(UserModel employee) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text("Employee Details"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Name : ${employee.name}"),
              const SizedBox(height: 10),
              Text("Email : ${employee.email}"),
              const SizedBox(height: 10),
              Text("Phone : ${employee.phone}"),
              const SizedBox(height: 10),
              Text("Department : ${employee.department}"),
              const SizedBox(height: 10),
              Text("Designation : ${employee.designation}"),
              const SizedBox(height: 10),
              Text("Routine : ${employee.routine}"),
              const SizedBox(height: 10),
              Text("Status : ${employee.status}"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  //---------------------------------------------
  /// Add / Edit Employee Dialog
  //---------------------------------------------

  void showEmployeeDialog({UserModel? employee, int? index}) {
    if (employee != null) {
      loadEmployee(employee, index!);
    } else {
      clearControllers();
    }

    showDialog(
      context: context,
      builder: (_) {
        return _AddEmployeeWizard(
          onSaved: () {
            setState(() {
              if (employee == null) {
                addEmployee();
              } else {
                updateEmployee();
              }
            });
            clearControllers();
          },
        );
      },
    );
  }

  void _showSendInviteDialog() {
    final emailCtrl = TextEditingController();
    final messageCtrl = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          backgroundColor: AppConstant.cardBg(context),
          insetPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.85,
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ── Header ──
                    Row(
                      children: [
                        Icon(Icons.mail_outline,
                            color: AppConstant.primarycolor, size: 22),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Send Employee Invite',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppConstant.textPrimary(context)),
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('Back',
                              style: TextStyle(
                                  fontSize: 13,
                                  color: AppConstant.textSecondary(context),
                                  fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    // ── Employee Email ──
                    Text('Employee Email',
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppConstant.textPrimary(context))),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(
                          fontSize: 13,
                          color: AppConstant.textPrimary(context)),
                      decoration: InputDecoration(
                        hintText: 'employee@company.com',
                        hintStyle: TextStyle(
                            fontSize: 13, color: AppConstant.textHint(context)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: AppConstant.border(context))),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: AppConstant.border(context))),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: AppConstant.primarycolor, width: 1.5)),
                        filled: true,
                        fillColor: AppConstant.inputBg(context),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                      ),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'Email is required';
                        }
                        if (!v.contains('@') || !v.contains('.')) {
                          return 'Please enter a valid email.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    // ── Message (optional) ──
                    Text('Message (optional)',
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppConstant.textPrimary(context))),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: messageCtrl,
                      maxLines: 3,
                      style: TextStyle(
                          fontSize: 13,
                          color: AppConstant.textPrimary(context)),
                      decoration: InputDecoration(
                        hintText: 'Welcome to the company...',
                        hintStyle: TextStyle(
                            fontSize: 13, color: AppConstant.textHint(context)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: AppConstant.border(context))),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: AppConstant.border(context))),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: AppConstant.primarycolor, width: 1.5)),
                        filled: true,
                        fillColor: AppConstant.inputBg(context),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // ── Buttons ──
                    Row(
                      children: [
                        FilledButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Invite sent to ${emailCtrl.text.trim()}'),
                                  backgroundColor: AppConstant.primarycolor,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                              );
                            }
                          },
                          style: FilledButton.styleFrom(
                            backgroundColor: AppConstant.primarycolor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 10),
                          ),
                          child: const Text('Send Invite',
                              style: TextStyle(fontWeight: FontWeight.w600)),
                        ),
                        const SizedBox(width: 12),
                        OutlinedButton(
                          onPressed: () {
                            emailCtrl.clear();
                            messageCtrl.clear();
                          },
                          style: OutlinedButton.styleFrom(
                            side:
                                BorderSide(color: AppConstant.border(context)),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 10),
                          ),
                          child: Text('Clear',
                              style: TextStyle(
                                  color: AppConstant.textSecondary(context),
                                  fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  //---------------------------------------------
  /// Build Method
  //---------------------------------------------

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Employee Management",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppConstant.textPrimary(context),
              ),
            ),
            Text(
              "Manage your workforce records",
              style: TextStyle(
                fontSize: 13,
                color: AppConstant.textPrimary(context),
              ),
            ),
          ],
        ),
      ),
      body: ScreenShimmerWrapper(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(Icons.mail),
                        label: const Text("Send Invite"),
                        onPressed: () {
                          _showSendInviteDialog();
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppConstant.primarycolor,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(Icons.add),
                        label: const Text("Add Employee"),
                        onPressed: () {
                          showEmployeeDialog();
                        },
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),

              //-----------------------------------------
              /// Search
              //-----------------------------------------

              const Text(
                "Search",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: "Search employee name or email",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: AppConstant.primarycolor,
                      width: 2,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              //-----------------------------------------
              /// Status Filter
              //-----------------------------------------

              const Text(
                "Status",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              DropdownButtonFormField<String>(
                value: filterStatus,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: const [
                  DropdownMenuItem(
                    value: "All Status",
                    child: Text("All Status"),
                  ),
                  DropdownMenuItem(
                    value: "Active",
                    child: Text("Active"),
                  ),
                  DropdownMenuItem(
                    value: "Inactive",
                    child: Text("Inactive"),
                  ),
                  DropdownMenuItem(
                    value: "Resigned",
                    child: Text("Resigned"),
                  ),
                  DropdownMenuItem(
                    value: "Terminated",
                    child: Text("Terminated"),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    filterStatus = value!;

                    searchEmployee();
                  });
                },
              ),

              const SizedBox(height: 20),

              //-----------------------------------------
              /// Buttons
              //-----------------------------------------

              const SizedBox(height: 25),

              //-----------------------------------------
              /// Employee Table
              //-----------------------------------------

              Container(
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
                        headingTextStyle: TextStyle(
                          color: AppConstant.textPrimary(context),
                          fontWeight: FontWeight.bold,
                        ),
                        columnSpacing: 40,
                        columns: const [
                          DataColumn(label: Text("#")),
                          DataColumn(label: Text("NAME")),
                          DataColumn(label: Text("EMAIL")),
                          DataColumn(label: Text("PHONE")),
                          DataColumn(label: Text("DEPARTMENT")),
                          DataColumn(label: Text("DESIGNATION")),
                          DataColumn(label: Text("ROUTINE")),
                          DataColumn(label: Text("STATUS")),
                          DataColumn(label: Text("ACTION")),
                        ],
                        rows: filteredUsers.asMap().entries.map((entry) {
                          final index = entry.key;

                          final employee = entry.value;

                          return DataRow(
                            cells: [
                              //---------------------------------
                              /// ID
                              //---------------------------------

                              DataCell(
                                Text("${employee.id}"),
                              ),

                              //---------------------------------
                              /// Name
                              //---------------------------------

                              DataCell(
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 16,
                                      backgroundColor: AppConstant.primarycolor
                                          .withValues(alpha: .15),
                                      child: Text(
                                        employee.name[0].toUpperCase(),
                                        style: TextStyle(
                                          color: AppConstant.primarycolor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(employee.name),
                                  ],
                                ),
                              ),

                              //---------------------------------
                              /// Email
                              //---------------------------------

                              DataCell(
                                Text(employee.email),
                              ),

                              //---------------------------------
                              /// Phone
                              //---------------------------------

                              DataCell(
                                Text(employee.phone),
                              ),

                              //---------------------------------
                              /// Department
                              //---------------------------------

                              DataCell(
                                Text(employee.department),
                              ),

                              //---------------------------------
                              /// Designation
                              //---------------------------------

                              DataCell(
                                Text(employee.designation),
                              ),

                              //---------------------------------
                              /// Routine
                              //---------------------------------

                              DataCell(
                                Text(employee.routine),
                              ),

                              //---------------------------------
                              /// Status
                              //---------------------------------

                              DataCell(
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: employee.status == "Active"
                                        ? Colors.green
                                        : employee.status == "Inactive"
                                            ? Colors.grey
                                            : employee.status == "Resigned"
                                                ? Colors.orange
                                                : Colors.red,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    employee.status,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),

                              //---------------------------------
                              /// Actions
                              //---------------------------------

                              DataCell(
                                Row(
                                  children: [
                                    Tooltip(
                                      message: "View",
                                      child: IconButton(
                                        icon: const Icon(
                                          Icons.remove_red_eye,
                                          color: Colors.blue,
                                        ),
                                        onPressed: () {
                                          viewEmployee(employee);
                                        },
                                      ),
                                    ),
                                    Tooltip(
                                      message: "Edit",
                                      child: IconButton(
                                        icon: const Icon(
                                          Icons.edit,
                                          color: Colors.orange,
                                        ),
                                        onPressed: () {
                                          showEmployeeDialog(
                                            employee: employee,
                                            index: index,
                                          );
                                        },
                                      ),
                                    ),
                                    Tooltip(
                                      message: "Delete",
                                      child: IconButton(
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                        onPressed: () {
                                          deleteEmployee(index);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _AddEmployeeWizard extends StatefulWidget {
  final VoidCallback onSaved;
  const _AddEmployeeWizard({required this.onSaved});
  @override
  State<_AddEmployeeWizard> createState() => _AddEmployeeWizardState();
}

class _AddEmployeeWizardState extends State<_AddEmployeeWizard> {
  int _currentStep = 0;

  // Step 1: Basic Info
  final _name = TextEditingController();
  final _fatherName = TextEditingController();
  final _email = TextEditingController();
  final _officialEmail = TextEditingController();
  final _phone = TextEditingController();
  final _emergencyNo = TextEditingController();
  final _cnic = TextEditingController();
  String _gender = '';
  String _dob = '';
  String _doj = '';
  String _department = '';
  String _empStatus = '';
  final _education = TextEditingController();
  final _experience = TextEditingController();
  final _shiftRoutine = TextEditingController();
  String _religion = '';
  String _maritalStatus = '';
  final _address = TextEditingController();
  final _reference = TextEditingController();

  // Step 2: Employment Details
  String _employmentType = '';
  String _workMode = '';
  String _empStatusDetail = '';
  final _probationMonths = TextEditingController();
  String _probationEndDate = '';
  final _contractMonths = TextEditingController();
  String _contractEndDate = '';

  // Step 3: Leaves
  String _leaveYear = '';
  final _annualLeaves = TextEditingController(text: '0');
  final _sickLeaves = TextEditingController(text: '0');
  final _casualLeaves = TextEditingController(text: '0');

  // Step 4: Documents
  String _profilePic = '';

  // Step 5: Bank Accounts
  final List<Map<String, dynamic>> _bankAccounts = [
    {
      'title': TextEditingController(),
      'bankName': TextEditingController(),
      'accountNo': TextEditingController(),
      'iban': TextEditingController(),
      'reference': TextEditingController(),
      'isPrimary': true,
    },
  ];

  final _stepTitles = [
    'Basic Info',
    'Employment Details',
    'Leaves Allocation',
    'Employee Documents',
    'Bank Accounts',
  ];

  @override
  void dispose() {
    for (final c in [
      _name,
      _fatherName,
      _email,
      _officialEmail,
      _phone,
      _emergencyNo,
      _cnic,
      _education,
      _experience,
      _shiftRoutine,
      _address,
      _reference,
      _probationMonths,
      _contractMonths,
      _annualLeaves,
      _sickLeaves,
      _casualLeaves,
    ]) {
      c.dispose();
    }
    for (final bank in _bankAccounts) {
      for (final c in bank.values.whereType<TextEditingController>()) {
        c.dispose();
      }
    }
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < _stepTitles.length - 1) {
      setState(() => _currentStep++);
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  void _addBankAccount() {
    setState(() {
      _bankAccounts.add({
        'title': TextEditingController(),
        'bankName': TextEditingController(),
        'accountNo': TextEditingController(),
        'iban': TextEditingController(),
        'reference': TextEditingController(),
        'isPrimary': false,
      });
    });
  }

  void _removeBankAccount(int index) {
    if (_bankAccounts.length > 1) {
      setState(() {
        final acc = _bankAccounts.removeAt(index);
        for (final c in acc.values.whereType<TextEditingController>()) {
          c.dispose();
        }
      });
    }
  }

  void _save() {
    widget.onSaved();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: AppConstant.cardBg(context),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.9,
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        child: Column(
          children: [
            // ── Header ──
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  Icon(Icons.person_add_outlined,
                      color: AppConstant.primarycolor, size: 22),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Add Employee',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppConstant.textPrimary(context)),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close,
                        color: AppConstant.textSecondary(context)),
                    style: IconButton.styleFrom(
                      backgroundColor: AppConstant.inputBg(context),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ],
              ),
            ),
            // ── Step indicator ──
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Row(
                children: List.generate(_stepTitles.length, (i) {
                  final isActive = i == _currentStep;
                  final isDone = i < _currentStep;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _currentStep = i),
                      child: Column(
                        children: [
                          Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isDone
                                  ? AppConstant.primarycolor
                                  : isActive
                                      ? AppConstant.primarycolor
                                      : AppConstant.inputBg(context),
                              border: Border.all(
                                color: isDone || isActive
                                    ? AppConstant.primarycolor
                                    : AppConstant.border(context),
                              ),
                            ),
                            child: Center(
                              child: isDone
                                  ? const Icon(Icons.check,
                                      size: 14, color: Colors.white)
                                  : Text('${i + 1}',
                                      style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: isActive
                                              ? Colors.white
                                              : AppConstant.textHint(context))),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _stepTitles[i],
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight:
                                  isActive ? FontWeight.bold : FontWeight.w500,
                              color: isActive
                                  ? AppConstant.primarycolor
                                  : AppConstant.textHint(context),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
            const Divider(height: 20),
            // ── Content ──
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildStepContent(),
              ),
            ),
            // ── Buttons ──
            Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              decoration: BoxDecoration(
                border:
                    Border(top: BorderSide(color: AppConstant.border(context))),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _currentStep > 0
                      ? OutlinedButton.icon(
                          onPressed: _prevStep,
                          icon: const Icon(Icons.arrow_back, size: 16),
                          label: const Text('Back'),
                          style: OutlinedButton.styleFrom(
                            side:
                                BorderSide(color: AppConstant.border(context)),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                          ),
                        )
                      : const SizedBox(),
                  _currentStep < _stepTitles.length - 1
                      ? FilledButton.icon(
                          onPressed: _nextStep,
                          icon: const Icon(Icons.arrow_forward, size: 16),
                          label: const Text('Next'),
                          style: FilledButton.styleFrom(
                            backgroundColor: AppConstant.primarycolor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 10),
                          ),
                        )
                      : FilledButton.icon(
                          onPressed: _save,
                          icon: const Icon(Icons.check, size: 16),
                          label: const Text('Create Employee'),
                          style: FilledButton.styleFrom(
                            backgroundColor: AppConstant.primarycolor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 10),
                          ),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildBasicInfo();
      case 1:
        return _buildEmploymentDetails();
      case 2:
        return _buildLeavesAllocation();
      case 3:
        return _buildDocuments();
      case 4:
        return _buildBankAccounts();
      default:
        return const SizedBox();
    }
  }

  // ── Step 1: Basic Info ──
  Widget _buildBasicInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Basic Info'),
        const SizedBox(height: 12),
        _row([
          _field(_name, 'Name', required: true),
          _field(_fatherName, 'Father Name'),
        ]),
        _row([
          _field(_email, 'Email',
              required: true, keyboard: TextInputType.emailAddress),
          _field(_officialEmail, 'Official Email',
              keyboard: TextInputType.emailAddress,
              hint: 'e.g. etc123@briskdev.co',
              sub: 'Set employee official email (e.g. etc123@briskdev.co).'),
        ]),
        _row([
          _field(_phone, 'Phone No',
              required: true, keyboard: TextInputType.phone),
          _field(_emergencyNo, 'Emergency No', keyboard: TextInputType.phone),
        ]),
        _row([
          _field(_cnic, 'CNIC', required: true, hint: '12345-1234567-1'),
          _dropdown('Gender', ['Male', 'Female', 'Other'], (v) => _gender = v),
        ]),
        _row([
          _dateField('Date of Birth'),
          _dateField('Date of Joining'),
        ]),
        _row([
          _dropdown(
              'Department',
              ['IT', 'HR', 'Finance', 'Marketing', 'Operations', 'Development'],
              (v) => _department = v),
          _dropdown('Status', ['Active', 'Inactive', 'On Leave', 'Probation'],
              (v) => _empStatus = v),
        ]),
        _row([
          _field(_education, 'Education'),
          _field(_experience, 'Experience'),
        ]),
        _row([
          _field(_shiftRoutine, 'Employee Shift Routine',
              hint:
                  'Shifts are managed from the Employee Shift Routine screen.'),
          _dropdown(
              'Religion',
              ['Islam', 'Christianity', 'Hinduism', 'Sikhism', 'Other'],
              (v) => _religion = v),
        ]),
        _dropdown(
            'Marital Status',
            ['Single', 'Married', 'Divorced', 'Widowed'],
            (v) => _maritalStatus = v),
        _field(_address, 'Address', maxLines: 3),
        _field(_reference, 'Reference'),
        const SizedBox(height: 8),
      ],
    );
  }

  // ── Step 2: Employment Details ──
  Widget _buildEmploymentDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Employment Details'),
        const SizedBox(height: 12),
        _row([
          _dropdown(
              'Employment Type',
              ['Full-Time', 'Part-Time', 'Contract', 'Intern'],
              (v) => _employmentType = v),
          _dropdown('Work Mode', ['On-Site', 'Remote', 'Hybrid'],
              (v) => _workMode = v),
          _dropdown(
              'Employee Status',
              ['Probation', 'Confirmed', 'Notice Period'],
              (v) => _empStatusDetail = v),
        ]),
        _row([
          _field(_probationMonths, 'Probation Months', hint: 'e.g. 3'),
          _dateField('Probation End Date'),
        ]),
        _row([
          _field(_contractMonths, 'Contract Months', hint: 'e.g. 12'),
          _dateField('Contract End Date'),
        ]),
        const SizedBox(height: 8),
      ],
    );
  }

  // ── Step 3: Leaves Allocation ──
  Widget _buildLeavesAllocation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Leaves Allocation'),
        const SizedBox(height: 12),
        _row([
          _dropdown('Year', ['2024', '2025', '2026'], (v) => _leaveYear = v),
          _field(_annualLeaves, 'Annual Leaves', required: true),
          _field(_sickLeaves, 'Sick Leaves', required: true),
        ]),
        _field(_casualLeaves, 'Casual Leaves', required: true),
        const SizedBox(height: 8),
      ],
    );
  }

  // ── Step 4: Documents ──
  Widget _buildDocuments() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Employee Documents'),
        const SizedBox(height: 12),
        Text('Profile Picture',
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppConstant.textPrimary(context))),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            border: Border.all(color: AppConstant.border(context)),
            borderRadius: BorderRadius.circular(10),
            color: AppConstant.inputBg(context),
          ),
          child: Row(
            children: [
              ElevatedButton(
                onPressed: () { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Action Performed!'))); },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstant.cardBg(context),
                  side: BorderSide(color: AppConstant.border(context)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: Text('Choose file',
                    style: TextStyle(
                        fontSize: 12, color: AppConstant.textPrimary(context))),
              ),
              const SizedBox(width: 12),
              Text(_profilePic.isEmpty ? 'No file chosen' : _profilePic,
                  style: TextStyle(
                      fontSize: 12, color: AppConstant.textHint(context))),
            ],
          ),
        ),
        const SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: () { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Action Performed!'))); },
          icon: const Icon(Icons.add, size: 16),
          label: const Text('Add Another Document'),
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: AppConstant.primarycolor),
            foregroundColor: AppConstant.primarycolor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  // ── Step 5: Bank Accounts ──
  Widget _buildBankAccounts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Bank Accounts'),
        const SizedBox(height: 12),
        ...List.generate(_bankAccounts.length, (i) {
          final acc = _bankAccounts[i];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              border: Border.all(color: AppConstant.border(context)),
              borderRadius: BorderRadius.circular(12),
              color: AppConstant.inputBg(context),
            ),
            child: Column(
              children: [
                _row([
                  _field(acc['title'] as TextEditingController, 'Account Title',
                      required: true),
                  _field(acc['bankName'] as TextEditingController, 'Bank Name',
                      required: true),
                  _field(acc['accountNo'] as TextEditingController,
                      'Account Number',
                      required: true),
                ]),
                _row([
                  _field(acc['iban'] as TextEditingController, 'IBAN'),
                  _field(
                      acc['reference'] as TextEditingController, 'Reference'),
                ]),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Radio<bool>(
                      value: true,
                      groupValue: acc['isPrimary'] as bool,
                      activeColor: AppConstant.primarycolor,
                      onChanged: (v) {
                        setState(() {
                          for (final a in _bankAccounts) {
                            a['isPrimary'] = false;
                          }
                          acc['isPrimary'] = true;
                        });
                      },
                    ),
                    Text('Primary',
                        style: TextStyle(
                            fontSize: 12,
                            color: AppConstant.textPrimary(context))),
                    const Spacer(),
                    if (_bankAccounts.length > 1)
                      TextButton.icon(
                        onPressed: () => _removeBankAccount(i),
                        icon: const Icon(Icons.delete_outline,
                            size: 16, color: Colors.red),
                        label: const Text('Remove',
                            style: TextStyle(color: Colors.red, fontSize: 12)),
                      ),
                  ],
                ),
              ],
            ),
          );
        }),
        OutlinedButton.icon(
          onPressed: _addBankAccount,
          icon: const Icon(Icons.add, size: 16),
          label: const Text('Add Bank Account'),
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: AppConstant.primarycolor),
            foregroundColor: AppConstant.primarycolor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  // ── Helpers ──
  Widget _sectionTitle(String title) {
    return Text(title,
        style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppConstant.textPrimary(context)));
  }

  Widget _row(List<Widget> children) {
    if (children.length == 1) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: children[0],
      );
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        children:
            children.expand((w) => [w, const SizedBox(height: 12)]).toList()
              ..removeLast(),
      ),
    );
  }

  Widget _field(TextEditingController ctrl, String label,
      {bool required = false,
      TextInputType? keyboard,
      String? hint,
      String? sub,
      int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppConstant.textPrimary(context))),
            if (required)
              const Text(' *',
                  style: TextStyle(color: Colors.red, fontSize: 12)),
          ],
        ),
        const SizedBox(height: 4),
        TextFormField(
          controller: ctrl,
          keyboardType: keyboard,
          maxLines: maxLines,
          style:
              TextStyle(fontSize: 12, color: AppConstant.textPrimary(context)),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle:
                TextStyle(fontSize: 12, color: AppConstant.textHint(context)),
            isDense: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppConstant.border(context))),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppConstant.border(context))),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide:
                    BorderSide(color: AppConstant.primarycolor, width: 1.5)),
            filled: true,
            fillColor: AppConstant.inputBg(context),
          ),
          validator: (v) {
            if (required && (v == null || v.trim().isEmpty)) {
              return '$label is required';
            }
            return null;
          },
        ),
        if (sub != null) ...[
          const SizedBox(height: 2),
          Text(sub,
              style: TextStyle(
                  fontSize: 10, color: AppConstant.textHint(context))),
        ],
      ],
    );
  }

  Widget _dropdown(
      String label, List<String> items, Function(String) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppConstant.textPrimary(context))),
        const SizedBox(height: 4),
        DropdownButtonFormField<String>(
          isDense: true,
          decoration: InputDecoration(
            isDense: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppConstant.border(context))),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppConstant.border(context))),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide:
                    BorderSide(color: AppConstant.primarycolor, width: 1.5)),
            filled: true,
            fillColor: AppConstant.inputBg(context),
          ),
          items: items
              .map((e) => DropdownMenuItem(
                  value: e,
                  child: Text(e,
                      style: TextStyle(
                          fontSize: 12,
                          color: AppConstant.textPrimary(context)))))
              .toList(),
          onChanged: (v) {
            if (v != null) onChanged(v);
          },
        ),
      ],
    );
  }

  Widget _dateField(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppConstant.textPrimary(context))),
        const SizedBox(height: 4),
        TextFormField(
          readOnly: true,
          style:
              TextStyle(fontSize: 12, color: AppConstant.textPrimary(context)),
          decoration: InputDecoration(
            hintText: 'mm/dd/yyyy',
            hintStyle:
                TextStyle(fontSize: 12, color: AppConstant.textHint(context)),
            isDense: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            suffixIcon: Icon(Icons.calendar_today,
                size: 16, color: AppConstant.textHint(context)),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppConstant.border(context))),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppConstant.border(context))),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide:
                    BorderSide(color: AppConstant.primarycolor, width: 1.5)),
            filled: true,
            fillColor: AppConstant.inputBg(context),
          ),
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1980),
              lastDate: DateTime(2030),
            );
            if (date != null) {
              setState(() {
                // Store date value
              });
            }
          },
        ),
      ],
    );
  }
}
