import 'package:lecture/data/models/models.dart';

abstract class MonthlyHourRepository {
  Future<List<MonthlyHourModel>> getMonthlyHours();
}
