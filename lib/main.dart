import 'dart:async';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'notification_plugin.dart';
import 'package:workmanager/workmanager.dart';
import 'package:auto_start_flutter/auto_start_flutter.dart';
import 'package:disable_battery_optimization/disable_battery_optimization.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

const fetchBackground = "fetchBackground";
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    switch (task) {
      case fetchBackground:
        NotificationService notificationService = NotificationService();
        notificationService.init();
        // print("hi");
        await notificationService.triggerNotification(
            await notificationService.getMotivationQuote());
        // print("notification triggered");
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
      requiresDeviceIdle: false,
      requiresCharging: false,
      requiresBatteryNotLow: false,
      networkType: NetworkType.connected,
    ),
  );
  // print("Task scheduled");

  runApp(ResponsiveSizer(builder: (context, orientation, screenType) {
    return const MaterialApp(
      home: MyApp(),
    );
  }));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
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
              Text('CHAD Notification',
                  style: TextStyle(
                    fontFamily: "someFont",
                    color: Colors.white,
                    fontSize: 28.sp,
                  )),
              SizedBox(
                height: 2.h,
              ),
              Text(
                  'Your notifications has been activated! Now get pumped up every hour with CHAD!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "someFont",
                    color: Colors.white70,
                    fontSize: 18.sp,
                  )),
              SizedBox(
                height: 5.h,
              ),
              SizedBox(
                height: 20.h,
                width: 80.w,
                child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.white30),
                        elevation: MaterialStateProperty.all<double>(30)),
                    child: Text("STOP THESE NOTIFICATIONS",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: "someFont",
                          color: Colors.white,
                          fontSize: 25.sp,
                        )),
                    onPressed: () {
                      alertBoxWithButtons(
                        context,
                        title: "AYO WTF?-",
                        desc:
                            "Got enough motivation? Or just gave up? Dude NEVER GIVE UP!",
                        buttons: [
                          DialogButton(
                            onPressed: () => Navigator.pop(context),
                            color: Colors.red,
                            radius: BorderRadius.circular(0.0),
                            child: Text(
                              "CANCEL",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 15.sp),
                            ),
                          ),
                          DialogButton(
                            onPressed: () {
                              cancelNotifications();
                              Navigator.pop(context);
                              messageAlert(context,
                                      "ALL NOTIFICATIONS HAS BEEN STOPPED")
                                  .show();
                              // print("Notifications stopped");
                            },
                            color: Colors.red,
                            radius: BorderRadius.circular(0.0),
                            child: Text(
                              "STOP",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 15.sp),
                            ),
                          ),
                        ],
                      );
                    }),
              ),
              SizedBox(
                height: 10.h,
              ),
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.white30),
                    elevation: MaterialStateProperty.all<double>(30)),
                onPressed: () async {
                  alertBoxWithButtons(context,
                      title: "CHAD not working?",
                      desc:
                          "Kindly enable Autostart and disable Battery Optimization for CHAD to work properly",
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
                          child: Text(
                            "AUTOSTART",
                            style:
                                TextStyle(color: Colors.white, fontSize: 15.sp),
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
                              messageAlert(context,
                                      "BATTERY OPTIMIZATION ALREADY DISABLED")
                                  .show();
                            }
                          },
                          color: Colors.red,
                          radius: BorderRadius.circular(0.0),
                          child: Text(
                            "BATTERY OPTIMIZATION",
                            style:
                                TextStyle(color: Colors.white, fontSize: 13.sp),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ]);
                },
                child: const Text("Optimization Settings"),
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
                  notification.triggerNotification(
                      await notification.getMotivationQuote());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void alertBoxWithButtons(BuildContext context,
    {required title,
    required String desc,
    required List<DialogButton> buttons}) {
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
                const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
            descStyle: TextStyle(
              color: Colors.white,
              fontSize: 20.sp,
              fontFamily: "someFont",
            ),
            titleStyle: TextStyle(
              color: Colors.red,
              fontSize: 25.sp,
              fontFamily: "someFont",
            ),
          ),
          buttons: buttons,
          context: context,
          title: title,
          desc: desc)
      .show();
}

Alert messageAlert(context, String message) {
  return Alert(
      context: context,
      title: message,
      style: AlertStyle(
        titleStyle: TextStyle(
          color: Colors.white,
          fontSize: 20.sp,
          fontFamily: "someFont",
        ),
        backgroundColor: Colors.white10,
        isCloseButton: false,
        animationType: AnimationType.grow,
        alertBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
          side: const BorderSide(
            color: Colors.white10,
          ),
        ),
      ),
      buttons: []);
}

void cancelNotifications() async {
  await Workmanager().cancelAll();
}
