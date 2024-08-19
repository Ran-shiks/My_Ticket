import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/ticket.dart';

class TicketModel extends Equatable {
  final String? id;
  final String event;
  final String seat;
  final String block;
  final String location;
  final double cost;
  final bool used;
  final bool isOccupied;
  String? user;

  TicketModel({
    this.id,
    required this.event,
    required this.seat,
    required this.block,
    required this.location,
    required this.cost,
    required this.used,
    required this.isOccupied,
    this.user
  });

  @override
  List<Object?> get props => [id, cost, isOccupied, user];

  factory TicketModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();

    return TicketModel(
        id: data?['id'],
        event: data?['event'],
        seat: data?['seat'],
        block: data?['block'],
        location: data?['location'],
        cost: data?['cost'],
        used: data?['used'],
        isOccupied: data?['isOccupied'],
        user: data?['user']);
  }

  Map<String, Object?> toFirestore() {
    return {"id": id,"event":event, "seat":seat, "block" : block, "location": location,"cost": cost,"used": used, "isOccupied": isOccupied, "users": user};
  }

  factory TicketModel.fromEntity(Ticket ticket) {
    return TicketModel(
        id: ticket.id,
        event: ticket.event,
        seat: ticket.seat,
        block: ticket.block,
        location: ticket.location,
        cost: ticket.cost,
        used: ticket.used,
        isOccupied: ticket.isOccupied,
        user: ticket.user);
  }

  Ticket toEntity() {
    return Ticket(id: id,event: event, seat:seat, block: block, location: location, used: used, cost: cost, isOccupied: isOccupied, user: user);
  }
}
