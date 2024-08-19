
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:my_ticket/core/router/app_router.dart';
import 'package:my_ticket/domain/use_cases/administrator_usecases.dart';

import '../../../core/resources/constants/constants.dart';
import '../../../domain/entities/location.dart';

//------------------------------------------------------------------------------
//  LocationList costruisce una lista di location partendo da uno stream.
//  Utilizza Un Admin Interactor
//
//------------------------------------------------------------------------------


Widget StreamLocationList(AdminInteractor interactor) {
  return StreamBuilder<List<Location>>(
      stream: interactor.streamOfLocation(),
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
                return LocationCard(item);
              });
        }
      });
}

Widget LocationCard(Location location) {
  return Card(
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
                  Icons.place_outlined,
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
                                      location.name,
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
                                      location.address,
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
                            onPressed: () {
                              admin.deleteLocation(location);
                            },
                            icon: const Icon(Icons.cancel_outlined)),
                        IconButton(
                            onPressed: () {
                              context.router.push(LocationInfoRoute(location: location));
                            },
                            icon: const Icon(Icons.maps_ugc))
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
