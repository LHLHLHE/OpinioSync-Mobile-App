import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:review_db/data/titles/models.dart';

class TitlesRepository {
  final http.Client client;

  TitlesRepository({http.Client? client}) : this.client = client ?? http.Client();

  Future<List<Category>> getCategories() async {
    final response = await client.get(Uri.parse('http://127.0.0.1/api/v1/categories/'));
    if (response.statusCode != 200) {
      throw Exception(jsonDecode(utf8.decode(response.bodyBytes)));
    }

    List categories = jsonDecode(utf8.decode(response.bodyBytes));
    return categories.map((data)=>Category.fromJson(data)).toList();
  }

  Future<List<Genre>> getGenres() async {
    final response = await client.get(Uri.parse('http://127.0.0.1/api/v1/genres/'));
    if (response.statusCode != 200) {
      throw Exception(jsonDecode(utf8.decode(response.bodyBytes)));
    }

    List genres = jsonDecode(utf8.decode(response.bodyBytes));
    return genres.map((data)=>Genre.fromJson(data)).toList();
  }

  Future<List<Title>> getTitles({
    String? category = null,
    String? genre = null,
    String? name = null
  }) async {
    Map<String, String?> params = {};
    if (category != null) {
      params['category'] = category;
    }
    if (genre != null) {
      params['genre'] = genre;
    }
    if (name != null) {
      params['name'] = name;
    }

    final response = await client.get(Uri.http('127.0.0.1', '/api/v1/titles/', params));
    if (response.statusCode != 200) {
      throw Exception(jsonDecode(utf8.decode(response.bodyBytes)));
    }
    List titles = jsonDecode(utf8.decode(response.bodyBytes));
    return titles.map((data)=>Title.fromJson(data)).toList();
  }

  Future<Title> getTitleById(int titleId) async {
    final response = await client.get(Uri.parse(
      'http://127.0.0.1/api/v1/titles/${titleId}/'
    ));
    if (response.statusCode != 200) {
      throw Exception(jsonDecode(utf8.decode(response.bodyBytes)));
    }

    Map<String, dynamic> title = jsonDecode(utf8.decode(response.bodyBytes));
    return Title.fromJson(title);
  }
}