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
