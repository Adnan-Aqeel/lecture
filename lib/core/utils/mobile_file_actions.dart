import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

/// Shared mobile file actions for HRMS reports and import workflows.
class MobileFileActions {
  MobileFileActions._();

  static Future<void> exportCsv({
    required String fileName,
    required List<String> headers,
    List<List<Object?>> rows = const [],
    String? shareText,
  }) async {
    final csv = const ListToCsvConverter().convert([
      headers,
      if (rows.isEmpty) ['No data available'],
      ...rows,
    ]);
    await _shareBytes(
      fileName: _withExtension(fileName, 'csv'),
      bytes: utf8.encode(csv),
      mimeType: 'text/csv',
      shareText: shareText,
    );
  }

  static Future<void> exportPdf({
    required String fileName,
    required String title,
    required List<String> headers,
    List<List<Object?>> rows = const [],
    String? shareText,
  }) async {
    final document = pw.Document();
    document.addPage(
      pw.MultiPage(
        build: (_) => [
          pw.Header(level: 0, text: title),
          pw.TableHelper.fromTextArray(
            headers: headers,
            data: rows.isEmpty ? [['No data available']] : rows,
          ),
        ],
      ),
    );
    await _shareBytes(
      fileName: _withExtension(fileName, 'pdf'),
      bytes: await document.save(),
      mimeType: 'application/pdf',
      shareText: shareText,
    );
  }

  static Future<void> downloadCsvTemplate({
    required String fileName,
    required List<String> headers,
  }) => exportCsv(fileName: fileName, headers: headers);

  static Future<PlatformFile?> pickImportFile({
    required List<String> allowedExtensions,
  }) async {
    if (kIsWeb) {
      debugPrint('File import is available on Android and iOS only.');
      return null;
    }

    try {
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: allowedExtensions,
        allowMultiple: false,
        withData: false,
      );
      return result?.files.isEmpty == true ? null : result?.files.single;
    } on MissingPluginException {
      debugPrint(
          'File picker is not registered. Stop and rebuild the app after installing file_picker.');
      return null;
    } on PlatformException catch (error) {
      debugPrint('Unable to open the file picker: ${error.message ?? error.code}');
      return null;
    }
  }

  static Future<void> _shareBytes({
    required String fileName,
    required List<int> bytes,
    required String mimeType,
    String? shareText,
  }) async {
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/$fileName');
    await file.writeAsBytes(bytes, flush: true);
    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path, mimeType: mimeType)],
        text: shareText,
      ),
    );
  }

  static String _withExtension(String fileName, String extension) {
    return fileName.toLowerCase().endsWith('.$extension')
        ? fileName
        : '$fileName.$extension';
  }
}
