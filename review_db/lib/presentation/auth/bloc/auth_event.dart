import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:review_db/data/auth/models.dart';

@immutable
abstract class AuthEvent extends Equatable {}

class CheckLoggedInEvent extends AuthEvent {
  @override
  List<Object> get props => [];
}

class LogInEvent extends AuthEvent {
  final SignInUser signInData;

  LogInEvent(this.signInData);

  @override
  List<Object> get props => [];
}

class RegisterEvent extends AuthEvent {
  final SignUpUser signUpData;

  RegisterEvent(this.signUpData);

  @override
  List<Object> get props => [];
}

class RegisteredEvent extends AuthEvent {
  final SignInUser signInData;

  RegisteredEvent(this.signInData);

  @override
  List<Object> get props => [];
}

class LoggedInEvent extends AuthEvent {
  @override
  List<Object> get props => [];
}

class LogOutEvent extends AuthEvent {
  @override
  List<Object> get props => [];
}