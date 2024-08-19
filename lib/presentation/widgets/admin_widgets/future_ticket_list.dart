import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_ticket/presentation/widgets/admin_widgets/ticket_card.dart';

import '../../../domain/entities/ticket.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/use_cases/common_usecases.dart';

/*
Widget FutureTicketList(CommonInteractor interactor, List<String> tickets) {
  return FutureBuilder<List<Ticket>>(
      future: interactor.retriveUserTicket(tickets),
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
                return TicketCard(item);
              });
        }
      });
}

 */

Widget FutureTicketList(BuildContext context) {
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
        itemCount: user.ticketBought.length,
        itemBuilder: (BuildContext context, int index) {
          final item = user.ticketBought[index];
          return FutureBuilder<Ticket?>(
              future: common.searchTicketById(item),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError || snapshot.data == null) {
                  return const Center(
                      child: Text('Errore nel caricamento dei dati'));
                } else {
                  final product = snapshot.data!;
                  return TicketCard(product);
                }
              });
        });
  }}
  );
}
