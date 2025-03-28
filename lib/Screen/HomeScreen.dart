import 'dart:convert';
import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:page_transition/page_transition.dart';
import 'package:photo_frame/Contstant/AppColor.dart';
import 'package:photo_frame/Contstant/CommonMethod.dart';
import 'package:photo_frame/Screen/EditImageScreen.dart';
import 'package:photo_frame/Screen/GradientText.dart';
import 'package:photo_frame/Screen/PrivacyPolicy.dart';
import 'package:photo_frame/Screen/Templates.dart';

int drawerContainer = 0;
bool isSliderImageTap = false;
bool isLoading = false;
List versionList = [];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();
  List drawerList = [
    {
      "name": "Home",
      "icon": "assets/images/Home.png",
    },
    {
      "name": "Templates",
      "icon": "assets/images/Templates.png",
    },
    {
      "name": "App Reviews",
      "icon": "assets/images/reviewIcon.png",
    },
    {
      "name": "Privacy and Policy",
      "icon": "assets/images/privacyPolicy.png",
    },
  ];
  List sliderImageList = [
    {
      "image": "assets/images/holi_2-tem.png",
      "image_2": "assets/images/holi_2.png",
    },
    {
      "image": "assets/images/janmashatmi_2-tem.png",
      "image_2": "assets/images/janmashatmi_2.png",
    },
    {
      "image": "assets/images/fatherDay_1-tem.png",
      "image_2": "assets/images/fatherDay_1.png",
    },
    {
      "image": "assets/images/independence_3-tem.png",
      "image_2": "assets/images/independence_3.png",
    },
    {
      "image": "assets/images/enviroment_1-tem.png",
      "image_2": "assets/images/environment_1.png",
    },
  ];
  List homeImageList = [
    {
      "image": "assets/images/independence_3-tem.png",
      "image_2": "assets/images/independence_3.png",
    },
    {
      "image": "assets/images/holi_1-tem.png",
      "image_2": "assets/images/holi_1.png",
    },
    {
      "image": "assets/images/fatherDay_1-tem.png",
      "image_2": "assets/images/fatherDay_1.png",
    },
    {
      "image": "assets/images/newYear_1-tem.png",
      "image_2": "assets/images/newYear_1.png",
    },
    {
      "image": "assets/images/enviroment_1-tem.png",
      "image_2": "assets/images/environment_1.png",
    },
    {
      "image": "assets/images/valentine_1-tem.png",
      "image_2": "assets/images/valentine_1.png",
    },
  ];
  ImagePicker picker = ImagePicker();
  String? version = '';

  // Pick Image Crop From Home Page
  Future<void> cropImage(index) async {
    try {
      if (image != null) {
        print("----------- image Crop ----------- $image");
        var croppedFile = await ImageCropper().cropImage(
          sourcePath: image!.path,
          compressFormat: ImageCompressFormat.jpg,
          compressQuality: 100,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.ratio16x9,
          ],
          uiSettings: [
            AndroidUiSettings(
              toolbarTitle: 'Edit',
              toolbarColor: grey800Color,
              toolbarWidgetColor: whiteColor,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false,
            ),
            IOSUiSettings(
              title: 'Edit',
            ),
            WebUiSettings(
              context: context,
              presentStyle: CropperPresentStyle.dialog,
              boundary: const CroppieBoundary(
                width: 520,
                height: 520,
              ),
              viewPort: const CroppieViewPort(
                  width: 480, height: 480, type: 'circle'),
              enableExif: true,
              enableZoom: true,
              showZoomer: true,
            ),
          ],
        );
        if (croppedFile != null) {
          setState(() {
            File cropImage = File(croppedFile!.path);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => EditImageScreen(
                  cropImage: cropImage,
                  image: isSliderImageTap == true
                      ? sliderImageList[index]["image"]
                      : homeImageList[index]["image"],
                  wallPaper: isSliderImageTap == true
                      ? sliderImageList[index]["image_2"]
                      : homeImageList[index]["image_2"],
                ),
              ),
            );
          });
          setState(() {});
        } else {
          image = null;
          isLoader = false;
          croppedFile = null;
          setState(() {});
        }
      }
    } catch (e) {
      print("-------------- Image Crop Error ----------- $e");
    }
  }

  // Get Json File Data
  Future<void> getImages() async {
    try {
      var imageResponse = await rootBundle.loadString('assets/images.json');
      templateWithImageList = jsonDecode(imageResponse).toList();
      setState(() {});
    } catch (e) {
      print("-------------- Json Get Data Error -------------- $e");
    }
  }

  // Get Version
  Future<void> getVersion() async {
    try {
      var versionResponse = await rootBundle.loadString('assets/version.json');
      versionList = jsonDecode(versionResponse).toList();
      setState(() {});
    } catch (e) {
      print("-------------- Json Get version Error -------------- $e");
    }
  }

  // Check Version
  Future<void> checkVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version = packageInfo.version;
    int currentVersion = getVersionNumber(version!);
    int latestVersion = getVersionNumber(versionList[0]["appVersion"]);
    print("---------- Current Version ----------- $version");
    print("---------- v1 ----------- $currentVersion");
    print("---------- v2 ----------- $latestVersion");
    // if (version[0]["appVersion"] != currentVersion) {
    if (latestVersion > currentVersion) {
      print("---------- Dialog Show ------------");
      showUpdateDialog(context);
    } else {
      print("----------- Dialog Not Show -------------");
    }
  }

  // String to Int Convert Version
  int getVersionNumber(String version) {
    List versionCells = version.split(".");
    versionCells = versionCells.map((e) => int.parse(e)).toList();
    return versionCells[0] * 100000 + versionCells[1] * 1000 + versionCells[2];
  }

  @override
  void initState() {
    if (templateWithImageList.isEmpty) {
      getImages();
    }
    getVersion();
    checkVersion();
    reviewCount(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    return Scaffold(
      key: key,
      backgroundColor: kscaffoldBgColor,
      appBar: AppBar(
        backgroundColor: kPrimeryColor,
        title: Text(
          "Home",
          style: GoogleFonts.poppins(
            color: whiteColor,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: GestureDetector(
          onTap: () {
            key.currentState!.openDrawer();
            setState(() {});
          },
          child: const Icon(
            Icons.menu,
            color: whiteColor,
          ),
        ),
      ),
      drawer: Drawer(
        elevation: 0,
        shadowColor: transparentColor,
        backgroundColor: whiteColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppBar(
              backgroundColor: kPrimeryColor,
              leading: Container(),
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.menu,
                    color: whiteColor,
                    size: 30,
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(left: 20, top: 30),
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
                    margin: const EdgeInsets.only(top: 5),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: drawerList.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            index == 0
                                ? {
                                    key.currentState!.closeDrawer(),
                                    reviewCount(context),
                                  }
                                : index == 1
                                    ? {
                                        Navigator.push(
                                          context,
                                          PageTransition(
                                            type: PageTransitionType
                                                .rightToLeftWithFade,
                                            child: const Templates(),
                                          ),
                                        ),
                                        key.currentState!.closeDrawer(),
                                        reviewCount(context),
                                      }
                                    : index == 2
                                        ? {
                                            key.currentState!.closeDrawer(),
                                            showFeedBackDialog(context),
                                          }
                                        : index == 3
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
                                                key.currentState!.closeDrawer(),
                                                reviewCount(context),
                                              }
                                            : Container();
                            setState(() {});
                          },
                          child: Container(
                            height: 50,
                            margin: const EdgeInsets.only(
                              top: 10,
                              right: 20,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: drawerContainer == index
                                  ? kDrwerSelectColor
                                  : null,
                            ),
                            child: Container(
                              margin: const EdgeInsets.only(left: 10),
                              child: Row(
                                children: [
                                  Image.asset(
                                    drawerList[index]["icon"],
                                    scale: 6,
                                    color: drawerContainer == index
                                        ? whiteColor
                                        : blackColor,
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    drawerList[index]["name"],
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: drawerContainer == index
                                          ? whiteColor
                                          : blackColor,
                                    ),
                                  ),
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
          ],
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10),
                child: CarouselSlider.builder(
                  itemCount: sliderImageList.length,
                  itemBuilder:
                      (BuildContext context, int index, int realIndex) {
                    return GestureDetector(
                      onTap: () async {
                        isSliderImageTap = true;
                        reviewCount(context);
                        await imageDialog(context, index, setState);
                        cropImage(index);
                      },
                      child: Image.asset(
                        sliderImageList[index]["image"],
                      ),
                    );
                  },
                  options: CarouselOptions(
                    height: 0.25 * h,
                    viewportFraction: 0.35,
                    initialPage: 0,
                    enlargeCenterPage: true,
                    enlargeFactor: 0.4,
                    scrollDirection: Axis.horizontal,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(top: 10),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: greyColor,
                        blurRadius: 10.0,
                      ),
                    ],
                    color: whiteColor,
                  ),
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 10, right: 10),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.rightToLeftWithFade,
                                child: const Templates(),
                              ),
                            );
                            reviewCount(context);
                          },
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0,
                                  ),
                                  child: Container(
                                    margin: const EdgeInsets.only(right: 5),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: blackColor,
                                        width: 1.5,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 25.0,
                                        vertical: 6.0,
                                      ),
                                      child: Text(
                                        "View all",
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 14,
                                  top: 4,
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: blackColor,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                        left: 2,
                                        bottom: 2,
                                        top: 2,
                                      ),
                                      padding: const EdgeInsets.all(3.0),
                                      child: const Icon(
                                        Icons.arrow_forward_ios,
                                        size: 12,
                                        color: whiteColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(
                            top: 10,
                            left: 10,
                            right: 10,
                          ),
                          child: MasonryGridView.builder(
                            padding: const EdgeInsets.only(bottom: 10),
                            itemCount: homeImageList.length,
                            gridDelegate:
                                const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                            ),
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(8),
                                child: GestureDetector(
                                  onTap: () async {
                                    reviewCount(context);
                                    await imageDialog(context, index, setState);
                                    cropImage(index);
                                  },
                                  child: Image.asset(
                                    homeImageList[index]["image"],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
