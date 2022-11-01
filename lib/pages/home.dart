import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:YTFeed/models/sub.dart';
import 'package:YTFeed/models/sub_storage.dart';
import 'package:YTFeed/pages/sub_page.dart';
import 'package:YTFeed/components/video_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.subStorage});
  final SubStorage subStorage;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, Sub> _subs = {};
  int _last = 0;

  @override
  void initState() {
    super.initState();
    _loadSubList();
    _loadLast();
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => SubPage(
        subStorage: widget.subStorage,
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
    widget.subStorage.readSubs().then((result) {
      setState(() {
        _subs = result;
      });
    });
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

  _deleteFromVideoList() {}

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
            itemCount: _subs.length,
            prototypeItem: const ListTile(
              title: Text("Subscription Lists"),
            ),
            itemBuilder: (context, index) {
              return VideoItem(
                  _subs[_subs.keys.elementAt(index)]!, _deleteFromVideoList);
            },
          ),
        ),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(_createRoute());
        },
        tooltip: 'Add A Subscription',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
