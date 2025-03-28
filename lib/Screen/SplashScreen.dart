import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:photo_frame/Contstant/AppColor.dart';
import 'package:photo_frame/Screen/GradientText.dart';
import 'package:photo_frame/Screen/HomeScreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    Future.delayed(
      const Duration(seconds: 3),
      () async {
        Navigator.pushReplacement(
          context,
          PageTransition(
            type: PageTransitionType.rightToLeftWithFade,
            child: const HomeScreen(),
          ),
        );
      },
    );
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
                "Festival Poster",
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
