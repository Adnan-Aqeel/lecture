import 'package:lecture/data/models/models.dart';

abstract class DepartmentRepository {
  Future<List<Department>> getDepartments();
  Future<void> addDepartment(Department department);
  Future<void> updateDepartment(Department department);
  Future<void> deleteDepartment(int id);
}
