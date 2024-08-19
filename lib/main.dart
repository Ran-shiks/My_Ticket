//Firebase
import 'package:fimber/fimber.dart';
import 'package:firebase_core/firebase_core.dart';
//Import Base
import 'package:flutter/material.dart';

import 'app.dart';

Future<void> main() async {
  /// Si chiama questo metodo per inizializzare altre componenti
  WidgetsFlutterBinding.ensureInitialized();

  ///Inizializzazione di Firebase
  await Firebase.initializeApp();

  ///Inizializzazione di Fimber - package dedicato ai Log
  Fimber.plantTree(DebugTree());

  ///RunApp
  runApp(MyApp());
}
