
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PushNotifications {
  static final _firebaseMessaging = FirebaseMessaging.instance;

  static Future<void> initialiserFCM() async {
    // Configurer les notifications pour qu'elles s'affichent même quand l'app est en premier plan (iOS et Android)
    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    
    // 🔐 Demander la permission (iOS)
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: true,
      announcement: true,
      carPlay: true,
      criticalAlert: true,
    );

    print('🛂 Permission : ${settings.authorizationStatus}');

    // 📲 Token de l'appareil
    final token = await _firebaseMessaging.getToken();
    print('📱 FCM Token : $token');

    // // 🔔 Quand l'app est au premier plan
    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   print('💬 Notification en foreground : ${message.notification?.title}');
    //   // Firebase affichera automatiquement la notification grâce à setForegroundNotificationPresentationOptions
    // });

    // // 🔙 Quand l'app est en arrière-plan et l'utilisateur clique
    // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    //   print('➡️ App ouverte via notification : ${message.notification?.title}');
    //   // Vous pouvez ajouter une logique ici pour naviguer vers un écran spécifique
    //   // basé sur les données de la notification
    // });
    
    // // Vérifier si l'application a été ouverte à partir d'une notification en arrière-plan
    // RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    // if (initialMessage != null) {
    //   print('🚀 App lancée depuis une notification : ${initialMessage.notification?.title}');
    //   // Vous pouvez ajouter une logique ici pour naviguer vers un écran spécifique
    // }
  }

  static Future<void> initialize(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var androidInitialize = AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOSInitialize = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    var initializationSettings =
        InitializationSettings(android: androidInitialize, iOS: iOSInitialize);

    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse payload) async {
        try {
          final String? urlcode = payload.payload;
          print(
              ".............................onDidReceiveNotificationResponse.............................");
          // handleNotificationNavigation(null, null);
        } catch (e) {
          print("Error: ${e.toString()}");
        }
      },
    );

    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print(
          ".............................onMessage.............................");
      print(
          "onMessage: ${message.notification?.title}/${message.notification?.body}/${message.data['source_name']} ${message.data['source_code']}");
      PushNotifications.showNotification(
          message, flutterLocalNotificationsPlugin);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print(
          ".............................onMessageOpenedApp.............................");
      print(
          "onMessageOpenedApp: ${message.notification?.title}/${message.notification?.body}/${message.data['source_name']}");

    });
  }

  static Future<void> showNotification(
      RemoteMessage msg, FlutterLocalNotificationsPlugin fln) async {
    BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
      msg.notification!.body!,
      htmlFormatBigText: true,
      contentTitle: msg.notification!.title!,
      htmlFormatContent: true,
    );
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      "channel_id_1",
      "hackathon_log",
      importance: Importance.high,
      styleInformation: bigTextStyleInformation,
      priority: Priority.high,
      playSound: true,
    );
    NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: DarwinNotificationDetails(),
    );
    await fln.show(
      0,
      msg.notification!.title!,
      msg.notification!.body!,
      platformChannelSpecifics,
    );
  }

  
}
