import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:review_db/data/auth/repository.dart';
import 'package:review_db/data/auth/models.dart';
import 'package:review_db/data/comments/models.dart';
import 'package:review_db/data/comments/repository.dart';
import 'package:review_db/data/reviews/models.dart';
import 'package:review_db/data/reviews/repository.dart';
import 'package:review_db/data/titles/repository.dart';
import 'package:review_db/data/users/models.dart';
import 'package:review_db/data/users/repository.dart';
import 'api_test.mocks.dart';
import 'package:review_db/data/titles/models.dart' as titles_data;

@GenerateMocks([http.Client, FlutterSecureStorage])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

group('AuthTests', () {
  late MockClient client;
  late MockFlutterSecureStorage storage;
  late AuthRepository repository;

  setUp(() {
    client = MockClient();
    storage = MockFlutterSecureStorage();
    repository = AuthRepository(client: client);
  });

  test('UserSignUp', () async {
    final user = SignUpUser('test@example.com', 'test_user', 'password123', 'password123');
    final responseJson = json.encode({
      'id': 1,
      'email': 'test@example.com',
      'username': 'test_user',
      'photo': null
    });
    
    when(client.post(
      Uri.parse('http://127.0.0.1/api/v1/users/'),
      headers: anyNamed('headers'),
      body: anyNamed('body'),
    )).thenAnswer((_) async => http.Response(responseJson, 201));

    final result = await repository.signUp(user);

    expect(result.id, equals(1));
    expect(result.email, equals('test@example.com'));
    expect(result.username, 'test_user');
    expect(result.photo, null);
  });

  test('UserSignIn', () async {
    final user = SignInUser('test_user', 'password123');
    final responseJson = json.encode({'auth_token': 'dummy_token'});
    
    when(client.post(
      Uri.parse('http://127.0.0.1/api/v1/auth/token/login/'),
      headers: anyNamed('headers'),
      body: anyNamed('body'),
    )).thenAnswer((_) async => http.Response(responseJson, 200));

    final result = await repository.signIn(user, storage);

    expect(result.token, equals('dummy_token'));
  });
});

  group('UsersTests', () {
    late MockClient client;
    late UsersRepository repository;

    setUp(() {
      client = MockClient();
      repository = UsersRepository(client: client);
    });

    test('GetCurrentUser', () async {
      const token = 'dummy_token';
      final responseJson = json.encode({
        'id': 1,
        'email': 'test@example.com',
        'username': 'test_user',
        'photo': null
      });
      
      when(client.get(
        Uri.parse('http://127.0.0.1/api/v1/users/me/'),
        headers:{'Authorization': 'Token $token'},
      )).thenAnswer((_) async => http.Response(responseJson, 200));

      final result = await repository.getCurrentUser(token);

      expect(result.id, equals(1));
      expect(result.email, equals('test@example.com'));
      expect(result.username, 'test_user');
      expect(result.photo, null);
    });

    test('SetUsername', () async {
      when(client.post(
        Uri.parse('http://127.0.0.1/api/v1/users/set_username/'),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response('', 204));

      final result = await repository.setUsername('dummy_token', 'new_username');

      expect(result, equals(null));
    });

    test('SetEmail', () async {
      when(client.post(
        Uri.parse('http://127.0.0.1/api/v1/users/set_email/'),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response('', 204));

      final result = await repository.setEmail('dummy_token', 'new_email');

      expect(result, equals(null));
    });

    test('SetPassword', () async {
      when(client.post(
        Uri.parse('http://127.0.0.1/api/v1/users/set_password/'),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response('', 204));

      final result = await repository.setPassword(
        'dummy_token',
        SetUserPassword('currentPassword', 'newPassword', 'newPassword'));

      expect(result, equals(null));
    });
  });

  group('TitlesTests', () {
    late MockClient client;
    late TitlesRepository repository;

    setUp(() {
      client = MockClient();
      repository = TitlesRepository(client: client);
    });

    test('GetCategories', () async {
      final responseJson = json.encode([
        {'name': 'Book', 'slug': 'book'},
        {'name': 'Music', 'slug': 'music'},
        {'name': 'Movie', 'slug': 'movie'}
      ]);
      
      when(client.get(
        Uri.parse('http://127.0.0.1/api/v1/categories/'),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response(responseJson, 200));

      final result = await repository.getCategories();

      expect(result.runtimeType, equals(List<titles_data.Category>));
      expect(result[0].name, equals('Book'));
      expect(result[0].slug, equals('book'));
    });

    test('GetGenres', () async {
      final responseJson = json.encode([
        {'name': 'Rock-n-roll', 'slug': 'rock-n-roll'},
        {'name': 'Ballad', 'slug': 'ballad'}
      ]);
      
      when(client.get(
        Uri.parse('http://127.0.0.1/api/v1/genres/'),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response(responseJson, 200));

      final result = await repository.getGenres();

      expect(result.runtimeType, equals(List<titles_data.Genre>));
      expect(result[0].name, equals('Rock-n-roll'));
      expect(result[0].slug, equals('rock-n-roll'));
    });

    test('GetTtiles', () async {
      final responseJson = json.encode([
        {
          'id': 1,
          'genre': [
            {
              'name': 'Roman',
              'slug': 'roman'
            }
          ],
          'category': {
            'name': 'Book',
            'slug': 'book'
          },
          'rating': 7,
          'name': 'War and Peace',
          'year': 1865,
          'description': '',
          'photo': null
        },
        {
          'id': 2,
          'genre': [
            {
              'name': 'Detective',
              'slug': 'detective'
            },
            {
              'name': 'Comedy',
              'slug': 'comedy'
            },
            {
              'name': 'Tale',
              'slug': 'tale'
            }
          ],
          'category': {
            'name': 'Movie',
            'slug': 'movie'
          },
          'rating': 4,
          'name': 'Operation IE',
          'year': 1965,
          'description': '',
          'photo': null
        }
      ]);
      
      when(client.get(
        Uri.http('127.0.0.1', '/api/v1/titles/', {}),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response(responseJson, 200));

      final result = await repository.getTitles();

      expect(result.runtimeType, equals(List<titles_data.Title>));
      expect(result.length, 2);
    });

    test('GetTtileById', () async {
      final responseJson = json.encode({
        'id': 1,
        'genre': [
          {
            'name': 'Roman',
            'slug': 'roman'
          }
        ],
        'category': {
          'name': 'Book',
          'slug': 'book'
        },
        'rating': 7,
        'name': 'War and Peace',
        'year': 1865,
        'description': '',
        'photo': null
      });
      const int titleId = 1;
      
      when(client.get(
        Uri.parse('http://127.0.0.1/api/v1/titles/$titleId/'),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response(responseJson, 200));

      final result = await repository.getTitleById(titleId);

      expect(result.id, equals(titleId));
    });
  });

  group('ReviewsTests', () {
    late MockClient client;
    late ReviewsRepository repository;

    setUp(() {
      client = MockClient();
      repository = ReviewsRepository(client: client);
    });

    test('GetTitleReviews', () async {
      final responseJson = json.encode([
        {
          "id": 1,
          "author": "djsfnsjnf",
          "title": 1,
          "score": 10,
          "pub_date": "28.04.2024 09:07",
          "text": "rrrrrrr1111111"
        },
        {
          "id": 2,
          "author": "lhlh",
          "title": 1,
          "score": 5,
          "pub_date": "26.04.2024 07:39",
          "text": "dsfdsf"
        }
      ]);
      const int titleId = 1;
      
      when(client.get(
        Uri.parse('http://127.0.0.1/api/v1/titles/$titleId/reviews/'),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response(responseJson, 200));

      final result = await repository.getTitleReviews(titleId);

      expect(result.runtimeType, equals(List<Review>));
      expect(result.every((item) => item.title == titleId), true);
    });

    test('GetReviewById', () async {
      final responseJson = json.encode({
        "id": 2,
        "author": "lhlh",
        "title": 1,
        "score": 5,
        "pub_date": "26.04.2024 07:39",
        "text": "dsfdsf"
      });
      const int titleId = 1;
      const int reviewId = 2;
      
      when(client.get(
        Uri.parse('http://127.0.0.1/api/v1/titles/$titleId/reviews/$reviewId/'),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response(responseJson, 200));

      final result = await repository.getReviewById(titleId, reviewId);

      expect(result!.id, equals(reviewId));
      expect(result.title, equals(titleId));
    });

    test('CreateReview', () async {
      const int titleId = 1;
      final review = CreateReview('rrrrrrr1111111', 5);
      final responseJson = json.encode({
        'id': 1,
        'author': 'test_user',
        'title': titleId,
        'score': 5,
        'pub_date': '02.05.2024 17:18',
        'text': 'rrrrrrr1111111'
      });
      
      when(client.post(
        Uri.parse('http://127.0.0.1/api/v1/titles/$titleId/reviews/'),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response(responseJson, 201));

      final result = await repository.createReview('dummy_token', titleId, review);

      expect(result.id, equals(1));
      expect(result.title, equals(titleId));
      expect(result.author, equals('test_user'));
      expect(result.score, equals(5));
      expect(result.pubDate, equals('02.05.2024 17:18'));
      expect(result.text, equals('rrrrrrr1111111'));
    });

    test('EditReview', () async {
      const int titleId = 1;
      const int reviewId = 2;
      final review = CreateReview('rrrrrrr1111111', 5);
      final responseJson = json.encode({
        'id': 1,
        'author': 'test_user',
        'title': titleId,
        'score': 5,
        'pub_date': '02.05.2024 17:18',
        'text': 'rrrrrrr1111111'
      });
      
      when(client.patch(
        Uri.parse('http://127.0.0.1/api/v1/titles/$titleId/reviews/$reviewId/'),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response(responseJson, 200));

      final result = await repository.editReview('dummy_token', titleId, reviewId, review);

      expect(result.id, equals(1));
      expect(result.title, equals(titleId));
      expect(result.author, equals('test_user'));
      expect(result.score, equals(5));
      expect(result.pubDate, equals('02.05.2024 17:18'));
      expect(result.text, equals('rrrrrrr1111111'));
    });

    test('DeleteReview', () async {
      const int titleId = 1;
      const int reviewId = 2;

      when(client.delete(
        Uri.parse('http://127.0.0.1/api/v1/titles/$titleId/reviews/$reviewId/'),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response('', 204));

      final result = await repository.deleteReview('dummy_token', titleId, reviewId);

      expect(result, equals(null));
    });
  });

  group('CommentsTests', () {
    late MockClient client;
    late CommentsRepository repository;

    setUp(() {
      client = MockClient();
      repository = CommentsRepository(client: client);
    });

    test('GetReviewComments', () async {
      const int titleId = 1;
      const int reviewId = 2;
      final responseJson = json.encode([
        {
          "id": 1,
          "text": "fff",
          "author": "djsfnsjnf",
          "pub_date": "28.04.2024 09:11"
        },
        {
          "id": 2,
          "text": "tyy",
          "author": "djsfnsjnf",
          "pub_date": "28.04.2024 09:12"
        }
      ]);
      
      when(client.get(
        Uri.parse('http://127.0.0.1/api/v1/titles/$titleId/reviews/$reviewId/comments/'),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response(responseJson, 200));

      final result = await repository.getReviewComments(titleId, reviewId);

      expect(result.runtimeType, equals(List<Comment>));
      expect(result.length, equals(2));
    });

    test('CreateComment', () async {
      const int titleId = 1;
      const int reviewId = 2;
      final comment = CreateComment('rrrrrrr');
      final responseJson = json.encode({
        "id": 1,
        "text": "rrrrrrr",
        "author": "test_user",
        "pub_date": "02.05.2024 17:38"
      });
      
      when(client.post(
        Uri.parse('http://127.0.0.1/api/v1/titles/$titleId/reviews/$reviewId/comments/'),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response(responseJson, 201));

      final result = await repository.createComment('dummy_token', titleId, reviewId, comment);

      expect(result.id, equals(1));
      expect(result.text, equals('rrrrrrr'));
      expect(result.author, equals('test_user'));
      expect(result.pubDate, equals('02.05.2024 17:38'));
    });

    test('EditComment', () async {
      const int titleId = 1;
      const int reviewId = 2;
      const int commentId = 1;
      final comment = CreateComment('rrrrrrr');
      final responseJson = json.encode({
        "id": 1,
        "text": "rrrrrrr",
        "author": "test_user",
        "pub_date": "02.05.2024 17:38"
      });
      
      when(client.patch(
        Uri.parse('http://127.0.0.1/api/v1/titles/$titleId/reviews/$reviewId/comments/$commentId/'),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response(responseJson, 200));

      final result = await repository.editComment('dummy_token', titleId, reviewId, commentId, comment);

      expect(result.id, equals(1));
      expect(result.text, equals('rrrrrrr'));
      expect(result.author, equals('test_user'));
      expect(result.pubDate, equals('02.05.2024 17:38'));
    });

    test('DeleteComment', () async {
      const int titleId = 1;
      const int reviewId = 2;
      const int commentId = 1;

      when(client.delete(
        Uri.parse('http://127.0.0.1/api/v1/titles/$titleId/reviews/$reviewId/comments/$commentId/'),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response('', 204));

      final result = await repository.deleteComment('dummy_token', titleId, reviewId, commentId);

      expect(result, equals(null));
    });
  });
}
