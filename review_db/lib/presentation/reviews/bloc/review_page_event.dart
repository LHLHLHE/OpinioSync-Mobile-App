import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:review_db/data/reviews/models.dart';

@immutable
abstract class ReviewEvent extends Equatable {}

class PostReviewEvent extends ReviewEvent {
  final CreateReview reviewData;

  PostReviewEvent(this.reviewData);

  @override
  List<Object> get props => [];
}

class DeleteReviewEvent extends ReviewEvent {
  @override
  List<Object> get props => [];
}

class LoadReviewEvent extends ReviewEvent {
  @override
  List<Object> get props => [];
}

class EditReviewEvent extends ReviewEvent {
  final CreateReview reviewData;

  EditReviewEvent(this.reviewData);

  @override
  List<Object> get props => [];
}
