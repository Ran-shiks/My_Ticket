
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/event.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/use_cases/common_usecases.dart';
import 'event_card.dart';



/*
Widget FutureEventList(CommonInteractor interactor, List<String> events) {
  return FutureBuilder<List<Event>>(
      future: interactor.retriveUserEvent(events),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Errore nel caricamento dei dati'));
        } else {
          final products = snapshot.data;
          return ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: products!.length,
              itemBuilder: (BuildContext context, int index) {
                final item = products[index];
                return EventCard(item);
              });
        }
      });
}

 */


Widget FutureEventList(BuildContext context) {
  var common = context.read<CommonInteractor>();
  return StreamBuilder<User?>(
      stream: common.streamUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError || snapshot.data == null) {
          return const Center(
              child: Text('Errore nel caricamento dei dati'));
        } else {
          var user = snapshot.data!;
          return ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: user.eventsFavorite.length,
              itemBuilder: (BuildContext context, int index) {
                final item = user.eventsFavorite[index];
                return FutureBuilder<Event?>(
                    future: common.searchEventById(item),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError || snapshot.data == null) {
                        return const Center(
                            child: Text('Errore nel caricamento dei dati'));
                      } else {
                        final product = snapshot.data!;
                        return EventCard(product);
                      }
                    });
              });
        }}
  );
}