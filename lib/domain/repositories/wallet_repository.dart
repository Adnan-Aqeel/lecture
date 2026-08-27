import 'package:lecture/data/models/models.dart';

abstract class WalletRepository {
  Future<List<ApprovalPolicy>> getPolicies();
  Future<void> addPolicy(ApprovalPolicy policy);
  Future<void> updatePolicy(ApprovalPolicy policy);
}
