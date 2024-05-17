import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:review_db/data/reviews/models.dart';

@immutable
abstract class ReviewState extends Equatable {}

class LoadingReviewState extends ReviewState {
  @override
  List<Object?> get props => [];
}

class ReviewLoadedState extends ReviewState {
  final Review? review;

  ReviewLoadedState(this.review);

  @override
  List<Object?> get props => [review];
}

class ReviewCreatedState extends ReviewState {
  final Review review;

  ReviewCreatedState(this.review);

  @override
  List<Object?> get props => [review];
}

class ReviewDeletedState extends ReviewState {
  @override
  List<Object?> get props => [];
}

class ReviewEditedState extends ReviewState {
  final Review review;

  ReviewEditedState(this.review);

  @override
  List<Object?> get props => [review];
}

class ReviewErrorState extends ReviewState {
  final String error;

  ReviewErrorState(this.error);

  @override
  List<Object?> get props => [error];
}
