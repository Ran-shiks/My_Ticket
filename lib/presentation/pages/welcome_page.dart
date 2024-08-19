import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_ticket/core/resources/constants/constants.dart';
import 'package:my_ticket/core/router/app_router.dart';
import 'package:my_ticket/presentation/manager/cubits/welcome_cubit.dart';

@RoutePage()
class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  /// Dividiamo il Widget in più sotto-Widget in modo
  /// da semplificare la programmazione e la lettura del codice
  @override
  Widget build(_) => _welcomeCubit(

      ///LayoutBuilder viene utilizzato per ottenere il context dopo aver
      ///innestato il welcomeCubit
      child: LayoutBuilder(
          builder: (context, _) => Scaffold(
                body: Container(
                  color: background,
                  padding: const EdgeInsets.all(32),
                  width: double.maxFinite,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _sliderContainer(context),
                      _startMessagingBubble(context),
                    ],
                  ),
                ),
              )));

  Widget _welcomeCubit({required Widget child}) => BlocProvider(
        create: (_) => WelcomeCubit(),
        child: child,
      );

  ///Anche in questo caso dividiamo in più sotto-Widget
  Widget _sliderContainer(BuildContext context) => Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _slides(context),
            _indicator(),
          ],
        ),
      );

  ///Slide che devono scorrere sullo schermo formate da una icona e due righe di testo
  Widget _slides(BuildContext context) {
    ///Widget che rappresenta la struttura della slide generale
    final widgets = _items(context)
        .map((item) => Container(color: background,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  Flexible(flex: 1, fit: FlexFit.tight, child: item['image']),
                  Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          children: [
                            Text(
                              item['header'],
                              textScaleFactor: 3,
                              style: TextStyle(color: selected,),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(item['description'], style: TextStyle(color: selected),),
                            ),
                          ],
                        ),
                      ))
                ],
              ),
            ))
        .toList(growable: false);

    ///Restituiamo un Container con dentro un Costruttore che inizializza
    ///la slide generale con la lista di elementi da inserire a seconda dell'indice
    return SizedBox(
      height: 300,
      child: PageView.builder(
        itemBuilder: (context, index) => widgets[index],
        itemCount: widgets.length,

        /// Quando costruiamo la Sezione delle Slide associamo il controller
        /// che abbiamo definito nel cubit WelcomeCubit, la logica sarebbe:
        ///
        /// Slide -> Controller -> stato cubit -> evento(emit) -> indicatore della slide
        ///
        /// Attraverso il contesto e con il metodo read possiamo andare a cercare qualcosa
        /// di specifico nella gerarchia dei widget, in questo caso WelcomeCubit, che viene innestato
        /// attraverso il Widget _welcomeCubit definito sopra e innestato prima dello Scaffold della Pagina
        controller: context.read<WelcomeCubit>().controller,
      ),
    );
  }

  /// Indicatore di scorrimento che indica a quale slide della welcome page
  /// si trova l'utente
  /// Con il BlocBuilder<WelcomeCubit, int> andiamo a metterci in ascolto dello stato del Cubit in questione
  /// e impostiamo l'indicatore di conseguenza
  Widget _indicator() => BlocBuilder<WelcomeCubit, int>(
      builder: (context, page) => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
                _items(context).length,
                (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      height: 8,
                      width: 8,
                      decoration: BoxDecoration(
                          color: page == index
                              ? selected
                              : primary,
                          borderRadius: BorderRadius.circular(10)),
                    )),
          ));

  ///Pulsante per andare avanti nella gerarchia
  Widget _startMessagingBubble(BuildContext context) => ElevatedButton(
    style: ElevatedButton.styleFrom(backgroundColor: background,foregroundColor: selected),
        onPressed: () => context.router.push(const LoginRouteConnection()),
        child: Text(
            AppLocalizations.of(context)?.action_start_buying_tickets ?? " "),
      );

  /// Subset di elementi fissi
  List _items(BuildContext context) => [
        {
          "image": const FaIcon(FontAwesomeIcons.ticketAlt,
              color: selected, size: 128),
          "header": AppLocalizations.of(context)?.welcome_header_1,
          "description": AppLocalizations.of(context)?.welcome_description_1,
        },
        {
          "image":
              const FaIcon(FontAwesomeIcons.rocket, color: selected, size: 128),
          "header": AppLocalizations.of(context)?.welcome_header_2,
          "description": AppLocalizations.of(context)?.welcome_description_2,
        },
        {
          "image": const FaIcon(FontAwesomeIcons.dollarSign,
              color: selected, size: 128),
          "header": AppLocalizations.of(context)?.welcome_header_3,
          "description": AppLocalizations.of(context)?.welcome_description_3,
        },
        {
          "image": const FaIcon(FontAwesomeIcons.tachometerAlt,
              color: selected, size: 128),
          "header": AppLocalizations.of(context)?.welcome_header_4,
          "description": AppLocalizations.of(context)?.welcome_description_4,
        },
        {
          "image":
              const FaIcon(FontAwesomeIcons.lock, color: selected, size: 128),
          "header": AppLocalizations.of(context)?.welcome_header_5,
          "description": AppLocalizations.of(context)?.welcome_description_5,
        },
        {
          "image":
              const FaIcon(FontAwesomeIcons.cloud, color: selected, size: 128),
          "header": AppLocalizations.of(context)?.welcome_header_6,
          "description": AppLocalizations.of(context)?.welcome_description_6,
        }
      ];
}
