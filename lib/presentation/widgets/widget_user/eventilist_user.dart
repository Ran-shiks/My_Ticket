import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:my_ticket/core/resources/constants/constants.dart';
import 'package:my_ticket/domain/use_cases/administrator_usecases.dart';
import 'package:my_ticket/domain/use_cases/common_usecases.dart';
import '../../../core/router/app_router.dart';
import '../../../domain/entities/event.dart';
import '../../../domain/entities/user.dart';

Widget EventList_user(CommonInteractor interactor) {
  return StreamBuilder<List<Event>>(
      stream: interactor.streamOfEvents(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Errore nel caricamento dei dati'));
        } else {
          final products = snapshot.data;
          return ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: products!.length,
              itemBuilder: (BuildContext context, int index) {
                final item = products[index];
                return EventCard_user(item, interactor);
              });
        }
      });
}

Widget EventCard_user(Event event, CommonInteractor interactor) {
  return Card(
      color: primary,
      elevation: 10,
      child: Builder(builder: (context) {
        var common = context.read<CommonInteractor>();
        return GestureDetector(
          onTap: () {
            context.router.push(EventInfoCustomerRoute(event: event));
          },
          child: Row(
            children: <Widget>[
              Container(
                width: 100,
                padding: EdgeInsets.all(5),
                child: ConstrainedBox(
                  child: Image.network(
                    event.imagepath,
                    fit: BoxFit.fill,
                  ),
                  constraints: BoxConstraints(maxHeight: 50, maxWidth: 50),
                ),
              ),
              Column(
                children: [
                  Text(event.name),
                  Text(event.credits),
                  Text(DateTime.now().toUtc().toIso8601String()),
                ],
              ),
              StreamBuilder<User?>(
                  stream: common.streamUser(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.cancel),
                        padding: EdgeInsets.symmetric(horizontal: 30),
                      );
                    } else {
                      var listFavourite = snapshot.data!.eventsFavorite;
                      if(listFavourite.contains(event.id)) {
                        return IconButton(
                          onPressed: () {
                            common.deleteEventFromFavourite(event.id!);
                            common.decrementFavourite(event.id!);
                          },
                          icon: Icon(Icons.favorite, color: selected,),
                          padding: EdgeInsets.symmetric(horizontal: 30),
                        );
                      } else {
                        return IconButton(
                          onPressed: () {
                            common.addEventInFavourite(event.id!);
                            common.incrementFavourite(event.id!);
                          },
                          icon: Icon(Icons.favorite_outline),
                          padding: EdgeInsets.symmetric(horizontal: 30),
                        );
                      }
                    }
                  }),
            ],
          ),
        );
      }),
    );
}
