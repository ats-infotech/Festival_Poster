import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_frame/Contstant/AppColor.dart';
import 'package:photo_frame/Screen/SplashScreen.dart';
import 'package:photo_frame/service/firebase_push_notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyDIGOcXuAarHHPID2QL5DxTRcdAwSdSy4E',
      appId: '1:573038774884:android:477d20d5fe85a89bf6ed71',
      messagingSenderId: '',
      projectId: 'festival-poster-3ccbf',
    ),
  );
  await FirebaseService.initialize();
  FirebaseMessaging.instance.getToken().then(
    (value) {
      log("token ••••••••••••• $value");
    },
  );
  runApp(
    // DevicePreview(
    //   enabled: true,
    //   builder: (context) =>
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      color: whiteColor,
      theme: ThemeData(
        useMaterial3: false,
        appBarTheme: const AppBarTheme(
          color: kPrimeryColor,
        ),
        scaffoldBackgroundColor: whiteColor,
        dialogBackgroundColor: whiteColor,
      ),
      home: const SplashScreen(),
    ),
    // ),
  );
}
