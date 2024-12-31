import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'storage.dart';
import '../models/sub.dart';
import '../models/video.dart';

class Scraper {
  Storage storage = Storage();

  Future<int> _getLast() async {
    final prefs = await SharedPreferences.getInstance();
    int last = (prefs.getInt('last') ?? 0);
    return last;
  }

  void _setLast(int time) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('last', time);
  }

  getRecentVideos() async {
    try {
      Map<String, Video> videos = await storage.readVideos();
      Map<String, Sub> subs = await storage.readSubs();
      int last = await _getLast();
      for (int i = 0; i < subs.length; i++) {
        final String channelId = subs.keys.elementAt(i);
        print(subs[channelId]!.name);
        // This app is likely to need attention if youtube changes it's structure anyway, so I'm summoning cthulu here :)
        //https://stackoverflow.com/questions/1732348/regex-match-open-tags-except-xhtml-self-contained-tags/1732454#1732454
        final String xml =
            'https://www.youtube.com/feeds/videos.xml?channel_id=$channelId';
        final response = await http.get(Uri.parse(xml));
        RegExp videoExp = RegExp(
            r'<entry>[\s\S]*?<yt:videoId>([\s\S]*?)<\/yt:videoId>[\s\S]*?<title>([\s\S]*?)<\/title>[\s\S]*?<published>([\s\S]*?)<\/published>[\s\S]*?<media:thumbnail url="([\s\S]*?)"');
        final expMatches = videoExp.allMatches(response.body);
        for (final match in expMatches) {
          final String? videoId = match.group(1);
          final String? name = match.group(2);
          final String? lastUpdatedMatch = match.group(3);
          final String? thumbnailUrl = match.group(4);
          if (videoId == null || lastUpdatedMatch == null || name == null || thumbnailUrl == null) {
            throw 'Null Value';
          }
          final lastUpdated =
              DateTime.parse(lastUpdatedMatch).millisecondsSinceEpoch;
          if (lastUpdated > last) {
            final Video newVideo =
                Video(id: videoId, name: name, lastUpdated: lastUpdated, thumbnailUrl: thumbnailUrl);
            videos[videoId] = newVideo;
         }
        }
      }
      storage.writeVideos(videos);
      _setLast(DateTime.now().millisecondsSinceEpoch);
      return videos;
    } catch (e) {
      rethrow;
    }
  }

  Future<Sub> getSubFromChannelURL(String channelURL) async {
    final response = await http.get(Uri.parse(channelURL));
    RegExp imageExp = RegExp("\"image_src\" href=\"(.*?)(?=\")");
    RegExp channelIdExp = RegExp("externalId\":\"(.*?)(?=\")");
    RegExp nameExp = RegExp("meta property=\"og:title\" content=\"(.*?)(?=\")");
    try {
      final imageURL = imageExp.firstMatch(response.body)!.group(1);
      final channelId = channelIdExp.firstMatch(response.body)!.group(1);
      final name = nameExp.firstMatch(response.body)!.group(1);
      if (imageURL == null || channelId == null || name == null) {
        throw 'Null Value';
      }
      return Sub(channelId: channelId, imageURL: imageURL, name: name);
    } catch (e) {
      rethrow;
    }
  }
}
