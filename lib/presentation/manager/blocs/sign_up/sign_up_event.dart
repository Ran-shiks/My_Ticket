part of 'sign_up_bloc.dart';

abstract class SignUpEvent extends Equatable {
  const SignUpEvent();

  @override
  List<Object?> get props => [];
}

class PerformSignUpEvent extends SignUpEvent {
  final String email;
  final String password;

  const PerformSignUpEvent({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class PerformSignUpWithGoogleEvent extends SignUpEvent {}
