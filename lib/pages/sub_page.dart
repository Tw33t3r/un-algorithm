import 'package:unalgorithm/components/sub_item.dart';
import 'package:unalgorithm/models/sub.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/storage.dart';

class SubPage extends StatefulWidget {
  const SubPage({super.key, required this.storage});

  final Storage storage;

  final String title = "Subs";

  @override
  State<SubPage> createState() => _SubsPageState();
}

class _SubsPageState extends State<SubPage> {
  final _formKey = GlobalKey<FormState>();
  final _urlController = TextEditingController();
  Map<String, Sub> _subs = {};

  @override
  void initState() {
    super.initState();
    _loadSubList();
  }

//TODO Move logic for subs outside of this widget
//TODO Change explicit title to scraped title
  _loadSubList() async {
    widget.storage.readSubs().then((result) {
      setState(() {
        _subs = result;
      });
    });
  }

  _deleteFromSubList(String channelId) async {
    setState(() {
      _subs.remove(channelId);
      widget.storage.writeSubs(_subs);
    });
  }

  _addToSubList(String channelURL) async {
    try {
      Sub newSub = await _getSubFromChannelURL(channelURL);
      setState(() {
        _subs[newSub.channelId] = newSub;
        widget.storage.writeSubs(_subs);
      });
    } catch (e) {
      rethrow;
    }
  }

  _getSubFromChannelURL(String channelURL) async {
    final response = await http.get(Uri.parse(channelURL));
    RegExp imageExp = RegExp("\"image_src\" href=\"(.*?)(?=\")");
    RegExp channelIdExp = RegExp("externalId\":\"(.*?)(?=\")");
    RegExp nameExp = RegExp("meta property=\"og:title\" content=\"(.*?)(?=\")");
    try {
      final imageURL = imageExp.firstMatch(response.body)!.group(1);
      final channelId = channelIdExp.firstMatch(response.body)!.group(1);
      final name = nameExp.firstMatch(response.body)!.group(1);
      if (imageURL == null || channelId == null || name == null) {
        throw NullThrownError();
      }
      return Sub(channelId: channelId, imageURL: imageURL, name: name);
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
                labelText: 'https://www.youtube.com/user/example',
              ),
              controller: _urlController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Enter the channel URL';
                }
                return null;
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _addToSubList(_urlController.text);
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
