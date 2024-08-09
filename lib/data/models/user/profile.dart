import 'package:tinder/data/models/user/location.dart';

class UserProfile {
  final String bio;
  final int age;
  final String gender;
  final List<String> interests;
  final String avatar;
  final List<String> picture;
  final Location location;

  UserProfile({
    required this.bio,
    required this.age,
    required this.gender,
    required this.interests,
    required this.avatar,
    required this.picture,
    required this.location,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      bio: json['bio'],
      age: json['age'],
      gender: json['gender'],
      interests: List<String>.from(json['interests']),
      avatar: json['avatar'],
      picture: List<String>.from(json['picture']),
      location: Location.fromJson(json['location']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bio': bio,
      'age': age,
      'gender': gender,
      'interests': interests,
      'avatar': avatar,
      'picture': picture,
      'location': location.toJson(),
    };
  }
}
