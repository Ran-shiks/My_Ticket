part of 'sign_in_bloc.dart';

abstract class SignInEvent extends Equatable {
  const SignInEvent();

  @override
  List<Object?> get props => [];
}

/// le uniche due azioni che possiamo catalogare nella schermata di Login
class PerformSignInEvents extends SignInEvent {
  final String email;
  final String password;

  const PerformSignInEvents({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class PerformSignInWithGoogleEvent extends SignInEvent {}
