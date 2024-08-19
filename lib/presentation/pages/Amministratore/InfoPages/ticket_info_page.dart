import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../core/resources/constants/constants.dart';
import '../../../../domain/entities/ticket.dart';
import '../../../../domain/use_cases/common_usecases.dart';

@RoutePage()
class TicketInfoAdminPage extends StatefulWidget {
  const TicketInfoAdminPage({super.key, required this.ticket});

  final Ticket ticket;

  @override
  State<TicketInfoAdminPage> createState() => _TicketInfoAdminPageState();
}

class _TicketInfoAdminPageState extends State<TicketInfoAdminPage> {
  @override
  Widget build(BuildContext context) {
    var common = context.read<CommonInteractor>();
    return Scaffold(
        backgroundColor: background,
        appBar: AppBar(
          backgroundColor: background,
        ),
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
                    widget.ticket.event,
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
              child: Center(
                child: QrImageView(
                  data: widget.ticket.id!,
                  size: 300.0,
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
              height: 50,
              child: FittedBox(
                  fit: BoxFit.fitHeight, child: Text(widget.ticket.seat)),
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
              child: FittedBox(
                  fit: BoxFit.fitHeight, child: Text(widget.ticket.cost.toString())),
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
              child: FittedBox(
                  fit: BoxFit.fitHeight, child: Text(widget.ticket.used.toString())),
            ),
          ]),
        ));
  }
}
