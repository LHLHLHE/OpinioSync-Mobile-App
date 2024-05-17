import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:review_db/data/reviews/models.dart';

class ReviewsRepository {
  final http.Client client;

  ReviewsRepository({http.Client? client}) : this.client = client ?? http.Client();

  Future<List<Review>> getTitleReviews(int titleId) async {
    final response = await client.get(Uri.parse(
      'http://127.0.0.1/api/v1/titles/${titleId}/reviews/'
    ));
    if (response.statusCode != 200) {
      throw Exception(jsonDecode(utf8.decode(response.bodyBytes)));
    }

    List reviews = jsonDecode(utf8.decode(response.bodyBytes));
    return reviews.map((data)=>Review.fromJson(data)).toList();
  }

  Future<Review?> getReviewById(int titleId, int reviewId) async {
    final response = await client.get(Uri.parse(
      'http://127.0.0.1/api/v1/titles/${titleId}/reviews/${reviewId}/'
    ));
    if (response.statusCode == 404) {
      return null;
    } 
    if (response.statusCode != 200) {
      throw Exception(jsonDecode(utf8.decode(response.bodyBytes)));
    }

    Map<String, dynamic> review = jsonDecode(utf8.decode(response.bodyBytes));
    return Review.fromJson(review);
  }

  Future<Review> createReview(String token, int titleId, CreateReview reviewData) async {
    final response = await client.post(
      Uri.parse('http://127.0.0.1/api/v1/titles/${titleId}/reviews/'),
      headers: {
        'Authorization': 'Token $token',
        'content-type': 'application/json'
        },
      body: jsonEncode(reviewData.toJson())
    );
    if (response.statusCode != 201) {
      throw Exception(jsonDecode(utf8.decode(response.bodyBytes)));
    }

    Map<String, dynamic> review = jsonDecode(utf8.decode(response.bodyBytes));
    return Review.fromJson(review);
  }

  Future deleteReview(String token, int titleId, int reviewId) async {
    final response = await client.delete(
      Uri.parse('http://127.0.0.1/api/v1/titles/${titleId}/reviews/${reviewId}/'),
      headers: {
        'Authorization': 'Token $token',
        },
    );
    if (response.statusCode != 204) {
      throw Exception(jsonDecode(utf8.decode(response.bodyBytes)));
    }
  }

  Future<Review> editReview(String token, int titleId, int reviewId, CreateReview reviewData) async {
    final response = await client.patch(
      Uri.parse('http://127.0.0.1/api/v1/titles/${titleId}/reviews/${reviewId}/'),
      headers: {
        'Authorization': 'Token $token',
        'content-type': 'application/json'
        },
      body: jsonEncode(reviewData.toJson())
    );
    if (response.statusCode != 200) {
      throw Exception(jsonDecode(utf8.decode(response.bodyBytes)));
    }

    Map<String, dynamic> review = jsonDecode(utf8.decode(response.bodyBytes));
    return Review.fromJson(review);
  }
}