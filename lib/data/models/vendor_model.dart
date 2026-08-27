class Vendor {
  Vendor({
    required this.id,
    required this.name,
    required this.code,
    required this.contact,
    required this.phone,
    required this.email,
    required this.taxNumber,
    this.address = '',
    this.notes = '',
    required this.isActive,
  });

  final int id;
  String name;
  String code;
  String contact;
  String phone;
  String email;
  String taxNumber;
  String address;
  String notes;
  bool isActive;
}
