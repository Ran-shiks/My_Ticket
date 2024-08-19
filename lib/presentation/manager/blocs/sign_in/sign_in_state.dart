part of 'sign_in_bloc.dart';

abstract class SignInState extends Equatable {
  const SignInState();

  @override
  List<Object?> get props => [];
}

/// Stato iniziale del processo di SignIn.
class InitialSignInstate extends SignInState {}

///Stato utilizzato per bloccare i campi email
///e password e far vedere l'icona di caricamento.
class SigningInState extends SignInState {}

///Stato che si ottiene una volta che il processo
/// è completato ed è andato a buon fine.
class SuccessSignInstate extends SignInState {
  final User user;

  const SuccessSignInstate(this.user);

  @override
  List<Object?> get props => [user];
}

///Stato che si ottiene una volta che il processo
///è completato e non è andato a buon fine.
class ErrorSignInState extends SignInState {}
