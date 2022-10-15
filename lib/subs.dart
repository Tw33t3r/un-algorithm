import 'package:YTFeed/fetch.dart';
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
  final _apiController = TextEditingController();
  String _apiKey = '';
  int _last = 0;

  @override
  void initState() {
    super.initState();
    _loadApiKey();
    _loadLast();
    fetchSubList();
  }

  _loadApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _apiKey = (prefs.getString('apikey') ?? 'String');
    });
  }

  _setApiKey(String key) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setString('apikey', key);
      _apiKey = key;
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
                labelText: 'Enter your Google API Key',
              ),
              controller: _apiController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a valid API Key';
                }
                return null;
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _setApiKey(_apiController.text);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Saved API Key')),
                    );
                  }
                },
                child: const Text('Save'),
              ),
            ),
            const Text(
              'API Key Is:',
            ),
            Text(
              _apiKey,
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
    );
  }
}
