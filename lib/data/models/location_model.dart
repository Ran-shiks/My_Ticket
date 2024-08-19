import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/location.dart';

class LocationModel extends Equatable {
  final String? id;
  final String address;
  final String name;
  final List<String> blocks;
  final Map<String, Timestamp> calendar;

  LocationModel({
    this.id,
    required this.name,
    required this.address,
    List<String>? blocks,
    Map<String, Timestamp>? calendar,
  }) : blocks = blocks ?? [],
        calendar = calendar ?? {};

  @override
  List<Object?> get props => [
        id,
        address,
        name,
      ];

  factory LocationModel.fromFirestone(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    final calendarData = data?['calendar'] as Map<String, dynamic>?;
    final calendar = calendarData?.map((key, value) => MapEntry(key, value as Timestamp)) ?? {};

    return LocationModel(
        id: data?['id'],
        name: data?['name'],
        address: data?['address'],
        blocks: List<String>.from(data?['blocks'] ?? []),
        calendar: calendar,
    );
  }

  Map<String, Object?> toFirestore() {
    return {
      "id": id,
      "name": name,
      "address": address,
      "blocks": blocks,
      "calendar":calendar
    };
  }

  factory LocationModel.fromEntity(Location location) {
    return LocationModel(
        id: location.id,
        name: location.name,
        address: location.address,
        blocks: location.blocks,
        calendar: Map.from(location.calendar)
    );
  }

  Location toEntity() {
    return Location(
      id: id,
      name: name,
      address: address,
      blocks: blocks,
      calendar: Map.from(calendar)
    );
  }
}
