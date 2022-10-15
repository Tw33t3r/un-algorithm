import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<SubList> fetchSubList() async {
  String? apiKey = '';
  final prefs = await SharedPreferences.getInstance();
  apiKey = prefs.getString('apikey');
  if(apiKey == null){
    //TODO Throw
  }
  final response = await http.get(
    Uri.parse('https://youtube.googleapis.com/youtube/v3/playlistItems?part=snippet%2CcontentDetails%2Cstatus&playlistId=UUK8sQmJBp8GCxrOtXWBpyEA&key=[$apiKey]'),
    // Send authorization headers to the backend.
    headers: {
      HttpHeaders.authorizationHeader: 'Bearer [$apiKey]',
      HttpHeaders.acceptHeader: 'application/json',
    },
  );
  final responseJson = jsonDecode(response.body);
  print(apiKey);
  print(response.body);
  return responseJson;
  //return SubList.fromJson(responseJson);
}

class SubList {
  final int userId;
  final int id;
  final String title;

  const SubList({
    required this.userId,
    required this.id,
    required this.title,
  });

  factory SubList.fromJson(Map<String, dynamic> json) {
    return SubList(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
    );
  }
}
