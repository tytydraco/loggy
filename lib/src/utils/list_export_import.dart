import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:loggy/src/models/loggy_list.dart';
import 'package:loggy/src/utils/list_export_web.dart';

/// Exports the [list] as a JSON file.
Future<void> exportListToFile(LoggyList list) async {
  final json = jsonEncode(list);
  final jsonBytes = utf8.encode(json);

  // Web requires a special method to save files.
  if (kIsWeb) {
    await exportListToFileWeb(list.name, jsonBytes);
    return;
  }

  final outputFilePath = await FilePicker.platform.saveFile(
    fileName: '${list.name}.json',
    allowedExtensions: ['json'],
    type: FileType.custom,
    bytes: jsonBytes,
  );

  // No file chosen.
  if (outputFilePath == null) return;

  // Desktop platforms require actually writing the file manually.
  if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
    final outputFile = File(outputFilePath);
    await outputFile.writeAsString(json);
  }
}

/// Imports a JSON file as a list.
Future<LoggyList?> importFileAsList() async {
  final inputFileResult = await FilePicker.platform.pickFiles(
    allowedExtensions: ['json'],
    type: FileType.custom,
    withData: true,
  );
  final inputFile = inputFileResult?.files.single;

  // No file chosen.
  if (inputFile == null) return null;

  final jsonBytes = inputFile.bytes!;
  final json = utf8.decode(jsonBytes);

  final listJson = jsonDecode(json) as Map<String, dynamic>;
  return LoggyList.fromJson(listJson);
}
