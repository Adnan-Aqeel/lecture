import 'package:lecture/domain/repositories/attendance_repository.dart';
import 'package:lecture/data/models/models.dart';

class MockAttendanceRepository implements AttendanceRepository {
  final List<EmployeeAttendance> _records = [
    EmployeeAttendance(id: '1', name: 'Ali', status: AttendanceStatus.absent),
    EmployeeAttendance(id: '2', name: 'Zain', status: AttendanceStatus.absent),
    EmployeeAttendance(id: '1002', name: 'Amair', status: AttendanceStatus.absent),
    EmployeeAttendance(id: '2002', name: 'Ehsan', status: AttendanceStatus.absent),
  ];

  @override
  Future<List<EmployeeAttendance>> getAttendanceRecords() async => _records;

  @override
  Future<void> saveAttendance(EmployeeAttendance record) async {
    _records.add(record);
  }

  @override
  Future<void> updateAttendance(EmployeeAttendance record) async {
    final index = _records.indexWhere((r) => r.id == record.id);
    if (index != -1) _records[index] = record;
  }
}
