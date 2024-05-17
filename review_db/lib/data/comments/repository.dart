import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:review_db/data/comments/models.dart';

class CommentsRepository {
  final http.Client client;

  CommentsRepository({http.Client? client}) : this.client = client ?? http.Client();

  Future<List<Comment>> getReviewComments(int titleId, int reviewId) async {
    final response = await client.get(Uri.parse(
      'http://127.0.0.1/api/v1/titles/${titleId}/reviews/${reviewId}/comments/'
    ));
    if (response.statusCode != 200) {
      throw Exception(jsonDecode(utf8.decode(response.bodyBytes)));
    }

    List comments = jsonDecode(utf8.decode(response.bodyBytes));
    return comments.map((data)=>Comment.fromJson(data)).toList();
  }

  Future<Comment> createComment(String token, int titleId, int reviewId, CreateComment commentData) async {
    final response = await client.post(
      Uri.parse('http://127.0.0.1/api/v1/titles/${titleId}/reviews/${reviewId}/comments/'),
      headers: {
        'Authorization': 'Token $token',
        'content-type': 'application/json'
        },
      body: jsonEncode(commentData.toJson())
    );
    if (response.statusCode != 201) {
      throw Exception(jsonDecode(utf8.decode(response.bodyBytes)));
    }

    Map<String, dynamic> comment = jsonDecode(utf8.decode(response.bodyBytes));
    return Comment.fromJson(comment);
  }

  Future deleteComment(String token, int titleId, int reviewId, int commentId) async {
    final response = await client.delete(
      Uri.parse('http://127.0.0.1/api/v1/titles/${titleId}/reviews/${reviewId}/comments/${commentId}/'),
      headers: {
        'Authorization': 'Token $token',
      }
    );
    if (response.statusCode != 204) {
      throw Exception(jsonDecode(utf8.decode(response.bodyBytes)));
    }
  }

  Future<Comment> editComment(String token, int titleId, int reviewId, int commentId, CreateComment commentData) async {
    final response = await client.patch(
      Uri.parse('http://127.0.0.1/api/v1/titles/${titleId}/reviews/${reviewId}/comments/${commentId}/'),
      headers: {
        'Authorization': 'Token $token',
        'content-type': 'application/json'
        },
      body: jsonEncode(commentData.toJson())
    );
    if (response.statusCode != 200) {
      throw Exception(jsonDecode(utf8.decode(response.bodyBytes)));
    }

    Map<String, dynamic> review = jsonDecode(utf8.decode(response.bodyBytes));
    return Comment.fromJson(review);
  }
}