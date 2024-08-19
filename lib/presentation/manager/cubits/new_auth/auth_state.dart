part of 'auth_cubit.dart';

///File che rappresenterà gli stati nei quali
///l'utente può trovarsi per quanto riguarda il Login

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

///Stato di mezzo per mostrare un Widget di caricamento
class LoadingAuthenticationState extends AuthState {}

///Stato che consente la vendita di biglietti e l'area personale con i biglietti comprati
class AuthenticatedState extends AuthState {
  final fire.User user;

  const AuthenticatedState(this.user);

  ///Proprietà dello stato
  @override
  List<Object?> get props => [user];
}

///stato di non Autenticazione nel sistema
class NotAuthenticatedState extends AuthState {}
