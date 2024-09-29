import 'dart:js_interop';

import 'package:flutter/foundation.dart';
import 'package:web/web.dart' as web;

Future<void> exportListToFileWeb(String name, Uint8List bytes) async {
  final data = bytes.toJS;
  final blob = web.Blob(
    [data].toJS,
    web.BlobPropertyBag(type: 'application/json'),
  );
  final url = web.URL.createObjectURL(blob);

  web.HTMLAnchorElement()
    ..href = url
    ..setAttribute('download', name)
    ..click();
  web.URL.revokeObjectURL(url);
}
