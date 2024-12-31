import 'package:unalgorithm/pages/home.dart';
import 'package:flutter/material.dart';

import 'package:unalgorithm/services/scraper.dart';
import 'package:unalgorithm/services/storage.dart';

void main() {
  runApp(const Unalgorithm());
}

class Unalgorithm extends StatefulWidget {
  const Unalgorithm({super.key});


  @override
  State<Unalgorithm> createState() => _UnalgorithmState();
}

class _UnalgorithmState extends State<Unalgorithm> {
  Scraper scraper = Scraper();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    if (!mounted) return;
  }
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Unalgorithm',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }

}
