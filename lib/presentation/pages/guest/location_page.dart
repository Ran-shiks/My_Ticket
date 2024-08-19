import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/resources/constants/constants.dart';
import '../../../domain/entities/location.dart';
import '../../../domain/use_cases/common_usecases.dart';


@RoutePage()
class LocationPage extends StatefulWidget {
  const LocationPage({super.key, required this.location});

  final Location location;

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {


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
              child: const FittedBox(fit: BoxFit.fitHeight, child: Text("Locations")),
            ),
            const Divider(
              height: 2,
            ),
          ]),
        ));
  }
}
