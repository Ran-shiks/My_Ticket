
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_ticket/core/resources/constants/constants.dart';
import 'package:my_ticket/domain/entities/user.dart';
import 'package:my_ticket/domain/use_cases/authentication_Interactor.dart';

import '../../widgets/anonym_widget/streamed_events_list.dart';

@RoutePage()
class AnonymusHomePage extends StatefulWidget {
  const AnonymusHomePage({super.key, required this.anonym});

  final User anonym;

  @override
  State<AnonymusHomePage> createState() => _AnonymusHomePageState();
}

class _AnonymusHomePageState extends State<AnonymusHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: background,
        title: const Text("Benvenuto Guest", style: TextStyle(color: selected),),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _signOutButton(context),
          )
        ],
        automaticallyImplyLeading: false
        ,),
      body: Container(
        color: background,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: primary,
                  border: Border.all(
                    color: secondary,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(20))),
              child: const Center(
                child: FittedBox(
                    child: Text("Qui puoi trovare tutti gli eventi in corso", textScaleFactor: 2,)),
              ),
            ),
            const Expanded(
                child: EventListStreamed()
            )
          ],
        ),
      ),
    );
  }

  Widget _signOutButton(BuildContext context) =>
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: selected,
          foregroundColor: background,
        ),
        onPressed: () {
          context.read<AuthInteractor>().SignOut().then((value) => context.router.pop());
        },
        child: const Text("SignOut"),
      );
}
