import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/resources/constants/constants.dart';
import '../../../core/router/app_router.dart';
import '../../../domain/entities/event.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/use_cases/administrator_usecases.dart';
import '../../../domain/use_cases/common_usecases.dart';

Widget EventCard(Event event) {
  return Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30.0),
    ),
    color: secondary,
    elevation: 8,
    child: Builder(builder: (context) {
      var admin = context.read<AdminInteractor>();
      var common = context.read<CommonInteractor>();

      return SizedBox(
        height: MediaQuery.of(context).size.height,
        width: 220,
        child: Center(
            child: Column(
          children: <Widget>[

            Container(
              width:MediaQuery.of(context).size.width,
              height: 120,
              decoration: BoxDecoration(
                color: primary,
                borderRadius: BorderRadius.circular(20),
              ),
              child : InkWell(
                onTap: () {
                  context.router.push(EventInfoAdminRoute(event: event));
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    event.imagepath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, object, stack) {
                      return const Icon(
                        Icons.event_seat_sharp,
                        size: 120,
                        color: background,
                      );
                    },

                  ),
                ),
              ),
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
                                  event.name,
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
                                  event.credits,
                                )),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            event.description,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12.0,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ],
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                        onPressed: () {
                          admin.deleteEvent(event);
                        },
                        icon: const Icon(Icons.restore_from_trash)),
                    IconButton(
                        onPressed: () async {
                          context.router.push(EventInfoRoute(event: event));
                        },
                        icon: const Icon(Icons.info_outline_rounded)),
                    StreamBuilder<User?>(
                        stream: common.streamUser(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return IconButton(
                              // TODO logica aggiungi/rimuovi dai preferiti
                              onPressed: () {},
                              icon: Icon(Icons.cancel),

                            );
                          } else {
                            var listFavourite = snapshot.data!.eventsFavorite;
                            if(listFavourite.contains(event.id)) {
                              return TextButton.icon(
                                onPressed: () {
                                  common.deleteEventFromFavourite(event.id!);
                                  common.decrementFavourite(event.id!);
                                },
                                style: ButtonStyle(
                                  foregroundColor: MaterialStatePropertyAll<Color>(background),
                                ),
                                icon: Icon(Icons.favorite),
                                label:Text(event.favCounter.toString()),

                              );
                            } else {
                              return TextButton.icon(
                                onPressed: () {
                                  common.addEventInFavourite(event.id!);
                                  common.incrementFavourite(event.id!);
                                },

                                style: ButtonStyle(
                                  foregroundColor: MaterialStatePropertyAll<Color>(background),
                                ),
                                icon: Icon(Icons.favorite_outline),
                                label: Text(event.favCounter.toString(),),
                              );
                            }
                          }
                        }),
                    IconButton(
                        onPressed: () {
                          common.deleteEventFromFavourite(event.id!);
                        },
                        icon: const Icon(Icons.cancel_outlined)),
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
