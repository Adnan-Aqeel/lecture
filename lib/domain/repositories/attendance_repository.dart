import 'package:lecture/data/models/models.dart';

abstract class AttendanceRepository {
  Future<List<EmployeeAttendance>> getAttendanceRecords();
  Future<void> saveAttendance(EmployeeAttendance record);
  Future<void> updateAttendance(EmployeeAttendance record);
}
