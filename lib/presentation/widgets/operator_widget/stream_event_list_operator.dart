
import 'package:flutter/material.dart';
import 'package:my_ticket/domain/use_cases/administrator_usecases.dart';

import '../../../domain/entities/event.dart';
import 'event_card_operator.dart';

//------------------------------------------------------------------------------
//  LocationList costruisce una lista di Eventi partendo da uno Stream.
//  Utilizza Un Common Interactor e poi un Admin Interactor
//
//------------------------------------------------------------------------------

Widget StreamEventListOperator(AdminInteractor interactor) {
  return StreamBuilder<List<Event>>(
      stream: interactor.streamOfLocationForOperator(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Errore nel caricamento dei dati'));
        } else {
          final products = snapshot.data;
          return GridView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: products!.length,
              itemBuilder: (BuildContext context, int index) {
                final item = products[index];
                return EventCardOperator(item);
              }, gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.7),);
        }
      });
}
