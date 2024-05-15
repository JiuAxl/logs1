import 'dart:io';
import 'dart:typed_data';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:uuid/uuid.dart';

var uuid = const Uuid();
mixin AudioRecorderMixin {
  Future<void> recordFile(AudioRecorder recorder, RecordConfig config) async {
    try{
      final path = await _getPath();
      await recorder.start(config, path: path);
    } catch (e, stackTrace) {
      print('Error stopping recorder: $e');
      print('Stack trace: $stackTrace');
    }
  }

  Future<void> recordStream(AudioRecorder recorder, RecordConfig config) async {
    final path = await _getPath();

    final file = File(path);

    final stream = await recorder.startStream(config);

    stream.listen(
          (data) {
        // ignore: avoid_print
        print(
          recorder.convertBytesToInt16(Uint8List.fromList(data)),
        );
        file.writeAsBytesSync(data, mode: FileMode.append);
      },
      // ignore: avoid_print
      onDone: () {
        // ignore: avoid_print
        print('End of stream. File written to $path.');
      },
    );
  }

  void downloadWebData(String path) {}

  Future<String> _getPath() async {
    // final dir = await getApplicationDocumentsDirectory();
    final dir = await getDownloadsDirectory();
    return p.join(
      // 'lib/assets/audionotes/'
      dir!.path!,
      '${uuid.v4()}.wav',
    // return '${uuid.v4()}.wav';
      // 'audio_${DateTime.now().millisecondsSinceEpoch}.m4a',
    );
  }
}