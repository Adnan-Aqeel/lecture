import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:lecture/core/constants/app_colors.dart';
import 'package:lecture/core/widgets/shimmer_widgets.dart';
 
class Interviews extends StatefulWidget {
  const Interviews({super.key});

  @override
  State<Interviews> createState() => _InterviewsState();
}

class _InterviewsState extends State<Interviews> {      
  String _status = 'All Statuses';

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
            Text('Interview Schedules',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppConstant.textPrimary(context))),
            Text('Manage and track candidate interviews',
                style: TextStyle(
                    fontSize: 13, color: AppConstant.textPrimary(context))),
          ],
        ),
      ),
      body: ScreenShimmerWrapper(
        child: SingleChildScrollView(
          child: Column(children: [
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: SizedBox(
                  height: 50,
                  width: 200,
                  child: Card(
                    color: AppConstant.primarycolor,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: _scheduleInterview,
                      child: Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Icon(Icons.add_circle_outline,
                                color: Colors.black),
                          ),
                          const Expanded(
                            child: Text(
                              'Schedule Interview',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text('Status',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF94A3B8),
                    )),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField<String>(
                value: _status,
                dropdownColor: Color(0xFF94A3B8),
                isExpanded: true,
                decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                    filled: true,
                    fillColor: AppConstant.cardBg(context),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)))),
                items: const [
                  'All Statuses',
                  'Scheduled',
                  'Completed',
                  'Cancelled'
                ]
                    .map((item) => DropdownMenuItem(
                        value: item,
                        child: Text(item,
                            style: TextStyle(
                                color: AppConstant.textPrimary(context)))))
                    .toList(),
                onChanged: (value) =>
                    setState(() => _status = value ?? _status),
              ),
            ),
            const SizedBox(height: 22),
            _buildEmptyState(),
          ]),
        ),
      ),
    );
  }

  Widget _buildEmptyState() => Column(
        children: [
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 330,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                  color: AppConstant.cardBg(context),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppConstant.border(context))),
              child: Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                    Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            color: AppConstant.cardBg(context),
                            border: Border.all(
                                color: AppConstant.border(context), width: 2),
                            borderRadius: BorderRadius.circular(5)),
                        child: const Icon(Icons.close,
                            color: Color(0xFF7188A1), size: 22)),
                    const SizedBox(height: 20),
                    const Text('No Interviews Found',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF94A3B8),
                        )),
                    const SizedBox(height: 8),
                    const Text(
                        'No interview records match your current filter.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFF94A3B8),
                        )),
                  ])),
            ),
          ),
        ],
      );

  Future<void> _scheduleInterview() async {
    final scheduled = await showDialog<bool>(
      context: context,
      builder: (_) => const _ScheduleInterviewDialog(),
    );
    if (scheduled == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Interview scheduled successfully.')),
      );
    }
  }
}

class _ScheduleInterviewDialog extends StatefulWidget {
  const _ScheduleInterviewDialog();

  @override
  State<_ScheduleInterviewDialog> createState() =>
      _ScheduleInterviewDialogState();
}

class _ScheduleInterviewDialogState extends State<_ScheduleInterviewDialog> {
  final _formKey = GlobalKey<FormState>();
  final _interviewerController = TextEditingController();
  final _locationController = TextEditingController();
  final _durationController = TextEditingController(text: '60');
  String? _candidate;
  String _interviewType = 'HR Interview';
  String _channel = '— Not specified —';
  DateTime? _scheduledAt;

