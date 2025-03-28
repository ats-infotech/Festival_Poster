import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:page_transition/page_transition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_frame/Contstant/AppColor.dart';
import 'package:photo_frame/Contstant/CommonMethod.dart';
import 'package:photo_frame/Screen/EditImageScreen.dart';
import 'package:photo_frame/Screen/EditVisitingCard.dart';
import 'package:photo_frame/Screen/HomePage.dart';
import 'package:photo_frame/Screen/SpecificPoster.dart';
import 'package:photo_frame/Screen/Templates.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

String? selectedName;

class HomeSearchPage extends StatefulWidget {
  const HomeSearchPage({super.key});

  @override
  State<HomeSearchPage> createState() => _HomeSearchPageState();
}

class _HomeSearchPageState extends State<HomeSearchPage> {
  TextEditingController searchController = TextEditingController();
  bool isSeeAllTap = true;
  List homeDataList = [];
  List homeFilterList = [];
  List homePosterDataList = [];
  List homePosterFilterList = [];
  SpeechToText speechToText = SpeechToText();
  bool isSpeechEnable = false;
  bool isDialogShow = false;
  String lastWords = "";

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
          androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Edit',
            toolbarColor: grey800Color,
            toolbarWidgetColor: whiteColor,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
          ),
          iosUiSettings: const IOSUiSettings(
            title: 'Edit',
          ),
        );
        if (croppedFile != null) {
          setState(() {
            File cropImage = File(croppedFile!.path);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => EditImageScreen(
                  cropImage: cropImage,
                  image: isPatrioticImageTap == true
                      ? patrioticDayList[index]["image"]
                      : isFestivalImageTap == true
                          ? festivalsEventList[index]["image"]
                          : isSpecialImageTap == true
                              ? specialDaysList[index]["image"]
                              : homePosterDataList[index]["image"],
                  wallPaper: isPatrioticImageTap == true
                      ? patrioticDayList[index]["image_2"]
                      : isFestivalImageTap == true
                          ? festivalsEventList[index]["image_2"]
                          : isSpecialImageTap == true
                              ? specialDaysList[index]["image_2"]
                              : homePosterDataList[index]["image_2"],
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

  Future<void> initSpeech() async {
    isSpeechEnable = await speechToText.initialize();
    print("---------- isSpeechEnable --------- $isSpeechEnable");
    setState(() {});
  }

  Future<void> startListening() async {
    await speechToText.listen(onResult: onSpeechResult);
    setState(() {});
  }

  Future<void> stopListening() async {
    await speechToText.stop();
    isDialogShow = false;
    setState(() {});
  }

  void onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      lastWords = result.recognizedWords;
      searchController.text = lastWords;
    });
    searchData(lastWords);
    searchTemplateData(lastWords);
    if (speechToText.isNotListening) {
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          isDialogShow = false;
        });
      });
    }
  }

  void searchData(String search) {
    homeDataList.clear();
    homeFilterList.clear();
    if (search.isEmpty) {
      homeDataList = List.from(popularFetivalList);
    } else {
      for (var searchData in popularFetivalList) {
        if (searchData['name'].toLowerCase().contains(search.toLowerCase())) {
          homeFilterList.add(searchData);
        }
      }
      homeDataList = List.from(homeFilterList);
    }
  }

  void searchTemplateData(String search) {
    homePosterDataList.clear();
    homePosterFilterList.clear();
    if (search.isEmpty) {
      homePosterDataList = List.from(templateWithImageList);
    } else {
      for (var searchData in templateWithImageList) {
        if (searchData['searchText']
            .toLowerCase()
            .contains(search.toLowerCase())) {
          homePosterFilterList.add(searchData);
        }
      }
      homePosterDataList = List.from(homePosterFilterList);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchData("");
    searchTemplateData("");
    getPatrioticImage();
    getFestivalImage();
    getSpecialImage();
    getVisitingCard();
    initSpeech();
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: kPrimeryColor,
          ),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Material(
                  elevation: 2,
                  borderRadius: BorderRadius.circular(10),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.fromLTRB(20, 12, 10, 0),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: greyColor,
                      ),
                      suffixIcon: IconButton(
                        onPressed: () async {
                          log('•••••••••••••••••  microphone permission •••••••••••••••••••  ${await Permission.microphone.status}');
                          if (await Permission.microphone.isPermanentlyDenied) {
                            showPermissionDeniedDialog(
                                title:
                                    'Microphone Permission Permanently Denied',
                                description:
                                    "The app has detected that microphone access has been permanently denied on your device. To continue using features that require microphone access, please open your device's settings and enable microphone permissions for this app.");
                          } else if (await Permission.microphone.isDenied) {
                            final status =
                                await Permission.microphone.request();
                            if (status.isDenied || status.isPermanentlyDenied) {
                              showPermissionDeniedDialog(
                                  title:
                                      'Microphone Permission Permanently Denied',
                                  description:
                                      "The app has detected that microphone access has been permanently denied on your device. To continue using features that require microphone access, please open your device's settings and enable microphone permissions for this app.");
                            }
                          } else {
                            log('•••••••••••••••••  microphone permission •••••••••••••••••••  ${await Permission.microphone.status}');
                            setState(() {
                              lastWords = "";
                              isDialogShow = true;
                            });
                            await initSpeech();
                            speechToText.isNotListening
                                ? startListening()
                                : stopListening();

                            if (speechToText.isNotListening) {
                              Future.delayed(
                                const Duration(seconds: 4),
                                () {
                                  if (lastWords == "") {
                                    setState(() {
                                      isDialogShow = false;
                                    });
                                  }
                                },
                              );
                            }
                          }
                        },
                        icon: const Icon(
                          Icons.keyboard_voice_outlined,
                        ),
                        color: greyColor,
                      ),
                      hintText: "Search Your Poster",
                      hintStyle: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    cursorColor: blackColor,
                    autofocus: true,
                    onChanged: (value) {
                      searchData(value);
                      searchTemplateData(value);
                      setState(() {});
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      homeDataList.isNotEmpty
                          ? Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                children: [
                                  Container(
                                    height: 30,
                                    width: 3,
                                    decoration: BoxDecoration(
                                      color: kPrimeryColor,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    "Popular Poster",
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: kPrimeryColor,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Container(),
                      homeDataList.isNotEmpty
                          ? SizedBox(
                              height: isSeeAllTap ? 150 : null,
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: GridView.count(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  crossAxisCount: 3,
                                  childAspectRatio: 0.0022 * w,
                                  children: List.generate(
                                    homeDataList.length,
                                    (index) {
                                      return GestureDetector(
                                        onTap: () {
                                          selectedName =
                                              homeDataList[index]["name"];
                                          Navigator.push(
                                            context,
                                            PageTransition(
                                              type: PageTransitionType
                                                  .rightToLeftWithFade,
                                              child: const SpecificPoster(),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          margin:
                                              const EdgeInsets.only(top: 30),
                                          width: w / 3 - 20,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Material(
                                                elevation: 5,
                                                borderRadius:
                                                    BorderRadius.circular(70),
                                                child: Container(
                                                  height: 70,
                                                  width: 70,
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: whiteColor,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Image.asset(
                                                    homeDataList[index]["icon"],
                                                    scale: 5,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 12,
                                              ),
                                              Text(
                                                homeDataList[index]["name"],
                                                style: GoogleFonts.poppins(
                                                  fontSize: 0.03 * w,
                                                  color: kPrimeryColor,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            )
                          : Container(),
                      const SizedBox(
                        height: 20,
                      ),
                      searchController.text != ""
                          ? GridView.count(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              crossAxisCount: 3,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              children: List.generate(
                                homePosterDataList.length,
                                (index) {
                                  return GestureDetector(
                                    onTap: () async {
                                      templateName =
                                          homePosterDataList[index]["title"];
                                      print(
                                          " ---------- Template Name -------- ${templateName}");
                                      homePosterDataList[index]["type"] ==
                                              "Post"
                                          ? {
                                              await imageDialog(
                                                context,
                                                index,
                                              ),
                                              cropImage(index),
                                              reviewCount(context),
                                            }
                                          : Navigator.push(
                                              context,
                                              PageTransition(
                                                type: PageTransitionType
                                                    .rightToLeftWithFade,
                                                child: EditVisitingCard(
                                                  frontSide:
                                                      homePosterDataList[index]
                                                          ["image_2"],
                                                  backSide:
                                                      homePosterDataList[index]
                                                          ["image_3"],
                                                ),
                                              ),
                                            );
                                    },
                                    child: Container(
                                      width: w / 3 - 20,
                                      height: w / 3 - 20,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Image.asset(
                                        homePosterDataList[index]["image"],
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )
                          : Column(
                              children: [
                                homeDataList.isNotEmpty
                                    ? GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            isSeeAllTap = !isSeeAllTap;
                                          });
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              isSeeAllTap
                                                  ? "See All"
                                                  : "See Less",
                                              style: GoogleFonts.poppins(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: const Color(0xff747474),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Icon(
                                              isSeeAllTap
                                                  ? Icons
                                                      .keyboard_arrow_down_outlined
                                                  : Icons.keyboard_arrow_up,
                                              color: const Color(0xff747474),
                                            )
                                          ],
                                        ),
                                      )
                                    : Container(),
                                const SizedBox(
                                  height: 30,
                                ),
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child:
                                      rowText("Patriotic Day", "View All", () {
                                    tabTap = 1;
                                    Navigator.push(
                                      context,
                                      PageTransition(
                                        type: PageTransitionType
                                            .rightToLeftWithFade,
                                        child:
                                            const Templates(scrollPosition: 0),
                                      ),
                                    );
                                  }),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                SizedBox(
                                  height: w / 3 - 20,
                                  child: ListView.builder(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 20),
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: patrioticDayList.length,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () async {
                                          templateName =
                                              patrioticDayList[index]["title"];
                                          print(
                                              " ---------- Template Name -------- ${templateName}");
                                          isPatrioticImageTap = true;
                                          isFestivalImageTap = false;
                                          isSpecialImageTap = false;
                                          await imageDialog(context, index);
                                          cropImage(index);
                                          reviewCount(context);
                                          setState(() {});
                                        },
                                        child: Container(
                                          margin:
                                              const EdgeInsets.only(left: 10),
                                          width: w / 3 - 20,
                                          height: w / 3 - 20,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          child: Image.asset(
                                            patrioticDayList[index]["image"],
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: rowText(
                                    "Transparent Visiting Card",
                                    "View All",
                                    () {
                                      tabTap = 4;
                                      Navigator.push(
                                        context,
                                        PageTransition(
                                          type: PageTransitionType
                                              .rightToLeftWithFade,
                                          child: const Templates(
                                              scrollPosition: 320),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                SizedBox(
                                  height: w / 3 - 20,
                                  child: ListView.builder(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 20),
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: visitingCardList.length,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () {
                                          templateName =
                                              visitingCardList[index]["title"];
                                          print(
                                              " ---------- Template Name -------- ${templateName}");
                                          reviewCount(context);
                                          Navigator.push(
                                            context,
                                            PageTransition(
                                              type: PageTransitionType
                                                  .rightToLeftWithFade,
                                              child: EditVisitingCard(
                                                frontSide:
                                                    visitingCardList[index]
                                                        ["image_2"],
                                                backSide:
                                                    visitingCardList[index]
                                                        ["image_3"],
                                              ),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          margin:
                                              const EdgeInsets.only(left: 10),
                                          width: w / 3 - 20,
                                          height: w / 3 - 20,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          child: Image.asset(
                                            visitingCardList[index]["image"],
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: rowText(
                                    "Folded Visiting Cards",
                                    "View All",
                                    () {
                                      tabTap = 4;
                                      Navigator.push(
                                        context,
                                        PageTransition(
                                          type: PageTransitionType
                                              .rightToLeftWithFade,
                                          child: const Templates(
                                              scrollPosition: 320),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                SizedBox(
                                  height: w / 3 - 20,
                                  child: ListView.builder(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 20),
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: visitingCardList.length,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () {
                                          templateName =
                                              visitingCardList[index]["title"];
                                          print(
                                              " ---------- Template Name -------- ${templateName}");
                                          reviewCount(context);
                                          Navigator.push(
                                            context,
                                            PageTransition(
                                              type: PageTransitionType
                                                  .rightToLeftWithFade,
                                              child: EditVisitingCard(
                                                frontSide:
                                                    visitingCardList[index]
                                                        ["image_2"],
                                                backSide:
                                                    visitingCardList[index]
                                                        ["image_3"],
                                              ),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          margin:
                                              const EdgeInsets.only(left: 10),
                                          width: w / 3 - 20,
                                          height: w / 3 - 20,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          child: Image.asset(
                                            visitingCardList[index]["image"],
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child:
                                      rowText("Festival Day", "View All", () {
                                    tabTap = 2;
                                    Navigator.push(
                                      context,
                                      PageTransition(
                                        type: PageTransitionType
                                            .rightToLeftWithFade,
                                        child: const Templates(
                                            scrollPosition: 100),
                                      ),
                                    );
                                  }),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                SizedBox(
                                  height: w / 3 - 20,
                                  child: ListView.builder(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 20),
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: festivalsEventList.length,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () async {
                                          templateName =
                                              festivalsEventList[index]
                                                  ["title"];
                                          print(
                                              " ---------- Template Name -------- ${templateName}");
                                          isFestivalImageTap = true;
                                          isPatrioticImageTap = false;
                                          isSpecialImageTap = false;
                                          await imageDialog(context, index);
                                          cropImage(index);
                                          reviewCount(context);
                                          setState(() {});
                                        },
                                        child: Container(
                                          margin:
                                              const EdgeInsets.only(left: 10),
                                          width: w / 3 - 20,
                                          height: w / 3 - 20,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          child: Image.asset(
                                            festivalsEventList[index]["image"],
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: rowText(
                                    "Premium Visiting Card",
                                    "View All",
                                    () {
                                      tabTap = 4;
                                      Navigator.push(
                                        context,
                                        PageTransition(
                                          type: PageTransitionType
                                              .rightToLeftWithFade,
                                          child: const Templates(
                                              scrollPosition: 320),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                SizedBox(
                                  height: w / 3 - 20,
                                  child: ListView.builder(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 20),
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: visitingCardList.length,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () {
                                          templateName =
                                              visitingCardList[index]["title"];
                                          print(
                                              " ---------- Template Name -------- ${templateName}");
                                          reviewCount(context);
                                          Navigator.push(
                                            context,
                                            PageTransition(
                                              type: PageTransitionType
                                                  .rightToLeftWithFade,
                                              child: EditVisitingCard(
                                                frontSide:
                                                    visitingCardList[index]
                                                        ["image_2"],
                                                backSide:
                                                    visitingCardList[index]
                                                        ["image_3"],
                                              ),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          margin:
                                              const EdgeInsets.only(left: 10),
                                          width: w / 3 - 20,
                                          height: w / 3 - 20,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          child: Image.asset(
                                            visitingCardList[index]["image"],
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: rowText("Special Day", "View All", () {
                                    tabTap = 3;
                                    Navigator.push(
                                      context,
                                      PageTransition(
                                        type: PageTransitionType
                                            .rightToLeftWithFade,
                                        child: const Templates(
                                            scrollPosition: 250),
                                      ),
                                    );
                                  }),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                SizedBox(
                                  height: w / 3 - 20,
                                  child: ListView.builder(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 20),
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: specialDaysList.length,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () async {
                                          templateName =
                                              specialDaysList[index]["title"];
                                          print(
                                              " ---------- Template Name -------- ${templateName}");
                                          isSpecialImageTap = true;
                                          isPatrioticImageTap = false;
                                          isFestivalImageTap = false;
                                          await imageDialog(context, index);
                                          cropImage(index);
                                          reviewCount(context);
                                          setState(() {});
                                        },
                                        child: Container(
                                          margin:
                                              const EdgeInsets.only(left: 10),
                                          width: w / 3 - 20,
                                          height: w / 3 - 20,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          child: Image.asset(
                                            specialDaysList[index]["image"],
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: rowText(
                                    "Photographic Visiting Cards",
                                    "View All",
                                    () {
                                      tabTap = 4;
                                      Navigator.push(
                                        context,
                                        PageTransition(
                                          type: PageTransitionType
                                              .rightToLeftWithFade,
                                          child: const Templates(
                                              scrollPosition: 320),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                SizedBox(
                                  height: w / 3 - 20,
                                  child: ListView.builder(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 20),
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: visitingCardList.length,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () {
                                          templateName =
                                              visitingCardList[index]["title"];
                                          print(
                                              " ---------- Template Name -------- ${templateName}");
                                          reviewCount(context);
                                          Navigator.push(
                                            context,
                                            PageTransition(
                                              type: PageTransitionType
                                                  .rightToLeftWithFade,
                                              child: EditVisitingCard(
                                                frontSide:
                                                    visitingCardList[index]
                                                        ["image_2"],
                                                backSide:
                                                    visitingCardList[index]
                                                        ["image_3"],
                                              ),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          margin:
                                              const EdgeInsets.only(left: 10),
                                          width: w / 3 - 20,
                                          height: w / 3 - 20,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          child: Image.asset(
                                            visitingCardList[index]["image"],
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                      const SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          isDialogShow == true
              ? GestureDetector(
                  onTap: () {
                    setState(() {
                      isDialogShow = false;
                    });
                  },
                  child: Container(
                    height: double.infinity,
                    width: double.infinity,
                    color: blackColor.withOpacity(0.5),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          isDialogShow = true;
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: whiteColor,
                              boxShadow: [
                                BoxShadow(
                                  color: kPrimeryColor.withOpacity(0.5),
                                  offset: const Offset(0, 3),
                                  blurRadius: 4,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(30.0),
                              child: Image.asset(
                                "assets/images/voice.png",
                                scale: 5,
                              ),
                            ),
                          ),
                          Text(
                            speechToText.isListening ? lastWords : "",
                            style: GoogleFonts.poppins(
                              color: whiteColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
