import 'package:background_fetch/background_fetch.dart';
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
    int status = await BackgroundFetch.configure(BackgroundFetchConfig(
        minimumFetchInterval: 480,
        stopOnTerminate: false,
        enableHeadless: true,
        requiresBatteryNotLow: false,
        requiresCharging: false,
        requiresStorageNotLow: false,
        requiresDeviceIdle: false,
        requiredNetworkType: NetworkType.NONE,
    ), (String taskId) async {
      await scraper.getRecentVideos();
      BackgroundFetch.finish(taskId);
    }, (String taskId) async {
      BackgroundFetch.finish(taskId);
    });
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
