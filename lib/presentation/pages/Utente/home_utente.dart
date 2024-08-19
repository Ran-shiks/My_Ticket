import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:my_ticket/presentation/widgets/widget_user/eventilist_user.dart';
import 'package:my_ticket/presentation/widgets/widget_user/future_ticket_list_customer.dart';
import '../../../core/resources/constants/constants.dart';
import '../../../core/router/app_router.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/use_cases/common_usecases.dart';
import '../../manager/cubits/new_auth/auth_cubit.dart';
import '../../widgets/widget_user/future_event_list_customer.dart';

part 'body_MyTickets.dart';

@RoutePage()
class HomePageUser extends StatefulWidget {
  final User user;

  HomePageUser({Key? key, required this.user}) : super(key: key);

  @override
  State<HomePageUser> createState() => _HomePageUserState();
}

class _HomePageUserState extends State<HomePageUser> {
  late int _Index;

  final List<Widget> _bodyWidget = [
    homeUserBody(),
    BodyMyTickets(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _Index = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _Index = 0;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          shadowColor: secondary,
          backgroundColor: background,
          foregroundColor: primary,
          title: Row(
            children: [
              Text(
                AppLocalizations.of(context)?.app_name ?? " ",
                style: TextStyle(color: selected,),
                textScaleFactor: 0.5,
              ),
              FutureBuilder<User?>(
                  future: context
                      .read<CommonInteractor>()
                      .infoUser(widget.user.uid),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text("Benvenuto"),
                      );
                    } else if (snapshot.hasError) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text("Benvenuto"),
                      );
                    } else {
                      final futureUser = snapshot.data!;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text("Benvenuto ${futureUser.name}"),
                      );
                    }
                  })
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: selected,
                child: IconButton(
                  onPressed: () async {
                    context.router.push(ProfileRouteUtente(user: widget.user));
                  },
                  icon: const Icon(Icons.account_circle_outlined, color: background, ),
                ),
              ),
            )
          ],
        ),
        backgroundColor: background,
        body: _bodyWidget[_Index],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _Index,
          fixedColor: selected,
          backgroundColor: secondary,
          items: [
            BottomNavigationBarItem(
              icon: IconButton(
                icon: const Icon(Icons.home,),
                onPressed: () async {
                  _onItemTapped(0);
                },
              ),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: IconButton(
                icon: const Icon(Icons.bookmark_add_outlined),
                onPressed: () async {
                  _onItemTapped(1);
                },
              ),
              label: "MyTicket",
            ),
            BottomNavigationBarItem(
              label: "LogOut",
              icon: IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () async {
                  context.read<AuthCubit>().signOut();
                },
              ),
            ),
          ],
        ),
      );
}

Widget homeUserBody() {
  return Builder(builder: (context) {
    var interactor = context.read<CommonInteractor>();

    return Column(
      children: [
        Expanded(child: EventList_user(interactor)),
      ],
    );
  });
}
