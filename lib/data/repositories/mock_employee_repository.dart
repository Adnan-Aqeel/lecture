import 'package:lecture/data/models/user_model.dart';
import 'package:lecture/domain/repositories/employee_repository.dart';

class MockEmployeeRepository implements EmployeeRepository {
  final List<UserModel> _employees = [
    UserModel(id: 1, name: 'Ali Ahmed', email: 'ali@magnitude.com', phone: '0300-1234567', department: 'Development', routine: '9AM-6PM', designation: 'Senior Developer', status: 'Active'),
    UserModel(id: 2, name: 'Zain Malik', email: 'zain@magnitude.com', phone: '0301-2345678', department: 'Design', routine: '9AM-6PM', designation: 'UI/UX Designer', status: 'Active'),
  ];

  @override
  Future<List<UserModel>> getEmployees() async => _employees;

  @override
  Future<void> addEmployee(UserModel employee) async {
    employee.id = _employees.isEmpty ? 1 : _employees.map((e) => e.id).reduce((a, b) => a > b ? a : b) + 1;
    _employees.add(employee);
  }

  @override
  Future<void> updateEmployee(UserModel employee) async {
    final index = _employees.indexWhere((e) => e.id == employee.id);
    if (index != -1) _employees[index] = employee;
  }

  @override
  Future<void> deleteEmployee(int id) async {
    _employees.removeWhere((e) => e.id == id);
  }
}
