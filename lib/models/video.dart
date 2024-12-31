class Video {
  final String id;
  final String name;
  final String thumbnailUrl;
  final int lastUpdated;

  const Video({
    required this.id,
    required this.name,
    required this.thumbnailUrl,
    required this.lastUpdated,
  });

  Video.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        thumbnailUrl = json['thumbnailUrl'],
        lastUpdated = json['lastUpdated'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'thumbnailUrl': thumbnailUrl,
        'lastUpdated': lastUpdated,
      };
}
