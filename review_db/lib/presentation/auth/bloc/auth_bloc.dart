import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:review_db/data/auth/models.dart';
import 'package:review_db/data/auth/repository.dart';
import 'package:review_db/presentation/auth/bloc/auth_event.dart';
import 'package:review_db/presentation/auth/bloc/auth_state.dart';


class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  AuthBloc(this._authRepository) : super(LogInState()) {
    on<CheckLoggedInEvent>((event, emit) async {
      final token = await _authRepository.getCachedToken(_storage);
      if (token != null) {
        emit(LoggedInState(token));
      } else {
        emit(LoggedOutState());
      }
    });

    on<LogInEvent>((event, emit) async {
      emit(LogInState());
      try {
        final token = await _authRepository.signIn(event.signInData, _storage);
        emit(LoggedInState(token.token));
      } catch (e) {
        emit(AuthErrorState(e.toString()));
      }
    });

    on<RegisterEvent>((event, emit) async {
      emit(RegisterState());
      try {
        final user = await _authRepository.signUp(event.signUpData);
        emit(RegisteredState());
        add(RegisteredEvent(SignInUser(user.username, event.signUpData.password)));
      } catch (e) {
        emit(AuthErrorState(e.toString()));
      }
    });

    on<RegisteredEvent>((event, emit) async {
      try {
        final token = await _authRepository.signIn(event.signInData, _storage);
        emit(LoggedInState(token.token));
      } catch (e) {
        emit(AuthErrorState(e.toString()));
      }
    });

    on<LoggedInEvent>((event, emit) async {
      try {
        final token = await _authRepository.getCachedToken(_storage);
        emit(LoggedInState(token!));
      } catch (e) {
        emit(AuthErrorState(e.toString()));
      }
    });

    on<LogOutEvent>((event, emit) async {
      emit(LogOutState());
      try {
        await _authRepository.removeCachedToken(_storage);
        emit(LoggedOutState());
      } catch (e) {
        emit(AuthErrorState(e.toString()));
      }
    });
  }
}
