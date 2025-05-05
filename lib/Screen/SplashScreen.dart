import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:photo_frame/Contstant/AppColor.dart';
import 'package:photo_frame/Contstant/Strings.dart';
import 'package:photo_frame/Screen/BottomNavBar.dart';
import 'package:photo_frame/Screen/GradientText.dart';
import 'package:photo_frame/Screen/OnBoardingScreen.dart';
import 'package:photo_frame/WebScreen/HomeScreenWeb.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    if (Get.size.shortestSide < 600) {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    }

    Future.delayed(
      const Duration(seconds: 3),
      () async {
        final prefs = await SharedPreferences.getInstance();
        final isOnboardingCompleted =
            prefs.getBool('isOnboardingComplated') ?? false;

        // if (!isOnboardingCompleted) {
        //   final OnBoardingController onBoardingController =
        //       Get.put(OnBoardingController());
        //   await onBoardingController.precacheAssets(context);
        // }

        Navigator.pushReplacement(
          context,
          PageTransition(
              type: PageTransitionType.rightToLeftWithFade,
              child: isOnboardingCompleted
                  ? (kIsWeb ? const HomeScreenWeb() : const BottomNavBarBar())
                  : const OnBoardingScreen()),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 120,
                width: 120,
                child: Image.asset("assets/images/AppLogo.png"),
              ),
              const SizedBox(
                height: 20,
              ),
              GradientText(
                festivalPoster,
                style: GoogleFonts.reemKufiFun(
                  fontSize: 25,
                ),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xff276EB6),
                    Color(0xff443995),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
