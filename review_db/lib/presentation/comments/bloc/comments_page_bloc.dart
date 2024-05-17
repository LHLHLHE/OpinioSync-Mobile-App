import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:review_db/data/comments/repository.dart';
import 'package:review_db/data/reviews/models.dart';
import 'package:review_db/presentation/comments/bloc/comments_page_event.dart';
import 'package:review_db/presentation/comments/bloc/comments_page_state.dart';

class CommentsBloc extends Bloc<CommentsEvent, CommentsState> {
  final CommentsRepository _commentsRepository;
  int _titleId = 0;
  Review? _review = null;
  String _token = '';
  int _commentId = 0;
  String _commentText = '';

  void setTitleId(int titleId) {
    _titleId = titleId;
  }

  void setReview(Review review) {
    _review = review;
  }

  void setToken(String token) {
    _token = token;
  }

  void setCommentId(int commentId) {
    _commentId = commentId;
  }

  void setCommentText(String commentText) {
    _commentText = commentText;
  }

  String getCommentText() {
    return _commentText;
  }

  CommentsBloc(this._commentsRepository) : super(CommentsLoadingState()) {
    on<LoadCommentsEvent>((event, emit) async {
      emit(CommentsLoadingState());
      try {
        final comments = await _commentsRepository.getReviewComments(_titleId, _review!.id);
        emit(CommentsLoadedState(_review!, comments));
      } catch (e) {
        emit(CommentsErrorState(e.toString()));
      }
    });

    on<PostCommentEvent>((event, emit) async {
      try {
        final comment = await _commentsRepository.createComment(_token, _titleId, _review!.id, event.commentData);
        emit(CommentCreatedState(comment));
      } catch (e) {
        emit(CommentsErrorState(e.toString()));
      }
    });
    
    on<DeleteCommentEvent>((event, emit) async {
      try {
        await _commentsRepository.deleteComment(_token, _titleId, _review!.id, _commentId);
        emit(CommentDeletedState());
      } catch (e) {
        emit(CommentsErrorState(e.toString()));
      }
    });

    on<EditingCommentEvent>((event, emit) async {
      emit(EditingCommentState());
    });

    on<EditCommentEvent>((event, emit) async {
      try {
        final comment = await _commentsRepository.editComment(_token, _titleId, _review!.id, _commentId, event.commentData);
        emit(CommentEditedState(comment));
      } catch (e) {
        emit(CommentsErrorState(e.toString()));
      }
    });
  }
}
