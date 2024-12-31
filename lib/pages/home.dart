import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:unalgorithm/services/storage.dart';
import 'package:unalgorithm/pages/sub_page.dart';
import 'package:unalgorithm/components/video_item.dart';
import 'package:unalgorithm/models/video.dart';
import 'package:unalgorithm/pages/video.dart';

import 'dart:convert'; import 'dart:developer' as developer;
import '../services/scraper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Scraper scraper = Scraper();
  Map<String, Video> _videos = {};
  Storage storage = Storage();
  WebViewController controller = WebViewController()
  ..enableZoom(false)
  ..setJavaScriptMode(JavaScriptMode.unrestricted)
  ..setBackgroundColor(const Color(0x00000000))
  ..setNavigationDelegate(
    NavigationDelegate(
      onProgress: (int progress) {
        // Update loading bar.
      },
      onPageStarted: (String url) {},
      onPageFinished: (String url) {},
      onWebResourceError: (WebResourceError error) {},
      onNavigationRequest: (NavigationRequest request) {
        return NavigationDecision.navigate;
      },
    ),
  );

  @override
  void initState() {
    super.initState();
    _loadVideoList();
    _getRecentVideos();
  }

  Route _subsRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => SubPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  Route _videoRoute(videoId, controller) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => VideoPage(
        videoId,
        controller
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  _loadVideoList() async {
    storage.readVideos().then((result) {
      setState(() {
        _videos = result;
      });
    });
  }

  _deleteFromVideoList(videoId) async {
    setState(() {
      _videos.remove(videoId);
      storage.writeVideos(_videos);
    });
  }

  _getRecentVideos() async {
    Map<String, Video> result = await scraper.getRecentVideos();
    setState(() {
      _videos = result;
    });
  }

  _fullscreen(videoId) async {
    var html = Uri.dataFromString(
      '<head><style type="text/css"> html, body { width:100%; height: 100%; margin: 0px; padding: 0px; } </style></head><body><iframe id="player" margin="0" padding="0" width="100%" height="100%" src="https://www.youtube.com/embed/$videoId" frameborder="0"></iframe></body>',
      mimeType: 'text/html');
    await controller.loadRequest(html);

    Navigator.of(context).push(_videoRoute(videoId, controller)).then((value) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: RefreshIndicator(
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _videos.length,
              itemBuilder: (context, index) {
                return SizedBox(
                    height: 120,
                    child: VideoItem(_videos[_videos.keys.elementAt(index)]!,
                        _deleteFromVideoList, _fullscreen));
              },
            ),
          ),
        ]),
        onRefresh: () {
          return _getRecentVideos();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(_subsRoute());
        },
        tooltip: 'Add A Subscription',
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
