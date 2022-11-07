import 'dart:convert';
import 'dart:io';

import 'package:unalgorithm/models/sub.dart';
import 'package:unalgorithm/models/video.dart';
import 'package:path_provider/path_provider.dart';

class Storage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localSubFile async {
    final path = await _localPath;
    return File('$path/subs.txt');
  }

  Future<File> get _localVidFile async {
    final path = await _localPath;
    return File('$path/vids.txt');
  }

  Future<Map<String, Sub>> readSubs() async {
    try {
      final file = await _localSubFile;

      final contents = await file.readAsString();
      Map<String, dynamic> result = json.decode(contents);

      Map<String, Sub> toReturn = {};
      result.forEach(((key, value) {
        toReturn[key] = Sub.fromJson(value);
      }));

      return (toReturn);
    } catch (e) {
      return {};
    }
  }

  Future<File> writeSubs(Map<String, Sub> subs) async {
    final file = await _localSubFile;

    return file.writeAsString(json.encode(subs));
  }

  Future<Map<String, Video>> readVideos() async {
    try {
      final file = await _localVidFile;

      final contents = await file.readAsString();
      Map<String, dynamic> result = json.decode(contents);

      Map<String, Video> toReturn = {};
      result.forEach(((key, value) {
        toReturn[key] = Video.fromJson(value);
      }));

      return (toReturn);
    } catch (e) {
      return {};
    }
  }

  Future<File> writeVideos(Map<String, Video> videos) async {
    final file = await _localVidFile;
    return file.writeAsString(json.encode(videos));
  }
}
