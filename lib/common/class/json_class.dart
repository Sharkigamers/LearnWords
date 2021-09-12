import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class JsonClass {
  Future<String> get _localPath async {
    final Directory directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final String path = await _localPath;
    return File('$path/vocabulary.class');
  }

  Future<bool> writeToJsonVocabulary(Map<String, List<Map<String, dynamic>>>? words) async {
    final File file = await _localFile;
    if (words != null) {
      file.writeAsString(jsonEncode(words));
      return true;
    }
    return false;
  }

  Future<String?> readJsonVocabulary() async {
    final File file = await _localFile;
    if (await file.exists())
      return file.readAsString();
    else
      return null;
  }
}