import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:photo_frame/Contstant/AppColor.dart';
import 'package:photo_frame/Contstant/CommonMethod.dart';
import 'package:photo_frame/Screen/BrandingPage.dart';
import 'package:photo_frame/Screen/GradientText.dart';
import 'package:photo_frame/Screen/HomePage.dart';
import 'package:photo_frame/Screen/HomeSearchPage.dart';
import 'package:photo_frame/Screen/PrivacyPolicy.dart';
import 'package:photo_frame/Screen/Templates.dart';
import 'package:photo_frame/Screen/saveImageShow.dart';


class BottomNavBarBar extends StatefulWidget {
  const BottomNavBarBar({super.key});

  @override
  State<BottomNavBarBar> createState() => _BottomNavBarBarState();
}

class _BottomNavBarBarState extends State<BottomNavBarBar> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool isHomeTap = true;
  bool isBrandingTap = false;

  Future<void> loadImage() async {
    try {
      var imageResponse = await rootBundle.loadString("assets/images.json");
      templateWithImageList = jsonDecode(imageResponse);
      setState(() {});
    } catch (e) {
      print("-------- Image Not Laod ---------- $e");
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        await loadImage();
        getPatrioticImage();
        getFestivalImage();
        getSpecialImage();
        getVisitingCard();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: kPrimeryColor,
        title: Text(
          isHomeTap == true ? "Home" : "Card",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            setState(() {
              scaffoldKey.currentState!.openDrawer();
            });
          },
          icon: const ImageIcon(
            AssetImage("assets/images/drawerIcon.png"),
          ),
        ),
      ),
      drawer: drawer(),
      floatingActionButton: Container(
        padding: const EdgeInsets.all(8),
        height: 80,
        width: 80,
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 236, 234, 234),
          shape: BoxShape.circle,
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.bottomToTop,
                duration: const Duration(milliseconds: 400),
                child: const HomeSearchPage(),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: const BoxDecoration(
              color: kPrimeryColor,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.search,
              color: whiteColor,
              size: 30,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: SizedBox(
        height: 65,
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  height: 65,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 236, 234, 234),
                  ),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 35),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isHomeTap = true;
                              isBrandingTap = false;
                            });
                          },
                          child: Container(
                            color: transparentColor,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                isHomeTap == true
                                    ? Container(
                                        width: 20,
                                        height: 2,
                                        color: kPrimeryColor,
                                      )
                                    : Container(),
                                Image.asset(
                                  "assets/images/Home.png",
                                  scale: 4.5,
                                  color: isHomeTap == true
                                      ? kPrimeryColor
                                      : kPrimeryColor.withOpacity(0.6),
                                ),
                                Text(
                                  "Home",
                                  style: GoogleFonts.poppins(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: isHomeTap == true
                                        ? kPrimeryColor
                                        : kPrimeryColor.withOpacity(0.6),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isBrandingTap = true;
                              isHomeTap = false;
                            });
                          },
                          child: Container(
                            color: transparentColor,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                isBrandingTap == true
                                    ? Container(
                                        width: 20,
                                        height: 2,
                                        color: kPrimeryColor,
                                      )
                                    : Container(),
                                Image.asset(
                                  "assets/images/branding.png",
                                  scale: 4.5,
                                  color: isBrandingTap == true
                                      ? kPrimeryColor
                                      : kPrimeryColor.withOpacity(0.6),
                                ),
                                Text(
                                  "Branding",
                                  style: GoogleFonts.poppins(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: isBrandingTap == true
                                        ? kPrimeryColor
                                        : kPrimeryColor.withOpacity(0.6),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 3,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  "Search",
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: kPrimeryColor.withOpacity(0.6),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Material(
              elevation: 5,
              borderRadius: BorderRadius.circular(10),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.bottomToTop,
                      duration: const Duration(milliseconds: 400),
                      child: const HomeSearchPage(),
                    ),
                  );
                },
                child: TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: const Icon(
                      Icons.search,
                      color: greyColor,
                    ),
                    suffixIcon: const Icon(
                      Icons.keyboard_voice_outlined,
                      color: greyColor,
                    ),
                    hintText: "Search Your Poster",
                    hintStyle: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    enabled: false,
                  ),
                  cursorColor: blackColor,
                ),
              ),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                isHomeTap == true ? const HomePage() : const BrandingPage(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget drawer() {
    return Drawer(
      elevation: 0,
      shadowColor: transparentColor,
      backgroundColor: whiteColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SafeArea(
            child: Container(
              margin: const EdgeInsets.only(left: 20, top: 40),
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        height: 55,
                        width: 55,
                        child: Image.asset("assets/images/AppLogo.png"),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      GradientText(
                        "Festival Poster",
                        style: GoogleFonts.reemKufiFun(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
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
                  Container(
                    margin: const EdgeInsets.only(top: 40),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: drawerList.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            drawerContainer = index;
                            index == 0
                                ? {
                                    scaffoldKey.currentState!.closeDrawer(),
                                    reviewCount(context),
                                  }
                                : index == 1
                                    ? {
                                        tabTap = 0,
                                        Navigator.push(
                                          context,
                                          PageTransition(
                                            type: PageTransitionType
                                                .rightToLeftWithFade,
                                            child: const Templates(
                                                scrollPosition: 0),
                                          ),
                                        ),
                                        scaffoldKey.currentState!.closeDrawer(),
                                        reviewCount(context),
                                        drawerContainer = 0,
                                      }
                                    : index == 2
                                        ? {
                                            scaffoldKey.currentState!
                                                .closeDrawer(),
                                            showFeedBackDialog(context),
                                            drawerContainer = 0,
                                          }
                                        : index == 3
                                            ? {
                                                Navigator.push(
                                                  context,
                                                  PageTransition(
                                                    type: PageTransitionType
                                                        .rightToLeftWithFade,
                                                    child:
                                                        const SaveImageShow(),
                                                  ),
                                                ),
                                                scaffoldKey.currentState!
                                                    .closeDrawer(),
                                                reviewCount(context),
                                                drawerContainer = 0,
                                              }
                                            : index == 4
                                                ? {
                                                    Navigator.push(
                                                      context,
                                                      PageTransition(
                                                        type: PageTransitionType
                                                            .rightToLeftWithFade,
                                                        child:
                                                            const PrivacyPolicy(),
                                                      ),
                                                    ),
                                                    scaffoldKey.currentState!
                                                        .closeDrawer(),
                                                    reviewCount(context),
                                                    drawerContainer = 0,
                                                  }
                                                : Container();
                            setState(() {});
                          },
                          child: Container(
                            height: 50,
                            margin: const EdgeInsets.only(
                              top: 10,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                              ),
                              color: drawerContainer == index
                                  ? kPrimeryColor.withOpacity(0.08)
                                  : null,
                            ),
                            child: Container(
                              margin: const EdgeInsets.only(left: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Image.asset(
                                        drawerList[index]["icon"],
                                        scale: 4.5,
                                        fit: BoxFit.fill,
                                        color: drawerContainer == index
                                            ? kPrimeryColor
                                            : blackColor,
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Text(
                                        drawerList[index]["name"],
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: drawerContainer == index
                                              ? kPrimeryColor
                                              : blackColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                  drawerContainer == index
                                      ? Container(
                                          height: 50,
                                          width: 5,
                                          decoration: const BoxDecoration(
                                            color: kPrimeryColor,
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(8),
                                              bottomLeft: Radius.circular(8),
                                            ),
                                          ),
                                        )
                                      : Container(),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
