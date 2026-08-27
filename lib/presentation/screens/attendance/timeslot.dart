import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lecture/core/constants/app_colors.dart';
import 'package:lecture/core/widgets/shimmer_widgets.dart';

class TimeSlotModel {
  int id;
  String slotName;
  String startTime;
  String endTime;
  int lateGrace;

  TimeSlotModel({
    required this.id,
    required this.slotName,
    required this.startTime,
    required this.endTime,
    required this.lateGrace,
  });
}

class Timeslot extends StatefulWidget {
  const Timeslot({super.key});

  @override
  State<Timeslot> createState() => _TimeslotState();
}

class _TimeslotState extends State<Timeslot> {
  final ScrollController horizontalController = ScrollController();
  final ScrollController verticalController = ScrollController();
  final TextEditingController searchController = TextEditingController();
  String _searchQuery = '';

  List<TimeSlotModel> allSlots = [
    TimeSlotModel(
        id: 1,
        slotName: 'Morning Shift',
        startTime: '09:00 AM',
        endTime: '05:00 PM',
        lateGrace: 15),
    TimeSlotModel(
        id: 2,
        slotName: 'Evening Shift',
        startTime: '02:00 PM',
        endTime: '10:00 PM',
        lateGrace: 10),
    TimeSlotModel(
        id: 3,
        slotName: 'Night Shift',
        startTime: '10:00 PM',
        endTime: '06:00 AM',
        lateGrace: 30),
  ];

