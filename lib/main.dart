import 'package:background_fetch/background_fetch.dart';
import 'package:unalgorithm/pages/home.dart';
import 'package:flutter/material.dart';

import 'models/storage.dart';

void main() {
  runApp(const Unalgorithm());
}

class Unalgorithm extends StatefulWidget {
  const Unalgorithm({super.key});


  @override
  State<Unalgorithm> createState() => _UnalgorithmState();
}

class _UnalgorithmState extends State<Unalgorithm> {

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    // Configure BackgroundFetch.
    int status = await BackgroundFetch.configure(BackgroundFetchConfig(
        minimumFetchInterval: 15,
        stopOnTerminate: false,
        enableHeadless: true,
        requiresBatteryNotLow: false,
        requiresCharging: false,
        requiresStorageNotLow: false,
        requiresDeviceIdle: false,
        requiredNetworkType: NetworkType.NONE
    ), (String taskId) async {
      print("[BackgroundFetch] Event received $taskId");
      BackgroundFetch.finish(taskId);
    }, (String taskId) async {
      print("[BackgroundFetch] TASK TIMEOUT taskId: $taskId");
      BackgroundFetch.finish(taskId);
    });
    print('[BackgroundFetch] configure success: $status');
    if (!mounted) return;
  }
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Unalgorithm',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(storage: Storage()),
    );
  }

}
