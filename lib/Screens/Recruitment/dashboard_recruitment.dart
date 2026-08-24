import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lecture/Screens/Recruitment/pipeline_board.dart';
import 'package:lecture/Screens/Recruitment/pipeline_builder.dart';
import 'package:lecture/appcolor.dart';
import 'package:lecture/widgets/shimmer_widgets.dart';

class RecruitmentDashboard extends StatefulWidget {
  const RecruitmentDashboard({super.key});

  @override
  State<RecruitmentDashboard> createState() => _RecruitmentDashboardState();
}

class _RecruitmentDashboardState extends State<RecruitmentDashboard> {
  String _position = 'All Positions';
  String _pipeline = 'Standard Recruitment Pipeline';

  final _metrics = const [
    _Metric('Open Positions', '0', Icons.business_center_outlined,
        Color(0xFF16C6E5)),
    _Metric('Total Applicants', '0', Icons.groups_outlined, Color(0xFF159AD0)),
    _Metric('Interviews', '0', Icons.calendar_month_outlined, Color(0xFFE98500),
        '0 completed'),
    _Metric('Hired', '0', Icons.person_add_alt_1_outlined, Color(0xFF16A34A),
        '0% hire rate'),
    _Metric('In Onboarding', '0', Icons.sync_outlined, Color(0xFF367BF5)),
    _Metric(
        'Avg Time to Hire', '—', Icons.timelapse_outlined, Color(0xFF299BC6)),
  ];

  final _stages = const [
    _Stage('Applied', Color(0xFF64748B)),
    _Stage('CV Screening', Color(0xFF10A8DE)),
    _Stage('Interview Round 1', Color(0xFF8558F3)),
    _Stage('Interview Round 2', Color(0xFF9857EE)),
    _Stage('Technical Assessment', Color(0xFFFFA20B)),
    _Stage('HR Review', Color(0xFF14ABC5)),
    _Stage('Offer Sent', Color(0xFF17B887)),
    _Stage('Hired', Color(0xFF20B85A), 'Hired'),
    _Stage('Rejected', Color(0xFFF0444F), 'Rejected'),
  ];

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
            Text('Recruitment & Onboarding',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppConstant.textPrimary(context))),
            Text('Overview of pipeline and hiring metrics',
                style: TextStyle(
                    fontSize: 13, color: AppConstant.textPrimary(context))),
          ],
        ),
        actions: [
          IconButton(
              tooltip: 'Pipeline Board',
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PipelineBoard()));
              },
              icon:
                  const Icon(Icons.view_kanban_outlined, color: Colors.white)),
          IconButton(
              tooltip: 'Configure',
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PipelineBuilder()));
              },
              icon: const Icon(Icons.tune, color: Colors.white)),
        ],
      ),
      body: ScreenShimmerWrapper(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 28),
          children: [
            _buildPositionFilter(),
            const SizedBox(height: 14),
            _buildMetrics(),
            const SizedBox(height: 20),
            _buildPipeline(),
          ],
        ),
      ),
    );
  }

  Widget _buildPositionFilter() => Row(
        children: [
          const Icon(
            Icons.filter_alt_outlined,
            size: 17,
            color: Color(0xFF94A3B8),
          ),
          const SizedBox(width: 7),
          const Text('Filter by Position:',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF94A3B8),
              )),
          const SizedBox(width: 10),
          Expanded(
            child: DropdownButtonFormField<String>(
              value: _position,
              decoration: const InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)))),
              items: const [
                'All Positions',
                'Engineering',
                'Sales',
                'Human Resources'
              ]
                  .map((value) => DropdownMenuItem(
                      value: value,
                      child: Text(value, style: TextStyle(fontSize: 12))))
                  .toList(),
              onChanged: (value) =>
                  setState(() => _position = value ?? _position),
            ),
          ),
        ],
      );

  Widget _buildMetrics() => LayoutBuilder(
        builder: (context, constraints) {
          final columns = constraints.maxWidth > 700 ? 2 : 1;
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _metrics.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                mainAxisExtent: 130,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12),
            itemBuilder: (_, index) => _MetricCard(metric: _metrics[index]),
          );
        },
      );

  Widget _buildPipeline() => Card(
        elevation: 0,
        color: AppConstant.cardBg(context),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              const Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text('Pipeline Stage Distribution',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF123B5A))),
                    SizedBox(height: 4),
                    Text(
                        'Live candidate count per stage for the selected pipeline',
                        style:
                            TextStyle(fontSize: 11, color: Color(0xFF62758A)))
                  ])),
              SizedBox(
                  width: 145,
                  child: DropdownButtonFormField<String>(
                      value: _pipeline,
                      isExpanded: true,
                      decoration: const InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)))),
                      items: const [
                        'Standard Recruitment Pipeline',
                        'Executive Pipeline'
                      ]
                          .map((value) => DropdownMenuItem(
                              value: value,
                              child: Text(value,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 10))))
                          .toList(),
                      onChanged: (value) =>
                          setState(() => _pipeline = value ?? _pipeline))),
            ]),
            const SizedBox(height: 16),
            ..._stages.map(_buildStageCard),
          ]),
        ),
      );

  Widget _buildStageCard(_Stage stage) => Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(11),
        decoration: BoxDecoration(
            color: AppConstant.cardBg(context),
            border: Border.all(color: AppConstant.border(context)),
            borderRadius: BorderRadius.circular(9)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(
                width: 8,
                height: 8,
                decoration:
                    BoxDecoration(color: stage.color, shape: BoxShape.circle)),
            const SizedBox(width: 7),
            Expanded(
                child: Text(stage.name,
                    style: const TextStyle(
                        fontSize: 11, color: Color(0xFF49627D)))),
            if (stage.badge != null)
              Container(
                  margin: const EdgeInsets.only(right: 6),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                      color: stage.color.withValues(alpha: .12),
                      borderRadius: BorderRadius.circular(10)),
                  child: Text(stage.badge!,
                      style: TextStyle(
                          fontSize: 9,
                          color: stage.color,
                          fontWeight: FontWeight.bold))),
            const Text('0',
                style: TextStyle(fontSize: 11, color: Color(0xFF43617B))),
          ]),
          const SizedBox(height: 7),
          ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: const LinearProgressIndicator(
                  value: 0,
                  minHeight: 5,
                  backgroundColor: Color(0xFFE1E8F0),
                  color: Color(0xFF22B8D4))),
          const SizedBox(height: 6),
          const Text('0% of total',
              style: TextStyle(fontSize: 10, color: Color(0xFF58708A))),
        ]),
      );
}

class _Metric {
  const _Metric(this.label, this.value, this.icon, this.color,
      [this.detail = '']);
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final String detail;
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.metric});
  final _Metric metric;
  @override
  Widget build(BuildContext context) => Card(
        elevation: 0,
        color: AppConstant.cardBg(context),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
            padding: const EdgeInsets.all(14),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: metric.color.withValues(alpha: .1),
                      borderRadius: BorderRadius.circular(8)),
                  child: Icon(metric.icon, size: 18, color: metric.color)),
              const Spacer(),
              Text(metric.value,
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: metric.color)),
              Text(metric.label.toUpperCase(),
                  style: const TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF64748B))),
              if (metric.detail.isNotEmpty)
                Text(metric.detail,
                    style:
                        const TextStyle(fontSize: 9, color: Color(0xFF64748B)))
            ])),
      );
}

class _Stage {
  const _Stage(this.name, this.color, [this.badge]);
  final String name;
  final Color color;
  final String? badge;
}
