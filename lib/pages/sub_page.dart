import 'dart:convert';

import 'package:YTFeed/components/sub_item.dart';
import 'package:YTFeed/models/sub.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  //TODO To avoid needing to iterate over sublist on a simple insert should I create mapping and index list to save??
  //    Will just implement the full iteration each time, but should check to see if it works otherwise

  @override
  void initState() {
    super.initState();
    _loadSubList();
    _loadLast();
  }

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
    setState(() {
      Sub newSub = Sub(name: newName, channelId: newChannelId);
      _subs[newChannelId] = newSub;
      widget.subStorage.writeSubs(_subs);
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
                itemCount: _subs.length,
                prototypeItem: const ListTile(
                  title: Text("Subscription Lists"),
                ),
                itemBuilder: (context, index) {
                  return SubItem(_subs[_subs.keys.elementAt(index)]!,
                      const Icon(Icons.more_vert), _deleteFromSubList);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
