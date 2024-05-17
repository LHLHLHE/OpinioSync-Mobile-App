import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:review_db/data/users/repository.dart';
import 'package:review_db/presentation/profile/bloc/profile_page_event.dart';
import 'package:review_db/presentation/profile/bloc/profile_page_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UsersRepository _usersRepository;
  String _token = '';

  void setToken(String token) {
    _token = token;
  }

  ProfileBloc(this._usersRepository) : super(ProfileLoadingState()) {
    on<LoadProfileEvent>((event, emit) async {
      emit(ProfileLoadingState());
      try {
        final user = await _usersRepository.getCurrentUser(_token);
        emit(ProfileLoadedState(user));
      } catch (e) {
        emit(ProfileErrorState(e.toString()));
      }
    });

    on<SetUsernameEvent>((event, emit) async {
      emit(ProfileEditingState());
      try {
        await _usersRepository.setUsername(_token, event.username);
        add(LoadProfileEvent());
      } catch (e) {
        emit(ProfileEditingErrorState(e.toString()));
      }
    });

    on<SetEmailEvent>((event, emit) async {
      emit(ProfileEditingState());
      try {
        await _usersRepository.setEmail(_token, event.email);
        add(LoadProfileEvent());
      } catch (e) {
        emit(ProfileEditingErrorState(e.toString()));
      }
    });

    on<SetPasswordEvent>((event, emit) async {
      emit(ProfileEditingState());
      try {
        await _usersRepository.setPassword(_token, event.passwordData);
        emit(ProfileEditedState());
      } catch (e) {
        emit(ProfileEditingErrorState(e.toString()));
      }
    });
  }
}
