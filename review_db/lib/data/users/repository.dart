import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:review_db/data/users/models.dart';

class UsersRepository {
  final http.Client client;

  UsersRepository({http.Client? client}) : this.client = client ?? http.Client();

  Future<User> getCurrentUser(String token) async {
    final response = await client.get(
      Uri.parse('http://127.0.0.1/api/v1/users/me/'),
      headers: {'Authorization': 'Token $token'}
    );
    if (response.statusCode != 200) {
      throw Exception(jsonDecode(utf8.decode(response.bodyBytes)));
    }

    Map<String, dynamic> user = jsonDecode(utf8.decode(response.bodyBytes));
    return User.fromJson(user);
  }

  Future setUsername(String token, String username) async {
    final response = await client.post(
      Uri.parse('http://127.0.0.1/api/v1/users/set_username/'),
      headers: {
        'Authorization': 'Token $token',
        'content-type': 'application/json'
      },
      body: jsonEncode({"new_username": username})
    );
    if (response.statusCode != 204) {
      throw Exception(jsonDecode(utf8.decode(response.bodyBytes)));
    }
  }

  Future setEmail(String token, String email) async {
    final response = await client.post(
      Uri.parse('http://127.0.0.1/api/v1/users/set_email/'),
      headers: {
        'Authorization': 'Token $token',
        'content-type': 'application/json'
      },
      body: jsonEncode({"new_email": email})
    );
    if (response.statusCode != 204) {
      throw Exception(jsonDecode(utf8.decode(response.bodyBytes)));
    }
  }

  Future setPassword(String token, SetUserPassword passwordData) async {
    final response = await client.post(
      Uri.parse('http://127.0.0.1/api/v1/users/set_password/'),
      headers: {
        'Authorization': 'Token $token',
        'content-type': 'application/json'
      },
      body: jsonEncode(passwordData.toJson())
    );
    if (response.statusCode != 204) {
      throw Exception(jsonDecode(utf8.decode(response.bodyBytes)));
    }
  }
}