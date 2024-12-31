import 'package:unalgorithm/models/video.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// A ListItem that contains data to display a message.
class VideoItem extends StatelessWidget {
  final Function deleteItem;
  final Function fullscreen;
  final Video video;

  const VideoItem(this.video, this.deleteItem, this.fullscreen, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
              flex: 3,
              child: 
                Image.network(
                  video.thumbnailUrl,
                  fit: BoxFit.fill,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                )
              ),
          Expanded(
            flex: 2,
            child: _VideoDescription(
              name: video.name,
              videoId: video.id,
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: IconButton(
                    icon: const Icon(Icons.delete),
                    iconSize: 24.0,
                    onPressed: () async {
                      await deleteItem(video.id);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: IconButton(
                    icon: const Icon(Icons.fullscreen),
                    iconSize: 24.0,
                    onPressed: () async {
                      await fullscreen(video.id);
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

class _VideoDescription extends StatelessWidget {
  const _VideoDescription({
    required this.name,
    required this.videoId,
  });

  final String name;
  final String videoId;

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
            videoId,
            style: const TextStyle(fontSize: 10.0),
          ),
        ],
      ),
    );
  }
}
