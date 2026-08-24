import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lecture/Screens/Recruitment/pipeline_board.dart';
import 'package:lecture/appcolor.dart';
import 'package:lecture/widgets/shimmer_widgets.dart';

class PipelineBuilder extends StatefulWidget {
  const PipelineBuilder({super.key});

  @override
  State<PipelineBuilder> createState() => _PipelineBuilderState();
}

class _PipelineBuilderState extends State<PipelineBuilder> {
  bool _isActive = true;
  bool _templateSelected = false;
  final _pipelineNameController = TextEditingController();
  final _pipelineDescriptionController = TextEditingController();
  bool _setAsDefault = false;

  @override
  void dispose() {
    _pipelineNameController.dispose();
    _pipelineDescriptionController.dispose();
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
            Text('Pipeline Builder',
                style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: AppConstant.textPrimary(context))),
            Text('Reusable pipeline templates shared across job positions.',
                style: TextStyle(
                    fontSize: 13, color: AppConstant.textPrimary(context))),
          ],
        ),
      ),
      body: ScreenShimmerWrapper(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 28),
          children: [
            _buildTemplateCard(),
            const SizedBox(height: 16),
            _buildConfigurationPanel(),
          ],
        ),
      ),
    );
  }

  Widget _buildTemplateCard() => Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                height: 50,
                width: 160,
                child: Card(
                    color: AppConstant.primarycolor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Icon(
                          Icons.view_kanban_outlined,
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
                            "Open Board",
                            style: TextStyle(
                              color: Colors.black,
                        )
                          ),
                        )
                      ],
                    )),
              ),
              SizedBox(
                height: 50,
                width: 160,
                child: InkWell(
                  borderRadius: BorderRadius.circular(4),
                  onTap: _showCreatePipelineDialog,
                  child: Card(
                    color: AppConstant.primarycolor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Icon(
                          Icons.add_circle_outline,
                          color: Colors.black,
                        ),
                        Text(
                          "New Template",
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
            height: 15,
          ),
          Card(
            elevation: 1,
            color: AppConstant.cardBg(context),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Expanded(
                          child: Text('Standard Recruitment Pipeline',
                              style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: AppConstant.textPrimary(context)))),
                      OutlinedButton(
                        onPressed: _deactivate,
                        style: OutlinedButton.styleFrom(
                            foregroundColor:
                                _isActive ? Colors.red : Colors.green,
                            side: BorderSide(
                                color: _isActive ? Colors.red : Colors.green),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8)),
                        child: Text(_isActive ? 'Deactivate' : 'Activate'),
                      ),
                    ]),
                    const SizedBox(height: 12),
                    Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 11, vertical: 5),
                        decoration: BoxDecoration(
                            color: const Color(0xFFE4F6EC),
                            borderRadius: BorderRadius.circular(16)),
                        child: Text('Default',
                            style: TextStyle(
                                color: Colors.green.shade700,
                                fontWeight: FontWeight.w600,
                                fontSize: 12))),
                    const SizedBox(height: 12),
                    Text('Default pipeline for all candidates',
                        style: TextStyle(
                            fontSize: 14,
                            color: AppConstant.textSecondary(context))),
                    const SizedBox(height: 10),
                    Text('9 stage(s)  ·  0 positions',
                        style: TextStyle(
                            fontSize: 15,
                            color: AppConstant.textSecondary(context))),
                    const SizedBox(height: 14),
                    SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                            onPressed: () =>
                                setState(() => _templateSelected = true),
                            style: FilledButton.styleFrom(
                                backgroundColor: AppConstant.primarycolor,
                                foregroundColor: Colors.black),
                            icon: const Icon(Icons.settings_outlined, size: 17),
                            label: const Text('Configure Stages'))),
                  ]),
            ),
          ),
        ],
      );

  Widget _buildConfigurationPanel() => Card(
        elevation: 1,
        color: AppConstant.cardBg(context),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: SizedBox(
          height: 270,
          child: _templateSelected
              ? _buildSelectedState()
              : const Center(
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.arrow_back_rounded,
                      size: 40, color: Color(0xFF536176)),
                  SizedBox(height: 22),
                  Text('Select a pipeline to configure its stages',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF94A3B8),
                      ))
                ])),
        ),
      );

  Widget _buildSelectedState() => Padding(
        padding: const EdgeInsets.all(18),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            const Expanded(
                child: Text('Pipeline stages',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
            TextButton(
                onPressed: () => setState(() => _templateSelected = false),
                child: const Text('Back'))
          ]),
          const SizedBox(height: 8),
          Text('Standard Recruitment Pipeline',
              style: TextStyle(color: AppConstant.textSecondary(context))),
          const SizedBox(height: 18),
          Expanded(
              child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: const [
                    'Applied',
                    'CV Screening',
                    'Interview 1',
                    'Interview 2',
                    'Technical',
                    'HR Review',
                    'Offer Sent',
                    'Hired',
                    'Rejected'
                  ]
                      .map((stage) => Padding(
                          padding: EdgeInsets.only(right: 8),
                          child: Chip(label: Text(stage))))
                      .toList())),
        ]),
      );

  Future<void> _deactivate() async {
    if (!_isActive) {
      setState(() => _isActive = true);
      return;
    }
    final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
                title: const Text('Deactivate pipeline?'),
                content: const Text(
                    'This pipeline will no longer be active for new candidates.'),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancel')),
                  FilledButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Deactivate'))
                ]));
    if (confirm == true && mounted) setState(() => _isActive = false);
  }

  Future<void> _showCreatePipelineDialog() async {
    _pipelineNameController.clear();
    _pipelineDescriptionController.clear();
    _setAsDefault = false;

    final created = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: StatefulBuilder(
            builder: (context, setDialogState) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isCompact = constraints.maxWidth < 560;
                    final nameField = _pipelineTextField(
                      label: 'Pipeline Name *',
                      hint: 'e.g. Engineering Recruitment',
                      controller: _pipelineNameController,
                    );
                    final descriptionField = _pipelineTextField(
                      label: 'Description',
                      hint: 'Optional...',
                      controller: _pipelineDescriptionController,
                    );
                    final defaultSwitch = _defaultSwitch(
                      value: _setAsDefault,
                      onChanged: (value) =>
                          setDialogState(() => _setAsDefault = value),
                    );

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.add_circle_outline, size: 20),
                            SizedBox(width: 8),
                            Text('Create New Pipeline',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 20),
                        if (isCompact)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              nameField,
                              const SizedBox(height: 14),
                              descriptionField,
                              const SizedBox(height: 14),
                              defaultSwitch,
                            ],
                          )
                        else
                          Row(
                            children: [
                              Expanded(child: nameField),
                              const SizedBox(width: 16),
                              Expanded(child: descriptionField),
                              const SizedBox(width: 16),
                              defaultSwitch,
                            ],
                          ),
                        const SizedBox(height: 18),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () => Navigator.pop(dialogContext),
                              child: const Text('Cancel'),
                            ),
                            const SizedBox(width: 8),
                            FilledButton.icon(
                              onPressed: () {
                                if (_pipelineNameController.text.trim().isEmpty) {
                                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                                    const SnackBar(
                                        content: Text('Pipeline name is required.')),
                                  );
                                  return;
                                }
                                Navigator.pop(dialogContext, true);
                              },
                              icon: const Icon(Icons.save_outlined, size: 17),
                              label: const Text('Create'),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              );
            },
          ),
        );
      },
    );

    if (created == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pipeline template created.')),
      );
    }
  }

  Widget _pipelineTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          ),
        ),
      ],
    );
  }

  Widget _defaultSwitch({
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Switch(value: value, onChanged: onChanged),
        const Text('Set as Default',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
      ],
    );
  }

  void _showMessage() => ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('This action will be connected later.')));
}
