import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_ticket/data/repositories/UserDatabaseRepositoryFirebaseImplementation.dart';
import 'package:my_ticket/data/repositories/authentication_repositories.dart';
import 'package:my_ticket/presentation/manager/cubits/dark_mode_cubit.dart';
import 'package:my_ticket/presentation/providers/shared_preferences_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/repositories/BlockDatabaseRepositoryFirebaseImplementation.dart';
import '../../data/repositories/EventDatabaserepositoryFirebaseImplementation.dart';
import '../../data/repositories/LocationDatabaserepositoryFirebaseImplementation.dart';
import '../../data/repositories/TicketDataBaseRepositoryFirebaseImplementation.dart';
import '../../domain/use_cases/administrator_usecases.dart';
import '../../domain/use_cases/authentication_Interactor.dart';
import '../../domain/use_cases/common_usecases.dart';
import '../../presentation/manager/cubits/new_auth/auth_cubit.dart';

/// Classe DependencyInjector usata per iniettare alla gerarchia dell'applicazione
/// tutte le dipendenze

class DependencyInjector extends StatelessWidget {
  final Widget child;

  const DependencyInjector({super.key, required this.child});

  /// Nel metodo build cabliamo i vari providers innestandoli uno dentro l'altro nella gerarchia dei widget
  @override
  Widget build(BuildContext context) => _providers(
      child: _repositories(child: _useCases(child: _block(child: child))));

  Widget _providers({required Widget child}) => MultiProvider(
        providers: [
          ///Questo metodo verrà invocato quando avremo bisogno attivamente di questo provider,
          /// bisogno che può concretizzarsi direttamente alla richiesta di un elemento
          /// che si ritrova a un livello inferiore della gerarchia o in modo esplicito
          /// attraverso l'interazione con l'applicazione
          ///
          Provider<SharedPreferencesProvider>(
            create: (_) => SharedPreferencesProvider(
                sharedPreferences: SharedPreferences.getInstance()),
          ),

          Provider<FirebaseAuth>(
            create: (_) => FirebaseAuth.instance,
          ),

          Provider<FirebaseFirestore>(
            create: (_) => FirebaseFirestore.instance,
          ),

          Provider<GoogleSignIn>(
            create: (_) => GoogleSignIn(scopes: [
              'https://www.googleapis.com/auth/userinfo.email',
              'https://www.googleapis.com/auth/userinfo.profile',
            ]),
          ),
        ],
        child: child,
      );

  Widget _mappers({required Widget child}) => MultiProvider(
        providers: const [],
        child: child,
      );

  Widget _repositories({required Widget child}) => MultiRepositoryProvider(
        providers: [
          ///AUTH REPOSITORY
          RepositoryProvider(
              create: (context) => AuthenticationRepositories(
                  firebaseAuth: context.read(),
                  googleSignIn: context.read(),
                  firebaseFirestore: context.read<FirebaseFirestore>())),

          ///DATA REPOSITORY
          RepositoryProvider(
              create: (context) => UserDatabaseFirebaseImplementation(
                  firebaseFirestore: context.read())),
          RepositoryProvider(
              create: (context) => TicketDatabaseFirebaseImplementation(
                  firebaseFirestore: context.read())),
          RepositoryProvider(
              create: (context) => BlockDatabaseFirebaseImplementation(
                  firebaseFirestore: context.read())),
          RepositoryProvider(
              create: (context) => EventDatabaseFirebaseImplementation(
                  firebaseFirestore: context.read())),
          RepositoryProvider(
              create: (context) => LocationDatabaseFirebaseImplementation(
                  firebaseFirestore: context.read())),
        ],
        child: child,
      );

  Widget _useCases({required Widget child}) => MultiProvider(
        providers: [
          Provider<AuthInteractor>(
              create: (context) => AuthInteractor(
                  context.read<AuthenticationRepositories>(),
                  context.read<UserDatabaseFirebaseImplementation>())),
          Provider<CommonInteractor>(
              create: (context) => CommonInteractor(
                  authenticationRepositories:
                  context.read<AuthenticationRepositories>(),
                  eventDatabaseRepository:
                      context.read<EventDatabaseFirebaseImplementation>(),
                  locationDatabaseRepository:
                      context.read<LocationDatabaseFirebaseImplementation>(),
                  ticketDatabaseRepository:
                      context.read<TicketDatabaseFirebaseImplementation>(),
                  blockDatabaseRepository:
                      context.read<BlockDatabaseFirebaseImplementation>(),
                  userDatabaseRepository:
                      context.read<UserDatabaseFirebaseImplementation>(),)),
          Provider<AdminInteractor>(
              create: (context) => AdminInteractor(
                  eventdatabaserepository:
                      context.read<EventDatabaseFirebaseImplementation>(),
                  locationdatabaserepository:
                      context.read<LocationDatabaseFirebaseImplementation>(),
                  ticketDatabaseRepository:
                      context.read<TicketDatabaseFirebaseImplementation>(),
                  blockdatabaserepository:
                      context.read<BlockDatabaseFirebaseImplementation>(),
                  userdatabaserepository:
                      context.read<UserDatabaseFirebaseImplementation>(),
                myTicketAuthenticationRepositories:
                      context.read<AuthenticationRepositories>(),))
        ],
        child: child,
      );

  Widget _block({required Widget child}) => MultiBlocProvider(
        providers: [
          /// Aggiungiamo ai blocchi di logica il blocco Dark Mode Cubit
          BlocProvider<DarkModeCubit>(
            create: (context) =>

                /// Poiché il provider lo abbiamo instaziato in alto nella gerarchia dei widget
                /// lo possiamo attenere per passarlo al cubit attraverso la lettura del contesto
                /// con context.read().
                /// context.read() andrà a risolvere la gerarchia dei widget alla ricerca del *primo*
                /// sharedPreferencesProvider utile
                ///
                /// init() serve a finché lo stesso inizializzi lo stato del cubit sulla base delle sharedPreferences
                DarkModeCubit(sharedPreferencesProvider: context.read())
                  ..init(),
          ),

          /// BlocProvide di tipo AuthCubit per costruire un istanza di AuthCubit e la mantiene nella gerarchia
          /// A questo provider serve l'istanza di firebase che già è presente nella gerarchia
          /// quindi con context.read() la andiamo a prendere e passare
          BlocProvider<AuthCubit>(
            create: (context) => AuthCubit(
              authInteractor: context.read<AuthInteractor>(),
            ),
          ),
        ],
        child: child,
      );
}
