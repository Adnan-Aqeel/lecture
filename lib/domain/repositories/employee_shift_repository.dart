import 'package:lecture/data/models/models.dart';

abstract class EmployeeShiftRepository {
  Future<List<EmployeeShiftModel>> getEmployeeShifts();
  Future<void> assignShift(EmployeeShiftModel shift);
  Future<void> updateShift(EmployeeShiftModel shift);
}
