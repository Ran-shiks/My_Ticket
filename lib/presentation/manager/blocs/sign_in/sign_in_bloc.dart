import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_essentials_kit/flutter_essentials_kit.dart';
import 'package:my_ticket/domain/use_cases/authentication_Interactor.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../domain/entities/user.dart';

part 'sign_in_event.dart';
part 'sign_in_state.dart';

///FlutterKit per il TwoWayBinding
class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final AuthInteractor authInteractor;

  ///TwoWayBinding
  final emailbinding = TwoWayBinding<String>()
      .bindDataRule(RequiredRule())
      .bindDataRule(EmailRule());
  final passwordBinding = TwoWayBinding<String>().bindDataRule(RequiredRule());

  ///TwoWayBinding

  SignInBloc({required this.authInteractor}) : super(InitialSignInstate()) {
    on<PerformSignInEvents>(_OnPerformSignIn);
    on<PerformSignInWithGoogleEvent>(_OnPerformSignInGoogle);
  }

  _OnPerformSignIn(PerformSignInEvents event, Emitter<SignInState> emit) async {
    emit(SigningInState());
    User? user;
    try {
      user = await authInteractor.login(
          email: event.email, password: event.password);
      emit(SuccessSignInstate(user));
    } catch (error) {
      emit(ErrorSignInState());
    }
  }

  _OnPerformSignInGoogle(
      PerformSignInWithGoogleEvent event, Emitter<SignInState> emit) async {
    emit(SigningInState());
    User? user;
    try {
      user = await authInteractor.loginWithGoogle();
      if (user != null) {
        emit(SuccessSignInstate(user));
      }
    } catch (error) {
      emit(ErrorSignInState());
    }
  }

  /// Stream per controllare la validità delle credenziali attraverso la libreria rxDart
  Stream<bool> get areValidCredentials => Rx.combineLatest2(
      emailbinding.stream,
      passwordBinding.stream,
      (_, __) =>
          emailbinding.value != null &&
          emailbinding.value!.isNotEmpty &&
          passwordBinding.value != null &&
          passwordBinding.value!.isNotEmpty);

  ///Bisogna fare l'override di close perchè abbiamo degli stream
  @override
  Future<void> close() async {
    await emailbinding.close();
    await passwordBinding.close();
    return super.close();
  }

  ///Metodi per eseguire il Login

  void performSignIn({
    String? email,
    String? password,
  }) =>
      add(PerformSignInEvents(
          email: (email ?? emailbinding.value) ?? " ",
          password: (password ?? passwordBinding.value) ?? " "));

  void performSignInWithGoogle() => add(PerformSignInWithGoogleEvent());
}
