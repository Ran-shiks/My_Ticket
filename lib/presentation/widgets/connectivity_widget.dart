import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_offline/flutter_offline.dart';

abstract class ConnectivityWidget extends StatelessWidget {
  const ConnectivityWidget({Key? key}) : super(key: key);

  ///Il metodo build verificherà la connessione del dispositivo e deciderà quale contenuto far vedere.
  ///Se la connessione è assente, verrà costruito disconnectedBuild.
  ///Mentre se la connessione è presente verrà costruito il connectedBuild
  @override
  Widget build(BuildContext context) => OfflineBuilder(
        connectivityBuilder: (context, connectivity, child) =>
            connectivity == ConnectivityResult.none
                ? disconnectedBuild(context)
                : child,
        child: connectedBuild(context),
      );

  /// Questa classe astratta implementa due tipi di Widget

  /// Un Widget Normale
  Widget connectedBuild(BuildContext context);

  ///Un Widget che funzionerà senza connessione
  ///
  /// In questo caso in questo widget vengono impostati dei messaggi di errore
  /// e un bottone per andare nelle impostazioni della connessione del dispositivo
  ///
  /// Per costruire questo Widget abbiamo bisogno di :
  /// app_settings - Per aprire la pagina delle impostazioni
  /// flutter_offline - Per l'OfflineBuilder
  Widget disconnectedBuild(BuildContext context) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.wifi_off,
                size: 128,
                color: Colors.red,
              ),
              Text(AppLocalizations.of(context)?.label_no_connection_msg1 ??
                  ' '),
              Text(AppLocalizations.of(context)?.label_no_connection_msg2 ??
                  ' '),
              Padding(
                padding: const EdgeInsets.only(top: 24),
                child: ElevatedButton(
                  onPressed: () => AppSettings.openDataRoamingSettings(),
                  child: Text(
                      AppLocalizations.of(context)?.action_open_settings ??
                          ' '),
                ),
              )
            ],
          ),
        ),
      );
}
