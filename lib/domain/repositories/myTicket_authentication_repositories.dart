import 'package:firebase_auth/firebase_auth.dart' as fire;

import '../entities/user.dart' as app;

abstract class MyTicketAuthenticationRepositories {
  Future<app.User> signIn({
    required String email,
    required String password,
  });
  Future<app.User> signInWithGoogle();
  Future<app.User> signUp({
    required String email,
    required String password,
  });
  Future<void> SignOut();
  String? fetchIdCurrentUser();
  Stream<fire.User?> changeUser();
  Stream<app.User?> User();
  Future<int?> role();
  Future<app.User> signInAnonymus();
}
