import 'dart:convert';
import 'dart:js_interop';

import 'package:file_picker/file_picker.dart';
import 'package:loggy/src/models/loggy_list.dart';
import 'package:web/web.dart' as web;

/// Exports the [list] as a JSON file.
Future<void> exportListToFile(LoggyList list) async {
  final json = jsonEncode(list);
  final jsonBytes = utf8.encode(json);

  final data = jsonBytes.toJS;
  final blob = web.Blob(
    [data].toJS,
    web.BlobPropertyBag(type: 'application/json'),
  );
  final url = web.URL.createObjectURL(blob);

  web.HTMLAnchorElement()
    ..href = url
    ..setAttribute('download', list.name)
    ..click();
  web.URL.revokeObjectURL(url);
}

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
