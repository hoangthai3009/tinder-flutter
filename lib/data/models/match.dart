class Match {
  final String id;
  final String userId;
  final String userName;
  final String userAvatar;
  final DateTime createdAt;
  final DateTime updatedAt;

  Match({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Match.fromJson(Map<String, dynamic> json) {
    return Match(
      id: json['_id'] as String,
      userId: json['user']['_id'] as String,
      userName: json['user']['name'] as String,
      userAvatar: json['user']['profile']['avatar'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}
