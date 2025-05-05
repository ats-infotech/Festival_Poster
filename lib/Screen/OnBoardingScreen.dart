import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:photo_frame/Controller/OnboardingController.dart';
import 'package:photo_frame/Contstant/AppColor.dart';
import 'package:photo_frame/Contstant/Strings.dart';
import 'package:photo_frame/Screen/BottomNavBar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final OnBoardingController onBoardingController =
      Get.put(OnBoardingController());
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        onBoardingController.precacheAssets(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () {
          final data = onBoardingController
              .onBoardingList[onBoardingController.selectedIndex.value];
          return Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                'assets/images/onboarding_bg.png',
                fit: BoxFit.cover,
              ),
              // Center(
              //   child: Lottie.asset(
              //     fit: BoxFit.cover,
              //     'assets/lottie/Idea.json',
              //     height: 72,
              //     width: 72,
              //   ),
              // ),
              Column(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        // Expanded(
                        //   child: Column(
                        //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                        //     // children: [
                        //     //   Center(
                        //     //     child: Lottie.asset(
                        //     //       fit: BoxFit.cover,
                        //     //       'assets/lottie/Idea.json',
                        //     //       height: 72,
                        //     //       width: 72,
                        //     //     ),
                        //     //   ),
                        //     //   Center(
                        //     //     child: Lottie.asset(
                        //     //       fit: BoxFit.cover,
                        //     //       'assets/lottie/Idea.json',
                        //     //       height: 72,
                        //     //       width: 72,
                        //     //     ),
                        //     //   ),
                        //     // ],
                        //     children: (data['gifs']['left'] as List)
                        //         .map(
                        //           (e) => Center(
                        //             child: Lottie.asset(
                        //               fit: BoxFit.cover,
                        //               e,
                        //               height: 112,
                        //               width: 112,
                        //             ),
                        //           ),
                        //         )
                        //         .toList(),
                        //   ),
                        // ),
                        Expanded(child: Container()),
                        Expanded(
                          flex: 3,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 70.0),
                            child: Image.asset(data['image']),
                          ),
                        ),
                        Expanded(child: Container()),
                        // Expanded(
                        //   child: Column(
                        //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        //     children: (data['gifs']['right'] as List)
                        //         .map(
                        //           (e) => Center(
                        //             child: Lottie.asset(
                        //               fit: BoxFit.cover,
                        //               e,
                        //               height: 112,
                        //               width: 112,
                        //             ),
                        //           ),
                        //         )
                        //         .toList(),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 250,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30.0),
                          child: SizedBox(
                            height: 80,
                            child: Text(
                              data['title'],
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 24,
                                color: Colors.black,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Obx(
                          () => Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              onBoardingController.onBoardingList.length,
                              (index) {
                                return AnimatedContainer(
                                  duration: const Duration(
                                    milliseconds: 400,
                                  ),
                                  margin: const EdgeInsets.only(right: 8),
                                  height: 6,
                                  width: index ==
                                          onBoardingController
                                              .selectedIndex.value
                                      ? 46
                                      : 6,
                                  decoration: BoxDecoration(
                                      color: index ==
                                              onBoardingController
                                                  .selectedIndex.value
                                          ? kPrimeryColor
                                          : const Color(0x2d2b2e33),
                                      borderRadius: BorderRadius.circular(20)),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Obx(
                          () => onBoardingController.selectedIndex.value == 4
                              ? GestureDetector(
                                  onTap: () async {
                                    // onBoardingController.showCelebration.value =
                                    //     true;
                                    final prefs =
                                        await SharedPreferences.getInstance();
                                    await prefs.setBool(
                                        'isOnboardingComplated', true);
                                    // await Future.delayed(
                                    //     const Duration(seconds: 7));
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const BottomNavBarBar(),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: kPrimeryColor, width: 2),
                                        color: kPrimeryColor,
                                        borderRadius:
                                            BorderRadius.circular(100)),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 40, vertical: 10),
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                    ),
                                    child: Text(
                                      'Complete',
                                      style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white),
                                    ),
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    onBoardingController.selectedIndex.value > 0
                                        ? GestureDetector(
                                            onTap: () {
                                              onBoardingController
                                                  .selectedIndex.value--;
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: kPrimeryColor,
                                                      width: 2),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100)),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 40,
                                                      vertical: 10),
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 20,
                                              ),
                                              child: Text(
                                                'Back',
                                                style: GoogleFonts.poppins(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                    color: kPrimeryColor),
                                              ),
                                            ),
                                          )
                                        : Container(),
                                    GestureDetector(
                                      onTap: () {
                                        onBoardingController
                                            .selectedIndex.value++;
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: kPrimeryColor, width: 2),
                                            color: kPrimeryColor,
                                            borderRadius:
                                                BorderRadius.circular(100)),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 40, vertical: 10),
                                        margin: const EdgeInsets.symmetric(
                                          horizontal: 20,
                                        ),
                                        child: Text(
                                          'Next',
                                          style: GoogleFonts.poppins(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // onBoardingController.showCelebration.value
              //     ? Container(
              //         alignment: Alignment.bottomCenter,
              //         // color: Colors.amber,
              //         child: Padding(
              //           padding: const EdgeInsets.only(bottom: 0.0),
              //           child: Lottie.asset(
              //             'assets/images/celebration.json',
              //             fit: BoxFit.cover,
              //           ),
              //         ),
              //       )
              //     : Container(),
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(top: 65, right: 20),
                  child: GestureDetector(
                    onTap: () async {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BottomNavBarBar(),
                        ),
                      );

                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setBool('isOnboardingComplated', true);
                    },
                    child: Text(
                      skip,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                        color: const Color(0xff7A7A7A),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
