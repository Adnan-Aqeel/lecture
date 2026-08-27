import 'package:lecture/domain/repositories/department_repository.dart';
import 'package:lecture/data/models/models.dart';

class MockDepartmentRepository implements DepartmentRepository {
  final List<Department> _departments = [
    Department(id: 1, name: 'Business Analyst', description: 'Business Analyst Department', isActive: true),
    Department(id: 2, name: 'Business Development', description: 'Business Development Department', isActive: true),
    Department(id: 3, name: 'Development', description: 'Development Department', isActive: true),
    Department(id: 4, name: 'Finance', description: 'Finance Department', isActive: true),
    Department(id: 5, name: 'Human Resources', description: 'Human Resources Department', isActive: true),
    Department(id: 6, name: 'Operations', description: 'HR, Operations and Finance', isActive: true),
    Department(id: 7, name: 'Project Manager', description: 'Project Manager', isActive: true),
    Department(id: 8, name: 'Quality Assurance', description: 'Quality Assurance Department', isActive: true),
    Department(id: 9, name: 'Social Media', description: 'Social Media Department', isActive: false),
  ];

  @override
  Future<List<Department>> getDepartments() async => _departments;

  @override
  Future<void> addDepartment(Department department) async {
    final newId = _departments.isEmpty ? 1 : _departments.map((d) => d.id).reduce((a, b) => a > b ? a : b) + 1;
    department.id = newId;
    _departments.add(department);
  }

  @override
  Future<void> updateDepartment(Department department) async {
    final index = _departments.indexWhere((d) => d.id == department.id);
    if (index != -1) _departments[index] = department;
  }

  @override
  Future<void> deleteDepartment(int id) async {
    _departments.removeWhere((d) => d.id == id);
  }
}
