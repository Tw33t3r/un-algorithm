import 'package:unalgorithm/models/sub.dart';
import 'package:flutter/material.dart';

/// A ListItem that contains data to display a message.
class SubItem extends StatelessWidget {
  final Function deleteItem;
  final Sub sub;

  const SubItem(this.sub, this.deleteItem, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Image.network(sub.imageURL),
          ),
          Expanded(
            flex: 5,
            child: _SubDescription(
              name: sub.name,
              channelId: sub.channelId,
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: IconButton(
                    icon: const Icon(Icons.delete),
                    iconSize: 24.0,
                    onPressed: () async {
                      await deleteItem(sub.channelId);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SubDescription extends StatelessWidget {
  const _SubDescription({
    required this.name,
    required this.channelId,
  });

  final String name;
  final String channelId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            name,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14.0,
            ),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 2.0)),
          Text(
            channelId,
            style: const TextStyle(fontSize: 10.0),
          ),
        ],
      ),
    );
  }
}
