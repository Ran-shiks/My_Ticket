import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

///Controller della pagina Welcome
///Il controller viene inserito dentro un cubit in modo da tenere traccia dell'unica
///informazione importante, ovvero un int che indicherà quale slide si sta visualizzando
///
/// Cubit<int> indica che il cubit emetterà eventi di tipo intero
class WelcomeCubit extends Cubit<int> {
  final PageController controller = PageController();

  /// costruttore senza parametri ma con super() con initialState impostato a 0
  WelcomeCubit() : super(0) {
    ///Aggiungiamo un Listener al controller in modo tale che se l'utente
    ///scorre la slide, il controller ne viene informato
    controller.addListener(() {
      ///Se la pagina viene cambiata viene emesso un evento in cui si valuta la funzione
      /// Se la pagina è divera da null allora il valore emesso è controller.page!.toInt()
      /// Se la pagina è null allora il valore emesso è 0
      emit(controller.page != null ? controller.page!.toInt() : 0);
    });
  }

  /// metodo di chiusura del cubit in cui chiudiamo tutte le risorse usate
  @override
  Future<void> close() {
    /// il controller viene chiuso
    controller.dispose();

    return super.close();
  }
}
