class Boosts {
  final int remaining;
  final DateTime resetDate;

  Boosts({
    required this.remaining,
    required this.resetDate,
  });

  factory Boosts.fromJson(Map<String, dynamic> json) {
    return Boosts(
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
