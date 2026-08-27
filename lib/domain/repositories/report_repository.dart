import 'package:lecture/data/models/models.dart';

abstract class ReportRepository {
  Future<List<AssetRecord>> getAssetRecords();
  Future<List<AttendanceRecord>> getAttendanceRecords();
  Future<List<EmployeeRecord>> getEmployeeRecords();
}
