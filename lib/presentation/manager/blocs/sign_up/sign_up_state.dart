part of 'sign_up_bloc.dart';

abstract class SignUpState extends Equatable {
  const SignUpState();

  @override
  List<Object?> get props => [];
}

/// Stato iniziale del processo di SignIn.
class InitialSignUpstate extends SignUpState {}

///Stato utilizzato per bloccare i campi email
///e password e far vedere l'icona di caricamento.
class SigningUpState extends SignUpState {}

///Stato che si ottiene una volta che il processo
/// è completato ed è andato a buon fine.
class SuccessSignUpstate extends SignUpState {
  final User user;

  const SuccessSignUpstate(this.user);

  @override
  List<Object?> get props => [user];
}

///Stato che si ottiene una volta che il processo
///è completato e non è andato a buon fine.
class ErrorSignUpState extends SignUpState {
  final FirebaseAuthException error;

  const ErrorSignUpState(this.error);

  @override
  List<Object?> get props => [error];
}
