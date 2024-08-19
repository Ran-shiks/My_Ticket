import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_essentials_kit/localizations/flutter_essentials_kit_localizations.dart';
// Per la localizzazione delle stringhe
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:my_ticket/core/router/app_router.dart';
import 'package:my_ticket/presentation/manager/cubits/dark_mode_cubit.dart';

import 'core/di/dependency_injector.dart';

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  ///Auto-route
  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) => DependencyInjector(
        child: _themeSelector(
          (context, mode) => MaterialApp.router(
            title: AppLocalizations.of(context)?.app_name ?? ' ',
            theme: _theme(context),
            darkTheme: _darkTheme(context),
            themeMode: mode,

            ///Per la localizzazione delle stringhe

            localizationsDelegates: const [
              ...AppLocalizations.localizationsDelegates,
              FlutterEssentialsKitLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,

            ///Auto-route
            routerDelegate: _appRouter.delegate(),
            routeInformationParser: _appRouter.defaultRouteParser(),
          ),
        ),
      );

  /// BlocBuilder si mette in ascolto di un DarkModeCubit, che sarà recuperato dalla gerarchia dei widget,
  /// e emetterà degli eventi di tipo booleano
  /// Quindi quando si attiverà la dark mode si attiverà la Function che sceglierà il theme
  /// Questo widget viene innestato nella gerarchia prima di MaterialApp.router
  ///
  Widget _themeSelector(
          Widget Function(BuildContext context, ThemeMode mode) widget) =>
      BlocBuilder<DarkModeCubit, bool>(
        builder: (context, darkModeEnabled) => widget(
          context,
          darkModeEnabled ? ThemeMode.dark : ThemeMode.light,
        ),
      );

  /// Tema principale dell'applicazione
  ThemeData _theme(BuildContext context) => ThemeData(
      primaryColor: Colors.lightBlue,
      primaryColorDark: Colors.blue,
      colorScheme:
          Theme.of(context).colorScheme.copyWith(secondary: Colors.lightBlue),
      brightness: Brightness.light,
      appBarTheme: const AppBarTheme(shadowColor: Colors.amber));

  /// Tema Dark dell'applicazione
  ThemeData _darkTheme(BuildContext context) => ThemeData.dark().copyWith(
      colorScheme:
          Theme.of(context).colorScheme.copyWith(secondary: Colors.lightBlue),
      appBarTheme: const AppBarTheme(shadowColor: Colors.deepPurple));
}

/*

 */
