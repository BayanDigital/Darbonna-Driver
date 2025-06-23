// ignore_for_file: unused_local_variable

import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseHelper {
  void subscribeFirebaseTopic() async {
    if (Platform.isIOS) {
      String? apnsToken = await FirebaseMessaging.instance.getAPNSToken();
      await FirebaseMessaging.instance.subscribeToTopic(
        'driver_maintenance_mode_on',
      );
      await FirebaseMessaging.instance.subscribeToTopic(
        'driver_maintenance_mode_off',
      );
    } else {
      await FirebaseMessaging.instance.subscribeToTopic(
        'driver_maintenance_mode_on',
      );
      await FirebaseMessaging.instance.subscribeToTopic(
        'driver_maintenance_mode_off',
      );
    }
  }
}
