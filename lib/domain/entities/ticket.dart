import 'package:equatable/equatable.dart';

class Ticket extends Equatable {
  final String? id;
  final String event;
  final String seat;
  final String block;
  final String location;
  final double cost;
  final bool isOccupied;
  final bool used;
  final String? user;

  const Ticket({
    this.id,
    required this.event,
    required this.seat,
    required this. block,
    required this.location,
    required this.cost,
    required this.used,
    required this.isOccupied,
    String? user,
  }) : user = user;

  Ticket copyWith({
    String? id,
    String? event,
    String? seat,
    String? block,
    String? location,
    double? cost,
    bool? used,
    bool? isOccupied,
    String? user,
  }) {
    return Ticket(
      id: id ?? this.id,
      event: event ?? this.event,
      seat: seat ?? this.seat,
      block: block ?? this.block,
      location: location ?? this.location,
      cost: cost ?? this.cost,
      used: used ?? this.used,
      isOccupied: isOccupied ?? this.isOccupied,
      user: user ?? this.user,
    );
  }

  bool isAvailable() {
    return !isOccupied;
  }

  @override
  List<Object?> get props => [id,event,seat, cost, isOccupied, user];
}
