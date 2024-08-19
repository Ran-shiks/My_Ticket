import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:my_ticket/domain/entities/block.dart';

class BlockModel extends Equatable {
  final String? id;
  final int nBlock;
  final int totalSeats;
  final int numberOfColumns;
  final List<String> seats;

  const BlockModel({
    this.id,
    required this.nBlock,
    required this.totalSeats,
    required this.numberOfColumns,
    required this.seats
  });

  @override
  List<Object?> get props => [id, totalSeats, numberOfColumns];

  factory BlockModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();

    return BlockModel(
        id: data?['id'],
        nBlock: data?['nBlock'],
        totalSeats: data?['totalSeats'],
        numberOfColumns: data?['numberOfColumns'],
        seats: List<String>.from(data?['seats'] ?? []),
    );
  }

  Map<String, Object?> toFirestore() {
    return {
      "id": id,
      "nBlock": nBlock,
      "totalSeats": totalSeats,
      "numberOfColumns": numberOfColumns,
      "seats": seats
    };
  }

  factory BlockModel.fromEntity(Block block) {
    return BlockModel(
        id: block.id,
        nBlock: block.nBlock,
        totalSeats: block.totalSeats,
        numberOfColumns: block.numberOfColumns,
        seats: block.seats
    );
  }

  Block toEntity() {
    return Block(
        id: id,
        nBlock: nBlock,
        totalSeats: totalSeats,
        numberOfColumns: numberOfColumns,
        seats : seats
    );
  }
}
