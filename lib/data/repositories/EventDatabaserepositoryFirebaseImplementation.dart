import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fimber/fimber.dart';
import 'package:my_ticket/domain/entities/event.dart';
import 'package:my_ticket/domain/repositories/myTicket_database_repositories.dart';

import '../models/event_model.dart';

const String eventsCollectionPath = "Events";

class EventDatabaseFirebaseImplementation implements EventDatabaseRepository {
  final FirebaseFirestore firebaseFirestore;

  EventDatabaseFirebaseImplementation({required this.firebaseFirestore});

  /// Funzione di base per creare gli eventi
  //------------------------------------------------------------------------
  @override
  Future<String> createEvent(Event e) async {
    //entity to model
    EventModel eventModel = EventModel.fromEntity(e);

    // Collection Reference
    CollectionReference eventCollection =
        firebaseFirestore.collection(eventsCollectionPath);

    //converter
    final events = eventCollection.withConverter<EventModel>(
        fromFirestore: (snapshot, _) => EventModel.fromFirestore(snapshot, _),
        toFirestore: (location, _) => location.toFirestore());

    //Operation
    return await events.add(eventModel).then((value) {
      events.doc(value.id).update({"id": value.id});
      Fimber.e("Event ${eventModel.name} Added");
      return value.id;
    });
  }

  ///Funzione di base per eliminare gli eventi
  //------------------------------------------------------------------------
  @override
  Future<void> deleteEvent(Event e) async {
//entity to model
    EventModel eventModel = EventModel.fromEntity(e);

    // Collection Reference
    CollectionReference eventCollection =
        firebaseFirestore.collection(eventsCollectionPath);

    //converter
    final events = eventCollection.withConverter<EventModel>(
        fromFirestore: (snapshot, _) => EventModel.fromFirestore(snapshot, _),
        toFirestore: (location, _) => location.toFirestore());

    //Operation
    await events.doc(eventModel.id).delete().then((value) {
      Fimber.e("Event ${eventModel.name} deleted");
    });
  }

  /// Funzione per ottenere tutti gli eventi
  //------------------------------------------------------------------------
  @override
  Future<List<Event>> listOfEvent() {
    Future<QuerySnapshot<EventModel>> events = firebaseFirestore
        .collection(eventsCollectionPath)
        .withConverter<EventModel>(
            fromFirestore: (snapshot, _) =>
                EventModel.fromFirestore(snapshot, _),
            toFirestore: (event, _) => event.toFirestore())
        .get();

    return events.then((value) => value.docs.map<Event>((doc) {
          return doc.data().toEntity();
        }).toList());
  }

  /// Funzione per ottenere tutti gli eventi - FUNZIONA
  //------------------------------------------------------------------------
  @override
  Stream<List<Event>> streamOfEvent() {
    Stream<QuerySnapshot<EventModel>> events = firebaseFirestore
        .collection(eventsCollectionPath)
        .withConverter<EventModel>(
            fromFirestore: (snapshot, _) =>
                EventModel.fromFirestore(snapshot, _),
            toFirestore: (event, _) => event.toFirestore())
        .snapshots();

    return events.map((snapshot) =>
        snapshot.docs.map<Event>((doc) => doc.data().toEntity()).toList());
  }

  /// Funzione per ottenere gli eventi in base a una caratteristica - FUNZIONA
  //------------------------------------------------------------------------
  @override
  Stream<List<Event>> streamOfEventFilteredisGreaterThanOrEqualTo(field, value) {
    Stream<QuerySnapshot<EventModel>> events = firebaseFirestore
        .collection(eventsCollectionPath)
        .where(field, isGreaterThanOrEqualTo: value)
        .withConverter<EventModel>(
        fromFirestore: (snapshot, _) =>
            EventModel.fromFirestore(snapshot, _),
        toFirestore: (event, _) => event.toFirestore())
        .snapshots();

    return events.map((snapshot) =>
        snapshot.docs.map<Event>((doc) => doc.data().toEntity()).toList());
  }

