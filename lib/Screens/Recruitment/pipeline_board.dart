import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lecture/appcolor.dart';
import 'package:lecture/widgets/shimmer_widgets.dart';
import 'package:lecture/utils/mobile_file_actions.dart';

class PipelineBoard extends StatefulWidget {
  const PipelineBoard({super.key});

  @override
  State<PipelineBoard> createState() => _PipelineBoardState();
}

class _PipelineBoardState extends State<PipelineBoard> {
  String _pipeline = 'Standard Recruitment Pipeline';
  String _department = 'All Departments';
  String _position = 'All Job Positions';
  final _searchController = TextEditingController();
  final _candidateNameController = TextEditingController();
  final _candidateEmailController = TextEditingController();
  final _candidatePhoneController = TextEditingController();
  final _candidatePositionController = TextEditingController();
  final _candidateSalaryController = TextEditingController();
  final _candidateNotesController = TextEditingController();

  final _stages = const [
    _PipelineStage('Applied', Color(0xFF64748B)),
    _PipelineStage('CV Screening', Color(0xFF23A8DD)),
    _PipelineStage('Interview Round 1', Color(0xFF8558F3)),
    _PipelineStage('Interview Round 2', Color(0xFF9857EE)),
    _PipelineStage('Technical Assessment', Color(0xFFFFA20B)),
    _PipelineStage('HR Review', Color(0xFF14ABC5)),
    _PipelineStage('Offer Sent', Color(0xFF17B887)),
    _PipelineStage('Hired', Color(0xFF20B85A)),
    _PipelineStage('Rejected', Color(0xFFF0444F)),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    _candidateNameController.dispose();
    _candidateEmailController.dispose();
    _candidatePhoneController.dispose();
    _candidatePositionController.dispose();
    _candidateSalaryController.dispose();
    _candidateNotesController.dispose();
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
            Text('Recruitment Pipeline Board',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppConstant.textPrimary(context))),
            Text('Drag and drop candidates to move them through stages.',
                style: TextStyle(
                    fontSize: 13, color: AppConstant.textPrimary(context))),
          ],
        ),
      ),
      body: ScreenShimmerWrapper(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(12, 14, 12, 24),
          children: [
            _buildFilters(),
            const SizedBox(height: 14),
            _buildBoard(),
          ],
        ),
      ),
    );
  }

  Widget _buildFilters() => Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                height: 50,
                width: 150,
                child: Card(
                    color: AppConstant.primarycolor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Icon(
                          Icons.settings_outlined,
                          color: Colors.black,
                        ),
                        InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PipelineBoard()));
                            },
                            child: Text(
                              "Configure",
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ))
                      ],
                    )),
              ),
              SizedBox(
                height: 50,
                width: 160,
                child: Card(
                    color: AppConstant.primarycolor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Icon(
                          Icons.description_outlined,
                          color: Colors.black,
                        ),
                        InkWell(
                          onTap: () => MobileFileActions.downloadCsvTemplate(
                            fileName: 'candidate_import_template',
                            headers: const ['Name', 'Email', 'Phone', 'Job Position', 'Expected Salary'],
                          ),
                          child: Text(
                          "CSV Template",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                          ),
                        )
                      ],
                    )),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                height: 50,
                width: 150,
                child: Card(
                    color: AppConstant.primarycolor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Icon(
                          Icons.upload_file_outlined,
                          color: Colors.black,
                        ),
                        InkWell(
                          onTap: () async {
                            final file = await MobileFileActions.pickImportFile(
                                allowedExtensions: const ['csv']);
                            if (!mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(file == null
                                    ? 'Import cancelled.'
                                    : 'Selected ${file.name} for validation.')));
                          },
                          child: Text(
                          "Import CSV",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                          ),
                        )
                      ],
                    )),
              ),
              SizedBox(
                height: 50,
                width: 180,
                child: InkWell(
                    borderRadius: BorderRadius.circular(4),
                    onTap: _showAddCandidateDialog,
                    child: Card(
                    color: AppConstant.primarycolor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Icon(
                          Icons.person_add_alt_1_outlined,
                          color: Colors.black,
                        ),
                        Text(
                          "Add New Candidate",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        )
                      ],
                    )),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 12,
          ),
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search name, position, email...',
              prefixIcon: const Icon(Icons.search, color: Color(0xFF0BB8D8)),
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
                  borderRadius: BorderRadius.all(Radius.circular(9))),
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 10),
          Row(children: [
            Expanded(
                child: _filterDropdown(
                    _department,
                    [
                      'All Departments',
                      'Engineering',
                      'Sales',
                      'Human Resources'
                    ],
                    (value) => setState(() => _department = value!))),
            const SizedBox(width: 8),
            Expanded(
                child: _filterDropdown(
                    _position,
                    [
                      'All Job Positions',
                      'Flutter Developer',
                      'HR Manager',
                      'Designer'
                    ],
                    (value) => setState(() => _position = value!))),
          ]),
        ],
      );

  Widget _filterDropdown(
          String value, List<String> items, ValueChanged<String?> onChanged) =>
      DropdownButtonFormField<String>(
        value: value,
        isExpanded: true,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            filled: true,
            fillColor: AppConstant.cardBg(context),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(9)))),
        items: items
            .map((item) => DropdownMenuItem(
                value: item,
                child: Text(item,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 11))))
            .toList(),
        onChanged: onChanged,
      );

  Widget _buildBoard() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _filterDropdown(
              _pipeline,
              ['Standard Recruitment Pipeline', 'Executive Pipeline'],
              (value) => setState(() => _pipeline = value!)),
          const SizedBox(height: 12),
          SizedBox(
            height: 430,
            child: Scrollbar(
              thumbVisibility: true,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(bottom: 12),
                itemCount: _stages.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (_, index) => _StageColumn(stage: _stages[index]),
              ),
            ),
          ),
        ],
      );

  void _showMessage() => ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('This action will be connected later.')));

  Future<void> _showAddCandidateDialog() async {
    _candidateNameController.clear();
    _candidateEmailController.clear();
    _candidatePhoneController.clear();
    _candidatePositionController.clear();
    _candidateSalaryController.clear();
    _candidateNotesController.clear();
    String? selectedCv;
    final formKey = GlobalKey<FormState>();

    final added = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: StatefulBuilder(
          builder: (context, setDialogState) => ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900, maxHeight: 760),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 18, 12, 14),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(11),
                          decoration: BoxDecoration(
                              color: const Color(0xFFE7F9FC),
                              borderRadius: BorderRadius.circular(10)),
                          child: const Icon(Icons.person_add_alt_1_outlined,
                              color: Color(0xFF08BBD8)),
                        ),
                        const SizedBox(width: 14),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Add New Candidate',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(height: 3),
                              Text('Enter candidate details to add them to this pipeline'),
                            ],
                          ),
                        ),
                        IconButton(
                            onPressed: () => Navigator.pop(dialogContext),
                            icon: const Icon(Icons.close)),
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
                          final name = _candidateField('Name *',
                              _candidateNameController, Icons.person_outline,
                              hint: 'John Doe', required: true);
                          final email = _candidateField('Email *',
                              _candidateEmailController, Icons.mail_outline,
                              hint: 'john@example.com',
                              required: true,
                              keyboardType: TextInputType.emailAddress);
                          final phone = _candidateField('Phone *',
                              _candidatePhoneController, Icons.phone_outlined,
                              hint: '+92 300 1234567',
                              required: true,
                              keyboardType: TextInputType.phone);
                          final position = _candidateField('Job Position *',
                              _candidatePositionController, Icons.work_outline,
                              hint: 'Angular Developer', required: true);

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _candidateSection('CONTACT INFORMATION', Icons.contact_phone_outlined),
                              _candidateRow([name, email], compact),
                              _candidateRow([phone, position], compact),
                              _candidateRow([
                                _candidateField('Expected Salary (PKR)',
                                    _candidateSalaryController, null,
                                    hint: 'e.g. 85000',
                                    keyboardType: TextInputType.number),
                              ], compact),
                              const SizedBox(height: 10),
                              _candidateSection('CV / RESUME', Icons.description_outlined),
                              _candidateLabel('Upload CV (Optional)'),
                              const SizedBox(height: 8),
                              OutlinedButton.icon(
                                onPressed: () => setDialogState(
                                    () => selectedCv = 'candidate_cv.pdf'),
                                icon: const Icon(Icons.attach_file),
                                label: Text(selectedCv ?? 'Choose file     No file chosen'),
                                style: OutlinedButton.styleFrom(
                                    alignment: Alignment.centerLeft,
                                    minimumSize: const Size(double.infinity, 48)),
                              ),
                              const SizedBox(height: 6),
                              const Text('Accepted formats: PDF, DOC, DOCX. Max size: 5MB',
                                  style: TextStyle(color: Color(0xFF7185A3), fontSize: 12)),
                              const SizedBox(height: 22),
                              _candidateSection('ADDITIONAL DETAILS', Icons.description_outlined),
                              _candidateLabel('Notes'),
                              const SizedBox(height: 8),
                              TextField(
                                controller: _candidateNotesController,
                                maxLines: 4,
                                decoration: _candidateInputDecoration('Additional candidate details...'),
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
                        FilledButton.icon(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              Navigator.pop(dialogContext, true);
                            }
                          },
                          icon: const Icon(Icons.check_circle_outline, size: 17),
                          label: const Text('Add Candidate'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    if (added == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Candidate added to the pipeline.')));
    }
  }

  Widget _candidateSection(String title, IconData icon) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          children: [
            Icon(icon, size: 17, color: const Color(0xFF05B9D7)),
            const SizedBox(width: 8),
            Expanded(
                child: Text(title,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.bold))),
          ],
        ),
      );

  Widget _candidateLabel(String text) => Text(text,
      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600));

  Widget _candidateRow(List<Widget> children, bool compact) {
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

  Widget _candidateField(String label, TextEditingController controller,
      IconData? icon,
      {required String hint,
      bool required = false,
      TextInputType? keyboardType}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _candidateLabel(label),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: required
              ? (value) => value == null || value.trim().isEmpty ? 'Required' : null
              : null,
          decoration: _candidateInputDecoration(hint).copyWith(
              prefixIcon: icon == null ? null : Icon(icon, size: 18)),
        ),
      ],
    );
  }

  InputDecoration _candidateInputDecoration(String hint) => InputDecoration(
        hintText: hint,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      );
}

