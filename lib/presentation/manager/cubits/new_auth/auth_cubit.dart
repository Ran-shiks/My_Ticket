import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fimber/fimber.dart';
import 'package:firebase_auth/firebase_auth.dart' as fire;
import 'package:my_ticket/domain/use_cases/authentication_Interactor.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  ///Dipendenza che serve per metterci in ascolto dei cambiamenti di stato da parte dell'utente
  final AuthInteractor authInteractor;

  late StreamSubscription<fire.User?> _streamSubscription;

  AuthCubit({required this.authInteractor})
      : super(LoadingAuthenticationState()) {
    _streamSubscription = authInteractor.userChange().listen((_onStateChanged));
  }

  ///Metodo di callBack per associare lo stato dell'utente
  ///su firebase con lo stato dell'applicazione
  void _onStateChanged(fire.User? user) {
    if (user == null) {
      emit(NotAuthenticatedState());
      Fimber.d('User Not Authenticated');
    } else {
      emit(AuthenticatedState(user));
      Fimber.d('User is Authenticated: $user');
    }
  }

  ///Override del metodo close per chiudere la stream-subscription
  @override
  Future<void> close() async {
    await _streamSubscription.cancel();
    return super.close();
  }

  ///Metodo di SignOut
  void signOut() => authInteractor.SignOut();
}
