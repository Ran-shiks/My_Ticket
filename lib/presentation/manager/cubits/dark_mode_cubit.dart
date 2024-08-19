import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_ticket/presentation/providers/shared_preferences_provider.dart';

///Classe per tenere traccia dello stato della dark mode
///Ha due stati : true - false
///

class DarkModeCubit extends Cubit<bool> {
  ///Con sharedPreferences abbiamo un modo per tenere traccia del dato
  ///anche se l'applicazione viene chiusa
  ///Continua nel file shared_preferences_provider.dart

  ///Dipendenza SharedPreferencesProvider
  final SharedPreferencesProvider sharedPreferencesProvider;

  ///Costruttore con valore iniziale False in modo che la dark mode sia "spenta"
  DarkModeCubit({required this.sharedPreferencesProvider}) : super(false);

  /// Metodo di inizializzazione del cubit
  /// Con Emit andremo a leggere il valore booleano della dark Mode
  /// e lo emetteremo come stato del nostro cubit

  void init() async {
    emit(await sharedPreferencesProvider.darkModeEnabled);
  }

  ///Anche qui abbiamo una Setter in cui faremo l'emit del valore impostato
  ///ma lo salveremo anche nello SharedPreferencesProvider
  void SetDarkModeEnabled(bool mode) async {
    await sharedPreferencesProvider.setdarkMode(mode);
    emit(mode);
  }

  void toggleDarkMode() => SetDarkModeEnabled(!state);
}
