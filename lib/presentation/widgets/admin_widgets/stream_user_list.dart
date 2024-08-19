import 'package:flutter/material.dart';
import 'package:my_ticket/presentation/widgets/admin_widgets/user_card.dart';

import '../../../domain/entities/user.dart';

Widget StreamUserList(admin) {
  return StreamBuilder<List<User>>(
      stream: admin.streamOfUser(),
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
                return PeopleCard(item);
              });
        }
      });


}