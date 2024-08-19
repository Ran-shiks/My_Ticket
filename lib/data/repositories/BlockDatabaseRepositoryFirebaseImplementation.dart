import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fimber/fimber.dart';
import 'package:my_ticket/domain/entities/block.dart';
import 'package:my_ticket/domain/repositories/myTicket_database_repositories.dart';

import '../models/block_model.dart';

const String blocksCollectionPath = "Blocks";

class BlockDatabaseFirebaseImplementation implements BlockDatabaseRepository {
  final FirebaseFirestore firebaseFirestore;
  BlockDatabaseFirebaseImplementation({required this.firebaseFirestore});

  /// Funzione di base per creare i blocchi
  //------------------------------------------------------------------------
  @override
  Future<String> createBlock(Block b) async {
    //entity to model
    BlockModel blockModel = BlockModel.fromEntity(b);

    //collection reference
    CollectionReference blockCollection =
        firebaseFirestore.collection(blocksCollectionPath);

    //converter
    final blocks = blockCollection.withConverter<BlockModel>(
        fromFirestore: (snapshot, _) => BlockModel.fromFirestore(snapshot, _),
        toFirestore: (location, _) => location.toFirestore());

    //operation
    return await blocks.add(blockModel).then((value) {
      blocks.doc(value.id).update({'id': value.id});
      Fimber.e("Block ${blockModel.id} Added");
      return value.id;
    });
  }

  /// Funzione di base per eliminare i blocchi
  //------------------------------------------------------------------------
  @override
  Future<void> deleteBlock(Block b) async {
    //entity to model
    BlockModel blockModel = BlockModel.fromEntity(b);

    //collection reference
    CollectionReference blockCollection =
        firebaseFirestore.collection(blocksCollectionPath);

    //converter
    final blocks = blockCollection.withConverter<BlockModel>(
        fromFirestore: (snapshot, _) => BlockModel.fromFirestore(snapshot, _),
        toFirestore: (location, _) => location.toFirestore());

    //operation
    await blocks.doc(blockModel.id).delete().then((value) {
      Fimber.e("Block ${blockModel.id} Deleted");
    });
  }

  /// Funzione per eliminare i blocchi trammite l'id
  //------------------------------------------------------------------------
  @override
  Future<void> deleteBlockById(String id) async {

    //collection reference
    CollectionReference blockCollection =
    firebaseFirestore.collection(blocksCollectionPath);

    //converter
    final blocks = blockCollection.withConverter<BlockModel>(
        fromFirestore: (snapshot, _) => BlockModel.fromFirestore(snapshot, _),
        toFirestore: (location, _) => location.toFirestore());

    //operation
    await blocks.doc(id).delete().then((value) {
      Fimber.e("Block $id Deleted");
    });
  }

  /// Funzione per ottenere una lista di tutti gli eventi - FUNZIONA
  //------------------------------------------------------------------------
  @override
  Future<List<Block>> listOfBlocks() {
    Future<QuerySnapshot<BlockModel>> blocks = firebaseFirestore
        .collection(blocksCollectionPath)
        .withConverter<BlockModel>(
            fromFirestore: (snapshot, _) =>
                BlockModel.fromFirestore(snapshot, _),
            toFirestore: (location, _) => location.toFirestore())
        .get();

    return blocks.then((value) => value.docs.map<Block>((doc) {
          return doc.data().toEntity();
        }).toList());
  }

  /// Funzione di base per restituire tutti i blocchi
  //------------------------------------------------------------------------
  @override
  Stream<List<Block>> streamOfBlock() {
    Stream<QuerySnapshot<BlockModel>> blocks = firebaseFirestore
        .collection(blocksCollectionPath)
        .withConverter<BlockModel>(
            fromFirestore: (snapshot, _) =>
                BlockModel.fromFirestore(snapshot, _),
            toFirestore: (user, _) => user.toFirestore())
        .snapshots();

    return blocks.map((snapshot) =>
        snapshot.docs.map<Block>((doc) => doc.data().toEntity()).toList());
  }

  /// Funzione di base per aggiornare un blocco
  //------------------------------------------------------------------------
  @override
  Future<void> updateBlock(Block b) async {
    //entity to model
    BlockModel blockModel = BlockModel.fromEntity(b);

    //collection reference
    CollectionReference blockCollection =
        firebaseFirestore.collection(blocksCollectionPath);

    //converter
    final blocks = blockCollection.withConverter<BlockModel>(
        fromFirestore: (snapshot, _) => BlockModel.fromFirestore(snapshot, _),
        toFirestore: (location, _) => location.toFirestore());

    //operation
    await blocks.doc(blockModel.id).set(blockModel).then((value) {
      Fimber.e("Block ${blockModel.id} Added");
    });
  }

  @override
  Future<Block?> searchBlockById(String id) async {
    //collection reference
    CollectionReference locationsCollection =
        firebaseFirestore.collection(blocksCollectionPath);

    //Converter
    final blocks = locationsCollection.withConverter<BlockModel>(
        fromFirestore: (snapshot, _) => BlockModel.fromFirestore(snapshot, _),
        toFirestore: (location, _) => location.toFirestore());

    return blocks.doc(id).get().then((value) {
      if (value.data() != null) {
        final block = value.data()?.toEntity();
        Fimber.e("Location ${block?.id} found");
        return block;
      }
      return null;
    });
  }
}
