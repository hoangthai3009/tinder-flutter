import 'profile.dart';
import 'super_likes.dart';
import 'boosts.dart';
import 'top_picks.dart';

class User {
  final String id;
  final String name;
  final String email;
  final String? subscription;
  final bool verified;
  final bool newUser;
  final DateTime createdAt;
  final DateTime updatedAt;
  final UserProfile profile;
  final SuperLikes superLikes;
  final Boosts boosts;
  final TopPicks topPicks;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.subscription,
    required this.verified,
    required this.newUser,
    required this.createdAt,
    required this.updatedAt,
    required this.profile,
    required this.superLikes,
    required this.boosts,
    required this.topPicks,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      subscription: json['subscription'],
      verified: json['verified'],
      newUser: json['newUser'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      profile: UserProfile.fromJson(json['profile']),
      superLikes: SuperLikes.fromJson(json['superLikes']),
      boosts: Boosts.fromJson(json['boosts']),
      topPicks: TopPicks.fromJson(json['topPicks']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'subscription': subscription,
      'verified': verified,
      'newUser': newUser,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'profile': profile.toJson(),
      'superLikes': superLikes.toJson(),
      'boosts': boosts.toJson(),
      'topPicks': topPicks.toJson(),
    };
  }
}
