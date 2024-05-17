import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:review_db/data/reviews/repository.dart';
import 'package:review_db/presentation/reviews/bloc/review_page_event.dart';
import 'package:review_db/presentation/reviews/bloc/review_page_state.dart';
import 'package:review_db/data/titles/models.dart' as titles_data;


class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  final ReviewsRepository _reviewsRepository;
  
  titles_data.Title? title = null;
  int _reviewId = 0;
  String _token = '';

  void setTitle(titles_data.Title _title) {
    title = _title;
  }

  void setReviewId(int reviewId) {
    _reviewId = reviewId;
  }

  void setToken(String token) {
    _token = token;
  }

  ReviewBloc(this._reviewsRepository) : super(LoadingReviewState()) {
    on<PostReviewEvent>((event, emit) async {
      try {
        final review = await _reviewsRepository.createReview(_token, title!.id, event.reviewData);
        emit(ReviewCreatedState(review));
      } catch (e) {
        emit(ReviewErrorState(e.toString()));
      }
    });

    on<DeleteReviewEvent>((event, emit) async {
      try {
        await _reviewsRepository.deleteReview(_token, title!.id, _reviewId);
        emit(ReviewDeletedState());
      } catch (e) {
        emit(ReviewErrorState(e.toString()));
      }
    });

    on<LoadReviewEvent>((event, emit) async {
      emit(LoadingReviewState());
      try {
        final review = await _reviewsRepository.getReviewById(title!.id, _reviewId);
        emit(ReviewLoadedState(review));
      } catch (e) {
        emit(ReviewErrorState(e.toString()));
      }
    });

    on<EditReviewEvent>((event, emit) async {
      try {
        final review = await _reviewsRepository.editReview(_token, title!.id, _reviewId, event.reviewData);
        emit(ReviewEditedState(review));
      } catch (e) {
        emit(ReviewErrorState(e.toString()));
      }
    });
  }
}
