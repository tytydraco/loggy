import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:loggy/src/models/loggy_list.dart';

/// Exports the [list] as a JSON file.
Future<void> exportListToFile(LoggyList list) async {
  final json = jsonEncode(list);
  final jsonBytes = utf8.encode(json);

  final outputFilePath = await FilePicker.platform.saveFile(
    fileName: '.json',
    allowedExtensions: ['json'],
    bytes: jsonBytes,
  );

  // No file chosen.
  if (outputFilePath == null) return;

  // For web, the file is already written. Write file for other platforms.
  if (!kIsWeb) {
    final outputFile = File(outputFilePath);
    await outputFile.writeAsString(json);
  }
}

/// Imports a JSON file as a list.
Future<LoggyList?> importFileAsList() async {
  final inputFileResult = await FilePicker.platform.pickFiles(
    allowedExtensions: ['json'],
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
