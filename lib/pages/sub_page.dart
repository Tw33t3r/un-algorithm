import 'dart:convert';

import 'package:YTFeed/components/sub_item.dart';
import 'package:YTFeed/models/sub.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SubPage extends StatefulWidget {
  const SubPage({super.key});

  final String title = "Subs";

  @override
  State<SubPage> createState() => _SubsPageState();
}

class _SubsPageState extends State<SubPage> {
  final _formKey = GlobalKey<FormState>();
  final _channelController = TextEditingController();
  final _idController = TextEditingController();
  List<Sub> _subList = [];
  int _last = 0;

  //TODO To avoid needing to iterate over sublist on a simple insert should I create mapping and index list to save??
  //    Will just implement the full iteration each time, but should check to see if it works otherwise

  @override
  void initState() {
    super.initState();
    _loadSubList();
    _loadLast();
  }

//TODO ugly code
  _loadSubList() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      var unparsedSubList = (prefs.getString('subList'));
      if (unparsedSubList == null) {
      } else {
        List<Sub> newSubList = [];
        dynamic subMapList = jsonDecode(unparsedSubList);
        for (var sub in subMapList) {
          newSubList.add(Sub.fromJson(sub));
        }
        _subList = newSubList;
      }
    });
  }

  _addToSubList(String newName, String newChannelId) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      Sub newSub = Sub(name: newName, channelId: newChannelId);
      _subList.add(newSub);
      String newSubListJson = json.encode(_subList);
      prefs.setString('subList', newSubListJson);
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
                itemCount: _subList.length,
                prototypeItem: const ListTile(
                  title: Text("Subscription Lists"),
                ),
                itemBuilder: (context, index) {
                  return SubItem(_subList[index], const Icon(Icons.more_vert));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
