import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:review_db/data/comments/models.dart';
import 'package:review_db/data/reviews/models.dart';

@immutable
abstract class CommentsState extends Equatable {}

class CommentsLoadingState extends CommentsState {
  @override
  List<Object?> get props => [];
}

class CommentsLoadedState extends CommentsState {
  final Review review;
  final List<Comment> comments;

  CommentsLoadedState(this.review, this.comments);

  @override
  List<Object?> get props => [review, comments];
}

class EditingCommentState extends CommentsState {
  @override
  List<Object?> get props => [];
}

class CurrentCommentLoadingState extends CommentsState {
  @override
  List<Object?> get props => [];
}

class CurrentCommentLoadedState extends CommentsState {
  final Comment comment;

  CurrentCommentLoadedState(this.comment);

  @override
  List<Object?> get props => [comment];
}

class CommentCreatedState extends CommentsState {
  final Comment comment;

  CommentCreatedState(this.comment);

  @override
  List<Object?> get props => [comment];
}

class CommentDeletedState extends CommentsState {
  @override
  List<Object?> get props => [];
}

class CommentEditedState extends CommentsState {
  final Comment comment;

  CommentEditedState(this.comment);

  @override
  List<Object?> get props => [comment];
}

class CommentsErrorState extends CommentsState {
  final String error;

  CommentsErrorState(this.error);

  @override
  List<Object?> get props => [error];
}
