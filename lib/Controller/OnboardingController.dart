import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnBoardingController extends GetxController {
  final RxInt selectedIndex = 0.obs;
  // final RxBool showCelebration = false.obs;
  final List onBoardingList = [
    {
      "title": "Create Stunning Festival Posters",
      "image": "assets/images/onboarding_1.png",
      "startIcon": "",
      "endIcon": "",
      "gifs": {
        "left": [
          "assets/lottie/Diwali.json",
          "assets/lottie/Holi.json",
        ],
        "right": [
          "assets/lottie/Dashera.json",
          "assets/lottie/Navratri.json",
        ],
      },
    },
    {
      "title": "Custom Posters Made Easy",
      "image": "assets/images/onboarding_1.gif",
      "startIcon": "",
      "endIcon": "",
      "gifs": {
        "left": [
          "assets/lottie/Pen Tools.json",
          "assets/lottie/Layer.json",
        ],
        "right": [
          "assets/lottie/Color.json",
          "assets/lottie/Idea.json",
        ],
      },
    },
    {
      "title": "Create Digital Business Cards",
      "image": "assets/images/onboarding_2.png",
      "startIcon": "",
      "endIcon": "",
      "gifs": {
        "left": [
          "assets/lottie/Visiting Card.json",
          "assets/lottie/User Visiting Card.json",
        ],
        "right": [
          "assets/lottie/Personal Visiting card.json",
          "assets/lottie/Bank Card.json",
        ],
      },
    },
    {
      "title": "Customizable Visiting Card, Design Your Vision",
      "image": "assets/images/onboarding_2.gif",
      "startIcon": "",
      "endIcon": "",
      "gifs": {
        "left": [
          "assets/lottie/Visiting Card.json",
          "assets/lottie/User Visiting Card.json",
        ],
        "right": [
          "assets/lottie/Personal Visiting card.json",
          "assets/lottie/Bank Card.json",
        ],
      },
    },
    {
      "title": "Let's Get Started",
      "image": "assets/images/onboarding_2.gif",
      "startIcon": "",
      "endIcon": "",
      "gifs": {
        "left": [
          "assets/lottie/Card Color.json",
          "assets/lottie/Hand Card.json",
        ],
        "right": [
          "assets/lottie/Card Book.json",
          "assets/lottie/Card Frame.json",
        ],
      },
    },
  ];

  Future<void> precacheAssets(BuildContext context) async {
    log('•••••••••••••••••••  ${DateTime.now()}      ');
    await Future.wait([
      // Pre-cache image assets
      precacheImage(
          const AssetImage('assets/images/onboarding_1.png'), context),
      precacheImage(
          const AssetImage('assets/images/onboarding_1.gif'), context),
      precacheImage(
          const AssetImage('assets/images/onboarding_2.png'), context),
      precacheImage(
          const AssetImage('assets/images/onboarding_2.gif'), context),
      // precacheImage(
      //     const AssetImage('assets/images/celebratetions.gif'), context),
    ]);
    log('•••••••••••••••••••  ${DateTime.now()}  222  2 2222      ');
  }
}