  List<TimeSlotModel> get filteredSlots {
    if (_searchQuery.isEmpty) return allSlots;
    return allSlots
        .where((s) =>
            s.slotName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            s.startTime.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            s.endTime.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  @override
  void dispose() {
    searchController.dispose();
    horizontalController.dispose();
    verticalController.dispose();
    super.dispose();
  }

  void _filterSlots(String query) {
    setState(() => _searchQuery = query);
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
            Text('Time Slots',
                style: TextStyle(
                    fontSize: 18, color: AppConstant.textPrimary(context))),
            Text('Manage Employee shift time Slots',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppConstant.textSecondary(context))),
          ],
        ),
      ),
      body: ScreenShimmerWrapper(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Search Bar
              TextField(
                controller: searchController,
                onChanged: _filterSlots,
                style: TextStyle(
                    fontSize: 13, color: AppConstant.textPrimary(context)),
                decoration: InputDecoration(
                  hintText: 'Search slots...',
                  hintStyle: TextStyle(
                      fontSize: 13, color: AppConstant.textHint(context)),
                  prefixIcon: Icon(Icons.search,
                      size: 18, color: AppConstant.textHint(context)),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear,
                              size: 16, color: AppConstant.textHint(context)),
                          onPressed: () {
                            searchController.clear();
                            _filterSlots('');
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: AppConstant.cardBg(context),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: AppConstant.border(context)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: AppConstant.border(context)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        BorderSide(color: AppConstant.primarycolor, width: 1.5),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
              ),
              const SizedBox(height: 20),

              // DataTable
              Expanded(
                child: filteredSlots.isEmpty
                    ? _buildEmptyState()
                    : Container(
                        decoration: BoxDecoration(
                          color: AppConstant.cardBg(context),
                          borderRadius: BorderRadius.circular(10),
                          border:
                              Border.all(color: AppConstant.border(context)),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Scrollbar(
                            thumbVisibility: true,
                            controller: horizontalController,
                            child: SingleChildScrollView(
                              controller: horizontalController,
                              scrollDirection: Axis.horizontal,
                              child: Scrollbar(
                                thumbVisibility: true,
                                controller: verticalController,
                                child: SingleChildScrollView(
                                  controller: verticalController,
                                  scrollDirection: Axis.vertical,
                                  child: DataTable(
                                    headingRowColor: WidgetStateProperty.all(
                                        AppConstant.primarycolor),
                                    headingTextStyle: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                    color: AppConstant.textPrimary(context),
                                        letterSpacing: 0.5),
                                    dataTextStyle: TextStyle(
                                        fontSize: 12,
                                        color:
                                            AppConstant.textPrimary(context)),
                                    dataRowMaxHeight: 60,
                                    dataRowMinHeight: 60,
                                    dividerThickness: 0.5,
                                    columnSpacing: 24,
                                    horizontalMargin: 16,
                                    columns: const [
                                      DataColumn(label: Text('#')),
                                      DataColumn(label: Text('SLOT NAME')),
                                      DataColumn(label: Text('START TIME')),
                                      DataColumn(label: Text('END TIME')),
                                      DataColumn(
                                          label: Text('LATE GRACE (min)')),
                                      DataColumn(label: Text('ACTION')),
                                    ],
                                    rows: filteredSlots
                                        .asMap()
                                        .entries
                                        .map((entry) {
                                      final i = entry.key;
                                      final slot = entry.value;
                                      return DataRow(cells: [
                                        DataCell(Text('${i + 1}')),
                                        DataCell(Text(slot.slotName,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600))),
                                        DataCell(Text(slot.startTime)),
                                        DataCell(Text(slot.endTime)),
                                        DataCell(Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: AppConstant.primarycolor
                                                .withValues(alpha: 0.08),
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            border: Border.all(
                                                color: AppConstant.primarycolor
                                                    .withValues(alpha: 0.3)),
                                          ),
                                          child: Text('${slot.lateGrace} min',
                                              style: TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w600,
                                                  color: AppConstant
                                                      .primarycolor)),
                                        )),
                                        DataCell(Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            _actionIcon(Icons.edit_outlined,
                                                () => _showEditDialog(slot)),
                                            const SizedBox(width: 4),
                                            _actionIcon(Icons.delete_outline,
                                                () => _showDeleteDialog(slot)),
                                          ],
                                        )),
                                      ]);
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppConstant.primarycolor,
        onPressed: () => _showAddDialog(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.access_time_outlined,
              size: 56, color: AppConstant.textHint(context)),
          const SizedBox(height: 14),
          Text('No time slots found',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppConstant.textSecondary(context))),
          const SizedBox(height: 6),
          Text('Add a new time slot to get started.',
              style: TextStyle(
                  fontSize: 12, color: AppConstant.textHint(context))),
        ],
      ),
    );
  }

  Widget _actionIcon(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: AppConstant.primarycolor.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
              color: AppConstant.primarycolor.withValues(alpha: 0.25)),
        ),
        child: Icon(icon, size: 15, color: AppConstant.primarycolor),
      ),
    );
  }

  // ═══════════════════════════════════════════
  //  ADD DIALOG
  // ═══════════════════════════════════════════
  void _showAddDialog() {
    final nameCtrl = TextEditingController();
    final graceCtrl = TextEditingController(text: '30');
    String startTime = '';
    String endTime = '';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => Dialog(
          backgroundColor: AppConstant.cardBg(ctx),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          insetPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(ctx).size.width * 0.85,
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.access_time,
                          color: AppConstant.primarycolor, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text('Add Time Slot',
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: AppConstant.textPrimary(ctx))),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(ctx),
                        child: Icon(Icons.close,
                            size: 20, color: AppConstant.textHint(ctx)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _dialogField(ctx, 'Name', nameCtrl, 'e.g. Morning Shift'),
                  const SizedBox(height: 14),
                  _dialogTimePicker(ctx, 'Start Time', startTime,
                      (v) => setDialogState(() => startTime = v)),
                  const SizedBox(height: 14),
                  _dialogTimePicker(ctx, 'End Time', endTime,
                      (v) => setDialogState(() => endTime = v)),
                  const SizedBox(height: 14),
                  _dialogField(ctx, 'Late Grace (min)', graceCtrl, '30'),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(ctx),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppConstant.textSecondary(ctx),
                            side: BorderSide(color: AppConstant.border(ctx)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text('Cancel'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            if (nameCtrl.text.trim().isEmpty) return;
                            setState(() {
                              final newId = allSlots.isEmpty
                                  ? 1
                                  : allSlots
                                          .map((s) => s.id)
                                          .reduce((a, b) => a > b ? a : b) +
                                      1;
                              allSlots.add(TimeSlotModel(
                                id: newId,
                                slotName: nameCtrl.text.trim(),
                                startTime:
                                    startTime.isEmpty ? '--:-- --' : startTime,
                                endTime: endTime.isEmpty ? '--:-- --' : endTime,
                                lateGrace: int.tryParse(graceCtrl.text) ?? 30,
                              ));
                            });
                            Navigator.pop(ctx);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    '${nameCtrl.text.trim()} added successfully'),
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
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text('Save',
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════
  //  EDIT DIALOG
  // ═══════════════════════════════════════════
  void _showEditDialog(TimeSlotModel slot) {
    final nameCtrl = TextEditingController(text: slot.slotName);
    final graceCtrl = TextEditingController(text: '${slot.lateGrace}');
    String startTime = slot.startTime;
    String endTime = slot.endTime;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => Dialog(
          backgroundColor: AppConstant.cardBg(ctx),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          insetPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(ctx).size.width * 0.85,
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.edit_outlined,
                          color: AppConstant.primarycolor, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text('Edit Time Slot',
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: AppConstant.textPrimary(ctx))),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(ctx),
                        child: Icon(Icons.close,
                            size: 20, color: AppConstant.textHint(ctx)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _dialogField(ctx, 'Name', nameCtrl, 'e.g. Morning Shift'),
                  const SizedBox(height: 14),
                  _dialogTimePicker(ctx, 'Start Time', startTime,
                      (v) => setDialogState(() => startTime = v)),
                  const SizedBox(height: 14),
                  _dialogTimePicker(ctx, 'End Time', endTime,
                      (v) => setDialogState(() => endTime = v)),
                  const SizedBox(height: 14),
                  _dialogField(ctx, 'Late Grace (min)', graceCtrl, '30'),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(ctx),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppConstant.textSecondary(ctx),
                            side: BorderSide(color: AppConstant.border(ctx)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text('Cancel'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            if (nameCtrl.text.trim().isEmpty) return;
                            setState(() {
                              slot.slotName = nameCtrl.text.trim();
                              slot.startTime = startTime;
                              slot.endTime = endTime;
                              slot.lateGrace =
                                  int.tryParse(graceCtrl.text) ?? 30;
                            });
                            Navigator.pop(ctx);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    '${nameCtrl.text.trim()} updated successfully'),
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
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text('Save',
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════
  //  DELETE DIALOG
  // ═══════════════════════════════════════════
  void _showDeleteDialog(TimeSlotModel slot) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: AppConstant.cardBg(ctx),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(ctx).size.width * 0.85,
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.delete_outline,
                      color: Colors.red.shade400, size: 28),
                ),
                const SizedBox(height: 14),
                Text('Delete Time Slot',
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: AppConstant.textPrimary(ctx))),
                const SizedBox(height: 8),
                Text('Are you sure you want to delete "${slot.slotName}"?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 13, color: AppConstant.textSecondary(ctx))),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(ctx),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppConstant.textSecondary(ctx),
                          side: BorderSide(color: AppConstant.border(ctx)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() =>
                              allSlots.removeWhere((s) => s.id == slot.id));
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${slot.slotName} deleted'),
                              backgroundColor: Colors.red.shade600,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade600,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text('Delete',
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════
  //  SHARED WIDGETS
  // ═══════════════════════════════════════════
  Widget _dialogField(
      BuildContext ctx, String label, TextEditingController ctrl, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppConstant.textPrimary(ctx))),
        const SizedBox(height: 6),
        TextField(
          controller: ctrl,
          keyboardType: label.contains('Grace')
              ? TextInputType.number
              : TextInputType.text,
          style: TextStyle(fontSize: 13, color: AppConstant.textPrimary(ctx)),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle:
                TextStyle(fontSize: 13, color: AppConstant.textHint(ctx)),
            filled: true,
            fillColor: AppConstant.inputBg(ctx),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppConstant.border(ctx))),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppConstant.border(ctx))),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    BorderSide(color: AppConstant.primarycolor, width: 1.5)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
        ),
      ],
    );
  }

  Widget _dialogTimePicker(BuildContext ctx, String label, String currentValue,
      ValueChanged<String> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppConstant.textPrimary(ctx))),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: () async {
            final time = await showTimePicker(
              context: ctx,
              initialTime: TimeOfDay.now(),
            );
            if (time != null) {
              final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
              final minute = time.minute.toString().padLeft(2, '0');
              final period = time.period == DayPeriod.am ? 'AM' : 'PM';
              onChanged('$hour:$minute $period');
            }
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: AppConstant.inputBg(ctx),
              border: Border.all(color: AppConstant.border(ctx)),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(Icons.access_time,
                    size: 16, color: AppConstant.textHint(ctx)),
                const SizedBox(width: 10),
                Text(
                  currentValue.isEmpty ? '--:-- --' : currentValue,
                  style: TextStyle(
                      fontSize: 13,
                      color: currentValue.isEmpty
                          ? AppConstant.textHint(ctx)
                          : AppConstant.textPrimary(ctx)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
