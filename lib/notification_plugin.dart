// import 'package:flutter/cupertino.dart';
import 'dart:math';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'network_helper.dart';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

// import 'dart:io' show Platform, File;
class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static final NotificationService _notificationService =
      NotificationService._internal();
  factory NotificationService() {
    return _notificationService;
  }
  NotificationService._internal();
  void init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  Future<String> getMotivationQuote() async {
    await Firebase.initializeApp();
    NetworkHelper networkHelper = NetworkHelper();
    CollectionReference messages =
        FirebaseFirestore.instance.collection("messages");
    dynamic body;
    try {
      body = await networkHelper.getData("http://192.168.29.254:5000/");
      body = jsonDecode(body);
      // print(body);
      if (body["message"] != "nothing") {
        await messages.add({'message': body["message"]});
        // print("Data submitted");
      }
      body = body["message"];
    } catch (e) {
      // print(e);
      // print("in catch");
      QuerySnapshot allMessages = await messages.get();
      final allData = allMessages.docs.map((e) => e.data()).toList();
      // print(allData);
      Random random = Random();
      var getRandomQuote = allData[random.nextInt(allData.length)] ??
          {"message": "No message found"};
      if (allData.isNotEmpty) {
        body = (getRandomQuote as Map<String, dynamic>)["message"];
      }
      // print(body);
    }
    return body.toUpperCase();
  }

  Future<void> triggerNotification(String inputData) async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    var androidChannelSpecifics = const AndroidNotificationDetails(
      'CHANNEL_ID',
      'CHANNEL_NAME',
      channelDescription: 'CHANNEL_DESCRIPTION',
      sound: RawResourceAndroidNotificationSound('notification'),
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'test ticker',
      styleInformation: BigTextStyleInformation(''),
    );
    var platformChannelSpecifics =
        NotificationDetails(android: androidChannelSpecifics);
    int notificationId = 0;
    await flutterLocalNotificationsPlugin.show(
      notificationId,
      'WTF ARE YOU DOING?',
      inputData,
      platformChannelSpecifics,
      payload: 'Test Payload',
    );
  }

  void stopNotification() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}
