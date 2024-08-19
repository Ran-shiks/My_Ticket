import 'package:shared_preferences/shared_preferences.dart';

/// Dopo aver aggiunto SharedPreferences abbiamo bisogno di una classe con cui ci possiamo
/// interfacciare.
/// Questa è la classe che farà da provider seguendo lo schema:
///
/// UI <-> dark_mode_cubit.dart <-> shared_preferences_provider.dart
///

const String _SHARED_PREFERENCES_DARK_MODE_ENABLED = "DARK MODE ENABLED";

class SharedPreferencesProvider {
  final Future<SharedPreferences> sharedPreferences;

  SharedPreferencesProvider({required this.sharedPreferences});

  ///Getter - Ottengo il valore della dark mode
  Future<bool> get darkModeEnabled async =>
      (await sharedPreferences)
          .getBool(_SHARED_PREFERENCES_DARK_MODE_ENABLED) ??
      false;

  ///Setter - funzione attraverso la quale setto il valore
  Future<bool> setdarkMode(bool value) async => (await sharedPreferences)
      .setBool(_SHARED_PREFERENCES_DARK_MODE_ENABLED, value);
}
