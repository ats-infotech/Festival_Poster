import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_frame/Contstant/AppColor.dart';
import 'package:photo_frame/Screen/SplashScreen.dart';

void main() {
  runApp(
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
  );
}
