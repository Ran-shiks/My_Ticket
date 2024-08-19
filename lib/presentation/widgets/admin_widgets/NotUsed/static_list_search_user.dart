import 'package:flutter/material.dart';

import '../../../../domain/entities/user.dart';

Widget UserList(list, Function function1, Function function2) {
  return ListView.separated(
    scrollDirection: Axis.horizontal,
    padding: const EdgeInsets.all(8),
    itemCount: list.length,
    itemBuilder: (BuildContext context, int index) {
      return Container(
        height: 50,
        color: Colors.amber,
        child: PeopleCard(list[index], function1, function2),
      );
    },
    separatorBuilder: (BuildContext context, int index) => const Divider(),
  );
}

Widget PeopleCard(User user, Function function1, Function function2) {
  return Card(
    color: Colors.red,
    elevation: 8,
    child: Builder(builder: (context) {
      return SizedBox(
        height: MediaQuery.of(context).size.height,
        width: 200,
        child: Center(
            child: Column(
          children: <Widget>[
            Container(child: const Icon(Icons.person, size: 200),),
            Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.black54.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Text(user.name),
                    Text(
                      user.surname,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12.0,
                        color: Colors.black54,
                      ),
                    ),
                    Text(user.email),
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              function1;
                            },
                            icon: const Icon(Icons.add)),
                        IconButton(
                            onPressed: () {
                              function2;
                            },
                            icon: const Icon(Icons.delete)),
                        Text(user.getRoleString())
                      ],
                    )
                  ],
                )),
          ],
        )),
      );
    }),
  );
}
