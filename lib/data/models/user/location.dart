class Location {
  final String type;
  final List<double> coordinates;

  Location({required this.type, required this.coordinates});

  factory Location.fromJson(Map<String, dynamic> json) {
    List<dynamic> rawCoordinates = json['coordinates'];
    List<double> parsedCoordinates = rawCoordinates.map((coord) => coord is int ? coord.toDouble() : coord as double).toList();

    return Location(
      type: json['type'],
      coordinates: parsedCoordinates,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'coordinates': coordinates,
    };
  }
}
