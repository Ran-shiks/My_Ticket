
import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:my_ticket/domain/use_cases/common_usecases.dart';

import '../../../domain/entities/event.dart';
import 'event_card.dart';

//------------------------------------------------------------------------------
//  LocationList costruisce una lista di Eventi partendo da uno Stream.
//  Utilizza Un Common Interactor e poi un Admin Interactor
//
//------------------------------------------------------------------------------

Widget StreamEventList(CommonInteractor interactor) {
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

//------------------------------------------------------------------------------
//  LocationList costruisce una lista di Eventi filtrata partendo da uno Stream filtrato.
//  Utilizza Un Common Interactor e poi un Admin Interactor
//
//------------------------------------------------------------------------------

Widget StreamEventListFiltered(CommonInteractor interactor, field, value) {
  return StreamBuilder<List<Event>>(
      stream: interactor.streamOfEventFilteredisGreaterThanOrEqualTo(field, value),
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