import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:my_ticket/domain/entities/user.dart';

class Event extends Equatable {
  final String? id;
  final String name;
  final String description;
  final double baseCost;
  final String credits;
  final String imagepath;
  final Timestamp startdate;
  final int favCounter;

  final Map<String, double> blockCost;
  final List<String> locations;
  final List<String> operators;
  final Map<String, String> tickets;

  Event({
    this.id,
    required this.name,
    required this.startdate,
    required this.credits,
    required this.baseCost,
    required this.description,
    required this.imagepath,
    required this.favCounter,
    List<String>? locations,
    List<String>? operators,
    Map<String, String>? tickets,
    Map<String, double>? blockCost,
  })  : locations = locations ?? [],
        operators = operators ?? [],
        tickets = tickets ?? {},
        blockCost = blockCost ?? {};

  Event copyWith({
    String? id,
    String? name,
    Timestamp? startdate,
    double? baseCost,
    String? credits,
    String? description,
    String? imagepath,
    int? favCounter,
    List<String>? locations,
    List<String>? operators,
    Map<String, String>? tickets,
  }) {
    return Event(
      id: id ?? this.id,
      name: name ?? this.name,
      startdate: startdate ?? this.startdate,
      baseCost: baseCost ?? this.baseCost,
      credits: credits ?? this.credits,
      favCounter: favCounter ?? this.favCounter,
      description: description ?? this.description,
      locations: locations ?? this.locations,
      operators: operators ?? this.operators,
      tickets: tickets ?? this.tickets,
      imagepath: imagepath ?? this.imagepath,
    );
  }

  void addOperator(User user) => operators.add(user.uid);
  void cancelOperator(User user) => operators.add(user.uid);

  String formattedStartDate() {
    final date = startdate.toDate();
    return "${date.day}-${date.month}-${date.year}";
  }

  @override
  List<Object?> get props => [name, description,baseCost, credits, imagepath, startdate];
}
