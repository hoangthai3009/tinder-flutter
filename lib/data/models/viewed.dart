class Viewed {
  final String id;
  final String user1;
  final String user2;
  final DateTime createdAt;
  final DateTime updatedAt;

  Viewed({
    required this.id,
    required this.user1,
    required this.user2,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Viewed.fromJson(Map<String, dynamic> json) {
    return Viewed(
      id: json['_id'] as String,
      user1: json['user1'] as String,
      user2: json['user2'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user1': user1,
      'user2': user2,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
