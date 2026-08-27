import 'package:lecture/data/models/models.dart';

abstract class TimeSlotRepository {
  Future<List<TimeSlotModel>> getTimeSlots();
  Future<void> addTimeSlot(TimeSlotModel slot);
  Future<void> updateTimeSlot(TimeSlotModel slot);
  Future<void> deleteTimeSlot(int id);
}
