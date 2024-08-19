import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fimber/fimber.dart';
import 'package:my_ticket/domain/entities/user.dart';
import 'package:my_ticket/domain/repositories/myTicket_database_repositories.dart';

import '../models/user_model.dart';

const String usersCollectionPath = "Users";

class UserDatabaseFirebaseImplementation implements UserDatabaseRepository {
  final FirebaseFirestore firebaseFirestore;

  UserDatabaseFirebaseImplementation({required this.firebaseFirestore});


  /*
  Funzione usata per restituire uno stream di aggiornamenti di un utente
   */
  //------------------------------------------------------------------------
  @override
  Future<User?> searchUserById(String id) async {
    CollectionReference usersCollection =
        firebaseFirestore.collection(usersCollectionPath);

    final users = usersCollection.withConverter<UserModel>(
        fromFirestore: (snapshot, _) => UserModel.fromFirestore(snapshot, _),
        toFirestore: (user, _) => user.toFirestore());

    return users.doc(id).get().then((value) {
      if (value.data() != null) {
        final user = value.data()?.toEntity();
        Fimber.e("User ${user?.name} retrived");
        return user;
      }
      return null;
    });
  }
  //------------------------------------------------------------------------


  /*
  Funzione usata per ottenere tutti gli utenti
   */
  //------------------------------------------------------------------------
  @override
  Future<List<User>> searchUserByEmail(String email) {
    CollectionReference usersCollection =
    firebaseFirestore.collection(usersCollectionPath);

    Future<QuerySnapshot<UserModel>> users = usersCollection
        .withConverter<UserModel>(
        fromFirestore: (snapshot, _) =>
            UserModel.fromFirestore(snapshot, _),
        toFirestore: (user, _) => user.toFirestore())
    .where("email", isEqualTo: email)
        .get();

    return users.then((value) =>
        value.docs.map<User>((doc) => doc.data().toEntity()).toList());
  }
  //------------------------------------------------------------------------

  /*
  Funzione usata solo nella registrazione per creare un documento
  nel database firestone riguardo lo stesso utente
   */
  //------------------------------------------------------------------------
  @override
  Future<void> createUser(User user) async {
    //Entity to Model
    UserModel userModel = UserModel.fromEntity(user);

    //Reference
    CollectionReference usersCollection =
        firebaseFirestore.collection(usersCollectionPath);

    var users = usersCollection.withConverter<UserModel>(
        fromFirestore: (snapshot, _) => UserModel.fromFirestore(snapshot, _),
        toFirestore: (user, _) => user.toFirestore());

    //Operation
    await users.doc(userModel.uid).set(userModel).then((value) {
      Fimber.e("User ${userModel.name} Added");
    });
  }
  //------------------------------------------------------------------------

  /*
  Funzione usata per eliminare un documento
  nel database firestone riguardo un utente
   */
  //------------------------------------------------------------------------
  @override
  Future<void> deleteUser(User user) async {
    //Entity to Model
    UserModel userModel = UserModel.fromEntity(user);

    //Collection Reference
    CollectionReference usersCollection =
        firebaseFirestore.collection(usersCollectionPath);

    //Converter
    var users = usersCollection.withConverter<UserModel>(
        fromFirestore: (snapshot, _) => UserModel.fromFirestore(snapshot, _),
        toFirestore: (user, _) => user.toFirestore());

    //Operation
    await users.doc(userModel.uid).delete().then((value) {
      Fimber.e("User ${userModel.name} Deleted");
    });
  }
  //------------------------------------------------------------------------

  /*
  Funzione usata per ottenere tutti gli utenti
   */
  //------------------------------------------------------------------------
  @override
  Stream<List<User>> streamOfUser() {
    CollectionReference usersCollection =
        firebaseFirestore.collection(usersCollectionPath);

    Stream<QuerySnapshot<UserModel>> users = usersCollection
        .withConverter<UserModel>(
            fromFirestore: (snapshot, _) =>
                UserModel.fromFirestore(snapshot, _),
            toFirestore: (user, _) => user.toFirestore())
        .snapshots();

    return users.map((snapshot) =>
        snapshot.docs.map<User>((doc) => doc.data().toEntity()).toList());
  }
  //------------------------------------------------------------------------

  /*
  Funzione usata per ottenere tutti gli utenti
   */
  //------------------------------------------------------------------------
  @override
  Future<List<User>> listOfUser() {
    CollectionReference usersCollection =
        firebaseFirestore.collection(usersCollectionPath);

    Future<QuerySnapshot<UserModel>> users = usersCollection
        .withConverter<UserModel>(
            fromFirestore: (snapshot, _) =>
                UserModel.fromFirestore(snapshot, _),
            toFirestore: (user, _) => user.toFirestore())
        .get();

    return users.then((value) =>
        value.docs.map<User>((doc) => doc.data().toEntity()).toList());
  }
  //------------------------------------------------------------------------

/*
  Funzione usata per aggiornare un utente
   */
  //------------------------------------------------------------------------

  @override
  Future<void> updateUser(User user) async {
    //entity to model
    UserModel userModel = UserModel.fromEntity(user);

    CollectionReference usersCollection =
        firebaseFirestore.collection(usersCollectionPath);

    final users = usersCollection.withConverter<UserModel>(
        fromFirestore: (snapshot, _) => UserModel.fromFirestore(snapshot, _),
        toFirestore: (user, _) => user.toFirestore());

    await users.doc(userModel.uid).set(userModel).then((value) {
      Fimber.e("User ${userModel.name} Updated");
    });
  }

  /*
  Funzione usata per aggiornare un campo di un utente
   */
  //------------------------------------------------------------------------

  @override
  Future<void> updateFieldUser(String idUser, String field, String data, bool add) async {
    var updates = <String, dynamic>{};

    if(add) {
      updates = <String, dynamic>{
        field: FieldValue.arrayUnion([data]),
      };
    } else {
      updates = <String, dynamic>{
        field: FieldValue.arrayRemove([data]),
      };
    }

    CollectionReference usersCollection =
    firebaseFirestore.collection(usersCollectionPath);

    await usersCollection.doc(idUser).update(updates).then((value) {
      Fimber.e("User $idUser Updated");
    });
  }


  /*
  Funzione usata per aggiornare un campo di un utente
   */
  //------------------------------------------------------------------------

  @override
  Future<void> updateBalanceUser(String idUser, double value) async {

    CollectionReference usersCollection =
    firebaseFirestore.collection(usersCollectionPath);

    await usersCollection.doc(idUser).update({"balance" : FieldValue.increment(value)}).then((value) {
      Fimber.e("User $idUser Updated");
    });
  }
  /*
  Funzione usata per restituire uno stream di aggiornamenti di un utente
   */
  //------------------------------------------------------------------------
  @override
  Stream<User?> changeUser(String u) async* {
    CollectionReference usersCollection =
        firebaseFirestore.collection(usersCollectionPath);

    Stream<DocumentSnapshot<UserModel>> user = usersCollection
        .withConverter<UserModel>(
            fromFirestore: UserModel.fromFirestore,
            toFirestore: (UserModel user, options) => user.toFirestore())
        .doc(u)
        .snapshots();

    yield* user.map<User?>((event) {
      return event.data()?.toEntity();
    });
  }
//------------------------------------------------------------------------
}
