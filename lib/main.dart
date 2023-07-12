import 'package:disko_001/router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import 'app_layout_screen.dart';
import 'color_schemes.g.dart';
import 'common/widgets/error_screen.dart';
import 'common/widgets/loading_screen.dart';
import 'features/auth/controller/auth_controller.dart';
import 'features/call/screens/call_pickup_screen.dart';
import 'features/starting/start_page.dart';
import 'firebase_options.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message ${message.messageId}');
}

late AndroidNotificationChannel channel;
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description: 'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  var initialzationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  var initializationSettings = InitializationSettings(
    android: initialzationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
  );

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

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
        Locale('ko'),
      ],
      locale: const Locale('ko'),
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: const Color(0xFF5E38EB),
        cardColor: Colors.white,
        fontFamily: 'Pretendard',
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500),
          headlineMedium:
              TextStyle(fontSize: 17.0, fontWeight: FontWeight.w700, color: Colors.black),
        ),
        dialogTheme: DialogTheme(
          backgroundColor: lightColorScheme.background,
        ),
        colorScheme: lightColorScheme.copyWith(background: Colors.white),
      ),
      onGenerateRoute: (settings) => generateRoute(settings),
      home:
          // const SettingScreen());
          ref.watch(userDataAuthProvider).when(
                data: (user) {
                  if (user == null) {
                    return const StartPage();
                  }
                  return const CallPickupScreen(scaffold: AppLayoutScreen());
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
