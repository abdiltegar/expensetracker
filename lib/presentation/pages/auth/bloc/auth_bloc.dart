import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:paml_20190140086_ewallet/domain/models/auth/auth_login_model.dart';
import 'package:paml_20190140086_ewallet/domain/models/auth/auth_register_model.dart';
import 'package:paml_20190140086_ewallet/domain/repositories/auth/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final authRepository = AuthRepository();

  AuthBloc() : super(AuthInitial()) {
    on<AuthEvent>((event, emit) {
    });

    on<AuthLogin>((event, emit) async {
      try {
        emit(AuthLoginLoading());
        final response = await authRepository.login(event.email, event.password);
          
        emit(AuthLoginLoaded(response: response));
      } catch (e) {
        emit(AuthError(error: e.toString()));
      }
    });

    on<AuthRegister>((event, emit) async {
      try {
        emit(AuthRegisterLoading());
        debugPrint('-- call auth repository');
        final response = await authRepository.register(event.email, event.password, event.name);
        debugPrint('-- register to be loaded, response : ${response.toString()}');
        emit(AuthRegisterLoaded(response: response));
        debugPrint('-- authRegisterLoaded');
      } catch (e) {
        debugPrint('-- auth register error : ${e.toString()}');
        emit(AuthError(error: e.toString()));
      }
    });

    on<AuthLogout>((event, emit) async {
      try {
        await authRepository.logout();
          
        emit(AuthLogoutLoaded());
      } catch (e) {
        emit(AuthError(error: e.toString()));
      }
    });
  }
}
