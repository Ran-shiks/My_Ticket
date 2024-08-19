import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_ticket/core/resources/constants/constants.dart';
import 'package:my_ticket/domain/use_cases/common_usecases.dart';
import 'package:my_ticket/presentation/widgets/admin_widgets/future_ticket_list.dart';

import '../../../domain/entities/user.dart';
import '../../manager/cubits/new_auth/auth_cubit.dart';
import '../../widgets/admin_widgets/future_event_list.dart';

@RoutePage()
class ProfilePageUtente extends StatelessWidget {
  const ProfilePageUtente({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    var common = context.read<CommonInteractor>();

    return Scaffold(
        backgroundColor: background,
        appBar: AppBar(
          backgroundColor: background,
          title: const Text("Pagina di Profilo"),
        ),
        body: StreamBuilder<User?>(
          stream: common.streamUser(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Errore nel caricamento dei dati'));
            } else {
              final futureUser = snapshot.data!;
              return _userProfile(context, futureUser);
            }
          }
        ));
  }

  Widget _signUpButton(BuildContext context, {bool enabled = true}) =>
      ElevatedButton(
        onPressed: enabled
            ? () => {context.read<AuthCubit>().signOut(), context.router.pop()}
            : null,
        child: const Text("SignOut"),
      );
}

Widget _userProfile(BuildContext context, User futureUser) {
  return  Container(
    height: MediaQuery.of(context).size.height,
            color: background,
            child: Card(
              elevation: 20,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(60.0),
              ),
              shadowColor: primary,
              color: primary,
              child: Column(
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 100,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          futureUser.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, object, stack) {
                            return const Icon(
                              Icons.person,
                              size: 120,
                              color: background,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  Divider(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 100),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Text(
                            futureUser.email,
                          )),
                    ),
                  ),
                  Divider(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 150),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Text(
                            "Name : ${futureUser.name}",
                          )),
                    ),
                  ),
                  Divider(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 150),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Text(
                            "Surname : ${futureUser.surname}",
                          )),
                    ),
                  ),
                  Divider(
                    height: 10,
                  ),
                  Text("Id : ${futureUser.uid}"),
                  Divider(
                    height: 10,
                  ),
                ],
              ),
            ),
          );
        }

Widget _changeName(BuildContext context, User user) {
  TextEditingController userController = TextEditingController();

  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Container(
      child: Column(
        children: [
          Text(user.name ?? " "),
          TextField(
            controller: userController,
          ),
          ElevatedButton(
              onPressed: () async {
                User newUser = User(
                    uid: user.uid,
                    name: userController.text,
                    balance: user.balance,
                    surname: user.surname,
                    email: user.email,
                    imageUrl: user.imageUrl,
                    role: user.role);

                //TODO context.read<FirestoneDatabaseRepository>().UserChange(user: newUser);
              },
              child: const Text("Aggiorna"))
        ],
      ),
    ),
  );
}

Widget _changeSurname(BuildContext context, User user) {
  TextEditingController userController = TextEditingController();

  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Container(
      child: Column(
        children: [
          Text(user.surname),
          TextField(
            controller: userController,
          ),
          ElevatedButton(
              onPressed: () async {
                User newUser = user.copyWith(
                  surname: userController.text,
                );

                context
                    .read<CommonInteractor>()
                    .userDatabaseRepository
                    .updateUser(newUser);
              },
              child: const Text("Aggiorna"))
        ],
      ),
    ),
  );
}
