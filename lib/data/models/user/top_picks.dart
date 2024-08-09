class TopPicks {
  final bool enabled;
  final DateTime lastUpdated;

  TopPicks({
    required this.enabled,
    required this.lastUpdated,
  });

  factory TopPicks.fromJson(Map<String, dynamic> json) {
    return TopPicks(
      enabled: json['enabled'],
      lastUpdated: DateTime.parse(json['lastUpdated']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'enabled': enabled,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }
}
