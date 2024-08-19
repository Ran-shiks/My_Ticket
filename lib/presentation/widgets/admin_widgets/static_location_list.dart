
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_ticket/domain/use_cases/common_usecases.dart';

import '../../../domain/entities/location.dart';

//------------------------------------------------------------------------------
//  LocationList costruisce una lista di location partendo da una lista.
//  Utilizza Un Common Interactor
//
//------------------------------------------------------------------------------

class LocationList extends StatelessWidget {
  const LocationList({super.key, required this.idLocation});
  final List<String> idLocation;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: idLocation.length,
        itemBuilder: (BuildContext context, int index) {
          final item = idLocation[index];
          return LocationCard(item, context);
        });
  }
}

Widget LocationCard(String location, BuildContext context) {
  final common = context.read<CommonInteractor>();
  return Card(
    color: Colors.red,
    elevation: 8,
    child: FutureBuilder(
      future: common.searchLocationById(location),
      builder: (BuildContext context, AsyncSnapshot<Location?> async) {
        if (async.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (async.hasError || async.data == null) {
          return const Center(child: Text('Errore nel caricamento dei dati'));
        } else {
          final location = async.data!;
          return LocationInfo(location: location,);
        }
      },
    ),
  );
}

class LocationInfo extends StatelessWidget {
  const LocationInfo({super.key, required this.location});

  final Location location;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: 200,
      child: Center(
          child: Column(
            children: <Widget>[
              Container(
                child: const Icon(Icons.event_seat_sharp, size: 100),
              ),
              Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.black54.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Text(location.name),
                      Text(
                        location.address,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12.0,
                          color: Colors.black54,
                        ),
                      ),
                      Text(location.blocks.length.toString()),
                      Row(
                        children: [
                          IconButton(
                              onPressed: () {
                              },
                              icon: const Icon(Icons.cancel_outlined)),
                          IconButton(
                              onPressed: () async {
                                //context.router.push(LocationRoute(location:location));
                              },
                              icon: const Icon(Icons.maps_ugc))
                        ],
                      )
                    ],
                  )),
            ],
          )),
    );
  }
}
