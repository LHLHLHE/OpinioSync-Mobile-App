import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';


@immutable
abstract class AuthState extends Equatable {}

class RegisterState extends AuthState {
  @override
  List<Object?> get props => [];
}

class RegisteredState extends AuthState {
  @override
  List<Object?> get props => [];
}

class LogInState extends AuthState {
  @override
  List<Object?> get props => [];
}

class LoggedInState extends AuthState {
  final String token;

  LoggedInState(this.token);

  @override
  List<Object?> get props => [token];
}

class LogOutState extends AuthState {
  @override
  List<Object?> get props => [];
}

class LoggedOutState extends AuthState {
  @override
  List<Object?> get props => [];
}

class AuthErrorState extends AuthState {
  final String error;

  AuthErrorState(this.error);

  @override
  List<Object?> get props => [error];
}
