import 'package:lecture/data/models/models.dart';

abstract class VendorRepository {
  Future<List<Vendor>> getVendors();
  Future<void> addVendor(Vendor vendor);
  Future<void> updateVendor(Vendor vendor);
  Future<void> deleteVendor(int id);
}
