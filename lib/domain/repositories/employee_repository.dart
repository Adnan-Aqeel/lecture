import 'package:lecture/data/models/user_model.dart';

abstract class EmployeeRepository {
  Future<List<UserModel>> getEmployees();
  Future<void> addEmployee(UserModel employee);
  Future<void> updateEmployee(UserModel employee);
  Future<void> deleteEmployee(int id);
}
