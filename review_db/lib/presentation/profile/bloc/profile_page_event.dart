import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:review_db/data/users/models.dart';

@immutable
abstract class ProfileEvent extends Equatable {
  const ProfileEvent();
}

class LoadProfileEvent extends ProfileEvent {
  @override
  List<Object> get props => [];
}

class SetUsernameEvent extends ProfileEvent {
  final String username;

  const SetUsernameEvent(this.username); 

  @override
  List<Object> get props => [];
}

class SetEmailEvent extends ProfileEvent {
  final String email;

  const SetEmailEvent(this.email); 

  @override
  List<Object> get props => [];
}

class SetPasswordEvent extends ProfileEvent {
  final SetUserPassword passwordData;

  const SetPasswordEvent(this.passwordData); 

  @override
  List<Object> get props => [];
}
