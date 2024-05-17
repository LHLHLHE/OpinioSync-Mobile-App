import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:review_db/data/comments/models.dart';

@immutable
abstract class CommentsEvent extends Equatable {}

class LoadCommentsEvent extends CommentsEvent {
  @override
  List<Object> get props => [];
}

class PostCommentEvent extends CommentsEvent {
  final CreateComment commentData;

  PostCommentEvent(this.commentData);

  @override
  List<Object> get props => [];
}

class DeleteCommentEvent extends CommentsEvent {
  @override
  List<Object> get props => [];
}

class EditingCommentEvent extends CommentsEvent {
  @override
  List<Object> get props => [];
}

class LoadCurrentCommentEvent extends CommentsEvent {
  @override
  List<Object> get props => [];
}

class EditCommentEvent extends CommentsEvent {
  final CreateComment commentData;

  EditCommentEvent(this.commentData);

  @override
  List<Object> get props => [];
}