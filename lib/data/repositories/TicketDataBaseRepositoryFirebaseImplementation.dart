import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fimber/fimber.dart';
import 'package:my_ticket/domain/repositories/myTicket_database_repositories.dart';

import '../../domain/entities/ticket.dart';
import '../models/ticket_model.dart';

const String ticketsCollectionPath = "Tickets";

class TicketDatabaseFirebaseImplementation extends TicketDatabaseRepository {
  final FirebaseFirestore firebaseFirestore;

  TicketDatabaseFirebaseImplementation({required this.firebaseFirestore});

  /// Funzione di base per creare i tickets
  //------------------------------------------------------------------------
  @override
  Future<String> createTicket(Ticket b) async {
    //Entity to model
    TicketModel ticketModel = TicketModel.fromEntity(b);

    //Collection reference
    CollectionReference ticketsCollection =
        firebaseFirestore.collection(ticketsCollectionPath);

    //converter
    final tickets = ticketsCollection.withConverter<TicketModel>(
        fromFirestore: (snapshot, _) => TicketModel.fromFirestore(snapshot, _),
        toFirestore: (ticket, _) => ticket.toFirestore());

    //operation
    return await tickets.add(ticketModel).then((value) {
      tickets.doc(value.id).update({"id": value.id});
      Fimber.e("Ticket ${ticketModel.id} Added");
      return value.id;
    });
  }

  /// Funzione di base per eliminare il sedile
  //------------------------------------------------------------------------
  @override
  Future<void> deleteTicket(Ticket b) async {
    //Entity to model
    TicketModel ticketModel = TicketModel.fromEntity(b);

    //Collection reference
    CollectionReference ticketsCollection =
        firebaseFirestore.collection(ticketsCollectionPath);

    //converter
    final tickets = ticketsCollection.withConverter<TicketModel>(
        fromFirestore: (snapshot, _) => TicketModel.fromFirestore(snapshot, _),
        toFirestore: (ticket, _) => ticket.toFirestore());

    //operation
    await tickets.doc(ticketModel.id).delete().then((value) {
      Fimber.e("Ticket ${ticketModel.id} Deleted");
    });
  }

  /// Funzione di base per eliminare il sedile
  //------------------------------------------------------------------------
  @override
  Future<void> deleteTicketById(String id) async {

    //Collection reference
    CollectionReference ticketsCollection =
    firebaseFirestore.collection(ticketsCollectionPath);

    //converter
    final tickets = ticketsCollection.withConverter<TicketModel>(
        fromFirestore: (snapshot, _) => TicketModel.fromFirestore(snapshot, _),
        toFirestore: (ticket, _) => ticket.toFirestore());

    //operation
    await tickets.doc(id).delete().then((value) {
      Fimber.e("Ticket $id Deleted");
    });
  }

  /// Funzione per recuperare i sedili
  //------------------------------------------------------------------------
  @override
  Stream<List<Ticket>> streamOfTicket() {
    Stream<QuerySnapshot<TicketModel>> tickets = firebaseFirestore
        .collection(ticketsCollectionPath)
        .withConverter<TicketModel>(
            fromFirestore: (snapshot, _) =>
                TicketModel.fromFirestore(snapshot, _),
            toFirestore: (ticket, _) => ticket.toFirestore())
        .snapshots();

    return tickets.map((snapshot) =>
        snapshot.docs.map<Ticket>((doc) => doc.data().toEntity()).toList());
  }

  /// Funzione per aggiornare il sedile
  //------------------------------------------------------------------------
  @override
  Future<void> updateTicket(Ticket b) async {
    //Entity to model
    TicketModel ticketModel = TicketModel.fromEntity(b);

    //Collection reference
    CollectionReference ticketsCollection =
        firebaseFirestore.collection(ticketsCollectionPath);

    //converter
    final tickets = ticketsCollection.withConverter<TicketModel>(
        fromFirestore: (snapshot, _) => TicketModel.fromFirestore(snapshot, _),
        toFirestore: (ticket, _) => ticket.toFirestore());

    //operation
    await tickets.doc(ticketModel.id).set(ticketModel).then((value) {
      Fimber.e("Ticket ${ticketModel.id} Updated");
    });
  }

  /*
  Funzione usata per aggiornare un campo di un ticket
   */
  //------------------------------------------------------------------------

  @override
  Future<void> updateFieldTicket(String idTicket, String field, Object data) async {
    var updates = <String, dynamic>{field : data};


    CollectionReference ticketsCollection =
    firebaseFirestore.collection(ticketsCollectionPath);

    await ticketsCollection.doc(idTicket).update(updates).then((value) {
      Fimber.e("User $idTicket Updated");
    });
  }

  /// Funzione per aggiornare il sedile
  //------------------------------------------------------------------------
  @override
  Future<Ticket?> searchTicketById(String id) {
    //collection reference
    CollectionReference ticketsCollection =
        firebaseFirestore.collection(ticketsCollectionPath);

    //Converter
    final tickets = ticketsCollection.withConverter<TicketModel>(
        fromFirestore: (snapshot, _) => TicketModel.fromFirestore(snapshot, _),
        toFirestore: (location, _) => location.toFirestore());

    return tickets.doc(id).get().then((value) {
      if (value.data() != null) {
        final ticket = value.data()?.toEntity();
        Fimber.e("Location ${ticket?.id} Retrived");
        return ticket;
      }
      return null;
    });
  }

  /// Funzione per ottenere una lista di tutti gli eventi - FUNZIONA
  //------------------------------------------------------------------------
  @override
  Future<List<Ticket>> listOfTickets() {
    Future<QuerySnapshot<TicketModel>> tickets = firebaseFirestore
        .collection(ticketsCollectionPath)
        .withConverter<TicketModel>(
            fromFirestore: (snapshot, _) =>
                TicketModel.fromFirestore(snapshot, _),
            toFirestore: (ticket, _) => ticket.toFirestore())
        .get();

    return tickets.then((value) => value.docs.map<Ticket>((doc) {
          return doc.data().toEntity();
        }).toList());
  }
}
