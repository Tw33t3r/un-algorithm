import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'package:unalgorithm/models/sub.dart';
import 'package:unalgorithm/models/storage.dart';
import 'package:unalgorithm/pages/sub_page.dart';
import 'package:unalgorithm/components/video_item.dart';
import 'package:unalgorithm/models/video.dart';
import 'package:unalgorithm/pages/video.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.storage});
  final Storage storage;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, Sub> _subs = {};
  Map<String, Video> _videos = {};
  int _last = 0;

  @override
  void initState() {
    super.initState();
    _loadSubList();
    _loadVideoList();
    _loadLast();
    _getRecentVideos();
    _setLast(DateTime.now().millisecondsSinceEpoch);
  }

  Route _subsRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => SubPage(
        storage: widget.storage,
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

  _loadSubList() async {
    widget.storage.readSubs().then((result) {
      setState(() {
        _subs = result;
      });
    });
  }

  _loadVideoList() async {
    widget.storage.readVideos().then((result) {
      setState(() {
        _videos = result;
      });
    });
  }

  _deleteFromVideoList(videoId) async {
    setState(() {
      _videos.remove(videoId);
      widget.storage.writeVideos(_videos);
    });
  }

  _getRecentVideos() async {
    for (int i = 0; i < _subs.length; i++) {
      final String channelId = _subs.keys.elementAt(i);
      // This app is likely to need attention if youtube changes it's structure anyway, so I'm summoning cthulu here :)
      //https://stackoverflow.com/questions/1732348/regex-match-open-tags-except-xhtml-self-contained-tags/1732454#1732454
      final String xml =
          'https://www.youtube.com/feeds/videos.xml?channel_id=$channelId';
      final response = await http.get(Uri.parse(xml));
      RegExp videoExp = RegExp(
          r"<entry>[\s\S]*?<yt:videoId>([\s\S]*?)<\/yt:videoId>[\s\S]*?<title>([\s\S]*?)<\/title>[\s\S]*?<updated>([\s\S]*?)<\/updated>");
      try {
        final expMatches = videoExp.allMatches(response.body);
        for (final match in expMatches) {
          final String? videoId = match.group(1);
          final String? name = match.group(2);
          final String? lastUpdatedMatch = match.group(3);
          if (videoId == null || lastUpdatedMatch == null || name == null) {
            throw NullThrownError();
          }
          final lastUpdated =
              DateTime.parse(lastUpdatedMatch).millisecondsSinceEpoch;
          if (lastUpdated > _last) {
            final Video newVideo =
                Video(id: videoId, name: name, lastUpdated: lastUpdated);
            setState(() {
              _videos[videoId] = newVideo;
            });
          }
        }
        widget.storage.writeVideos(_videos);
      } catch (e) {
        rethrow;
      }
    }
  }

  _loadLast() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _last = (prefs.getInt('last') ?? 0);
    });
  }

  _setLast(int lastUpdated) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setInt('last', lastUpdated);
    });
  }

  _fullscreen(videoId){
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
      body: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
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
