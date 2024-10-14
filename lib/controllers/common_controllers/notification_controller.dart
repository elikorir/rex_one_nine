import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../config.dart';

/// Create a [AndroidNotificationChannel] for heads up notifications
AndroidNotificationChannel? channel;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

void notificationTapBackground(NotificationResponse notificationResponse) {

}

class CustomNotificationController extends GetxController {
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotification() async {
    log('initCall');
    //when app in background
    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    if (Platform.isIOS) {
      // For iOS, request permissions
      final result = await firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        provisional: true,
        sound: true,
      );
      final bool? result1 = await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );

      if (result.authorizationStatus == AuthorizationStatus.authorized) {
        print('FCM: iOS User have granted permission');
        // For handling the received notifications
        await setupListenerCallbacks();
      } else {
        print('FCM: iOS User have declined or not accepted permission');
      }
    } else if (Platform.isAndroid) {
      final result = await firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        provisional: true,
        sound: true,
      );
      final bool? result2 = await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();

      if (result.authorizationStatus == AuthorizationStatus.authorized) {
        print('FCM: Android User have granted permission');
        // For handling the received notifications
        await setupListenerCallbacks();
      } else {
        print('FCM: Android User have declined or not accepted permission');
      }
    } else {
      await setupListenerCallbacks();
    }
    if (!kIsWeb) {
      channel = const AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // titledescription
        importance: Importance.high,
        sound: RawResourceAndroidNotificationSound('callsound'),
        playSound: true,
      );

      /// We use this channel in the `AndroidManifest.xml` file to override the
      /// default FCM channel to enable heads up notifications.
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel!);
    }

    //when app is [closed | killed | terminated]
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      firebaseCtrl.syncContact();
      if (message != null) {
        flutterLocalNotificationsPlugin.cancelAll();
        Map<String, dynamic>? notificationData = message.data;
        if (
        notificationData['title'] != 'Incoming Video Call...' ||
            notificationData['title'] != 'Incoming Audio Call...') {
          //   flutterLocalNotificationsPlugin.cancelAll();
          log("message.data : ${message.data}");
          if (message.data["isGroup"] == true) {
            FirebaseFirestore.instance
                .collection(collectionName.groups)
                .doc(message.data["groupId"])
                .get() /*.then((value) => Get.toNamed(routeName.groupChatMessage,arguments: value.data()))*/;
          } else {
            var data = {
              "chatId": message.data["chatId"],
              "data": message.data["userContact"]
            };
            Get.toNamed(routeName.chatLayout, arguments: data);
          }
          showFlutterNotification(message);
        }
      }
    });

    var initialzationSettingsAndroid =
    const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings = InitializationSettings(
      android: initialzationSettingsAndroid,
    );

    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) {
        log("SS :$notificationResponse");

      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    requestPermissions();
  }

  Future<void> setupListenerCallbacks() async {
    //Triggered if a message is received while the app is in foreground
    //when app in foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      log("CHECK");
      RemoteNotification notification = message.notification!;
      firebaseCtrl.syncContact();
      AndroidNotification? android = message.notification?.android;
      if (android != null && !kIsWeb) {
        flutterLocalNotificationsPlugin.show(
          message.notification.hashCode,
          message.notification!.title,
          message.notification!.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channelDescription: channel!.description,
              'your_channel_id',
              'your other channel name',
              playSound: true,
              importance: Importance.max,
              priority: Priority.high,
              sound: RawResourceAndroidNotificationSound('callsound'),
              // TODO add a proper drawable resource to android, for now using
              //      one that already exists in example app.
              icon: 'launch_background',
            ),
          ),
        );
      }
      // ignore: unnecessary_null_comparison
      log("notification1 : ${message.data}");
      flutterLocalNotificationsPlugin.cancelAll();

      if (message.data['title'] != 'Call Ended' &&
          message.data['title'] != 'Missed Call' &&
          message.data['title'] != 'You have new message(s)' &&
          message.data['title'] != 'Incoming Video Call...' &&
          message.data['title'] != 'Incoming Audio Call...' &&
          message.data['title'] != 'Incoming Call ended' &&
          message.data['title'] != 'Group Message') {
        log("newnotifications");
        showFlutterNotification(message);
      } else {
        if (message.data['title'] == 'Call Ended') {
          flutterLocalNotificationsPlugin.cancelAll();
        } else {
          if (message.data['title'] == 'Incoming Audio Call...' ||
              message.data['title'] == 'Incoming Video Call...') {
            showFlutterNotification(message);
          } else if (message.data['title'] == 'Single Message') {
            log("ovrr : ");
            showFlutterNotification(message);
          } else {
            showFlutterNotification(message);
          }
        }
      }
    });

    //when app in background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      log('A new onMessageOpenedApp event was published!');
      log("onMessageOpenedApp: $message");
      flutterLocalNotificationsPlugin.cancelAll();
      Map<String, dynamic> notificationData = message.data;
      AndroidNotification? android = message.notification?.android;
      if (android != null) {
        if (notificationData['title'] == 'Call Ended') {
          flutterLocalNotificationsPlugin.cancelAll();
        } else if (
        notificationData['title'] != 'Incoming Video Call...' ||
            notificationData['title'] != 'Incoming Audio Call...' ) {
          flutterLocalNotificationsPlugin.cancelAll();
        } else if (message.data["title"] == "Incoming Video Call..." ||
            message.data["title"] == "Incoming Audio Call...") {
          flutterLocalNotificationsPlugin.show(
            message.notification.hashCode,
            message.notification!.title,
            message.notification!.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channelDescription: channel!.description,
                'your_channel_id',
                'your other channel name',
                playSound: true,
                importance: Importance.max,
                priority: Priority.high,
                sound: RawResourceAndroidNotificationSound('callsound'),
                // TODO add a proper drawable resource to android, for now using
                //      one that already exists in example app.
                icon: 'launch_background',
              ),
            ),
          );
        } else {
          flutterLocalNotificationsPlugin.cancelAll();
        }
      }
    });
  }

  void showFlutterNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (message.data["title"] == "Incoming Video Call..." ||
        message.data["title"] == "Incoming Audio Call...") {
      log("SHOOO");
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification!.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channelDescription: channel!.description,
            'your_channel_id',
            'your other channel name',
            playSound: true,
            importance: Importance.max,
            priority: Priority.high,
            sound: RawResourceAndroidNotificationSound('callsound'),
            // TODO add a proper drawable resource to android, for now using
            //      one that already exists in example app.
            icon: 'launch_background',
          ),
        ),
      );
    } else {
      if (notification != null && android != null && !kIsWeb) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel!.id,
              channel!.name,
              channelDescription: channel!.description,
              // TODO add a proper drawable resource to android, for now using
              //      one that already exists in example app.
              icon: 'launch_background',
            ),
          ),
        );
      }
    }
  }

  requestPermissions() async {
    NotificationSettings settings = await FirebaseMessaging.instance
        .requestPermission(
        announcement: true,
        carPlay: true,
        criticalAlert: true,
        sound: true);

    log("settings.authorizationStatus: ${settings.authorizationStatus}");
  }

  @override
  void onReady() {
    // TODO: implement onReady

    super.onReady();
  }
}

showNotification(RemoteMessage remote) async {
  print("---Show Notification ---- ${remote.notification?.title}");
  Map<String, dynamic> notificationData = remote.data;

  String title = remote.notification!.title ?? "",
      message = remote.notification?.body ?? "";

  BigPictureStyleInformation? bigPictureStyleInformation;

  AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    channelDescription: channel!.description,
    icon: "ic_notification",
    'your_channel_id',
    'your other channel name',
    playSound: true,
    importance: Importance.max,
    priority: Priority.high,
    sound: RawResourceAndroidNotificationSound('callsound'),
  );
  DarwinNotificationDetails iOSDetails =
  DarwinNotificationDetails(sound: 'callsound.wav', presentSound: true);

  NotificationDetails notificationDetails = NotificationDetails(
    android: androidDetails,
    iOS: iOSDetails,
  );

  flutterLocalNotificationsPlugin.show(0, title, message, notificationDetails,
      payload: remote.data.toString());
}
