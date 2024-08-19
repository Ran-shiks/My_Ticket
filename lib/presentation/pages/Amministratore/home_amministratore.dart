import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:my_ticket/core/resources/constants/constants.dart';
import 'package:my_ticket/core/router/app_router.dart';
import 'package:my_ticket/domain/use_cases/administrator_usecases.dart';
import 'package:my_ticket/domain/use_cases/authentication_Interactor.dart';
import 'package:my_ticket/presentation/manager/cubits/new_auth/auth_cubit.dart';
import 'package:my_ticket/presentation/pages/Profile/profile_page.dart';
import 'package:my_ticket/presentation/widgets/admin_widgets/stream_location_list.dart';

import '../../../domain/entities/block.dart';
import '../../../domain/entities/event.dart';
import '../../../domain/entities/location.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/use_cases/common_usecases.dart';
import '../../widgets/admin_widgets/stream_event_list.dart';
import '../../widgets/admin_widgets/stream_user_list.dart';

part 'add_operator.dart';
part 'create_event.dart';
part 'create_location.dart';

@RoutePage()
class HomePageAdmin extends StatefulWidget {
  const HomePageAdmin({required this.user});
  final User user;

  @override
  State<HomePageAdmin> createState() => _HomePageAdminState();
}

class _HomePageAdminState extends State<HomePageAdmin> {
  late int _Index;

  final List<Widget> _bodyWidget = [
    homeBody(),
    const AddOperator(),
    const CreateLocation(),
    const CreateEvent(),

  ];

  void _onItemTapped(int index) {
    setState(() {
      _Index = index;
    });
  }

  int get index=> _Index;

  @override
  void initState() {
    super.initState();
    // cambiare quando finito di correggere
    _Index = 0;
  }

  @override
  Widget build(BuildContext context) {
    var interactor = context.read<AuthInteractor>();
    var commoninteractor = context.read<CommonInteractor>();

    return Scaffold(
        appBar: AppBar(
          shadowColor: secondary,
          backgroundColor: background,
          foregroundColor: primary,
          title: Text(AppLocalizations.of(context)?.app_name ?? " "),
          actions: [
            IconButton(
              icon: const Icon(Icons.account_circle),
              onPressed: () {
                context.router.push(ProfileRoute(user: widget.user));
              },
            )
          ],
        ),
        backgroundColor: background,
        body: _bodyWidget[_Index],
        drawer: adminDrawer(context));
  }

  // Drawer Home
  //--------------------------------------------------------------------------------------------------
  Drawer adminDrawer(BuildContext context) {
    return Drawer(
      elevation: 5,
      shadowColor: secondary,
      surfaceTintColor: primary,
      backgroundColor: secondary,
      child: ListView(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        children: <Widget>[
          const DrawerHeader(
              decoration: BoxDecoration(color: primary),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "My ticket",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                    ),
                  ),
                  Text(
                    "Home menu",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ],
              )),
          Card(
            child: ListTile(
              leading: const FittedBox(
                fit: BoxFit.contain,
                  child: Icon(Icons.home, size: 72.0, color: background,)),
              title: const Text('Home'),
              tileColor: (index == 0) ? secondary : primary,
              subtitle: const Text(
                  'Pagina dove puoi vedere gli eventi più popolari, gli eventi preferiti'),
              onTap: () {
                _onItemTapped(0);
                context.router.pop();
              },
              isThreeLine: true,
            ),
          ),
          Card(
            child: ListTile(
              leading: const FittedBox(
                  fit: BoxFit.contain,
                  child: Icon(Icons.people, size: 72.0, color: background,)),
              tileColor: (index == 1) ? secondary : primary,
              title: const Text('Aggiungi Operatore'),
              onTap: () {
                _onItemTapped(1);
                context.router.pop();
              },
              subtitle:
                  const Text('Aggiungi un operatore, deve avere un account normale'),
              isThreeLine: true,
            ),
          ),
          Card(
            child: ListTile(
              leading: const FittedBox(
                  fit: BoxFit.contain,
                  child: Icon(Icons.place_outlined, size: 72.0, color: background,)),
              tileColor: (index == 2) ? secondary : primary,
              onTap: () {
                _onItemTapped(2);
                context.router.pop();
              },
              title: const Text('Aggiungi un posto'),
              subtitle: const Text('Aggiungi un luogo'),
              isThreeLine: true,
            ),
          ),
          Card(
            child: ListTile(
              leading: const FittedBox(
                  fit: BoxFit.contain,
                  child: Icon(Icons.event, size: 72.0, color: background,)),
              tileColor: (index == 3) ? secondary : primary,
              onTap: () {
                _onItemTapped(3);
                context.router.pop();
              },
              title: const Text('Aggiungi un evento'),
              subtitle: const Text('Aggiungi un evento'),
              isThreeLine: true,
            ),
          ),
          Card(
            color: background,
              child: Container(
                child: Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: background),

                    child: const Text("LogOut"),
                      onPressed: () {
                      context.read<AuthCubit>().signOut();
                      context.router.popUntilRoot();
                },
              ),
            ),
          )),
        ],
      ),
    );
  }
}

// Home Body
//-----------------------------------------------------------------
Widget homeBody() {
  return Builder(builder: (context) {
    var interactor = context.read<CommonInteractor>();
    var interactorA = context.read<AdminInteractor>();

    return Container(
      color: background,
      child: ListView(
          shrinkWrap: true,
          children: [
            Container(
              color: primary,
              height: 50,
              width: MediaQuery.of(context).size.width,
              child: FittedBox(child: const Center(child: Text("Popolari")), fit: BoxFit.contain,),
            ),
            Container(
                color: background,
                height: 300,
                width: MediaQuery.of(context).size.width,
                child: StreamEventListFiltered(interactor, "favCounter", 10)),
            Container(
              color: primary,
              height: 50,
              width: MediaQuery.of(context).size.width,
              child: FittedBox(child: const Center(child: Text("Tutti gli eventi")), fit: BoxFit.contain,),
            ),
            Container(
                color: background,
                height: 300,
                width: MediaQuery.of(context).size.width,
                child: StreamEventList(interactor)),
            Container(
              color: primary,
              height: 50,
              width: MediaQuery.of(context).size.width,
              child: const Center(child: Text("Locations")),
            ),
            Container(
              color: background,
              height: 300,
              width: MediaQuery.of(context).size.width,

              child: StreamLocationList(interactorA),
            ),
            Container(
                color: primary,
                height: 10,
                width: MediaQuery.of(context).size.width,
            ),
          ],
        ),
    );
  });
}
