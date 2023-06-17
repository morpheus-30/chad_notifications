import 'dart:async';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'NotificationPlugin.dart';
import 'package:workmanager/workmanager.dart';
import 'package:auto_start_flutter/auto_start_flutter.dart';
import 'package:disable_battery_optimization/disable_battery_optimization.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

const fetchBackground = "fetchBackground";
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    switch (task) {
      case fetchBackground:
        NotificationService notificationService = NotificationService();

        notificationService.init();
        print("hi");
        await notificationService.triggerNotification();
        print("notification triggered");
        break;
    }
    return Future.value(true);
  });
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService notificationService = NotificationService();
  notificationService.init();
  await Workmanager().initialize(
    callbackDispatcher,
  );
  await Workmanager().registerPeriodicTask(
    "1",
    fetchBackground,
    frequency: const Duration(minutes: 60),
    constraints: Constraints(
      networkType: NetworkType.connected,
    ),
  );
  print("Task scheduled");

  runApp(ResponsiveSizer(builder: (context, orientation, screenType) {
    return MaterialApp(
      home: MyApp(),
    );
  }));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("images/6999296.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('CHAD Notification',
                  style: TextStyle(
                    fontFamily: "someFont",
                    color: Colors.white,
                    fontSize: 50,
                  )),
                  SizedBox(
                height: 2.h,
              ),
              const Text('Your notifications has been activated! Now get pumped up every hour with CHAD!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "someFont",
                    color: Colors.white70,
                    fontSize: 20,
                  )),
              SizedBox(
                height: 5.h,
              ),
              Container(
                height: 20.h,
                width: 80.w,
                child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.white30),
                        elevation: MaterialStateProperty.all<double>(30)),
                    child: const Text("STOP THESE NOTIFICATIONS",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: "someFont",
                          color: Colors.white,
                          fontSize: 40,
                        )),
                    onPressed: () {
                      AlertBox(context);
                    }),
              ),
              SizedBox(
                height: 10.h,
              ),
              ElevatedButton(
                child: const Text("Optimization Settings"),
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.white30),
                    elevation: MaterialStateProperty.all<double>(30)),
                onPressed: () async {
                  ShowAutoStartAndBatteryOptimizationDialog(context);
                },
              ),
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.white30),
                    elevation: MaterialStateProperty.all<double>(30)),
                child: const Text("Example Notification"),
                onPressed: () async {
                  NotificationService notification = NotificationService();
                  // notification.getMotivationQuote();
                  notification.triggerNotification();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void AlertBox(BuildContext context) {
  Alert(
          style: AlertStyle(
            backgroundColor: Colors.white10,
            isCloseButton: false,
            alertBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
              side: const BorderSide(
                color: Colors.white10,
              ),
            ),
            animationType: AnimationType.grow,
            buttonAreaPadding:
                EdgeInsets.symmetric(horizontal: 50, vertical: 10),
            descStyle: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontFamily: "someFont",
            ),
            titleStyle: const TextStyle(
              color: Colors.red,
              fontSize: 30,
              fontFamily: "someFont",
            ),
          ),
          buttons: [
            DialogButton(
              onPressed: () => Navigator.pop(context),
              color: Colors.red,
              radius: BorderRadius.circular(0.0),
              child: const Text(
                "CANCEL",
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
            DialogButton(
              onPressed: () async {
                await Workmanager().cancelAll();
                Navigator.pop(context);
                print("Notifications stopped");
              },
              color: Colors.red,
              radius: BorderRadius.circular(0.0),
              child: const Text(
                "STOP",
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
          ],
          context: context,
          title: "AYO WTF?-",
          desc: "Got enough motivation? Or just gave up? Dude NEVER GIVE UP!")
      .show();
}

void ShowAutoStartAndBatteryOptimizationDialog(context) {
  Alert(
          style: AlertStyle(
            backgroundColor: Colors.white10,
            isCloseButton: false,
            alertBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
              side: const BorderSide(
                color: Colors.white10,
              ),
            ),
            animationType: AnimationType.grow,
            buttonAreaPadding:
                EdgeInsets.symmetric(horizontal: 50, vertical: 10),
            descStyle: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontFamily: "someFont",
            ),
            titleStyle: const TextStyle(
              color: Colors.red,
              fontSize: 30,
              fontFamily: "someFont",
            ),
          ),
          buttons: [
            DialogButton(
              onPressed: () async {
                Navigator.pop(context);
                var test = (await isAutoStartAvailable) ?? false;
                if (test) {
                  await getAutoStartPermission();
                }
              },
              color: Colors.red,
              radius: BorderRadius.circular(0.0),
              child: const Text(
                "AUTOSTART",
                style: TextStyle(color: Colors.white, fontSize: 10),
              ),
            ),
            DialogButton(
              onPressed: () async {
                var test = (await DisableBatteryOptimization
                        .isBatteryOptimizationDisabled) ??
                    false;
                await DisableBatteryOptimization
                    .showDisableBatteryOptimizationSettings();
                Navigator.pop(context);
                if (test) {
                  Alert(
                      context: context,
                      title: "BATTERY OPTIMIZATION ALREADY DISABLED",
                      style: AlertStyle(
                        titleStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontFamily: "someFont",
                        ),
                        backgroundColor: Colors.white10,
                        isCloseButton: false,
                        alertBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                          side: const BorderSide(
                            color: Colors.white10,
                          ),
                        ),
                      ),
                      buttons: []).show();
                }
              },
              color: Colors.red,
              radius: BorderRadius.circular(0.0),
              child: const Text(
                "BATTERY OPTIMIZATION",
                style: TextStyle(color: Colors.white, fontSize: 10),
                textAlign: TextAlign.center,
              ),
            ),
          ],
          context: context,
          title: "CHAD not working?",
          desc:
              "Kindly enable Autostart and disable Battery Optimization for CHAD to work properly")
      .show();
}
