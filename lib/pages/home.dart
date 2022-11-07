import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:unalgorithm/services/storage.dart';
import 'package:unalgorithm/pages/sub_page.dart';
import 'package:unalgorithm/components/video_item.dart';
import 'package:unalgorithm/models/video.dart';
import 'package:unalgorithm/pages/video.dart';

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

  Route _videoRoute(videoId) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => VideoPage(
        videoId,
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

  _fullscreen(videoId) {
    Navigator.of(context).push(_videoRoute(videoId)).then((value) {
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
    );
  }
}
