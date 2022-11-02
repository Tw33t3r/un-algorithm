class Video {
  final String id;
  final String name;
  final int lastUpdated;

  const Video({
    required this.id,
    required this.name,
    required this.lastUpdated,
  });

  Video.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        lastUpdated = json['lastUpdated'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'lastUpdated': lastUpdated,
      };
}
