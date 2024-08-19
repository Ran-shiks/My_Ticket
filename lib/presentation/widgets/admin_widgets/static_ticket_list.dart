
import 'package:flutter/material.dart';
import 'package:my_ticket/core/resources/constants/constants.dart';
import 'package:my_ticket/presentation/widgets/admin_widgets/ticket_card.dart';


Widget StaticTicketList(list) {
  return ListView.separated(
    scrollDirection: Axis.horizontal,
    padding: const EdgeInsets.all(8),
    itemCount: list.length,
    itemBuilder: (BuildContext context, int index) {
      return Container(
        height: 50,
        color: secondary,
        child: TicketCard(list[index]),
      );
    },
    separatorBuilder: (BuildContext context, int index) => const Divider(),
  );
}