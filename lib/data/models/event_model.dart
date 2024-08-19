import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/event.dart';

class EventModel extends Equatable {
  final String? id;
  final String name;
  final String description;
  final String credits;
  final double cost;
  final int favCounter;
  final Timestamp startdate;
  final String imagepath;

  final Map<String, double?> blockCost;
  final List<String> locations;
  final List<String> operators;
  final Map<String, String?> tickets;

  EventModel({
    this.id,
    required this.name,
    required this.description,
    required this.credits,
    required this.cost,
    required this.favCounter,
    required this.startdate,
    required this.imagepath,
    List<String>? locations,
    List<String>? operators,
    Map<String, String>? tickets,
    Map<String, double>? blockCost,
  })  : locations = locations ?? [],
        operators = operators ?? [],
        tickets = tickets ?? {},
        blockCost = blockCost ?? {};

  @override
  List<Object?> get props => [
        name,
        description,
        credits,
        cost,
        startdate,
        locations,
        operators,
        imagepath,
      ];

  factory EventModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    final ticketsData = data?["tickets"] as Map<String, dynamic>?;
    final tickets = ticketsData?.map((key, value) => MapEntry(key, value as String)) ?? {};

    final blocksCostData = data?["blockCost"] as Map<String, dynamic>?;
    final blocksCost = blocksCostData?.map((key, value) => MapEntry(key, value as double)) ?? {};


    return EventModel(
        id: data?["id"],
        name: data?["name"],
        startdate: data?["startdate"],
        credits: data?["credits"],
        cost: data?["cost"],
        favCounter: data?["favCounter"],
        description: data?["description"],
        imagepath: data?["imagepath"],
        tickets: tickets,
        blockCost: blocksCost,
        locations: List<String>.from(data?["locations"] ?? []),
        operators: List<String>.from(data?["operators"] ?? [])
    );
  }

  Map<String, Object?> toFirestore() {
    return {
      "id": id,
      "name": name,
      "startdate": startdate,
      "credits": credits,
      "description": description,
      "cost": cost,
      "favCounter":favCounter,
      "imagepath": imagepath,
      "locations": locations,
      "operators": operators,
      "tickets": tickets,
      "blockCost": blockCost
    };
  }

  factory EventModel.fromEntity(Event event) {
    return EventModel(
        id: event.id,
        name: event.name,
        description: event.description,
        credits: event.credits,
        cost: event.baseCost,
        favCounter: event.favCounter,
        startdate: event.startdate,
        imagepath: event.imagepath,
        operators: event.operators,
        locations: event.locations,
        blockCost: Map.from(event.blockCost),
        tickets: Map.from(event.tickets)
    );
  }

  Event toEntity() {
    return Event(
        id: id,
        name: name,
        description: description,
        credits: credits,
        baseCost: cost,
        favCounter: favCounter,
        startdate: startdate,
        imagepath: imagepath,
        locations: locations,
        operators: operators,
        blockCost: Map.from(blockCost),
        tickets: Map.from(tickets)
    );
  }
}
