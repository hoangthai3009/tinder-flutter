class SuperLikes {
  final int remaining;
  final DateTime resetDate;

  SuperLikes({
    required this.remaining,
    required this.resetDate,
  });

  factory SuperLikes.fromJson(Map<String, dynamic> json) {
    return SuperLikes(
      remaining: json['remaining'],
      resetDate: DateTime.parse(json['resetDate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'remaining': remaining,
      'resetDate': resetDate.toIso8601String(),
    };
  }
}
