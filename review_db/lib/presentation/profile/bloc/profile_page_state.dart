import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:review_db/data/users/models.dart';

@immutable
abstract class ProfileState extends Equatable {}

class ProfileLoadingState extends ProfileState {
  @override
  List<Object?> get props => [];
}

class ProfileLoadedState extends ProfileState {
  final User user;

  ProfileLoadedState(this.user);

  @override
  List<Object?> get props => [user];
}

class ProfileEditingState extends ProfileState {
  @override
  List<Object?> get props => [];
}

class ProfileEditedState extends ProfileState {
  @override
  List<Object?> get props => [];
}

class ProfileEditingErrorState extends ProfileState {
  final String error;

  ProfileEditingErrorState(this.error);

  @override
  List<Object?> get props => [error];
}

class ProfileErrorState extends ProfileState {
  final String error;

  ProfileErrorState(this.error);

  @override
  List<Object?> get props => [error];
}
