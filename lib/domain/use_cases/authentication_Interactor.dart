import 'package:fimber/fimber.dart';
import 'package:firebase_auth/firebase_auth.dart' as fire;
import 'package:my_ticket/domain/entities/user.dart';
import 'package:my_ticket/domain/repositories/myTicket_authentication_repositories.dart';

import '../repositories/myTicket_database_repositories.dart';

class AuthInteractor {
  final MyTicketAuthenticationRepositories _myTicketAuthenticationRepositories;
  final UserDatabaseRepository _userRepository;

  AuthInteractor(
      this._myTicketAuthenticationRepositories, this._userRepository);

  Future<User> login({required String email, required String password}) async {
    User user = await _myTicketAuthenticationRepositories.signIn(
        email: email, password: password);

    try {
      var userA = await _userRepository.searchUserById(user.uid);
      return userA!;
    } catch (error) {
      Fimber.e("user not found");
      return User.isEmpty();
    }
  }

  Future<User> loginWithGoogle() async {
    User user = await _myTicketAuthenticationRepositories.signInWithGoogle();
    try {
      var userA = await _userRepository.searchUserById(user.uid);
      return userA!;
    } catch (error) {
      Fimber.e("user not found");
      return User.isEmpty();
    }
  }

  Future<User> registration(
      {required String email,
      required String password,
      required String name,
      required String surname}) async {
    User user = await _myTicketAuthenticationRepositories.signUp(
        email: email, password: password);

    User newUser = User(
        uid: user.uid,
        name: name,
        surname: surname,
        balance: 0.0,
        email: email,
        imageUrl: " ",
        role: Role.customer);

    try {
      await _userRepository.createUser(newUser);
      var userA = await _userRepository.searchUserById(newUser.uid);
      return userA!;
    } catch (error) {
      Fimber.e("user not found");
      return User.isEmpty();
    }
  }

  Future<void> SignOut() async {
    await _myTicketAuthenticationRepositories.SignOut();
  }

  Stream<fire.User?> userChange() {
    return _myTicketAuthenticationRepositories.changeUser();
  }

  Stream<User?> user() {
    return _myTicketAuthenticationRepositories.User();
  }

  Future<int?> role() async {
    return await _myTicketAuthenticationRepositories.role();
  }

  Future<User> loginAnonymus() async {
    return await _myTicketAuthenticationRepositories.signInAnonymus();
  }
}