  @override
  void dispose() {
    _interviewerController.dispose();
    _locationController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  Color _text(BuildContext context) => AppConstant.textPrimary(context);

  InputDecoration _decoration(BuildContext context,
      {String? hint, Widget? suffixIcon}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: AppConstant.textHint(context)),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: AppConstant.inputBg(context),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: AppConstant.border(context)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFF22D3EE), width: 1.5),
      ),
    );
  }

  Widget _label(BuildContext context, String text, {bool required = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: RichText(
        text: TextSpan(
          text: text,
          style: TextStyle(fontWeight: FontWeight.w600, color: _text(context)),
          children: required
              ? const [
                  TextSpan(text: ' *', style: TextStyle(color: Colors.red))
                ]
              : null,
        ),
      ),
    );
  }

  Widget _dropdown(BuildContext context,
      {required String? value,
      required String hint,
      required List<String> items,
      required ValueChanged<String?> onChanged,
      String? Function(String?)? validator}) {
    return DropdownButtonFormField<String>(
      value: value,
      isExpanded: true,
      dropdownColor: AppConstant.cardBg(context),
      style: TextStyle(color: _text(context)),
      decoration: _decoration(context, hint: hint),
      validator: validator,
      items: items
          .map((item) => DropdownMenuItem(value: item, child: Text(item)))
          .toList(),
      onChanged: onChanged,
    );
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      initialDate: _scheduledAt ?? DateTime.now(),
    );
    if (date == null || !mounted) return;
    final time =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (time == null) return;
    setState(() => _scheduledAt =
        DateTime(date.year, date.month, date.day, time.hour, time.minute));
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ConstrainedBox(
        constraints: BoxConstraints(
            maxWidth: 560, maxHeight: MediaQuery.sizeOf(context).height * .9),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(children: [
                    const Icon(Icons.event_available_outlined,
                        color: Color(0xFF22D3EE)),
                    const SizedBox(width: 10),
                    Expanded(
                        child: Text('Schedule Interview',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: _text(context)))),
                    IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close)),
                  ]),
                  const Divider(),
                  _label(context, 'Candidate', required: true),
                  _dropdown(context,
                      value: _candidate,
                      hint: 'Select candidate...',
                      items: const ['Ali Khan', 'Sarah Khan', 'Zain Ahmed'],
                      onChanged: (v) => setState(() => _candidate = v),
                      validator: (v) =>
                          v == null ? 'Please select a candidate' : null),
                  const SizedBox(height: 18),
                  LayoutBuilder(builder: (context, constraints) {
                    final vertical = constraints.maxWidth < 430;
                    final type = Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _label(context, 'Interview Type'),
                          _dropdown(context,
                              value: _interviewType,
                              hint: '',
                              items: const [
                                'HR Interview',
                                'Technical Interview',
                                'Final Interview'
                              ],
                              onChanged: (v) => setState(
                                  () => _interviewType = v ?? _interviewType))
                        ]);
                    final channel = Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _label(context, 'Interview Channel'),
                          _dropdown(context,
                              value: _channel,
                              hint: '',
                              items: const [
                                '— Not specified —',
                                'Google Meet',
                                'Zoom',
                                'In-person'
                              ],
                              onChanged: (v) =>
                                  setState(() => _channel = v ?? _channel))
                        ]);
                    return vertical
                        ? Column(children: [
                            type,
                            const SizedBox(height: 14),
                            channel
                          ])
                        : Row(children: [
                            Expanded(child: type),
                            const SizedBox(width: 16),
                            Expanded(child: channel)
                          ]);
                  }),
                  const SizedBox(height: 18),
                  LayoutBuilder(builder: (context, constraints) {
                    final dateField = Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _label(context, 'Scheduled At', required: true),
                          TextFormField(
                              readOnly: true,
                              onTap: _pickDateTime,
                              controller: TextEditingController(
                                  text: _scheduledAt == null
                                      ? ''
                                      : DateFormat('MM/dd/yyyy hh:mm a')
                                          .format(_scheduledAt!)),
                              decoration: _decoration(context,
                                  hint: 'mm/dd/yyyy --:-- --',
                                  suffixIcon: Icon(
                                      Icons.calendar_today_outlined,
                                      color: _text(context),
                                      size: 18)),
                              validator: (_) => _scheduledAt == null
                                  ? 'Please select date and time'
                                  : null)
                        ]);
                    final duration = Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _label(context, 'Duration (min)'),
                          TextFormField(
                              controller: _durationController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              decoration: _decoration(context),
                              validator: (v) => int.tryParse(v ?? '') == null ||
                                      int.parse(v!) <= 0
                                  ? 'Enter valid duration'
                                  : null)
                        ]);
                    return constraints.maxWidth < 430
                        ? Column(children: [
                            dateField,
                            const SizedBox(height: 14),
                            duration
                          ])
                        : Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                Expanded(flex: 2, child: dateField),
                                const SizedBox(width: 16),
                                Expanded(child: duration)
                              ]);
                  }),
                  const SizedBox(height: 18),
                  _label(context, 'Interviewer Name', required: true),
                  TextFormField(
                      controller: _interviewerController,
                      decoration: _decoration(context, hint: 'e.g. Sarah Khan'),
                      validator: (v) => v == null || v.trim().isEmpty
                          ? 'Enter interviewer name'
                          : null),
                  const SizedBox(height: 18),
                  _label(context, 'Location / Meeting Link'),
                  TextFormField(
                      controller: _locationController,
                      decoration: _decoration(context,
                          hint: 'Conference room / Google Meet link...')),
                  const Divider(height: 28),
                  Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel')),
                    const SizedBox(width: 10),
                    ElevatedButton.icon(
                        onPressed: () {
                          if (_formKey.currentState!.validate())
                            Navigator.pop(context, true);
                        },
                        icon: const Icon(Icons.event_available_outlined,
                            size: 18),
                        label: const Text('Schedule'),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF22D3EE),
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))))
                  ]),
                ]),
          ),
        ),
      ),
    );
  }
}
