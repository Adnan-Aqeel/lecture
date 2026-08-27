import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lecture/core/constants/app_colors.dart';
import 'package:lecture/core/widgets/shimmer_widgets.dart';

// ─── Model ───────────────────────────────────────────────────────────────────

class Department {
  int id;
  String name;
  String description;
  bool isActive;

  Department({
    required this.id,
    required this.name,
    required this.description,
    required this.isActive,
  });
}

// ─── Screen ──────────────────────────────────────────────────────────────────

class DepartmentScreen extends StatefulWidget {
  const DepartmentScreen({super.key});

  @override
  State<DepartmentScreen> createState() => _DepartmentScreenState();
}

class _DepartmentScreenState extends State<DepartmentScreen> {
  // ── Data ──────────────────────────────────────────────────────────────────
  final List<Department> _allDepartments = [
    Department(
        id: 1,
        name: 'Business Analyst',
        description: 'Business Analyst Department',
        isActive: true),
    Department(
        id: 2,
        name: 'Business Development',
        description: 'Business Development Department',
        isActive: true),
    Department(
        id: 3,
        name: 'Development',
        description: 'Development Department',
        isActive: true),
    Department(
        id: 4,
        name: 'Finance',
        description: 'Finance Department',
        isActive: true),
    Department(
        id: 5,
        name: 'Human Resources',
        description: 'Human Resources Department',
        isActive: true),
    Department(
        id: 6,
        name: 'Operations',
        description: 'HR, Operations and Finance',
        isActive: true),
    Department(
        id: 7,
        name: 'Project Manager',
        description: 'Project Manager',
        isActive: true),
    Department(
        id: 8,
        name: 'Quality Assurance',
        description: 'Quality Assurance Department',
        isActive: true),
    Department(
        id: 9,
        name: 'Social Media',
        description: 'Social Media Department',
        isActive: false),
  ];

  List<Department> _filtered = [];
  final TextEditingController _searchCtrl = TextEditingController();

  // ── Scroll controllers ───────────────────────────────────────────────────
  final ScrollController horizontalcontroller = ScrollController();
  final ScrollController verticalcontroller = ScrollController();

  // ── Pagination ────────────────────────────────────────────────────────────
  int _currentPage = 1;
  int _entriesPerPage = 10;
  final List<int> _pageSizes = [5, 10, 15, 25];

  // ── Computed ──────────────────────────────────────────────────────────────
  List<Department> get _paginated {
    final start = (_currentPage - 1) * _entriesPerPage;
    final end = (start + _entriesPerPage).clamp(0, _filtered.length);
    return _filtered.sublist(start, end);
  }

  int get _totalPages =>
      (_filtered.length / _entriesPerPage).ceil().clamp(1, 999);

  @override
  void initState() {
    super.initState();
    _filtered = List.from(_allDepartments);
    _searchCtrl.addListener(_onSearch);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    horizontalcontroller.dispose();
    verticalcontroller.dispose();
    super.dispose();
  }

  void _onSearch() {
    final q = _searchCtrl.text.toLowerCase();
    setState(() {
      _filtered = _allDepartments
          .where((d) =>
              d.name.toLowerCase().contains(q) ||
              d.description.toLowerCase().contains(q))
          .toList();
      _currentPage = 1;
    });
  }

  // ── Dialogs ───────────────────────────────────────────────────────────────

