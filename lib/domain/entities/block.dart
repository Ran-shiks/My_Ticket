import 'package:equatable/equatable.dart';

class Block extends Equatable {
  final String? id;
  final int nBlock;
  final int totalSeats;
  final int numberOfColumns;
  final List<String> seats;

  Block({
    this.id,
    required this.nBlock,
    required this.totalSeats,
    required this.numberOfColumns,
    List<String>? seats,
  }) : seats = seats ?? createSeats(nBlock, totalSeats, numberOfColumns);

  static List<String> createSeats(int nBlock ,int totalSeats, int numberOfColumns) {
    final List<String> generatedSeats = [];
    int seatNumber = 1;

    for (int row = 1; row <= (totalSeats/numberOfColumns).ceil(); row++) {
      for (int column = 1; column <= numberOfColumns && seatNumber <= totalSeats; column++) {
        generatedSeats.add("$seatNumber - $row - $column");
        seatNumber++;
      }
    }
    return generatedSeats;
  }

  Block copyWith({
    String? id,
    int? nBlock,
    int? totalSeats,
    int? numberOfColumns,
    Map<String, String?>? seats,
  }) {
    return Block(
      id: id ?? this.id,
      nBlock: nBlock ?? this.nBlock,
      totalSeats: totalSeats ?? this.totalSeats,
      numberOfColumns: numberOfColumns ?? this.numberOfColumns,
    );
  }

  @override
  List<Object?> get props => [id, totalSeats, numberOfColumns, seats];
}
