import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// A ListItem that contains data to display a message.
class VideoPage extends StatelessWidget {
  final String videoId;
  final WebViewController controller;

  const VideoPage(this.videoId, this.controller, {super.key});
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    return WebViewWidget(
      controller: controller
    );
  }
}
