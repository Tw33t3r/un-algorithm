import 'package:YTFeed/models/sub.dart';
import 'package:flutter/material.dart';

/// A ListItem that contains data to display a message.
class SubItem extends StatelessWidget {
  final Sub sub;
  Icon image;

  SubItem(this.sub, this.image, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: image,
          ),
          Expanded(
            flex: 3,
            child: _VideoDescription(
              name: sub.name,
              channelId: sub.channelId,
            ),
          ),
          const Icon(
            Icons.more_vert,
            size: 16.0,
          ),
        ],
      ),
    );
  }
}

class _VideoDescription extends StatelessWidget {
  const _VideoDescription({
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
