import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

Future<String> createTempFile(Uint8List data, String filename) async {
  final applicationTempDir = await getTemporaryDirectory();
  
  final processedPath = path.join(applicationTempDir.path, filename);
  final file = File(processedPath);
  await file.writeAsBytes(data);
  return file.path;
}

String generateUniqueName()
{
   return DateTime.now().toIso8601String().replaceAll("-", "_").replaceAll(":", "_").replaceAll(".", "_");
}
