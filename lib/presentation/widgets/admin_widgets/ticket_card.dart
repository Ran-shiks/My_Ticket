
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_ticket/domain/use_cases/common_usecases.dart';

import '../../../core/resources/constants/constants.dart';
import '../../../core/router/app_router.dart';
import '../../../domain/entities/ticket.dart';
import '../../../domain/use_cases/administrator_usecases.dart';

Widget TicketCard(Ticket ticket) {
  return Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30.0),
    ),
    color: secondary,
    elevation: 8,
    child: Builder(builder: (context) {
      var common = context.read<CommonInteractor>();

      return SizedBox(
        height: MediaQuery.of(context).size.height,
        width: 200,
        child: Center(
            child: Column(
              children: <Widget>[

                const Icon(
                  Icons.event_available_outlined,
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
                                    fit: BoxFit.fitWidth,
                                    child: Text(
                                      ticket.event,
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
                                    child: Text("Posto: ${ticket.seat}",
                                    )),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width,

                              child: Text(
                                ticket.cost.toString(),
                                textAlign: TextAlign.center,
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
                              common.CancelTicket(ticket);
                            },
                            icon: const Icon(Icons.cancel_outlined)),
                        IconButton(
                            onPressed: () {
                              context.router.push(TicketInfoAdminRoute(ticket: ticket));
                            },
                            icon: const Icon(Icons.insert_drive_file_outlined)),
                        IconButton(
                            onPressed: () async {

                              common.searchEventById(ticket.event).then((value) {
                                if(value != null) return context.router.push(EventInfoRoute(event: value));
                              });

                            },
                            icon: const Icon(Icons.info_outline))
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