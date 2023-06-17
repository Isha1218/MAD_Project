import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:mad/push_notification.dart';
import 'package:overlay_support/overlay_support.dart';

import 'notification_badge.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  late final FirebaseMessaging _messaging;
  late int _totalNotifications;
  PushNotification? _notificationInfo;

  @override
  void initState() {
    _totalNotifications = 0;
    super.initState();
  }

  void registerNotification() async {
    await Firebase.initializeApp();

    _messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');

      // handle the recieved notifications
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        // Parse the message recieved
        PushNotification notification = PushNotification(
          title: message.notification?.title,
          body: message.notification?.body,
        );

        setState(() {
          _notificationInfo = notification;
          _totalNotifications++;
        });

        if (_notificationInfo != null) {
          showSimpleNotification(
            Text(_notificationInfo!.title as String),
            leading: NotificationBadge(totalNotifications: _totalNotifications),
            subtitle: Text(_notificationInfo!.body!),
            background: Colors.cyan.shade700,
            duration: Duration(seconds: 2),
          );
        } else {
          print('User declined or has not accepted permission');
        }
      });
    } else {
      print('User declined or has not accepted permission');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _notificationInfo != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'App for capturing Firebase Push Notifications',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    NotificationBadge(totalNotifications: _totalNotifications),
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      'TITLE: ${_notificationInfo!.title}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      'BODY: ${_notificationInfo!.body}',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    )
                  ],
                )
              : Container()
        ],
      ),
    );
  }
}
