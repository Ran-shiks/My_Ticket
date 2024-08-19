import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/resources/constants/constants.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/use_cases/administrator_usecases.dart';

Widget PeopleCard(User user) {
  return Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30.0),
    ),
    color: secondary,
    elevation: 8,
    child: Builder(builder: (context) {
      var admin = context.read<AdminInteractor>();

      return SizedBox(
        height: MediaQuery.of(context).size.height,
        width: 200,
        child: Center(
            child: Column(
              children: <Widget>[

                const Icon(
                  Icons.person,
                  size: 120,
                  color: primary,
                ),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: primary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 30),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: 30,
                                child: FittedBox(
                                    fit: BoxFit.fitHeight,
                                    child: Text(
                                      user.name,
                                    )),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 30),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: 20,
                                child: FittedBox(
                                    fit: BoxFit.fitHeight,
                                    child: Text(
                                      user.surname,
                                    )),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 30),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: 20,
                                child: FittedBox(
                                    fit: BoxFit.fitHeight,
                                    child: Text(
                                      user.email,
                                    )),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 30),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: 30,
                                child: FittedBox(
                                    fit: BoxFit.fitHeight,
                                    child: Text(
                                      user.getRoleString(),
                                    )),
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 30),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: 30,
                                child: FittedBox(
                                    fit: BoxFit.fitHeight,
                                    child: Text(
                                      user.ticketBought.length.toString(),
                                    )),
                              ),
                            ),


                          ],
                        )),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                            onPressed: () async {
                              admin.updateRole(user, 1);
                            },
                            icon: const Icon(Icons.arrow_upward)),
                        IconButton(
                            onPressed: () async {
                              admin.updateRole(user, 2);
                            },
                            icon: const Icon(Icons.arrow_downward)),
                        IconButton(
                            onPressed: () async {
                              //Non so
                            },
                            icon: const Icon(Icons.info))
                      ],
                    ),
                  ),
                )
              ],
            )),
      );
    }),
  );
}