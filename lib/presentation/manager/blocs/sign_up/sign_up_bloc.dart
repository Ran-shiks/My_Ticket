import 'package:equatable/equatable.dart';
import 'package:fimber/fimber.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_essentials_kit/misc/data_rules/email_rule.dart';
import 'package:flutter_essentials_kit/misc/data_rules/required_rule.dart';
import 'package:flutter_essentials_kit/misc/two_way_binding.dart';
import 'package:my_ticket/domain/use_cases/authentication_Interactor.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../domain/entities/user.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final AuthInteractor authInteractor;

  ///TwoWayBinding
  final emailbinding = TwoWayBinding<String>()
      .bindDataRule(RequiredRule())
      .bindDataRule(EmailRule());
  final passwordBinding = TwoWayBinding<String>().bindDataRule(RequiredRule());
  final nameBinding = TwoWayBinding<String>().bindDataRule(RequiredRule());
  final surnameBinding = TwoWayBinding<String>().bindDataRule(RequiredRule());

  ///TwoWayBinding

  SignUpBloc({
    required this.authInteractor,
  }) : super(InitialSignUpstate()) {
    on<PerformSignUpEvent>(_OnPerformSignUpEvent);
    on<PerformSignUpWithGoogleEvent>(_OnPerformSignUpWithGoogleEvent);
  }

  _OnPerformSignUpEvent(
      PerformSignUpEvent event, Emitter<SignUpState> emit) async {
    emit(SigningUpState());
    User? user;

    try {
      user = await authInteractor.registration(
          email: event.email,
          password: event.password,
          name: nameBinding.value!,
          surname: surnameBinding.value!);
    } on FirebaseAuthException catch (error) {
      Fimber.d(error.toString());
      emit(ErrorSignUpState(error));
    } catch (error) {
      Fimber.d(error.toString());
    }

    if (user != null) {
      emit(SuccessSignUpstate(user));
    }
  }

  _OnPerformSignUpWithGoogleEvent(
      PerformSignUpWithGoogleEvent event, Emitter<SignUpState> emit) async {
    emit(SigningUpState());
    User? user;
    try {
      user = await authInteractor.loginWithGoogle();
    } on FirebaseAuthException catch (error) {
      Fimber.d(error.toString());
      emit(ErrorSignUpState(error));
    } catch (error) {
      Fimber.d(error.toString());
    }

    if (user != null) {
      emit(SuccessSignUpstate(user));
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
    await nameBinding.close();
    await surnameBinding.close();

    return super.close();
  }

  void performSignUp({
    String? email,
    String? password,
  }) =>
      add(PerformSignUpEvent(
          email: (email ?? emailbinding.value) ?? " ",
          password: (password ?? passwordBinding.value) ?? " "));

  void performSignUpWithGoogle() => add(PerformSignUpWithGoogleEvent());
}