class _PipelineStage {
  const _PipelineStage(this.name, this.color);
  final String name;
  final Color color;
}

class _StageColumn extends StatelessWidget {
  const _StageColumn({required this.stage});
  final _PipelineStage stage;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: 238,
        child: DecoratedBox(
          decoration: BoxDecoration(
              color: AppConstant.cardBg(context),
              border: Border.all(color: AppConstant.border(context)),
              borderRadius: BorderRadius.circular(10)),
          child: Column(children: [
            Container(
              height: 52,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                  color: AppConstant.cardBg(context),
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(10))),
              child: Row(children: [
                const Icon(Icons.drag_indicator,
                    size: 15, color: Color(0xFFB2C0CE)),
                const SizedBox(width: 6),
                Expanded(
                    child: Text(stage.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Color(0xFF293A4E)))),
                Container(
                    width: 25,
                    height: 25,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: stage.color.withValues(alpha: .12),
                        shape: BoxShape.circle),
                    child: const Text('0',
                        style: TextStyle(
                            fontSize: 11, fontWeight: FontWeight.bold))),
              ]),
            ),
            Expanded(
                child: Center(
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
              Icon(Icons.inbox_outlined,
                  size: 26, color: Colors.blueGrey.shade300),
              const SizedBox(height: 10),
              Text('Drop candidates here',
                  style:
                      TextStyle(color: Colors.blueGrey.shade300, fontSize: 12))
            ]))),
          ]),
        ),
      );
}
