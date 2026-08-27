class DocumentType {
  DocumentType({
    required this.id,
    required this.name,
    required this.description,
    required this.maxSizeMb,
    required this.allowedTypes,
    required this.isActive,
    required this.createdDate,
  });

  final int id;
  String name;
  String description;
  double maxSizeMb;
  List<String> allowedTypes;
  bool isActive;
  DateTime createdDate;
}
