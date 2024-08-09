import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tinder/data/models/match.dart';
import 'package:tinder/data/models/user/user.dart';
import 'package:tinder/shared/constants.dart';

class MatchRepository {
  Future<List<Match>> getMatches() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/api/matches'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> matchesData = data as List;
      final List<Match> matches = matchesData.map((match) => Match.fromJson(match)).toList();
      return matches;
    } else if (response.statusCode == 401) {
      await prefs.remove('token');
      throw Exception('TokenExpired');
    } else {
      throw Exception('Failed to load matches');
    }
  }

  Future<void> matchAction(String user2Id, bool action) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/api/matches/action'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'user2Id': user2Id,
        'action': action,
      }),
    );
    if (response.statusCode != 200) {
      if (response.statusCode == 401) {
        await prefs.remove('token');
        throw Exception('TokenExpired');
      } else {
        throw Exception('Failed to perform action');
      }
    }
  }

  Future<List<User>> getListUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/api/matches/recommend'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<User> users = (data['users'] as List).map((userJson) => User.fromJson(userJson)).toList();
      return users;
    } else if (response.statusCode == 401) {
      await prefs.remove('token');
      throw Exception('TokenExpired');
    } else {
      throw Exception('Failed to load random users');
    }
  }
}
