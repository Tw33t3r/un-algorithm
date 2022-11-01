import 'package:YTFeed/components/sub_item.dart';
import 'package:YTFeed/models/sub.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../models/sub_storage.dart';

class SubPage extends StatefulWidget {
  const SubPage({super.key, required this.subStorage});

  final SubStorage subStorage;

  final String title = "Subs";

  @override
  State<SubPage> createState() => _SubsPageState();
}

class _SubsPageState extends State<SubPage> {
  final _formKey = GlobalKey<FormState>();
  final _channelController = TextEditingController();
  final _idController = TextEditingController();
  Map<String, Sub> _subs = {};
  int _last = 0;

  @override
  void initState() {
    super.initState();
    _loadSubList();
  }

//TODO Move logic for subs outside of this widget
//TODO Change explicit title to scraped title
  _loadSubList() async {
    widget.subStorage.readSubs().then((result) {
      setState(() {
        _subs = result;
      });
    });
  }

  _deleteFromSubList(String channelId) async {
    setState(() {
      _subs.remove(channelId);
      widget.subStorage.writeSubs(_subs);
    });
  }

  _addToSubList(String newName, String newChannelId) async {
    try {
      String newImageURL = await _getSubImageURL(newChannelId);
      setState(() {
        Sub newSub =
            Sub(name: newName, channelId: newChannelId, imageURL: newImageURL);
        _subs[newChannelId] = newSub;
        widget.subStorage.writeSubs(_subs);
      });
    } catch (e) {
      rethrow;
    }
  }

  _getSubImageURL(String channelId) async {
    final String ytUrl = "https://www.youtube.com/channel/$channelId";
    final response = await http.get(Uri.parse(ytUrl));
    RegExp imageExp = RegExp("(\"image_src\" href=\")(.*?)(?=\")");
    try {
      final imageURL = imageExp.firstMatch(response.body)!.group(2);
      return imageURL;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextFormField(
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Enter the name for this channel',
              ),
              controller: _channelController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a name for this channel';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Enter the channel ID',
              ),
              controller: _idController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Enter the channel ID';
                }
                return null;
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _addToSubList(_channelController.text, _idController.text);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Saved Channel')),
                    );
                  }
                },
                child: const Text('Save'),
              ),
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _subs.length,
                prototypeItem: const ListTile(
                  title: Text("Subscription Lists"),
                ),
                itemBuilder: (context, index) {
                  return SubItem(
                      _subs[_subs.keys.elementAt(index)]!, _deleteFromSubList);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
