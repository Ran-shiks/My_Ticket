import 'package:flutter/material.dart';

import '../../domain/entities/event.dart';

class cardEvent extends StatefulWidget {
  final Event event;

  const cardEvent({
    super.key,
    required this.event,
  });

  @override
  State<cardEvent> createState() => _cardEventState();
}

class _cardEventState extends State<cardEvent> {
  bool isFavourite = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 200,
      color: Colors.blue,
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Image.network(widget.event.imagepath),
          Text(widget.event.name),
          Text(widget.event.credits),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _prefIconButton(context),
            ],
          )
        ],
      ),
    );
  }

  Widget _prefIconButton(BuildContext context) =>
      IconButton(
        onPressed: () {
          setState(() {
            isFavourite = !isFavourite;
          });
        },
        icon: isFavourite
            ? const Icon(
                Icons.favorite,
                color: Colors.red,
              )
            : const Icon(Icons.favorite_outline),
      );
}
