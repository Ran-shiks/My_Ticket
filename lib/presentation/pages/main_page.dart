import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_ticket/data/models/user_model.dart';
import 'package:my_ticket/domain/entities/user.dart';
import 'package:my_ticket/domain/use_cases/authentication_Interactor.dart';
import 'package:my_ticket/presentation/pages/guest/anonymous_home_page.dart';
import 'package:my_ticket/presentation/pages/welcome_page.dart';
import 'package:my_ticket/presentation/widgets/connectivity_widget.dart';

import '../../presentation/manager/cubits/new_auth/auth_cubit.dart';
import 'Amministratore/home_amministratore.dart';
import 'Operatore/home_operatore.dart';
import 'Utente/home_utente.dart';

@RoutePage()
class MainPage extends ConnectivityWidget {
  @override
  Widget connectedBuild(BuildContext context) =>

      ///BlocBuilder che si metterà in ascolto dei cambiamenti di AuthCubit
      ///Accetterà due parametri, ovvero il tipo di cubit da ascoltare e il tipo di stato
      ///Si controllerà lo stato per costruire la pagina giusta

      BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          late User user;
          if (state is AuthenticatedState) {
            if (state.user.isAnonymous) {
              return AnonymusHomePage(anonym: UserModel.fromFireUser(state.user)!.toEntity());
            }
            user = UserModel.fromFireUser(state.user)!.toEntity();
          }
          return state is LoadingAuthenticationState
              ? _loadingStateWidget()
              : state is AuthenticatedState
                  ? FutureBuilder<int?>(
                      future: context.read<AuthInteractor>().role(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return const Center(
                              child: Text('Errore nel caricamento dell utente'));
                        } else {
                          if (snapshot.data != null) {
                            final userWidget = <Widget>[
                              HomePageAdmin(user: user),
                              HomePageOperator(user: user),
                              HomePageUser(user: user),
                            ];
                            return userWidget[snapshot.data!];
                          }
                          return const Center(
                              child: Text('Errore nel caricare utente'));
                        }
                      })
                  : const WelcomePage();
        },
      );

  Widget _loadingStateWidget() => Scaffold(
        body: Container(),
      );
}
