import 'package:YTFeed/pages/home.dart';
import 'package:YTFeed/pages/sub_page.dart';
import 'package:flutter/material.dart';

import 'models/sub_storage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SubPage(subStorage: SubStorage()),
    );
  }
}
