import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Location extends Equatable {
  final String? id;
  final String name;
  final String address;
  final List<String> blocks;

  final Map<String, Timestamp> calendar;



  Location({
    this.id,
    required this.name,
    required this.address,
    List<String>? blocks,
    Map<String, Timestamp>? calendar,
  }) : blocks = blocks ?? [],
      calendar = calendar ?? {};

  Location copyWith({
    String? id,
    String? name,
    String? address,
    List<String>? blocks,
    Map<String, Timestamp>? calendar,
  }) {
    return Location(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      blocks: blocks ?? this.blocks,
      calendar: calendar ?? this.calendar
    );
  }

  @override
  List<Object?> get props => [id, address, name, blocks];
}
