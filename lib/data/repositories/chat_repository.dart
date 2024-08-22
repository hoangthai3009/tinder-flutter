import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tinder/data/models/chat.dart';
import 'package:tinder/utils/constants.dart';

class ChatRepository {
  Future<List<Message>> fetchMessages(String matchId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('No token found');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/api/messages/$matchId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Message.fromJson(json)).toList();
    } else if (response.statusCode == 401) {
      await prefs.remove('token');
      throw Exception('TokenExpired');
    } else {
      throw Exception('Failed to load messages');
    }
  }

  Future<Message> fetchLastMessage(String matchId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('No token found');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/api/messages/last/$matchId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return Message.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 401) {
      await prefs.remove('token');
      throw Exception('TokenExpired');
    } else {
      throw Exception('Failed to load messages');
    }
  }

  Future<void> sendMessage(String matchId, String text) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('No token found');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/api/messages'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'matchId': matchId,
        'text': text,
      }),
    );

    if (response.statusCode != 200) {
      if (response.statusCode == 401) {
        await prefs.remove('token');
        throw Exception('TokenExpired');
      } else {
        throw Exception('Failed to send message');
      }
    }
  }
}
