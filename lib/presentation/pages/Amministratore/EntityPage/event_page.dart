import 'package:auto_route/auto_route.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_ticket/domain/use_cases/common_usecases.dart';

import '../../../../core/resources/constants/constants.dart';
import '../../../../core/router/app_router.dart';
import '../../../../domain/entities/block.dart';
import '../../../../domain/entities/event.dart';
import '../../../../domain/entities/location.dart';

@RoutePage()
class EventInfoPage extends StatefulWidget {
  const EventInfoPage({super.key, required this.event});

  final Event event;

  @override
  State<EventInfoPage> createState() => _EventInfoPageState();
}

class _EventInfoPageState extends State<EventInfoPage> {
  Location? chosedLocation;
  Block? chosedBlock;
  List<String> selectedTickets = [];

  void _selectTicket(String seat) {
    setState(() {
      if (selectedTickets.contains(seat)) {
        selectedTickets.remove(seat);
      } else {
        selectedTickets.add(seat);
        Fimber.e("selected $seat");
      }
    });
  }

  void _selectLocation(Location location) {
    setState(() {
      if(chosedLocation == location){
        chosedLocation = null;
      } else {
        chosedLocation = location;
        chosedBlock = null;
        selectedTickets.clear();
      }
    });
  }

  void _selectBlock(Block block) {
    setState(() {
      if(chosedBlock == block){
        chosedBlock = null;
      } else {
        chosedBlock = block;
        selectedTickets.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var common = context.read<CommonInteractor>();
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {

          for (var element in selectedTickets) {

            var plusCost = 0.0;

            if (widget.event.blockCost.containsKey(chosedBlock)){
              plusCost = widget.event.blockCost[chosedBlock]!;
            }

            common.buyTicket(widget.event, element, chosedBlock!.id!, chosedLocation!.id!,widget.event.baseCost + plusCost, null);
          }


        },

      ),
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
      ),
      body: Container(
        color: background,
        child: ListView(
          shrinkWrap: true,
          children: [
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
                      widget.event.name,
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
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  widget.event.imagepath,
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
                child: Text(widget.event.description),
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
                  fit: BoxFit.fitHeight,
                  child: Text(
                   "Locations"
                  )),
            ),
            const Divider(
              height: 2,
            ),
            Container(
                decoration: BoxDecoration(
                    color: secondary,
                    border: Border.all(
                      color: secondary,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(20))),
                width: MediaQuery.of(context).size.width,

                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: widget.event.locations.length,
                    itemBuilder: (context, index) {
                      return FutureBuilder(
                        future: common
                            .searchLocationById(widget.event.locations[index]),
                        builder: (BuildContext context,
                            AsyncSnapshot<Location?> async) {
                          if (async.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (async.hasError || async.data == null) {
                            return const Center(
                                child: Text('Errore nel caricamento dei dati'));
                          } else {
                            final location = async.data!;
                            return Container(
                              decoration: BoxDecoration(
                                  color: primary,
                                  border: Border.all(
                                    color: secondary,
                                  ),
                                  borderRadius: const BorderRadius.all(Radius.circular(20))),
                              child: ListTile(
                                selected: chosedLocation == location,
                                onTap: () => _selectLocation(location),
                                tileColor: primary,
                                leading: const Icon(Icons.place_outlined),
                                title: Text(
                                    location.name),
                                subtitle: Text(location.address),
                                trailing:
                                    IconButton(
                                        onPressed: () {
                                          context.router.push(LocationInfoRoute(location: location));
                                        },
                                        icon: const Icon(Icons.info_outline_rounded)),
                              ),
                            );
                          }
                        },
                      );
                    })),

            Container(
              decoration: BoxDecoration(
                  color: primary,
                  border: Border.all(
                    color: secondary,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(20))),
              height: 50,
              child: const FittedBox(
                  fit: BoxFit.fitHeight,
                  child: Text(
                      "Blocchi Disponibili"
                  )),
            ),

            if (chosedLocation != null) Container(
                decoration: BoxDecoration(
                    color: secondary,
                    border: Border.all(
                      color: secondary,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(20))),
                width: MediaQuery.of(context).size.width,

                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: chosedLocation!.blocks.length,
                    itemBuilder: (context, index) {
                      return FutureBuilder(
                        future: common
                            .searchBlockById(chosedLocation!.blocks[index]),
                        builder: (BuildContext context,
                            AsyncSnapshot<Block?> async) {
                          if (async.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (async.hasError || async.data == null) {
                            return const Center(
                                child: Text('Errore nel caricamento dei dati'));
                          } else {
                            final block = async.data!;
                            return Container(
                              decoration: BoxDecoration(
                                  color: primary,
                                  border: Border.all(
                                    color: secondary,
                                  ),
                                  borderRadius: const BorderRadius.all(Radius.circular(20))),
                              child: ListTile(
                                selected: chosedBlock == block,
                                onTap: () => _selectBlock(block),
                                tileColor: primary,
                                leading: const Icon(Icons.place_outlined),
                                title: Text(
                                    block.nBlock.toString()),
                                subtitle: Text(block.totalSeats.toString()),
                              ),
                            );
                          }
                        },
                      );
                    })),

            Container(
              decoration: BoxDecoration(
                  color: primary,
                  border: Border.all(
                    color: secondary,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(20))),
              height: 50,
              child: const FittedBox(
                  fit: BoxFit.fitHeight,
                  child: Text(
                      "Posti Disponibili"
                  )),
            ),

            if (chosedBlock != null && chosedLocation != null) Container(
              decoration: BoxDecoration(
                  color: primary,
                  border: Border.all(
                    color: secondary,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(20))),
              child: gridSeat(chosedBlock!),
            ),

            const Divider(
              height: 2,
            ),
          ],
        ),
      ),
    );
  }

  Widget gridSeat(Block block) {
    var seats = block.seats;
    seats.sort((a, b) =>
        int.parse(a.split(' ').first).compareTo(int.parse(b.split(' ').first)));

    return Container(
      height: 400,
      color: background,
      width: MediaQuery.of(context).size.width,
      child: GridView.builder(
        itemCount: block.totalSeats,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: block.numberOfColumns,
        ),
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.all(4),
        itemBuilder: (context, index) {
          return TicketHolder(
                seats[index],
                selectedTickets.contains(seats[index]),
                !widget.event.tickets.containsValue(seats[index]),
          );
        },
      ),
    );
  }

  Widget TicketHolder(String seat, bool selected, bool available) {
    return InkWell(
      onTap:() => _selectTicket(seat),
      child: Card(
        color: selected || !available ? primary : secondary,
        elevation: 5,
        child: FittedBox(
          fit: BoxFit.fitWidth,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: Text(
                      seat,
                      style: const TextStyle(color: Colors.black),
                    ),
                ),
          ),
        ),
      ),
    );
  }
}
