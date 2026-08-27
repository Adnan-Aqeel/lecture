import 'package:lecture/data/models/models.dart';

abstract class DocumentTypeRepository {
  Future<List<DocumentType>> getDocumentTypes();
  Future<void> addDocumentType(DocumentType docType);
  Future<void> updateDocumentType(DocumentType docType);
  Future<void> deleteDocumentType(int id);
}
