import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
final supabase = Supabase.instance.client;
Future<void> save(String filePath, String path) async {
  try {
    Uint8List fileData = await filePathToUint8List(filePath);
    print('data: ${fileData.length}');
    await supabase.storage
        .from('audio')
        .uploadBinary(path,fileData);
    print('File uploaded successfully');
  } on StorageException catch (e) {
    print('Error uploading file: ${e.message}');
  }
}

Future<Uint8List> filePathToUint8List(String filePath) async {
  print('not web');
  String modifiedFilePath = filePath.replaceAll('\\', '/');
  print(modifiedFilePath);
  final file = File(modifiedFilePath);
  // Read the file as bytes
  Uint8List bytes = await file.readAsBytes();
  return bytes;
}
