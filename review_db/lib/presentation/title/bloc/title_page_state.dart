import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:review_db/data/reviews/models.dart';
import 'package:review_db/data/titles/models.dart' as titles_data;

@immutable
abstract class DetailTitleState extends Equatable {}

class TitleLoadingState extends DetailTitleState {
  @override
  List<Object?> get props => [];
}

class TitleLoadedState extends DetailTitleState {
  final titles_data.Title title;
  final List<Review> reviews;

  TitleLoadedState(this.title, this.reviews);

  @override
  List<Object?> get props => [title, reviews];
}

class TitleErrorState extends DetailTitleState {
  final String error;

  TitleErrorState(this.error);

  @override
  List<Object?> get props => [error];
}
