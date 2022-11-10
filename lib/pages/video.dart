import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// A ListItem that contains data to display a message.
class VideoPage extends StatelessWidget {
  final String videoId;

  const VideoPage(this.videoId, {super.key});

  @override
  Widget build(BuildContext context) {
    // return OrientationBuilder(builder: (context, orientation) {
    //   switch (orientation) {
    //     case Orientation.landscape:
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
          return WebView(
            initialUrl: Uri.dataFromString(
                    '<head><style type="text/css"> html, body { width:100%; height: 100%; margin: 0px; padding: 0px; } </style></head><body><iframe id="player" margin="0" padding="0" width="100%" height="100%" src="http://www.youtube.com/embed/$videoId" frameborder="0"></iframe></body>',
                    mimeType: 'text/html')
                .toString(),
            javascriptMode: JavascriptMode.unrestricted,
          );
    //     case Orientation.portrait:
    //       SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    //       return Scaffold(
    //         appBar: AppBar(
    //           title: Text(videoId),
    //         ),
    //         body: WebView(
    //           initialUrl: Uri.dataFromString(
    //                   '<head><style type="text/css"> html, body { width:100%; height: 100%; margin: 0px; padding: 0px; } </style></head><body><iframe id="player" margin="0" padding="0" width="100%" height="100%" src="http://www.youtube.com/embed/$videoId" frameborder="0"></iframe></body>',
    //                   mimeType: 'text/html')
    //               .toString(),
    //           javascriptMode: JavascriptMode.unrestricted,
    //         ),
    //       );
    //   }
    // });
  }
}
