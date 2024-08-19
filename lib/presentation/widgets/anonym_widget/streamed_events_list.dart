import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_ticket/core/resources/constants/constants.dart';
import '../../../core/router/app_router.dart';
import '../../../domain/entities/event.dart';
import '../../../domain/use_cases/common_usecases.dart';

class EventListStreamed extends StatelessWidget {
  const EventListStreamed({super.key});
  @override
  Widget build(BuildContext context) {
    var common = context.read<CommonInteractor>();

    return StreamBuilder<List<Event>>(
        stream: common.streamOfEvents(),
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
                  return EventCard(item);
                }, gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2));
          }
        });
  }
}

Widget EventCard(Event event) {
  return Card(
    color: primary,
    elevation: 8,
    child: Builder(builder: (context) {
      return SizedBox(
        height: MediaQuery.of(context).size.height,
        width: 200,
        child: Column(
          children: <Widget>[
            Container(
              width:MediaQuery.of(context).size.width,
              height: 120,
              decoration: BoxDecoration(
                color: primary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
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
                Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.black54.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Text(event.name),
                        Text(
                          event.description,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12.0,
                            color: Colors.black54,
                          ),
                        ),
                        Text(event.credits),

                      ],
                    )),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: secondary,
                          foregroundColor: background,
                        ),
                        onPressed: () => context.router.push(EventRoute(event: event)),
                        child: const Text("Dettagli"),
                      ),

                    ],
                  ),
                )
              ],
            ),
      );
    }),
  );
}
