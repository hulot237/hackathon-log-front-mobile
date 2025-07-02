import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hackathon_log/firebase_options.dart';
import 'package:hackathon_log/notification_push/push_notification.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'constants/app_theme.dart';
import 'cubits/log/log_cubit.dart';
import 'screens/splash_screen.dart';



// 🔁 Fonction qui gère les messages en arrière-plan
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print("🔙 Message reçu en arrière-plan: ${message.messageId}");
  print("💬 Titre: ${message.notification?.title}");
  print("💬 Corps: ${message.notification?.body}");
  // Firebase s'occupe automatiquement d'afficher la notification
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialiser les données de localisation pour le format de date français
  await initializeDateFormatting('fr_FR', null);

  // Initialiser Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

PushNotifications.initialiserFCM();
  // 🔧 On initialise le handler background
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  PushNotifications.initialize(flutterLocalNotificationsPlugin);


  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LogCubit>(create: (_) => LogCubit()),
      ],
      child: MaterialApp(
        title: 'Suivi de Journaux',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('fr', 'FR'),
          Locale('en', 'US'),
        ],
        locale: const Locale('fr', 'FR'),
        home: const SplashScreen(),
      ),
    );
  }
}
