import 'package:disko_001/phone_test.dart';
import 'package:firebase_core/firebase_core.dart';

import 'start_page.dart';
import 'package:flutter/material.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Disko Demo',

      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
//      home: const Condition(),
      home: const phonelogin(),
//      home: const LoginPage(),
    );
  }
}