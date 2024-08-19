import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fimber/fimber.dart';
import 'package:my_ticket/domain/repositories/myTicket_database_repositories.dart';

import '../../domain/entities/location.dart';
import '../models/location_model.dart';

const String locationsCollectionPath = "Locations";

class LocationDatabaseFirebaseImplementation
    implements LocationDatabaseRepository {
  final FirebaseFirestore firebaseFirestore;

  LocationDatabaseFirebaseImplementation({required this.firebaseFirestore});

  /// Funzione di base per creare gli eventi
  //------------------------------------------------------------------------
  @override
  Future<void> createLocation(Location p) async {
    //entity to model
    LocationModel locationModel = LocationModel.fromEntity(p);

    //collection reference
    CollectionReference locationsCollection =
        firebaseFirestore.collection(locationsCollectionPath);

    //Converter
    final locations = locationsCollection.withConverter<LocationModel>(
        fromFirestore: (snapshot, _) =>
            LocationModel.fromFirestone(snapshot, _),
        toFirestore: (location, _) => location.toFirestore());

    //Operation
    await locations.add(locationModel).then((value) {
      locations.doc(value.id).update({"id": value.id});
      Fimber.e("Location ${locationModel.name} Added");
    });
  }

  /// Funzione di base per eliminare gli eventi - FUNZIONA
  //------------------------------------------------------------------------
  @override
  Future<void> deleteLocation(Location p) async {
    LocationModel locationModel = LocationModel.fromEntity(p);

    CollectionReference locationsCollection =
        firebaseFirestore.collection(locationsCollectionPath);

    final locations = locationsCollection.withConverter<LocationModel>(
        fromFirestore: (snapshot, _) =>
            LocationModel.fromFirestone(snapshot, _),
        toFirestore: (location, _) => location.toFirestore());

    await locations.doc(locationModel.id).delete().then((value) {
      Fimber.e("Location ${locationModel.name} Deleted");
    });
  }

  /// Funzione per ottenere una lista di tutti gli eventi - FUNZIONA
  //------------------------------------------------------------------------
  @override
  Future<List<Location>> listOfLocation() {
    Future<QuerySnapshot<LocationModel>> locations = firebaseFirestore
        .collection(locationsCollectionPath)
        .withConverter<LocationModel>(
            fromFirestore: (snapshot, _) =>
                LocationModel.fromFirestone(snapshot, _),
            toFirestore: (location, _) => location.toFirestore())
        .get();

    return locations.then((value) => value.docs.map<Location>((doc) {
          return doc.data().toEntity();
        }).toList());
  }

  /// Funzione per ottenere tutti gli eventi - FUNZIONA
  //------------------------------------------------------------------------
  @override
  Stream<List<Location>> streamOfLocation() {
    Stream<QuerySnapshot<LocationModel>> locations = firebaseFirestore
        .collection(locationsCollectionPath)
        .withConverter<LocationModel>(
            fromFirestore: (snapshot, _) =>
                LocationModel.fromFirestone(snapshot, _),
            toFirestore: (user, _) => user.toFirestore())
        .snapshots();

    return locations.map((snapshot) =>
        snapshot.docs.map<Location>((doc) => doc.data().toEntity()).toList());
  }

  /// Funzione per aggiornare un evento
  //------------------------------------------------------------------------
  @override
  Future<void> updateLocation(Location p) async {
    //entity to model
    LocationModel locationModel = LocationModel.fromEntity(p);

    //collection reference
    CollectionReference locationsCollection =
        firebaseFirestore.collection(locationsCollectionPath);

    //Converter
    final locations = locationsCollection.withConverter<LocationModel>(
        fromFirestore: (snapshot, _) =>
            LocationModel.fromFirestone(snapshot, _),
        toFirestore: (location, _) => location.toFirestore());

    await locations.doc(locationModel.id).set(locationModel).then((value) {
      Fimber.e("Location ${locationModel.name} Updated");
    });
  }

  /// Funzione per cercare una Location
  //------------------------------------------------------------------------
  @override
  Future<List<Location>> searchLocationByName(String name) {
    Future<QuerySnapshot<LocationModel>> locations = firebaseFirestore
        .collection(locationsCollectionPath)
        .where("name", isEqualTo: name)
        .withConverter<LocationModel>(
            fromFirestore: (snapshot, _) =>
                LocationModel.fromFirestone(snapshot, _),
            toFirestore: (user, _) => user.toFirestore())
        .get();

    return locations.then((snapshot) =>
        snapshot.docs.map<Location>((doc) => doc.data().toEntity()).toList());
  }

  /// Funzione per cercare una Location
  //------------------------------------------------------------------------
  @override
  Future<Location?> searchLocationById(String id) async {
    //collection reference
    CollectionReference locationsCollection =
        firebaseFirestore.collection(locationsCollectionPath);

    //Converter
    final locations = locationsCollection.withConverter<LocationModel>(
        fromFirestore: (snapshot, _) =>
            LocationModel.fromFirestone(snapshot, _),
        toFirestore: (location, _) => location.toFirestore());

    return locations.doc(id).get().then((value) {
      if (value.data() != null) {
        final location = value.data()?.toEntity();
        Fimber.e("Location ${location?.name} Updated");
        return location;
      }
      return null;
    });
  }
}