  void _showAddEditDialog({Department? dept}) {
    final nameCtrl = TextEditingController(text: dept?.name ?? '');
    final descCtrl = TextEditingController(text: dept?.description ?? '');
    bool isActive = dept?.isActive ?? true;
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setS) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          titlePadding: EdgeInsets.zero,
          title: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: AppConstant.primarycolor,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                Icon(
                    dept == null
                        ? Icons.add_business_rounded
                        : Icons.edit_rounded,
                    color: Colors.white,
                    size: 20),
                const SizedBox(width: 10),
                Text(
                  dept == null ? 'Add Department' : 'Edit Department',
                  style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white),
                ),
              ],
            ),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 8),
                  _dialogField(
                    ctrl: nameCtrl,
                    label: 'Department Name',
                    hint: 'e.g. Finance',
                    icon: Icons.business_center_outlined,
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Name is required'
                        : null,
                  ),
                  const SizedBox(height: 14),
                  _dialogField(
                    ctrl: descCtrl,
                    label: 'Description',
                    hint: 'e.g. Finance Department',
                    icon: Icons.description_outlined,
                    maxLines: 2,
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Text('Status:',
                          style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppConstant.textPrimary(context))),
                      const Spacer(),
                      Transform.scale(
                        scale: 0.85,
                        child: Switch(
                          value: isActive,
                          activeColor: AppConstant.primarycolor,
                          onChanged: (v) => setS(() => isActive = v),
                        ),
                      ),
                      Text(
                        isActive ? 'Active' : 'Inactive',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isActive
                              ? const Color(0xFF10B981)
                              : const Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel',
                  style: GoogleFonts.inter(
                      fontSize: 13,
                      color: AppConstant.textSecondary(context),
                      fontWeight: FontWeight.w600)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstant.primarycolor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              ),
              onPressed: () {
                if (!formKey.currentState!.validate()) return;
                setState(() {
                  if (dept == null) {
                    final newId = _allDepartments.isEmpty
                        ? 1
                        : _allDepartments
                                .map((d) => d.id)
                                .reduce((a, b) => a > b ? a : b) +
                            1;
                    _allDepartments.add(Department(
                      id: newId,
                      name: nameCtrl.text.trim(),
                      description: descCtrl.text.trim(),
                      isActive: isActive,
                    ));
                  } else {
                    dept.name = nameCtrl.text.trim();
                    dept.description = descCtrl.text.trim();
                    dept.isActive = isActive;
                  }
                  _onSearch();
                });
                Navigator.pop(context);
                _showSnack(
                    dept == null ? 'Department added!' : 'Department updated!');
              },
              child: Text(dept == null ? 'Add' : 'Update',
                  style: GoogleFonts.inter(
                      fontSize: 13, fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(Department dept) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Color(0xFFEF4444)),
            const SizedBox(width: 8),
            Text('Delete Department',
                style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppConstant.textPrimary(context))),
          ],
        ),
        content: RichText(
          text: TextSpan(
            style: GoogleFonts.inter(
                fontSize: 13, color: AppConstant.textSecondary(context)),
            children: [
              const TextSpan(text: 'Are you sure you want to delete '),
              TextSpan(
                text: '"${dept.name}"',
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppConstant.primarycolor),
              ),
              const TextSpan(text: '? This action cannot be undone.'),
            ],
          ),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel',
                style: GoogleFonts.inter(
                    fontSize: 13,
                    color: AppConstant.textSecondary(context),
                    fontWeight: FontWeight.w600)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            ),
            onPressed: () {
              setState(() {
                _allDepartments.removeWhere((d) => d.id == dept.id);
                _onSearch();
              });
              Navigator.pop(context);
              _showSnack('Department deleted.');
            },
            child: Text('Delete',
                style: GoogleFonts.inter(
                    fontSize: 13, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: GoogleFonts.inter(fontSize: 13)),
        backgroundColor: AppConstant.primarycolor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  Widget _dialogField({
    required TextEditingController ctrl,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: ctrl,
      maxLines: maxLines,
      validator: validator,
      style: GoogleFonts.inter(
          fontSize: 13, color: AppConstant.textPrimary(context)),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, size: 18, color: AppConstant.primarycolor),
        labelStyle: GoogleFonts.inter(
            fontSize: 12, color: AppConstant.textSecondary(context)),
        hintStyle: GoogleFonts.inter(
            fontSize: 12, color: AppConstant.textHint(context)),
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
        filled: true,
        fillColor: AppConstant.inputBg(context),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────

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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Departments',
                style: GoogleFonts.inter(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: AppConstant.textPrimary(context))),
            Text('Create, update and manage organization departments',
                style: GoogleFonts.inter(
                    fontSize: 13, color: AppConstant.textPrimary(context))),
          ],
        ),
      ),
      body: ScreenShimmerWrapper(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConstant.primarycolor,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                    ),
                    icon: const Icon(
                      Icons.add_rounded,
                      size: 16,  
                      color: Colors.black,
                    ),
                    label: Text('Add Department',
                        style: GoogleFonts.inter(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.w700)),
                    onPressed: () => _showAddEditDialog(),
                  ),
                ),
              ),
              SizedBox(height: 12),
              // ── Search bar ────────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _searchCtrl,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search departments...',
                    hintStyle: GoogleFonts.inter(
                      fontSize: 13,
                      color: AppConstant.textHint(context),
                    ),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      size: 18,
                      color: AppConstant.textHint(context),
                    ),
                    suffixIcon: _searchCtrl.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(
                              Icons.clear_rounded,
                              size: 16,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              _searchCtrl.clear();
                              _onSearch();
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: AppConstant.cardBg(context),
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
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12),
                  ),
                ),
              ),

              // ── DataTable inside styled Container ────────────────────────────
              _filtered.isEmpty
                  ? _buildEmptyState()
                  : Padding(
                      padding: const EdgeInsets.all(16),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppConstant.cardBg(context),
                          borderRadius: BorderRadius.circular(10),
                          border:
                              Border.all(color: AppConstant.border(context)),
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
                              child: SingleChildScrollView(
                                controller: verticalcontroller,
                                scrollDirection: Axis.vertical,
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    minWidth: MediaQuery.of(context).size.width,
                                  ),
                                  child: DataTable(
                                    headingRowColor: WidgetStateProperty.all(
                                      AppConstant.primarycolor,
                                    ),
                                    headingTextStyle: GoogleFonts.inter(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: AppConstant.textPrimary(context),
                                      letterSpacing: 0.5,
                                    ),
                                    dataTextStyle: GoogleFonts.inter(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: AppConstant.textPrimary(context),
                                    ),
                                    headingRowHeight: 44,
                                    dataRowMinHeight: 56,
                                    dataRowMaxHeight: 64,
                                    columnSpacing: 24,
                                    horizontalMargin: 16,
                                    dividerThickness: 1,
                                    columns: const [
                                      DataColumn(label: Text('#')),
                                      DataColumn(label: Text('NAME')),
                                      DataColumn(label: Text('DESCRIPTION')),
                                      DataColumn(label: Text('STATUS')),
                                      DataColumn(label: Text('ACTIONS')),
                                    ],
                                    rows: List<DataRow>.generate(
                                      _paginated.length,
                                      (index) {
                                        final dept = _paginated[index];
                                        final isEven = index % 2 == 0;
                                        return DataRow(
                                          color: WidgetStateProperty.all(
                                            isEven
                                                ? AppConstant.cardBg(context)
                                                : AppConstant.inputBg(context),
                                          ),
                                          cells: [
                                            DataCell(
                                              Text(
                                                '${(_currentPage - 1) * _entriesPerPage + index + 1}',
                                                style: GoogleFonts.inter(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                  color: AppConstant.textHint(
                                                      context),
                                                ),
                                              ),
                                            ),
                                            DataCell(
                                              Text(
                                                dept.name,
                                                style: GoogleFonts.inter(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w700,
                                                  color:
                                                      AppConstant.primarycolor,
                                                ),
                                              ),
                                            ),
                                            DataCell(
                                              ConstrainedBox(
                                                constraints:
                                                    const BoxConstraints(
                                                        maxWidth: 260),
                                                child: Text(
                                                  dept.description,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                  style: GoogleFonts.inter(
                                                    fontSize: 12,
                                                    color: AppConstant
                                                        .textSecondary(context),
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            DataCell(_StatusBadge(
                                                isActive: dept.isActive)),
                                            DataCell(
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  _ActionIconBtn(
                                                    icon: Icons.edit_outlined,
                                                    color: AppConstant
                                                        .primarycolor,
                                                    tooltip: 'Edit',
                                                    onTap: () =>
                                                        _showAddEditDialog(
                                                            dept: dept),
                                                  ),
                                                  const SizedBox(width: 6),
                                                  _ActionIconBtn(
                                                    icon: Icons
                                                        .delete_outline_rounded,
                                                    color:
                                                        const Color(0xFFEF4444),
                                                    tooltip: 'Delete',
                                                    onTap: () =>
                                                        _confirmDelete(dept),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

              // ── Pagination footer ─────────────────────────────────────────────
              _buildPaginationFooter(),
            ],
          ),
        ),
      ),
    );
  }

  // ── Empty state ───────────────────────────────────────────────────────────

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.business_outlined,
              size: 64, color: AppConstant.textHint(context)),
          const SizedBox(height: 16),
          Text('No departments found',
              style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppConstant.textSecondary(context))),
          const SizedBox(height: 6),
          Text('Try adjusting your search or add a new department.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                  fontSize: 12, color: AppConstant.textHint(context))),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstant.primarycolor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            icon: const Icon(Icons.add_rounded, size: 16),
            label: Text('Add Department',
                style: GoogleFonts.inter(
                    fontSize: 13, fontWeight: FontWeight.w600)),
            onPressed: () => _showAddEditDialog(),
          ),
        ],
      ),
    );
  }

  // ── Pagination footer ─────────────────────────────────────────────────────

  Widget _buildPaginationFooter() {
    final start =
        _filtered.isEmpty ? 0 : (_currentPage - 1) * _entriesPerPage + 1;
    final end = ((_currentPage) * _entriesPerPage).clamp(0, _filtered.length);

    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 8.0, // Horizontal gap
      runSpacing: 10.0, // Vertical gap jab line change ho
      children: [
        // Left Side: Show X entries
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Show',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppConstant.textSecondary(context),
                ),
              ),
              const SizedBox(width: 6),
              Container(
                height: 30,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: AppConstant.border(context)),
                  borderRadius: BorderRadius.circular(6),
                  color: AppConstant.cardBg(context),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    value: _entriesPerPage,
                    isDense: true,
                    items: _pageSizes
                        .map((s) => DropdownMenuItem(
                              value: s,
                              child: Text(
                                '$s',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: AppConstant.textPrimary(context),
                                ),
                              ),
                            ))
                        .toList(),
                    onChanged: (v) {
                      if (v == null) return;
                      setState(() {
                        _entriesPerPage = v;
                        _currentPage = 1;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Text(
                'entries',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppConstant.textSecondary(context),
                ),
              ),
            ],
          ),
        ),

        // Right Side: Records Info + Pagination Buttons
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Records info
            Text(
              _filtered.isEmpty
                  ? 'No records'
                  : 'Page $_currentPage — Records: $start-$end of ${_filtered.length}',
              style: GoogleFonts.inter(
                fontSize: 11,
                color: AppConstant.textHint(context),
              ),
            ),

            const SizedBox(width: 10),

            // Prev / Page buttons / Next
            _PaginationBtn(
              icon: Icons.first_page_rounded,
              enabled: _currentPage > 1,
              onTap: () => setState(() => _currentPage = 1),
            ),
            const SizedBox(width: 4),
            _PaginationBtn(
              icon: Icons.chevron_left_rounded,
              enabled: _currentPage > 1,
              onTap: () => setState(() => _currentPage--),
            ),
            const SizedBox(width: 4),
            // Page number chip
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppConstant.primarycolor,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '$_currentPage',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 4),
            _PaginationBtn(
              icon: Icons.chevron_right_rounded,
              enabled: _currentPage < _totalPages,
              onTap: () => setState(() => _currentPage++),
            ),
            const SizedBox(width: 4),
            _PaginationBtn(
              icon: Icons.last_page_rounded,
              enabled: _currentPage < _totalPages,
              onTap: () => setState(() => _currentPage = _totalPages),
            ),
          ],
        ),
      ],
    );
  }
}

// ─── Small reusable widgets ───────────────────────────────────────────────────

class _StatusBadge extends StatelessWidget {
  final bool isActive;
  const _StatusBadge({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isActive
            ? const Color(0xFF10B981).withValues(alpha: 0.12)
            : const Color(0xFF94A3B8).withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isActive
              ? const Color(0xFF10B981).withValues(alpha: 0.4)
              : const Color(0xFF94A3B8).withValues(alpha: 0.4),
        ),
      ),
      child: Text(
        isActive ? 'Active' : 'Inactive',
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: isActive ? const Color(0xFF10B981) : const Color(0xFF94A3B8),
        ),
      ),
    );
  }
}

class _ActionIconBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String tooltip;
  final VoidCallback onTap;
  const _ActionIconBtn(
      {required this.icon,
      required this.color,
      required this.tooltip,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color.withValues(alpha: 0.25)),
          ),
          child: Icon(icon, size: 15, color: color),
        ),
      ),
    );
  }
}

class _PaginationBtn extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;
  const _PaginationBtn(
      {required this.icon, required this.enabled, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(6),
      child: Container(
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
      ),
    );
  }
}
