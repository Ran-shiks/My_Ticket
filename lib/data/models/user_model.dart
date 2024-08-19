import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as fire;

import '../../domain/entities/user.dart';

class UserModel extends Equatable {
  final String uid;

  final String email;
  final String name;
  final String surname;
  final String imageUrl;
  final int role;
  final double balance;

  final List<String> ticketBought;
  final List<String> eventsFavorite;

  UserModel({
    required this.uid,
    required this.name,
    required this.surname,
    required this.email,
    required this.balance,
    required this.imageUrl,
    required this.role,
    List<String>? ticketBought,
    List<String>? eventsFavorite,
  })  : ticketBought = ticketBought ?? [],
        eventsFavorite = eventsFavorite ?? [];

  factory UserModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return UserModel(
        uid: data?['uid'],
        name: data?['name'],
        surname: data?['surname'],
        email: data?['email'],
        balance: data?['balance'],
        imageUrl: data?['imageUrl'],
        role: data?['role'],
        ticketBought: List<String>.from(data?['ticketBought'] ?? []),
        eventsFavorite: List<String>.from(data?['eventsFavorite'] ?? []));
  }

  Map<String, Object?> toFirestore() {
    return {
      "uid": uid,
      "email": email,
      "name": name,
      "surname": surname,
      "balance": balance,
      "imageUrl": imageUrl,
      "role": role,
      "ticketBought": ticketBought,
      "eventsFavorite": eventsFavorite
    };
  }

  @override
  List<Object?> get props => [uid, name, surname, email, imageUrl, role];

  static UserModel? fromFireUser(fire.User? user) {
    if (user == null) {
      return null;
    }
    return UserModel(
      uid: user.uid,
      email: user.email ?? " ",
      name: user.displayName ?? " ",
      balance: 0.0,
      surname: " ",
      imageUrl: user.photoURL ?? " ",
      role: 2,
    );
  }

  factory UserModel.fromEntity(User user) {
    return UserModel(
        uid: user.uid,
        email: user.email,
        name: user.name,
        balance: user.balance,
        surname: user.surname,
        imageUrl: user.imageUrl,
        role: user.role.index,
        ticketBought: user.ticketBought,
        eventsFavorite: user.eventsFavorite);
  }

  User toEntity() {
    return User(
        uid: uid,
        name: name,
        balance: balance,
        surname: surname,
        email: email,
        imageUrl: imageUrl,
        role: Role.values[role],
        eventsFavorite: eventsFavorite,
        ticketBought: ticketBought);
  }
}
