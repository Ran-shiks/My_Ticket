
import 'package:flutter/material.dart';
import 'package:my_ticket/presentation/widgets/admin_widgets/user_card.dart';

Widget StaticUserList(list) {
  return ListView.separated(
    scrollDirection: Axis.horizontal,
    padding: const EdgeInsets.all(8),
    itemCount: list.length,
    itemBuilder: (BuildContext context, int index) {
      return Container(
        height: 50,
        color: Colors.amber,
        child: PeopleCard(list[index]),
      );
    },
    separatorBuilder: (BuildContext context, int index) => const Divider(),
  );
}