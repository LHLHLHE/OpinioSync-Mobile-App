import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:review_db/data/auth/models.dart';
import 'package:review_db/data/users/models.dart';

class AuthRepository {
  final http.Client client;

  AuthRepository({http.Client? client}) : this.client = client ?? http.Client();

  Future<User> signUp(SignUpUser userData) async {
    final response = await client.post(
      Uri.parse('http://127.0.0.1/api/v1/users/'),
      headers: {'content-type': 'application/json'},
      body: jsonEncode(userData.toJson())
    );
    if (response.statusCode != 201) {
      throw Exception(jsonDecode(utf8.decode(response.bodyBytes)));
    }

    Map<String, dynamic> user = jsonDecode(utf8.decode(response.bodyBytes));
    return User.fromJson(user);
  }

  Future<Token> signIn(SignInUser userData, FlutterSecureStorage storage) async {
    final response = await client.post(
      Uri.parse('http://127.0.0.1/api/v1/auth/token/login/'),
      headers: {'content-type': 'application/json'},
      body: jsonEncode(userData.toJson())
    );
    if (response.statusCode != 200) {
      throw Exception(jsonDecode(utf8.decode(response.bodyBytes)));
    }

    Map<String, dynamic> token = jsonDecode(utf8.decode(response.bodyBytes));
    await storage.write(key: 'token', value: token['auth_token']);

    return Token.fromJson(token);
  }

  Future<String?> getCachedToken(FlutterSecureStorage storage) async {
    final token = await storage.read(key: 'token');
    if (token == null) return null;
    return token;
  }

  Future<void> removeCachedToken(FlutterSecureStorage storage) async {
    await storage.delete(key: 'token');
  }
}