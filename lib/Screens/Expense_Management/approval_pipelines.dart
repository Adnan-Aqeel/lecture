import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lecture/appcolor.dart';
import 'package:lecture/widgets/shimmer_widgets.dart';

class ApprovalPipeline {
  final int id;
  final String name;
  final String description;
  final int stages;
  final bool isActive;

  const ApprovalPipeline({
    required this.id,
    required this.name,
    required this.description,
    required this.stages,
    this.isActive = true,
  });
}

class ApprovalPipelinesScreen extends StatefulWidget {
  const ApprovalPipelinesScreen({super.key});

  @override
  State<ApprovalPipelinesScreen> createState() =>
      _ApprovalPipelinesScreenState();
}

class _ApprovalPipelinesScreenState extends State<ApprovalPipelinesScreen> {
  final List<ApprovalPipeline> _pipelines = [];

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
              Text(
                'Approval Pipelines',
                style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: AppConstant.textPrimary(context)),
              ),
              Text(
                'Manage expense approval workflows',
                style: TextStyle(
                    fontSize: 13, color: AppConstant.textPrimary(context)),
              ),
            ],
          ),
        ),
        body: ScreenShimmerWrapper(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 15,
                ),
                Wrap(
                  alignment: WrapAlignment.end,
                  spacing: 12,
                  runSpacing: 8,
                  children: [
                    OutlinedButton.icon(
                        onPressed: _repairPendingApprovals,
                        icon: const Icon(Icons.build_outlined, size: 16),
                        label: const Text('Repair',
                            style: TextStyle(fontSize: 12)),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppConstant.primarycolor,
                          side:
                              const BorderSide(color: AppConstant.primarycolor),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 8),
                        ),
                      ),
                    ElevatedButton.icon(
                        onPressed: _showNewPipelineDialog,
                        icon: const Icon(Icons.add, size: 16),
                        label: const Text('New Pipeline',
                            style: TextStyle(fontSize: 12)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppConstant.primarycolor,
                          foregroundColor: Colors.black,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                        ),
                      ),
                  ],
                ),
                SizedBox(
                  height: 115,
                ),
                _pipelines.isEmpty ? _buildEmptyState() : _buildPipelineList(),
              ],
            ),
          ),
        ));
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppConstant.textSecondary(context),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(Icons.account_tree_outlined,
                size: 56, color: AppConstant.textHint(context)),
          ),
          const SizedBox(height: 20),
          const Text(
            'No pipelines configured',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A2E)),
          ),
          const SizedBox(height: 8),
          Text(
            'No approval pipelines configured yet.',
            style:
                TextStyle(fontSize: 13, color: AppConstant.textHint(context)),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _showNewPipelineDialog,
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Create Pipeline'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstant.primarycolor,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPipelineList() {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _pipelines.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final pipeline = _pipelines[index];
        return _buildPipelineCard(pipeline);
      },
    );
  }

  Widget _buildPipelineCard(ApprovalPipeline pipeline) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppConstant.cardBg(context),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F8F5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.account_tree_outlined,
                color: AppConstant.primarycolor, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pipeline.name,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  pipeline.description,
                  style: TextStyle(
                      fontSize: 12, color: AppConstant.textSecondary(context)),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: pipeline.isActive
                  ? const Color(0xFFE3F7EA)
                  : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${pipeline.stages} stages',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: pipeline.isActive
                    ? const Color(0xFF1E9E5A)
                    : Colors.grey.shade600,
              ),
            ),
          ),
          const SizedBox(width: 12),
          _actionButton(
              icon: Icons.edit_outlined,
              color: AppConstant.primarycolor,
              onTap: () => _editPipeline(pipeline)),
          _actionButton(
              icon: Icons.delete_outline,
              color: Colors.red,
              onTap: () => _deletePipeline(pipeline)),
        ],
      ),
    );
  }

  Widget _actionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(left: 6),
        padding: const EdgeInsets.all(7),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(7),
        ),
        child: Icon(icon, size: 16, color: color),
      ),
    );
  }

  void _showNewPipelineDialog() {
    final nameController = TextEditingController();
    final stages = <String>[];
    bool extraApproval = false;

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1000, maxHeight: 720),
            child: Column(
              children: [
                _pipelineDialogHeader(dialogContext),
                const Divider(height: 1),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final compact = constraints.maxWidth < 700;
                        final settings = _pipelineSettings(
                            nameController, extraApproval, setDialogState);
                        final stagePanel = _stagePanel(stages, setDialogState);
                        return compact
                            ? Column(children: [settings, const SizedBox(height: 16), stagePanel])
                            : Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                SizedBox(width: 330, child: settings),
                                const SizedBox(width: 24),
                                Expanded(child: stagePanel),
                              ]);
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
                          if (nameController.text.trim().isEmpty || stages.isEmpty) return;
                          setState(() => _pipelines.add(ApprovalPipeline(
                                id: _pipelines.length + 1,
                                name: nameController.text.trim(),
                                description: 'Expense approval pipeline',
                                stages: stages.length,
                              )));
                          Navigator.pop(dialogContext);
                        },
                        child: const Text('Create Pipeline'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _pipelineDialogHeader(BuildContext dialogContext) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 16, 14),
        child: Row(children: [
          Container(
            padding: const EdgeInsets.all(11),
            decoration: BoxDecoration(
                color: const Color(0xFFE7F9FC),
                borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.account_tree_outlined,
                color: Color(0xFF0DB9D8)),
          ),
          const SizedBox(width: 14),
          const Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('New Approval Pipeline',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0DB9D8))),
            SizedBox(height: 3),
            Text('Configure pipeline stages and settings'),
          ])),
          OutlinedButton.icon(
              onPressed: () => Navigator.pop(dialogContext),
              icon: const Icon(Icons.arrow_back, size: 15),
              label: const Text('Back')),
        ]),
      );

  Widget _pipelineSettings(TextEditingController nameController,
      bool extraApproval, StateSetter setDialogState) => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Pipeline Settings', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 18),
            const Text('Name *', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            TextField(controller: nameController, decoration: _pipelineInput('e.g. Standard 2-Stage Approval')),
            const SizedBox(height: 16),
            const Text('Module', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            TextField(readOnly: true, controller: TextEditingController(text: 'Expense'), decoration: _pipelineInput('')),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              value: extraApproval,
              onChanged: (value) => setDialogState(() => extraApproval = value ?? false),
              controlAffinity: ListTileControlAffinity.leading,
              title: const Text('Require extra approval for over-budget settlements',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
            ),
          ]),
        ),
      );

  Widget _stagePanel(List<String> stages, StateSetter setDialogState) => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(children: [
            Row(children: [
              const Expanded(child: Text('Approval Stages', style: TextStyle(fontWeight: FontWeight.bold))),
              OutlinedButton.icon(
                onPressed: () {
                  final controller = TextEditingController();
                  showDialog(context: context, builder: (stageContext) => AlertDialog(
                    title: const Text('Add Approval Stage'),
                    content: TextField(controller: controller, autofocus: true, decoration: _pipelineInput('e.g. Finance Review')),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(stageContext), child: const Text('Cancel')),
                      FilledButton(onPressed: () { if (controller.text.trim().isNotEmpty) setDialogState(() => stages.add(controller.text.trim())); Navigator.pop(stageContext); }, child: const Text('Add')),
                    ],
                  ));
                },
                icon: const Icon(Icons.add_circle_outline, size: 16),
                label: const Text('Add Stage'),
              ),
            ]),
            const Divider(height: 24),
            if (stages.isEmpty)
              const SizedBox(height: 160, child: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.account_tree_outlined, size: 34, color: Color(0xFF7188A1)),
                SizedBox(height: 12), Text('No stages yet. Add at least one.'),
              ])))
            else
              ...stages.asMap().entries.map((entry) => ListTile(
                    leading: CircleAvatar(radius: 14, child: Text('${entry.key + 1}')),
                    title: Text(entry.value),
                    trailing: IconButton(icon: const Icon(Icons.delete_outline), onPressed: () => setDialogState(() => stages.removeAt(entry.key))),
                  )),
          ]),
        ),
      );

  InputDecoration _pipelineInput(String hint) => InputDecoration(
        hintText: hint.isEmpty ? null : hint,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      );

  void _editPipeline(ApprovalPipeline pipeline) {
    final nameController = TextEditingController(text: pipeline.name);
    final descController = TextEditingController(text: pipeline.description);
    final stagesController =
        TextEditingController(text: pipeline.stages.toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: AppConstant.cardBg(context),
        title: const Text('Edit Pipeline',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.85,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Pipeline Name *',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: stagesController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    labelText: 'Number of Stages *',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel',
                style: TextStyle(color: AppConstant.textSecondary(context))),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                final index = _pipelines.indexWhere((p) => p.id == pipeline.id);
                if (index != -1) {
                  _pipelines[index] = ApprovalPipeline(
                    id: pipeline.id,
                    name: nameController.text,
                    description: descController.text,
                    stages:
                        int.tryParse(stagesController.text) ?? pipeline.stages,
                    isActive: pipeline.isActive,
                  );
                }
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstant.primarycolor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _deletePipeline(ApprovalPipeline pipeline) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: AppConstant.cardBg(context),
        title: const Text('Delete Pipeline'),
        content: Text('Are you sure you want to delete "${pipeline.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel',
                style: TextStyle(color: AppConstant.textSecondary(context))),
          ),
          ElevatedButton(
            onPressed: () {
              setState(
                  () => _pipelines.removeWhere((p) => p.id == pipeline.id));
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Pipeline deleted'),
                  backgroundColor: Colors.red.shade600,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, foregroundColor: Colors.white),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _repairPendingApprovals() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: AppConstant.cardBg(context),
        title: Row(
          children: [
            Icon(Icons.build, color: AppConstant.primarycolor, size: 22),
            const SizedBox(width: 8),
            const Text('Repair Pending Approvals',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        content: const Text(
            'This will scan and repair any stuck or pending approval requests. Do you want to continue?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel',
                style: TextStyle(color: AppConstant.textSecondary(context))),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Repair completed successfully!'),
                  backgroundColor: Colors.green.shade600,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstant.primarycolor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Repair'),
          ),
        ],
      ),
    );
  }
}
