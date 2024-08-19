import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fimber/fimber.dart';
import 'package:firebase_auth/firebase_auth.dart' as fire;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_ticket/core/exceptions/sign_in_canceled_exception.dart';
import 'package:my_ticket/core/exceptions/wrong_credentials_exception.dart';
import 'package:my_ticket/data/models/user_model.dart';
import 'package:my_ticket/domain/repositories/myTicket_authentication_repositories.dart';

import '../../domain/entities/user.dart' as app;

const String usersCollectionPath = "Users";

class AuthenticationRepositories implements MyTicketAuthenticationRepositories {
  final fire.FirebaseAuth firebaseAuth;
  final GoogleSignIn googleSignIn;
  final FirebaseFirestore firebaseFirestore;

  AuthenticationRepositories(
      {required this.firebaseAuth,
      required this.googleSignIn,
      required this.firebaseFirestore});

  /// Funzione per creare l'utente attraverso l'interfaccia firebase Auth
  /// Dato che signInWithEmailAndPassword ci restituisce un Future dobbiamo wrapparlo in un try catch
  @override
  Future<app.User> signIn({
    required String email,
    required String password,
  }) async {
    try {
      fire.UserCredential UC = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      UserModel? userModel = UserModel.fromFireUser(UC.user!);

      return userModel!.toEntity();
    } on fire.FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Fimber.e('No user found for the email.');
      } else if (e.code == 'wrong-password') {
        Fimber.e('Wrong password provided for that user');
      }
      throw WrongCredentialException();
    }
  }

  ///Funzione per creare l'utente attraverso l'interfaccia firebase Auth e google
  @override
  Future<app.User> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final Googlecredentials = fire.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      fire.UserCredential credential =
          await firebaseAuth.signInWithCredential(Googlecredentials);
      UserModel? userModel = UserModel.fromFireUser(credential.user!);

      return userModel!.toEntity();
    }
    Fimber.e('User canceled the login process');
    throw SignInCanceledException();
  }

  @override
  Future<app.User> signUp({
    required String email,
    required String password,
  }) async {
    try {
      fire.UserCredential credential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      UserModel? userModel = UserModel.fromFireUser(credential.user!);

      return userModel!.toEntity();
    } on fire.FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Fimber.e('No user found for the email.');
      } else if (e.code == 'wrong-password') {
        Fimber.e('Wrong password provvided for that user');
      }
      throw WrongCredentialException();
    }
  }

  @override
  Future<void> SignOut() async {
    await firebaseAuth.signOut();
  }

  @override
  String? fetchIdCurrentUser() {
    if (firebaseAuth.currentUser != null) {
      return firebaseAuth.currentUser!.uid;
    } else {
      return null;
    }
  }

  //serve per l'autenticazione nel primo passaggio nel main
  @override
  Stream<fire.User?> changeUser() {
    return firebaseAuth.userChanges();
  }

  // non usata
  @override
  Stream<app.User?> User() async* {
    var id = fetchIdCurrentUser();
    if (id == null) yield* Stream.value(null);
    Stream<app.User?> user = firebaseFirestore
        .collection(usersCollectionPath)
        .doc(id)
        .withConverter<UserModel>(
            fromFirestore: UserModel.fromFirestore,
            toFirestore: (UserModel user, options) => user.toFirestore())
        .snapshots()
        .map<app.User?>((event) {
      return event.data()?.toEntity();
    });

    yield* user;
  }

  // NON TOCCARE - La funzione recupera il ruolo dell'utente per lo smistamento nella pagina main
  @override
  Future<int?> role() async {
    var id = fetchIdCurrentUser();
    if (id == null) return null;
    int user = (await firebaseFirestore
        .collection(usersCollectionPath)
        .doc(id)
        .withConverter<UserModel>(
            fromFirestore: UserModel.fromFirestore,
            toFirestore: (UserModel user, options) => user.toFirestore())
        .get()
        .then((value) {
      return value.data()!.role;
    }));

    return user;
  }

  @override
  Future<app.User> signInAnonymus() async {
    try {
      fire.UserCredential UC = await firebaseAuth.signInAnonymously();

      UserModel? userModel = UserModel.fromFireUser(UC.user!);

      return userModel!.toEntity();
    } on fire.FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Fimber.e('No user found for the email.');
      } else if (e.code == 'wrong-password') {
        Fimber.e('Wrong password provided for that user');
      }
      throw WrongCredentialException();
    }
  }
}
