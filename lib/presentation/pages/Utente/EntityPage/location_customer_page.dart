import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_ticket/core/router/app_router.dart';

import '../../../../core/resources/constants/constants.dart';
import '../../../../domain/entities/event.dart';
import '../../../../domain/entities/location.dart';
import '../../../../domain/use_cases/common_usecases.dart';

@RoutePage()
class LocationInfoCustomerPage extends StatefulWidget {
  const LocationInfoCustomerPage({super.key, required this.location});

  final Location location;

  @override
  State<LocationInfoCustomerPage> createState() =>
      _LocationInfoCustomerPageState();
}

class _LocationInfoCustomerPageState extends State<LocationInfoCustomerPage> {
  @override
  @override
  Widget build(BuildContext context) {
    var common = context.read<CommonInteractor>();
    return Scaffold(
        backgroundColor: background,
        appBar: AppBar(),
        body: Container(
          color: background,
          child: ListView(shrinkWrap: true, children: [
            Container(
              decoration: BoxDecoration(
                  color: primary,
                  border: Border.all(
                    color: secondary,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(20))),
              height: 50,
              child: FittedBox(
                  fit: BoxFit.fitHeight,
                  child: Text(
                    widget.location.name,
                  )),
            ),
            const Divider(
              height: 2,
            ),
            Container(
              decoration: BoxDecoration(
                  color: primary,
                  border: Border.all(
                    color: secondary,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(20))),
              width: MediaQuery.of(context).size.width,
              height: 400,
              child: const Icon(
                Icons.place,
                size: 300,
              ),
            ),
            const Divider(
              height: 2,
            ),
            Container(
              decoration: BoxDecoration(
                  color: primary,
                  border: Border.all(
                    color: secondary,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(20))),
              width: MediaQuery.of(context).size.width,
              height: 100,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(widget.location.address),
              ),
            ),
            const Divider(
              height: 2,
            ),
            Container(
              decoration: BoxDecoration(
                  color: primary,
                  border: Border.all(
                    color: secondary,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(20))),
              height: 50,
              child: const FittedBox(
                  fit: BoxFit.fitHeight, child: Text("Future Events")),
            ),
            const Divider(
              height: 2,
            ),
            Container(
                decoration: BoxDecoration(
                    color: primary,
                    border: Border.all(
                      color: secondary,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(20))),
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: widget.location.calendar.keys.toList().length,
                    itemBuilder: (context, index) {
                      return Container(
                        height: 40,
                        decoration: BoxDecoration(
                            color: primary,
                            border: Border.all(
                              color: secondary,
                            ),
                            borderRadius:
                            const BorderRadius.all(Radius.circular(20))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              child: Text(widget.location.calendar.values
                                  .toList()[index]
                                  .toDate()
                                  .toIso8601String()),
                            ),
                            Container(
                                child: FutureBuilder<Event?>(
                                  future: common.searchEventById(widget
                                      .location.calendar.keys
                                      .toList()[index]),
                                  builder: (context, async) {
                                    if (async.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    } else if (async.hasError || async.data == null) {
                                      return const Center(
                                          child: Text(
                                              'Errore nel caricamento dei dati'));
                                    } else {
                                      var event = async.data!;
                                      return Container(
                                        child: Row(
                                          children: [
                                            Text(event.name),
                                            IconButton(
                                                onPressed: () {
                                                  context.router.push(EventInfoCustomerRoute(event: event));
                                                },
                                                icon: const Icon(Icons.info_outline))
                                          ],
                                        ),

                                      );
                                    }
                                  },
                                ))
                          ],
                        ),
                      );
                    })),
          ]),
        ));
  }
}
