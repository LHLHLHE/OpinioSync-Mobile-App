import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:review_db/data/titles/models.dart' as titles_data;

@immutable
abstract class HomeState extends Equatable {}

class TitlesLoadingState extends HomeState {
  @override
  List<Object?> get props => [];
}

class TitlesLoadedState extends HomeState {
  final List<titles_data.Title> titles;
  final List<titles_data.Category> categories;
  final List<titles_data.Genre> genres;

  TitlesLoadedState(
    this.titles,
    this.categories,
    this.genres
  );

  @override
  List<Object?> get props => [titles, categories, genres];
}

class TitlesErrorState extends HomeState {
  final String error;

  TitlesErrorState(this.error);

  @override
  List<Object?> get props => [error];
}
