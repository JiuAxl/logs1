import 'dart:html' as html;
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

Future<Uint8List> blobUrlToUint8List(String blobUrl) async {
  final response = await html.window.fetch(blobUrl);
  final blob = await response.blob();
  final reader = html.FileReader();
  reader.readAsArrayBuffer(blob);
  await reader.onLoad.first;
  return reader.result as Uint8List;
}


Future<void> save(String blobUrl, String path) async {
  try {
    Uint8List data = await blobUrlToUint8List(blobUrl);
    await supabase.storage
        .from('audio')
        .uploadBinary(path, data);
  } on StorageException catch (e) {
    print("Upload failed: $e");
  }
}

