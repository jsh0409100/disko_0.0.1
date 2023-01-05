import 'package:disko_001/app_state.dart';
import 'package:disko_001/notification.dart';
import 'package:disko_001/search.dart';
import 'package:disko_001/select_category.dart';
import 'package:disko_001/signup_page.dart';
import 'package:disko_001/start_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:provider/provider.dart';

//import 'start_pagerial.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
        providers: [ChangeNotifierProvider(create: (_) => ApplicationState())],
        child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Disko Demo',

      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
//      home: const Condition(),
//      home: const phonelogin(),
      //home: const StartPage(),
      home: const NotificationTap(),
      //home: const search(),
      //home: const SelectCategory(),
    );
  }
}
