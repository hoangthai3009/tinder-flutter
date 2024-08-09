import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tinder/data/repositories/auth_repository.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc() : super(AuthenticationInitial()) {
    on<LoginEvent>((event, emit) async {
      emit(AuthenticationLoading());
      try {
        await AuthRepository().login(event.email, event.password);
        emit(AuthenticationSuccess());
      } catch (error) {
        emit(AuthenticationFailure(error: error.toString()));
      }
    });

    on<RegisterEvent>((event, emit) async {
      emit(AuthenticationLoading());
      try {
        await AuthRepository().register(event.name, event.email, event.password);
        emit(AuthenticationSuccess());
      } catch (error) {
        emit(AuthenticationFailure(error: error.toString()));
      }
    });

    on<LogoutEvent>((event, emit) async {
      emit(AuthenticationLoading());
      try {
        await AuthRepository().logout();
        emit(AuthenticationInitial());
      } catch (error) {
        emit(AuthenticationFailure(error: error.toString()));
      }
    });

    on<AppStarted>((event, emit) async {
      final token = await AuthRepository().getToken();
      if (token != null) {
        emit(AuthenticationSuccess());
      } else {
        emit(AuthenticationInitial());
      }
    });
  }
}