  /// Funzione per aggiornare un evento
  //------------------------------------------------------------------------
  @override
  Future<void> updateEvent(Event e) async {
    //entity to model
    EventModel eventModel = EventModel.fromEntity(e);

    //collection reference
    CollectionReference eventCollection =
        firebaseFirestore.collection(eventsCollectionPath);

    final events = eventCollection.withConverter<EventModel>(
        fromFirestore: (snapshot, _) => EventModel.fromFirestore(snapshot, _),
        toFirestore: (event, _) => event.toFirestore());

    await events.doc(eventModel.id).set(eventModel).then((value) {
      Fimber.e("Event ${eventModel.name} updated");
    });
  }

  /*
  Funzione usata per aggiornare un campo di un evento
   */
  //------------------------------------------------------------------------

  @override
  Future<void> updateFieldEvent(String idEvent, String field, Object data, bool add) async {
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
    firebaseFirestore.collection(eventsCollectionPath);

    await usersCollection.doc(idEvent).update(updates).then((value) {
      Fimber.e("Event $idEvent Updated");
    });
  }

  /*
  Funzione usata per aggiornare un campo di un evento
   */
  //------------------------------------------------------------------------

  @override
  Future<void> incrementFavEvent(String idEvent) async {

    CollectionReference usersCollection =
    firebaseFirestore.collection(eventsCollectionPath);

    await usersCollection.doc(idEvent).update({"favCounter":FieldValue.increment(1)}).then((value) {
      Fimber.e("Event $idEvent Updated");
    });
  }

  /*
  Funzione usata per aggiornare un campo di un evento
   */
  //------------------------------------------------------------------------

  @override
  Future<void> decrementFavEvent(String idEvent) async {

    CollectionReference usersCollection =
    firebaseFirestore.collection(eventsCollectionPath);

    await usersCollection.doc(idEvent).update({"favCounter":FieldValue.increment(-1)}).then((value) {
      Fimber.e("Event $idEvent Updated");
    });
  }

  /*
  Funzione usata per cercare un evento tramite id
   */
  //------------------------------------------------------------------------


  @override
  Future<Event?> searchEventById(String id) {
    //collection reference
    CollectionReference locationsCollection =
        firebaseFirestore.collection(eventsCollectionPath);

    //Converter
    final events = locationsCollection.withConverter<EventModel>(
        fromFirestore: (snapshot, _) => EventModel.fromFirestore(snapshot, _),
        toFirestore: (location, _) => location.toFirestore());

    return events.doc(id).get().then((value) {
      if (value.data() != null) {
        final event = value.data()?.toEntity();
        Fimber.e("Event ${event?.name} Updated");
        return event;
      }
      return null;
    });
  }

  /*
  Funzione usata per cercare un evento tramite nome - non funziona
   */
  //------------------------------------------------------------------------


  @override
  Future<List<Event>> searchEventByName(String name) {
    Future<QuerySnapshot<EventModel>> events = firebaseFirestore
        .collection(eventsCollectionPath)
        .withConverter<EventModel>(
        fromFirestore: (snapshot, _) =>
            EventModel.fromFirestore(snapshot, _),
        toFirestore: (event, _) => event.toFirestore())
        .where("name", isEqualTo: name)
        .get();

    return events.then((value) => value.docs.map<Event>((doc) => doc.data().toEntity()).toList());
  }

  /*
  Funzione usata per cercare un evento tramite operatore
   */
  //------------------------------------------------------------------------


  @override
  Stream<List<Event>> searchEventFilteredByOperator(String idUser) {
    Stream<QuerySnapshot<EventModel>> events = firebaseFirestore
        .collection(eventsCollectionPath)
        .where("operators", arrayContains: idUser)
        .withConverter<EventModel>(
        fromFirestore: (snapshot, _) =>
            EventModel.fromFirestore(snapshot, _),
        toFirestore: (event, _) => event.toFirestore())
        .snapshots();

    return events.map((snapshot) =>
        snapshot.docs.map<Event>((doc) => doc.data().toEntity()).toList());
  }
}
