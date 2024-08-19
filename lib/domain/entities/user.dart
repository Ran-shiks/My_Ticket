import 'package:equatable/equatable.dart';


class User extends Equatable {
  final String uid;
  final String email;
  final String name;
  final String surname;
  final String imageUrl;
  final double balance;
  final Role role;
  final List<String> ticketBought;
  final List<String> eventsFavorite;

  User({
    required this.uid,
    required this.name,
    required this.surname,
    required this.balance,
    required this.email,
    required this.imageUrl,
    required this.role,
    List<String>? ticketBought,
    List<String>? eventsFavorite,
  })  : ticketBought = ticketBought ?? [],
        eventsFavorite = eventsFavorite ?? [];

  String getRoleString() {
    return role.toString().split('.').last;
  }

  User copyWith({
    String? uid,
    String? email,
    String? name,
    double? balance,
    String? surname,
    String? imageUrl,
    Role? role,
    List<String>? ticketBought,
    List<String>? eventsFavorite,
  }) {
    return User(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      name: name ?? this.name,
      balance: balance ?? this.balance,
      surname: surname ?? this.surname,
      imageUrl: imageUrl ?? this.imageUrl,
      role: role ?? this.role,
      ticketBought: ticketBought ?? this.ticketBought,
      eventsFavorite: eventsFavorite ?? this.eventsFavorite,
    );
  }


  static User isEmpty() {
    return User(
        uid: " ",
        name: " ",
        surname: " ",
        balance: 0.0,
        email: " ",
        imageUrl: " ",
        role: Role.customer);
  }

  @override
  List<Object?> get props =>
      [uid, name, surname, email, imageUrl,balance, role, ticketBought, eventsFavorite];
}

enum Role { admin, operator, customer }
