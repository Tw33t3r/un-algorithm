class Sub {
  final String channelId;
  final String name;

  const Sub({
    required this.channelId,
    required this.name,
  });

  Sub.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        channelId = json['channelId'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'channelId': channelId,
      };
}
