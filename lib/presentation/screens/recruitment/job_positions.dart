import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lecture/core/constants/app_colors.dart';
import 'package:lecture/core/widgets/shimmer_widgets.dart';

class JobPositions extends StatefulWidget {
  const JobPositions({super.key});

  @override
  State<JobPositions> createState() => _JobPositionsState();
}

class _JobPositionsState extends State<JobPositions> {
  final _searchController = TextEditingController();
  final _titleController = TextEditingController();
  final _vacanciesController = TextEditingController(text: '1');
  final _salaryMinController = TextEditingController();
  final _salaryMaxController = TextEditingController();
  final _experienceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _openingDateController = TextEditingController();
  final _closingDateController = TextEditingController();
  String _department = 'All Departments';
  String _status = 'All Statuses';

  @override
  void dispose() {
    _searchController.dispose();
    _titleController.dispose();
    _vacanciesController.dispose();
    _salaryMinController.dispose();
    _salaryMaxController.dispose();
    _experienceController.dispose();
    _descriptionController.dispose();
    _openingDateController.dispose();
    _closingDateController.dispose();
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
            Text('Job Positions',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppConstant.textPrimary(context))),
            Text('Manage open job positions and vacancies',
                style: TextStyle(
                    fontSize: 13, color: AppConstant.textPrimary(context))),
          ],
        ),
      ),
      body: ScreenShimmerWrapper(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 30),
          children: [
            _buildFilters(),
            const SizedBox(height: 26),
            _buildEmptyState(),
          ],
        ),
      ),
    );
  }

  Widget _buildFilters() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: SizedBox(
              height: 50,
              width: 200,
              child: Card(
                  color: AppConstant.primarycolor,
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: _showNewPositionDialog,
                          icon: const Icon(Icons.add_circle_outline,
                              color: Colors.black)),
                      Text(
                        "New Positions",
                        style: TextStyle(color: Colors.black),
                      )
                    ],
                  )),
              ),
            ),
          ),
          const Text('Search',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF94A3B8),
              )),
          const SizedBox(height: 8),
          TextField(
            controller: _searchController,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              hintText: 'Search title / department...',
              prefixIcon: const Icon(Icons.search, color: Color(0xFF0DB9D8)),
              suffixIcon: _searchController.text.isEmpty
                  ? null
                  : IconButton(
                      onPressed: () {
                        _searchController.clear();
                        setState(() {});
                      },
                      icon: const Icon(Icons.clear)),
              filled: true,
              fillColor: AppConstant.cardBg(context),
              border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
            ),
          ),
          const SizedBox(height: 16),
          _dropdownLabel('Department', context),
          const SizedBox(height: 8),
          _dropdown(
              _department,
              ['All Departments', 'Engineering', 'Sales', 'Human Resources'],
              (value) => setState(() => _department = value!)),
          const SizedBox(height: 16),
          _dropdownLabel('Status', context),
          const SizedBox(height: 8),
          _dropdown(_status, ['All Statuses', 'Open', 'Closed', 'On Hold'],
              (value) => setState(() => _status = value!)),
        ],
      );

  Widget _dropdownLabel(String label, BuildContext context) => Text(label,
      style: TextStyle(
          fontWeight: FontWeight.bold,
          color: AppConstant.textPrimary(context)));

  Widget _dropdown(
          String value, List<String> items, ValueChanged<String?> onChanged) =>
      DropdownButtonFormField<String>(
        value: value,
        isExpanded: true,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            filled: true,
            fillColor: AppConstant.cardBg(context),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)))),
        items: items
            .map((item) => DropdownMenuItem(
                value: item,
                child: Text(item,
                    style: TextStyle(color: AppConstant.textPrimary(context)))))
            .toList(),
        onChanged: onChanged,
      );

  Widget _buildEmptyState() => SizedBox(
        height: 245,
        child: Center(
            child: Text('No positions found.',
                style:
                    TextStyle(fontSize: 18, color: Colors.blueGrey.shade400))),
      );

  Future<void> _showNewPositionDialog() async {
    _titleController.clear();
    _vacanciesController.text = '1';
    _salaryMinController.clear();
    _salaryMaxController.clear();
    _experienceController.clear();
    _descriptionController.clear();
    final today = DateTime.now();
    _openingDateController.text = _formatDate(today);
    _closingDateController.clear();

    String employmentType = 'Full-time';
    String department = 'Select department...';
    String status = 'Open';
    final formKey = GlobalKey<FormState>();

    final created = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: StatefulBuilder(
          builder: (context, setDialogState) {
            return ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900, maxHeight: 760),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 18, 12, 14),
                      child: Row(
                        children: [
                          const Expanded(
                            child: Text('New Job Position',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                          ),
                          IconButton(
                            onPressed: () => Navigator.pop(dialogContext),
                            icon: const Icon(Icons.close),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(20),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final compact = constraints.maxWidth < 600;
                            final title = _dialogTextField(
                                'Title *', _titleController,
                                required: true);
                            final employment = _dialogDropdown(
                                'Employment Type',
                                employmentType,
                                [
                                  'Full-time',
                                  'Part-time',
                                  'Contract',
                                  'Internship'
                                ],
                                (value) => setDialogState(
                                    () => employmentType = value!));
                            final departmentField = _dialogDropdown(
                                'Department *',
                                department,
                                [
                                  'Select department...',
                                  'Engineering',
                                  'Sales',
                                  'Human Resources'
                                ],
                                (value) =>
                                    setDialogState(() => department = value!));
                            final vacancies = _dialogTextField(
                                'Vacancies', _vacanciesController,
                                keyboardType: TextInputType.number);
                            final statusField = _dialogDropdown(
                                'Status',
                                status,
                                ['Open', 'Closed', 'On Hold'],
                                (value) =>
                                    setDialogState(() => status = value!));
                            final opening = _dateField('Opening Date',
                                _openingDateController, today, setDialogState);
                            final closing = _dateField('Closing Date',
                                _closingDateController, today, setDialogState);
                            final salaryMin = _dialogTextField(
                                'Salary Min', _salaryMinController,
                                keyboardType: TextInputType.number);
                            final salaryMax = _dialogTextField(
                                'Salary Max', _salaryMaxController,
                                keyboardType: TextInputType.number);
                            final experience = _dialogTextField(
                                'Required Experience', _experienceController,
                                hint: 'e.g. 3+ years in React');

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _dialogRow([title, employment], compact),
                                _dialogRow([
                                  departmentField,
                                  vacancies,
                                  statusField,
                                ], compact),
                                _dialogRow(
                                    [opening, closing, salaryMin], compact),
                                _dialogRow([salaryMax, experience], compact),
                                _dialogLabel('Recruitment Pipeline'),
                                const SizedBox(height: 8),
                                _pipelineInfo(),
                                const SizedBox(height: 4),
                                Text(
                                    'All positions share the global pipeline. Stages are filtered per position on the board.',
                                    style: TextStyle(
                                        color:
                                            AppConstant.textSecondary(context),
                                        fontSize: 12)),
                                const SizedBox(height: 16),
                                _dialogLabel('Description'),
                                const SizedBox(height: 8),
                                TextField(
                                  controller: _descriptionController,
                                  maxLines: 4,
                                  decoration: _inputDecoration(''),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                    const Divider(height: 1),
                    Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                              onPressed: () => Navigator.pop(dialogContext),
                              child: const Text('Cancel')),
                          const SizedBox(width: 10),
                          FilledButton(
                            onPressed: () {
                              if (!formKey.currentState!.validate() ||
                                  department == 'Select department...') {
                                if (department == 'Select department...') {
                                  ScaffoldMessenger.of(dialogContext)
                                      .showSnackBar(const SnackBar(
                                          content:
                                              Text('Select a department.')));
                                }
                                return;
                              }
                              Navigator.pop(dialogContext, true);
                            },
                            child: const Text('Create'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );

    if (created == true && mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Job position created.')));
    }
  }

  Widget _dialogRow(List<Widget> children, bool compact) {
    if (compact) {
      return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: children
              .expand((child) => [child, const SizedBox(height: 14)])
              .toList());
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children
              .map((child) => Expanded(
                  child: Padding(
                      padding: const EdgeInsets.only(right: 12), child: child)))
              .toList()),
    );
  }

  Widget _dialogLabel(String text) => Text(text,
      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600));

  Widget _dialogTextField(String label, TextEditingController controller,
      {String hint = '', bool required = false, TextInputType? keyboardType}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _dialogLabel(label),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: required
              ? (value) =>
                  value == null || value.trim().isEmpty ? 'Required' : null
              : null,
          decoration: _inputDecoration(hint),
        ),
      ],
    );
  }

  Widget _dialogDropdown(String label, String value, List<String> items,
      ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _dialogLabel(label),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          isExpanded: true,
          decoration: _inputDecoration(''),
          items: items
              .map((item) => DropdownMenuItem(value: item, child: Text(item)))
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _dateField(String label, TextEditingController controller,
      DateTime firstDate, StateSetter setDialogState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _dialogLabel(label),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          readOnly: true,
          onTap: () async {
            final date = await showDatePicker(
                context: context,
                firstDate: firstDate,
                lastDate: DateTime(2100),
                initialDate: firstDate);
            if (date != null) {
              setDialogState(() => controller.text = _formatDate(date));
            }
          },
          decoration: _inputDecoration('mm/dd/yyyy').copyWith(
              suffixIcon: const Icon(Icons.calendar_today_outlined, size: 17)),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration(String hint) => InputDecoration(
        hintText: hint.isEmpty ? null : hint,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      );

  Widget _pipelineInfo() => Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFCBD5E1)),
            borderRadius: BorderRadius.circular(8)),
        child: const Row(
          children: [
            Icon(Icons.account_tree_outlined, size: 18),
            SizedBox(width: 10),
            Text(
              'Auto-assigned from the system default pipeline',
              style: TextStyle(fontSize: 10),
            ),
          ],
        ),
      );

  String _formatDate(DateTime date) =>
      '${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}/${date.year}';
}
