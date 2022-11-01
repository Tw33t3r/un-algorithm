class Sub {
  final String channelId;
  final String name;
  final String imageURL;

  const Sub({
    required this.channelId,
    required this.name,
    required this.imageURL,
  });

  Sub.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        channelId = json['channelId'],
        imageURL = json['imageURL'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'channelId': channelId,
        'imageURL': imageURL,
      };
}
