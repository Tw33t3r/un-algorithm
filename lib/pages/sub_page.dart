import 'package:unalgorithm/components/sub_item.dart';
import 'package:unalgorithm/models/sub.dart';

import 'package:flutter/material.dart';
import 'package:unalgorithm/services/scraper.dart';

import '../services/storage.dart';

class SubPage extends StatefulWidget {
  const SubPage({super.key});

  final String title = "Subs";

  @override
  State<SubPage> createState() => _SubsPageState();
}

class _SubsPageState extends State<SubPage> {
  final _formKey = GlobalKey<FormState>();
  final _urlController = TextEditingController();
  Map<String, Sub> _subs = {};
  Scraper scraper = Scraper();
  Storage storage = Storage();

  @override
  void initState() {
    super.initState();
    _loadSubList();
  }

//TODO Move logic for subs outside of this widget
//TODO Change explicit title to scraped title
  _loadSubList() async {
    storage.readSubs().then((result) {
      setState(() {
        _subs = result;
      });
    });
  }

  _deleteFromSubList(String channelId) async {
    setState(() {
      _subs.remove(channelId);
      storage.writeSubs(_subs);
    });
  }

  _addToSubList(String channelURL) async {
    try {
      Sub newSub = await _getSubFromChannelURL(channelURL);
      setState(() {
        _subs[newSub.channelId] = newSub;
        storage.writeSubs(_subs);
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<Sub> _getSubFromChannelURL(String channelURL) async {
    return await scraper.getSubFromChannelURL(channelURL);
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
