import 'package:disko_001/router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import 'app_layout_screen.dart';
import 'color_schemes.g.dart';
import 'common/widgets/error_screen.dart';
import 'common/widgets/loading_screen.dart';
import 'features/auth/controller/auth_controller.dart';
import 'features/starting/start_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  runApp(const ProviderScope(
    child: MyApp(),
  ));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GetMaterialApp(
      title: 'Disko Demo',
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('ko'),
      ],
      locale: const Locale('ko'),
      theme: ThemeData(
        backgroundColor: Colors.white,
        useMaterial3: true,
        colorScheme: lightColorScheme,
        primaryColor: const Color(0xFF5E38EB),
        cardColor: Colors.white,
        fontFamily: 'Pretendard',
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500),
          headlineMedium: TextStyle(
              fontSize: 17.0, fontWeight: FontWeight.w700, color: Colors.black),
        ),
      ),
      // darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
      onGenerateRoute: (settings) => generateRoute(settings),
      home: ref.watch(userDataAuthProvider).when(
            data: (user) {
              if (user == null) {
                return const StartPage();
              }
              return const AppLayoutScreen();
            },
            error: (err, trace) {
              return ErrorScreen(
                error: err.toString(),
              );
            },
            loading: () => const LoadingScreen(),
          ),
    );
  }
}
