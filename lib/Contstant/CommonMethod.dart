import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:clipboard/clipboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_frame/Contstant/AppColor.dart';
import 'package:photo_frame/Contstant/EditableTextItem.dart';
import 'package:photo_frame/Contstant/Strings.dart';
import 'package:photo_frame/Contstant/sharedPreference.dart';
import 'package:photo_frame/Screen/EditImageScreen.dart';
import 'package:photo_frame/Screen/EditVisitingCard.dart';
import 'package:photo_frame/Screen/HomePage.dart';
import 'package:photo_frame/Screen/Templates.dart';
import 'package:photo_frame/Screen/saveImageShow.dart';
import 'package:photo_frame/WebScreen/EditImageScreenWeb.dart';
import 'package:photo_frame/service/firebase_analytics_service.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:ui' as ui;

List<String> fontFamilyList = [
  'Poppins',
  'Roboto',
  'Lobster',
  'Oswald',
  'Merriweather',
  "Lexend",
];

List<double> fontSizeList = [
  8.0,
  10.0,
  12.0,
  14.0,
  16.0,
  18.0,
  20.0,
  22.0,
];

List<double> strokeWidthList = [
  1.0,
  2.0,
  3.0,
  4.0,
  5.0,
  6.0,
  7.0,
  8.0,
  9.0,
  10.0,
];

final List drawList = [
  {
    "icon": Icons.edit,
    "name": "Brush",
  },
  {
    "icon": Icons.brush,
    "name": "Pencil",
  },
  {
    "icon": Icons.show_chart,
    "name": "Line",
  },
  {
    "icon": CupertinoIcons.stop,
    "name": "Rectangle",
  },
  {
    "icon": CupertinoIcons.circle,
    "name": "Circle",
  },
  {
    "icon": CupertinoIcons.triangle,
    "name": "Triangle",
  },
  {
    "icon": CupertinoIcons.bandage,
    "name": "Eraser",
  },
];

ImagePicker picker = ImagePicker();
bool isLoader = false;
var isInternetConnected = false;

List drawerList = [
  {
    "name": "Dashboard",
    "icon": "assets/images/drawerDashboard.png",
  },
  {
    "name": "Templates",
    "icon": "assets/images/drawerTemplate.png",
  },
  {
    "name": "Reviews",
    "icon": "assets/images/drawerReview.png",
  },
  // {
  //   "name": "Saved Templates",
  //   "icon": "assets/images/drawerSaveImage.png",
  // },
  {
    "name": "Personal Info",
    "icon": "assets/images/personal_info.png",
  },
  {
    "name": "Feedback",
    "icon": "assets/images/survey.png",
  },
  {
    "name": "Privacy and Policy",
    "icon": "assets/images/drawerPrivacyPolicy.png",
  },
];

// Image Pick Dialog
imageDialog(BuildContext context, int index, {required String templateName}) {
  FirebaseAnalyticsService.instance
      .logEvent(name: 'template_selection', parameters: {'name': templateName});
  return showGeneralDialog(
    barrierDismissible: false,
    context: context,
    pageBuilder: (context, animation, secondaryAnimation) {
      return Container();
    },
    transitionBuilder: (context, a1, a2, widget) {
      return Transform.scale(
        scale: a1.value,
        child: StatefulBuilder(
          builder: (context, newSetState) {
            return Opacity(
              opacity: a1.value,
              child: Center(
                child: isLoader
                    ? commonLoader()
                    : Stack(
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            decoration: BoxDecoration(
                              color: whiteColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            height: 200,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    try {
                                      if (await Permission
                                          .camera.isPermanentlyDenied) {
                                        showPermissionDeniedDialog(
                                            title:
                                                'Camera Permission Permanently Denied',
                                            description:
                                                "The app has detected that camera access has been permanently denied on your device. To continue using features that require camera access, please open your device's settings and enable camera permissions for this app.");
                                        print(
                                            '•••••••••••••• camera permission permanetly denied');
                                      } else if (await Permission
                                          .camera.isDenied) {
                                        final status =
                                            await Permission.camera.request();
                                        if (status.isDenied ||
                                            status.isPermanentlyDenied) {
                                          showPermissionDeniedDialog(
                                              title:
                                                  'Camera Permission Permanently Denied',
                                              description:
                                                  "The app has detected that camera access has been permanently denied on your device. To continue using features that require camera access, please open your device's settings and enable camera permissions for this app.");
                                        }
                                        print(
                                            '•••••••••••••• camera permission denied');
                                      } else {
                                        print(
                                            '•••••••••••••• camera permission grandted');
                                        isLoader = true;
                                        newSetState(() {});
                                        if (editController.pickedImage.value !=
                                            null) {
                                          File f1 = File(editController
                                              .pickedImage.value!.path);
                                          f1.delete().then((value) {
                                            print(
                                                "----------- Delete --------- $value");
                                          });
                                        }

                                        editController.pickedImage.value =
                                            await picker.pickImage(
                                          source: ImageSource.camera,
                                          imageQuality: 80,
                                        );
                                        if (editController.pickedImage.value !=
                                            null) {
                                          var imagePath = await editController
                                              .pickedImage.value!
                                              .readAsBytes();
                                          var fileSize = imagePath.length;
                                          final kb = fileSize / 1024;
                                          final mb = kb / 1024;
                                          print(
                                              "------------ Image Size ----------- $mb.MB");
                                          if (mb < 3) {
                                            Navigator.pop(context);
                                            image = editController
                                                .pickedImage.value;
                                          } else {
                                            Navigator.pop(context);
                                            image = await compressImage(
                                                File(editController
                                                    .pickedImage.value!.path),
                                                ".jpg");
                                          }
                                        } else {
                                          isLoader = false;
                                          image = null;
                                          newSetState(() {});
                                          Navigator.pop(context);
                                        }
                                        Future.delayed(
                                            const Duration(seconds: 2), () {
                                          isLoader = false;
                                        });
                                      }
                                    } catch (e) {
                                      isLoader = false;
                                      newSetState(() {});

                                      print(
                                          "------------ Image Pick Camera Error --------- $e");
                                    }
                                  },
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: kPrimeryColor,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(40.0),
                                      child: Image.asset(
                                        "assets/images/camera.png",
                                        scale: 5,
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    try {
                                      isLoader = true;
                                      newSetState(() {});
                                      if (editController.pickedImage.value !=
                                          null) {
                                        File f1 = File(editController
                                            .pickedImage.value!.path);
                                        f1.delete().then((value) {
                                          print(
                                              "----------- Delete --------- $value");
                                        });
                                      }
                                      editController.pickedImage.value =
                                          await picker.pickImage(
                                        source: ImageSource.gallery,
                                        imageQuality: 50,
                                      );
                                      if (editController.pickedImage.value !=
                                          null) {
                                        var imagePath = await editController
                                            .pickedImage.value!
                                            .readAsBytes();
                                        var fileSize = imagePath.length;
                                        final kb = fileSize / 1024;
                                        final mb = kb / 1024;
                                        print(
                                            "------------ Image Size ----------- $mb.MB");
                                        if (mb < 3) {
                                          image =
                                              editController.pickedImage.value;
                                          Navigator.pop(context);
                                        } else {
                                          image = await compressImage(
                                              File(editController
                                                  .pickedImage.value!.path),
                                              ".jpg");
                                          Navigator.pop(context);
                                        }
                                      } else if (editController
                                              .pickedImage.value ==
                                          null) {
                                        isLoader = false;
                                        image = null;
                                        newSetState(() {});
                                        Navigator.pop(context);
                                      }
                                      Future.delayed(const Duration(seconds: 2),
                                          () {
                                        isLoader = false;
                                      });
                                    } catch (e) {
                                      print(
                                          "----------- Image pick gallery Error ---------- $e");
                                    }
                                  },
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: kPrimeryColor,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(40.0),
                                      child: Image.asset(
                                        "assets/images/gallery.png",
                                        scale: 5,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            right: 5,
                            top: 4,
                            child: GestureDetector(
                              onTap: () {
                                image = null;
                                Navigator.pop(context);
                              },
                              child: Container(
                                height: 35,
                                width: 35,
                                decoration: const BoxDecoration(
                                  color: kPrimeryColor,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.close,
                                  color: whiteColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            );
          },
        ),
      );
    },
  );
}

// Pick Image Compress
Future compressImage(File file, String targetPath) async {
  try {
    final tempDir = await getTemporaryDirectory();
    final targetFile = File('${tempDir.path}/compressed_image$targetPath');
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetFile.path,
    );
    var imagePath = await result!.readAsBytes();
    var fileSize = imagePath.length;
    final kb = fileSize / 1024;
    final mb = kb / 1024;
    print("--------- After Compress MB ---------- $mb.MB");
    return result;
  } catch (e) {
    print("------------ Image Compress Error ------------ $e");
  }
}

// Internet Dialog
void showInternetDialog(BuildContext context) {
  if (!isInternetConnected) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: whiteColor,
          title: const Text(
            "Try again",
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          content: const Text(
            "Please check your internet Connection.",
            style: TextStyle(
              fontSize: 15,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text(ok),
            ),
          ],
        );
      },
    );
  }
}

// Internet Connectivity
void internetConnectivity(BuildContext context, isInternet) {
  Timer.run(() {
    try {
      InternetAddress.lookup("google.com").then((value) {
        if (value.isNotEmpty && value[0].rawAddress.isNotEmpty) {
          print("------------- Connected ------------");
          isInternet(true);
        } else {
          print("--------------- Not Connected ---------------");
          isInternet(false);
        }
      }).catchError((error) {
        print("------------- Not Connected ---------------");
        isInternet(false);
      });
    } catch (e) {
      print("----------- Internet Error ----------- $e");
      isInternet(false);
    }
  });
}

// Internet Check
checkInternet(BuildContext context, navigate) {
  internetConnectivity(context, (bool isInternet) {
    if (!isInternet) {
      print("----------- Dialog Open ------------");
      showInternetDialog(context);
    } else {
      // if (navigate) {
      // onNavigate();
      // }
    }
  });
}

// Update Dialog
void showUpdateDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        backgroundColor: whiteColor,
        title: const Text('New Update'),
        content: const SingleChildScrollView(
          child: ListBody(
            children: [
              Text(
                'New Version is available please update the app.',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Update Now'),
            onPressed: () async {
              launchUrl(Uri.parse(
                  "https://play.google.com/store/apps/details?id=com.festival.posterImage"));
            },
          ),
          versionList[0]["forceUpdate"] == false
              ? TextButton(
                  child: const Text(cancel),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              : Container(),
        ],
      );
    },
  );
}

// Skeleton Show
Future<bool> loadImage() async {
  try {
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  } catch (e) {
    return false;
  }
}

// Feedback Dialog
showFeedBackDialog(BuildContext context) {
  var h = MediaQuery.of(context).size.height / 100;
  var w = MediaQuery.of(context).size.width / 100;
  int rating = 0;
  bool isStarTap = false;
  bool isSubmitButton = false;
  List image = [
    'assets/images/first_star.png',
    'assets/images/second_star.png',
    'assets/images/third_star.png',
    'assets/images/four_star.png',
    'assets/images/five_star.png',
  ];
  List text = [
    'Not at all Satisfied',
    'Slightly Satisfied',
    'Netural',
    'Very Satisfied',
    'Extremely Satisfied',
  ];

  Widget borderImage(color) {
    print('Tap...... $isStarTap');

    return Image.asset(
      'assets/images/ratingStar.png',
      color: color,
    );
  }

  Widget fillColorImage(color) {
    print('Tap...... $isStarTap');
    return Image.asset(
      'assets/images/fillColorImage.png',
      color: color,
    );
  }

  Widget star(index) {
    if (index < rating) {
      return fillColorImage(fillStarColor);
    } else {
      return borderImage(blackColor);
    }
  }

  Widget feedBackImage(int index) {
    if (index >= 1 && index <= 5) {
      return SizedBox(
        height: 15 * h,
        width: 25 * w,
        child: Image.asset(image[index - 1]),
      );
    } else {
      return SizedBox(
        height: 15 * h,
        width: 55 * w,
        child: Image.asset('assets/images/feedbackDialog.png'),
      );
    }
  }

  Widget feedBackText(int index) {
    if (index >= 1 && index <= 5) {
      return Text(
        text[index - 1],
        textAlign: TextAlign.center,
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      );
    } else {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Text(
          giveUsFeedback,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }
  }

  Widget reviewDialog() {
    return StatefulBuilder(
      builder: (BuildContext context, setState) {
        return Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 5),
            width: double.infinity,
            color: transparentColor,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(13.0),
                  child: Container(
                    width: !isStarTap ? 150 * w : 150 * w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: whiteColor,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height: !isStarTap ? 3 * h : 2 * h,
                          ),
                          isSubmitButton == false
                              ? feedBackImage(rating)
                              : rating <= 4
                                  ? SizedBox(
                                      height: 18.8 * h,
                                      width: 35 * w,
                                      child: Image.asset(
                                        'assets/images/review_submit.png',
                                      ),
                                    )
                                  : Container(
                                      margin: const EdgeInsets.only(
                                        top: 20,
                                        left: 30,
                                        right: 30,
                                      ),
                                      child: Text.rich(
                                        textAlign: TextAlign.center,
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text: "Glad you're enjoying ",
                                              style: GoogleFonts.poppins(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            TextSpan(
                                              text: " Festival Poster! ",
                                              style: GoogleFonts.poppins(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            TextSpan(
                                              text:
                                                  "We’d really appreciate it if you could leave us a rating.",
                                              style: GoogleFonts.poppins(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                          SizedBox(
                            height: isSubmitButton == false
                                ? !isStarTap
                                    ? 3 * h
                                    : 1 * h
                                : 2 * h,
                          ),
                          isSubmitButton == false
                              ? feedBackText(rating)
                              : rating <= 4
                                  ? Text(
                                      'Completed',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: kPrimeryColor,
                                      ),
                                    )
                                  : Container(
                                      margin: const EdgeInsets.only(
                                        left: 40,
                                        right: 40,
                                        top: 10,
                                      ),
                                      height: 16 * h,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: reviewContainetColor,
                                          width: 2,
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Column(
                                            children: [
                                              Text(
                                                "Rate Your Experience",
                                                style: GoogleFonts.poppins(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              Text(
                                                "Tell others what you think",
                                                style: GoogleFonts.poppins(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                  color: reviewTextColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Image.asset(
                                            "assets/images/fullRating.png",
                                            scale: 6,
                                          ),
                                        ],
                                      ),
                                    ),
                          SizedBox(
                            height: isSubmitButton == false
                                ? !isStarTap
                                    ? 2 * h
                                    : 3.5 * h
                                : 2 * h,
                          ),
                          isSubmitButton == false
                              ? SizedBox(
                                  width: 65 * w,
                                  height: 4 * h,
                                  child: GridView.builder(
                                    padding: EdgeInsets.zero,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    // shrinkWrap: true,
                                    itemCount: 5,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 5,
                                      mainAxisSpacing: 3 * h,
                                      crossAxisSpacing: 4 * w,
                                      mainAxisExtent: 4 * h,
                                    ),
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            isStarTap = true;
                                            rating = index + 1;
                                            print('Star Tap.........');
                                          });
                                        },
                                        child: star(index),
                                      );
                                    },
                                  ),
                                )
                              : rating <= 4
                                  ? Text(
                                      yourfeedbackhasbeensubmitted,
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    )
                                  : Container(),
                          SizedBox(
                            height: isStarTap ? 1 * h : 1 * h,
                          ),
                          SizedBox(
                            height: isSubmitButton == false
                                ? !isStarTap
                                    ? 2 * h
                                    : 3.5 * h
                                : 1 * h,
                          ),
                          isSubmitButton == false
                              ? InkWell(
                                  onTap: isStarTap
                                      ? () {
                                          DateTime now =
                                              DateTime.now().toLocal();
                                          var dateTime =
                                              DateFormat("dd-MM-yyyy hh:mm a")
                                                  .format(now);
                                          print(
                                              "--------- Current Date Time ------------ ${dateTime}");

                                          setState(() {
                                            isSubmitButton = true;

                                            if (rating < 4) {
                                              FirebaseFirestore.instance
                                                  .collection('review')
                                                  .add({
                                                "rating": rating + 1,
                                                "date_time": dateTime,
                                              });
                                            }
                                          });
                                        }
                                      : null,
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 20),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color:
                                          isStarTap ? kPrimeryColor : greyColor,
                                    ),
                                    height: 45,
                                    width: 75 * w,
                                    child: Center(
                                      child: Text(
                                        submit,
                                        style: GoogleFonts.poppins(
                                          color: whiteColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : rating <= 4
                                  ? GestureDetector(
                                      onTap: () async {
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .pop(true);
                                        await SharedPreference.sharedPreference
                                            .setBoolMethod(
                                                "feedbackCompleted", true);
                                      },
                                      child: Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 20),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: kPrimeryColor,
                                        ),
                                        height: 45,
                                        width: 50 * w,
                                        child: Center(
                                          child: Text(
                                            done,
                                            style: GoogleFonts.poppins(
                                              fontSize: 16,
                                              color: whiteColor,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.only(
                                            bottom: 20,
                                            left: 20,
                                          ),
                                          child: TextButton(
                                            onPressed: () {
                                              Navigator.of(context,
                                                      rootNavigator: true)
                                                  .pop(true);
                                            },
                                            child: Center(
                                              child: Text(
                                                cancel,
                                                style: GoogleFonts.poppins(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color: kPrimeryColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(
                                              bottom: 20, right: 20),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: kPrimeryColor,
                                          ),
                                          height: 40,
                                          width: 45 * w,
                                          child: GestureDetector(
                                            onTap: () async {
                                              launchUrl(Uri.parse(
                                                  "https://play.google.com/store/apps/details?id=com.festival.posterImage"));
                                              await SharedPreference
                                                  .sharedPreference
                                                  .setBoolMethod(
                                                      "feedbackCompleted",
                                                      true);
                                              Navigator.of(context,
                                                      rootNavigator: true)
                                                  .pop(true);
                                            },
                                            child: Center(
                                              child: Text(
                                                'RATE ON PLAYSTORE',
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.poppins(
                                                  fontSize: 12,
                                                  color: whiteColor,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                        ],
                      ),
                    ),
                  ),
                ),
                isSubmitButton
                    ? Positioned(
                        right: 0,
                        top: 0,
                        child: Container(),
                      )
                    : Positioned(
                        right: 0,
                        top: 0,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context, rootNavigator: true)
                                .pop(true);
                          },
                          child: Container(
                            margin: const EdgeInsets.only(left: 100),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: whiteColor,
                              boxShadow: const [
                                BoxShadow(
                                  color: greyColor,
                                  blurRadius: 6.0,
                                  offset: Offset(0.0, 5.0),
                                ),
                              ],
                            ),
                            height: 35,
                            width: 35,
                            child:
                                Image.asset('assets/images/feedBackCancel.png'),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        );
      },
    );
  }

  showGeneralDialog(
    context: context,
    barrierDismissible: false,
    pageBuilder: (_, __, ___) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: transparentColor,
          body: reviewDialog(),
        ),
      );
    },
  );
}

// Review Count
Future<void> reviewCount(BuildContext context) async {
  var reviewIndex =
      await SharedPreference.sharedPreference.getIntMethod("reviewKey");
  var reviewCompleted = await SharedPreference.sharedPreference
      .getBoolMethod("feedbackCompleted");
  if (reviewCompleted == true) {
    print(
        "---------- Feedback already completed. Dialog will not open. ----------");
    await SharedPreference.sharedPreference
        .setBoolMethod("feedbackCompleted", true);
  } else if (reviewIndex == null || reviewIndex < 4) {
    print("------ Review Index --------- $reviewIndex");
    await SharedPreference.sharedPreference
        .setIntMethod("reviewKey", reviewIndex == null ? 1 : reviewIndex + 1);
  } else {
    showFeedBackDialog(context);
    await SharedPreference.sharedPreference.setIntMethod("reviewKey", 0);
    print("-------- Else Review Index ---------- $reviewIndex");
  }

  // •••••••••••••••• for survey ••••••••••••••••
  var surveyCount = await SharedPreference.sharedPreference.getSurveyCount();
  var isSurveyComplated =
      await SharedPreference.sharedPreference.isSurveyComplated();
  if (isSurveyComplated == true) {
  } else if (surveyCount < 6) {
    await SharedPreference.sharedPreference
        .setSurveyCount(count: surveyCount + 1);
  } else {
    showSurveyDialog(context);
    await SharedPreference.sharedPreference.setSurveyCount(count: 0);
  }
}

// Image Save Success Dialog
imageSaveSuccessDialog(BuildContext context, onTap, {bool image = true}) {
  var w = MediaQuery.of(context).size.width / 100;
  showDialog(
    context: context,
    builder: (context) {
      return Scaffold(
        backgroundColor: transparentColor,
        body: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            width: double.infinity,
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    "assets/images/success.png",
                    scale: 5,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    width: double.infinity,
                    child: Text(
                      image == true
                          ? imageSaveDescription
                          : videoSaveDescription,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      style: GoogleFonts.poppins(
                        fontSize: 3.2 * w,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    checkGallery,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: greyColor,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: kPrimeryColor,
                            ),
                            height: 45,
                            width: 37 * w,
                            child: Center(
                              child: Text(
                                ok,
                                style: GoogleFonts.poppins(
                                  color: whiteColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: onTap,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: kPrimeryColor,
                            ),
                            height: 45,
                            width: 37 * w,
                            child: Center(
                              child: Text(
                                share,
                                style: GoogleFonts.poppins(
                                  color: whiteColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

pickLogoDialog(BuildContext context) {
  return showGeneralDialog(
    barrierDismissible: false,
    context: context,
    pageBuilder: (context, animation, secondaryAnimation) {
      return Container();
    },
    transitionBuilder: (context, a1, a2, widget) {
      return Transform.scale(
        scale: a1.value,
        child: StatefulBuilder(
          builder: (context, newSetState) {
            return Opacity(
              opacity: a1.value,
              child: Center(
                child: isLoader
                    ? commonLoader()
                    : Stack(
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            decoration: BoxDecoration(
                              color: whiteColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            height: 200,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    editController.pickedFile.value =
                                        await picker.pickImage(
                                            source: ImageSource.camera);
                                    if (editController.pickedFile.value !=
                                        null) {
                                      editController.isImageShow.value = true;
                                      editController.pickLogo.value = File(
                                          editController
                                              .pickedFile.value!.path);
                                      editController.pickLogos.add({
                                        "image": editController
                                            .pickedFile.value!.path,
                                        "shapeIndex": editController.logoIndex,
                                      });
                                      selectedImageIndex.value = 1;
                                      print(
                                          "---------- Pick Logo List ----------- ${editController.pickLogos}");
                                      if (isFrontTap) {
                                        editController.frontImage.value = File(
                                            editController
                                                .pickLogo.value!.path);
                                        editController.pickLogosCardFrontSide
                                            .add({
                                          "image": editController
                                              .frontImage.value!.path,
                                          "shapeIndex":
                                              editController.logoIndex,
                                          "radius": frontImageRadius,
                                          "rotation": frontImageRotate,
                                          "position": frontImagePosition,
                                        });
                                        frontLogoShapeIndex.value = 1;
                                      } else {
                                        editController.backImage.value = File(
                                            editController
                                                .pickLogo.value!.path);
                                        editController.pickLogosCardBackSide
                                            .add({
                                          "image": editController
                                              .backImage.value!.path,
                                          "shapeIndex":
                                              editController.logoIndex,
                                          "radius": backImageRadius,
                                          "rotation": backImageRotate,
                                          "position": backImagePosition,
                                        });
                                        backLogoShapeIndex.value = 1;
                                      }
                                      print(
                                          "----------path------${editController.pickLogo.value}");
                                      Navigator.of(context).pop();
                                      // setState(() {});
                                    } else {
                                      Navigator.of(context).pop();
                                    }
                                  },
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: kPrimeryColor,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(40.0),
                                      child: Image.asset(
                                        "assets/images/camera.png",
                                        scale: 5,
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    editController.pickedFile.value =
                                        await picker.pickImage(
                                            source: ImageSource.gallery);
                                    if (editController.pickedFile.value !=
                                        null) {
                                      editController.isImageShow.value = true;
                                      editController.pickLogo.value = File(
                                          editController
                                              .pickedFile.value!.path);
                                      editController.pickLogos.add({
                                        "image": editController
                                            .pickedFile.value!.path,
                                        "shapeIndex": editController.logoIndex,
                                      });
                                      selectedImageIndex.value = 1;
                                      print(
                                          "---------- Pick Logo List ----------- ${editController.pickLogos}");
                                      if (isFrontTap) {
                                        editController.frontImage.value = File(
                                            editController
                                                .pickLogo.value!.path);
                                        editController.pickLogosCardFrontSide
                                            .add({
                                          "image": editController
                                              .frontImage.value!.path,
                                          "shapeIndex":
                                              editController.logoIndex,
                                          "radius": frontImageRadius,
                                          "rotation": frontImageRotate,
                                          "position": frontImagePosition,
                                        });
                                        frontLogoShapeIndex.value = 1;
                                      } else {
                                        editController.backImage.value = File(
                                            editController
                                                .pickLogo.value!.path);
                                        editController.pickLogosCardBackSide
                                            .add({
                                          "image": editController
                                              .backImage.value!.path,
                                          "shapeIndex":
                                              editController.logoIndex,
                                          "radius": backImageRadius,
                                          "rotation": backImageRotate,
                                          "position": backImagePosition,
                                        });
                                        backLogoShapeIndex.value = 1;
                                      }
                                      print(
                                          "----------path------${editController.pickLogo.value}");
                                      Navigator.of(context).pop();
                                      // setState(() {});
                                    } else {
                                      Navigator.of(context).pop();
                                    }
                                  },
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: kPrimeryColor,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(40.0),
                                      child: Image.asset(
                                        "assets/images/gallery.png",
                                        scale: 5,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            right: 5,
                            top: 4,
                            child: GestureDetector(
                              onTap: () {
                                image = null;
                                Navigator.pop(context);
                              },
                              child: Image.asset(
                                "assets/images/cross.png",
                                scale: 5,
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            );
          },
        ),
      );
    },
  );
}

Widget color({required Color color}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 7.0),
    child: GestureDetector(
      onTap: () {
        editController.textBlackColor.value = color;
      },
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
        height: 20,
        width: 20,
      ),
    ),
  );
}

colorPicker(context) {
  return Obx(
    () => ColorIndicator(
        width: 40,
        height: 40,
        borderRadius: 0,
        color: editController.textBlackColor.value,
        elevation: 1,
        onSelectFocus: false,
        onSelect: () async {
          print("------tap-----");
          final Color newColor = await showColorPickerDialog(
            context,
            editController.textBlackColor.value,
            title: Text('ColorPicker',
                style: Theme.of(context).textTheme.titleLarge),
            width: 40,
            height: 40,
            spacing: 0,
            runSpacing: 0,
            borderRadius: 0,
            wheelDiameter: 165,
            enableOpacity: true,
            pickersEnabled: <ColorPickerType, bool>{
              ColorPickerType.wheel: true,
            },
            actionButtons: const ColorPickerActionButtons(
              okButton: true,
              closeButton: true,
              dialogActionButtons: false,
            ),
            constraints: const BoxConstraints(
                minHeight: 450, minWidth: 320, maxWidth: 320),
          );
          editController.textBlackColor.value = newColor;
        }),
  );
}

strokeColorPicker(context, bool isStroke, {Color strokeColor = Colors.black}) {
  return ColorIndicator(
      width: 40,
      height: 40,
      borderRadius: 0,
      color: strokeColor,
      elevation: 1,
      onSelectFocus: false,
      onSelect: () async {
        print("------tap-----");
        final Color newColor = await showColorPickerDialog(
          context,
          strokeColor,
          title: Text('ColorPicker',
              style: Theme.of(context).textTheme.titleLarge),
          width: 40,
          height: 40,
          spacing: 0,
          runSpacing: 0,
          borderRadius: 0,
          wheelDiameter: 165,
          enableOpacity: true,
          pickersEnabled: <ColorPickerType, bool>{
            ColorPickerType.wheel: true,
          },
          actionButtons: const ColorPickerActionButtons(
            okButton: true,
            closeButton: true,
            dialogActionButtons: false,
          ),
          constraints: const BoxConstraints(
              minHeight: 450, minWidth: 320, maxWidth: 320),
        );
        if (isStroke == true) {
          editController.forgroundStrokeColor.value = newColor;
        } else {
          editController.backgroundStrokeColor.value = newColor;
        }
        strokeColor = newColor;
      });
}

textFeture(BuildContext context, setState, TextEditingController controller) {
  String duplicate = "";

  List moreList = [
    {
      "image": "assets/images/copy.png",
      "title": "Copy",
    },
    {
      "image": "assets/images/duplicate.png",
      "title": "Duplicate",
    },
    {
      "image": "assets/images/cut.png",
      "title": "Cut",
    },
    {
      "image": "assets/images/delete.png",
      "title": "Delete",
    },
  ];
  return Column(
    children: [
      Container(
        margin: const EdgeInsets.only(left: 20, right: 20),
        height: 40,
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Material(
          elevation: 5,
          borderRadius: BorderRadius.circular(10),
          child: Row(
            children: [
              fontFamilyDropDown(context),
              fontSizeDropDown(context),
              const SizedBox(
                width: 10,
              ),
              editController.checkBoxValue.value
                  ? Container()
                  : colorPickerText(),
              const SizedBox(
                width: 5,
              ),
              const VerticalDivider(
                color: blackColor,
                indent: 10,
                endIndent: 10,
              ),
              textBoldIcon(),
              const SizedBox(
                width: 5,
              ),
              textFontStyleIcon(),
              const SizedBox(
                width: 5,
              ),
              textDecorationIcon(),
              const VerticalDivider(
                color: blackColor,
                indent: 10,
                endIndent: 10,
              ),
              GestureDetector(
                onTap: () {
                  editController.isColorIconTap.value = false;
                  editController.isMoreIconTap.value =
                      !editController.isMoreIconTap.value;
                },
                child: const Icon(
                  Icons.more_horiz,
                  size: 20,
                ),
              ),
              const SizedBox(
                width: 15,
              ),
            ],
          ),
        ),
      ),
      editController.checkBoxValue.value ? Container() : colorPickPad(context),
      editController.isMoreIconTap.value == true
          ? Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  editController.isTextTap.value = true;
                },
                child: Container(
                  margin: const EdgeInsets.only(top: 5, right: 20),
                  width: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: whiteColor,
                  ),
                  child: ListView.builder(
                    padding: const EdgeInsets.only(
                      top: 10,
                      bottom: 10,
                      left: 5,
                    ),
                    shrinkWrap: true,
                    itemCount: moreList.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          index == 0
                              ? FlutterClipboard.copy(controller.text)
                              : index == 1
                                  ? {
                                      duplicate =
                                          "${controller.text}\n${controller.text}",
                                      controller.text = duplicate,
                                    }
                                  : index == 2
                                      ? {
                                          FlutterClipboard.copy(
                                              controller.text),
                                          controller.text = ""
                                        }
                                      : index == 3
                                          ? controller.text = ""
                                          : null;

                          editController.isMoreIconTap.value = false;
                        },
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ImageIcon(
                                AssetImage(
                                  moreList[index]["image"],
                                ),
                                size: 20,
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              moreList[index]["title"],
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: ui.FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            )
          : Container(),
    ],
  );
}

Widget strokeTextFeture(BuildContext context) {
  var w = MediaQuery.of(context).size.width;
  return Container(
    margin: const EdgeInsets.only(left: 20, right: 20),
    decoration: BoxDecoration(
      color: whiteColor,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(10),
      color: whiteColor,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Stroke Width",
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Center(
                    child: Container(
                      margin: const EdgeInsets.only(top: 2),
                      width: 100,
                      height: 28,
                      child: Theme(
                        data: ThemeData(
                          splashColor: transparentColor,
                          hoverColor: transparentColor,
                          highlightColor: transparentColor,
                          focusColor: transparentColor,
                        ),
                        child: DropdownButtonHideUnderline(
                          child: Container(
                            margin:
                                const EdgeInsets.only(left: kIsWeb ? 20 : 20),
                            child: DropdownButton2<double>(
                              value: strokeWidthList.contains(
                                      editController.selectedStrokeWidth.value)
                                  ? editController.selectedStrokeWidth.value
                                  : null,
                              isExpanded: true,
                              isDense: false,
                              items: strokeWidthList.map((e) {
                                return DropdownMenuItem<double>(
                                  value: e,
                                  child: Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "${e.toInt()}",
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w600,
                                            color: blackColor,
                                            fontSize: kIsWeb
                                                ? w < 600
                                                    ? 13
                                                    : 14
                                                : 14,
                                          ),
                                        ),
                                        TextSpan(
                                          text: "  PX",
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w600,
                                            color: blackColor,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                              hint: Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: editController
                                          .selectedStrokeWidth.value
                                          .toStringAsFixed(0),
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold,
                                        color: blackColor,
                                        fontSize: 13,
                                      ),
                                    ),
                                    TextSpan(
                                      text: "  PX",
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold,
                                        color: blackColor,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              onChanged: (value) {
                                editController.selectedStrokeWidth.value =
                                    value!;
                              },
                              dropdownStyleData: DropdownStyleData(
                                width: 70,
                                maxHeight: 300,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 6),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: whiteColor,
                                ),
                                offset: const Offset(-20, -12),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Obx(
              () => Expanded(
                child: Column(
                  children: [
                    Text(
                      "Forground Color",
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 2),
                      height: 30,
                      width: 30,
                      child: ClipOval(
                        child: strokeColorPicker(
                            context,
                            strokeColor:
                                editController.forgroundStrokeColor.value,
                            true),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Obx(
              () => Expanded(
                child: Column(
                  children: [
                    Text(
                      "Background Color",
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 2),
                      height: 30,
                      width: 30,
                      child: ClipOval(
                        child: strokeColorPicker(
                            context,
                            strokeColor:
                                editController.backgroundStrokeColor.value,
                            false),
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
  );
}

bool isLoadingSkeleton = false;

Widget rowText(text, text2, onTap, {bool isLoading = false}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      isLoading
          ? Shimmer.fromColors(
              baseColor: skeletonBaseColor,
              highlightColor: skeletonhighlightColor,
              child: Container(
                width: 150,
                height: 20,
                decoration: BoxDecoration(
                  color: skeletonBaseColor,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            )
          : Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: kPrimeryColor,
              ),
            ),
      isLoading
          ? Shimmer.fromColors(
              baseColor: skeletonBaseColor,
              highlightColor: skeletonhighlightColor,
              child: Container(
                width: 80,
                height: 20,
                decoration: BoxDecoration(
                  color: skeletonBaseColor,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            )
          : GestureDetector(
              onTap: onTap,
              child: Row(
                children: [
                  Text(
                    text2,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 12,
                    color: greyColor,
                  )
                ],
              ),
            ),
    ],
  );
}

Widget rowTextWeb(text, text2, onTap) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 20),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: kPrimeryColor,
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: Row(
            children: [
              Text(
                text2,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Future<bool> loadImageSkeleton() async {
  try {
    await Future.delayed(const Duration(milliseconds: 500));

    return true;
  } catch (e) {
    return false;
  }
}

Future<bool> allScreenSkeleton(setState) async {
  try {
    setState(() {
      isLoadingSkeleton = true;
    });
    await Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        isLoadingSkeleton = false;
      });
    });

    return true;
  } catch (e) {
    setState(() {
      isLoadingSkeleton = false;
    });
    return false;
  }
}

void getPatrioticImage() {
  patrioticDayList.clear();

  for (var x in templateWithImageList) {
    if (x["title"] == "Patriotic Day") {
      patrioticDayList.add(x);
    }
  }
}

void getFestivalImage() {
  festivalsEventList.clear();
  for (var festivalImage in templateWithImageList) {
    if (festivalImage["title"] == "Festivals Event") {
      festivalsEventList.add(festivalImage);
    }
  }
}

void getSpecialImage() {
  specialDaysList.clear();
  for (var specialImage in templateWithImageList) {
    if (specialImage["title"] == "Special Days") {
      specialDaysList.add(specialImage);
    }
  }
}

void getVisitingCard() {
  visitingCardList.clear();
  for (var visitingCard in templateWithImageList) {
    if (visitingCard["title"] == "Visiting Card") {
      visitingCardList.add(visitingCard);
    }
  }
}

Widget filterWidget(color, text, image, double height, double width) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
    child: GestureDetector(
      onTap: () {
        editController.filterContainerColor.value = color;
      },
      child: Column(
        children: [
          SizedBox(
            height: kIsWeb ? height : 110,
            width: kIsWeb ? width : 100,
            child: Stack(
              children: [
                Container(
                  height: kIsWeb ? height : 90,
                  width: kIsWeb ? width : 110,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(image),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Container(
                  height: kIsWeb ? height : 90,
                  width: kIsWeb ? width : 110,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                kIsWeb
                    ? Container()
                    : Positioned(
                        bottom: 5,
                        right: 5,
                        child: Container(
                          decoration: BoxDecoration(
                            color: kfilterContainerColor,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          height: 30,
                          width: 90,
                          child: Center(
                            child: Text(
                              text,
                              style: GoogleFonts.montserrat(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ),
          const SizedBox(
            height: kIsWeb ? 11 : 0,
          ),
          kIsWeb
              ? Text(
                  text,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: kPrimeryColor,
                  ),
                )
              : Container(),
        ],
      ),
    ),
  );
}

class TextWidget extends StatefulWidget {
  var item;
  final VoidCallback onRemove;
  final VoidCallback onEdit;
  int index;
  TextWidget({
    super.key,
    required this.item,
    required this.onRemove,
    required this.onEdit,
    required this.index,
  });

  @override
  State<TextWidget> createState() => _TextWidgetState();
}

class _TextWidgetState extends State<TextWidget> {
  Offset? initialPosition;
  Offset? currentPosition;

  double scale = 1.0;
  double previousScale = 1.0;
  Offset panOffset = Offset.zero;
  double initialScale = 1.0;
  Offset initialPanOffset = Offset.zero;
  Offset lastFocalPoint = Offset.zero;
  var touchPosition = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return item();
  }

  item() {
    var h = MediaQuery.of(context).size.height;
    // var w = MediaQuery.of(context).size.width;
    // TextPainter textPainter = TextPainter(
    //   text: TextSpan(
    //     text: widget.item.text,
    //     style: GoogleFonts.getFont(
    //       editController.selectedFontFamily.value,
    //       fontSize: editController.selectedFontSize.value,
    //       color: editController.textBlackColor.value,
    //       fontWeight: widget.item.fontWeight,
    //       fontStyle: widget.item.fontStyle,
    //       decoration: widget.item.textDecoration,
    //     ),
    //   ),
    //   maxLines: 1,
    //   textDirection: TextDirection.ltr,
    // )..layout();
    return Positioned(
      left: widget.item.offset.dx,
      top: widget.item.offset.dy,
      child: widget.item.text == ""
          ? Container()
          : Obx(
              () => Transform.rotate(
                angle: widget.item.rotation,
                child: Transform.scale(
                  scale: scale,
                  child: Stack(
                    children: [
                      GestureDetector(
                        onScaleStart: (details) {
                          initialScale = scale;
                          initialPanOffset = panOffset;
                          lastFocalPoint = details.focalPoint;

                          Offset centerOfGestureDetector = Offset(
                              editController.width.value / 2,
                              editController.height.value / 2);

                          final touchPositionFromCenter =
                              details.localFocalPoint - centerOfGestureDetector;
                          editController.offsetAngle.value =
                              touchPositionFromCenter.direction -
                                  widget.item.rotation;

                          final RenderBox referenceBox = kIsWeb
                              ? context.findRenderObject()
                              : widget.item.parentKey.currentContext
                                  .findRenderObject();
                          var x = kIsWeb
                              ? referenceBox.localToGlobal(Offset.zero)
                              : referenceBox.globalToLocal(details.focalPoint);

                          touchPosition = editController.imageHeight.value ==
                                  double.infinity
                              ? Offset(x.dx, x.dy + 100)
                              : editController.imageHeight.value == 0.65 * h
                                  ? Offset(x.dx, x.dy + 155)
                                  : editController.imageHeight.value == 0.6 * h
                                      ? Offset(x.dx, x.dy + 170)
                                      : editController.imageHeight.value ==
                                              0.65 * h
                                          ? Offset(x.dx, x.dy + 155)
                                          : editController.imageHeight.value ==
                                                  0.62 * h
                                              ? Offset(x.dx + 30, x.dy + 180)
                                              : Offset(x.dx + 30, x.dy + 200);
                          kIsWeb ? initialPosition = details.focalPoint : null;
                          kIsWeb ? currentPosition = widget.item.offset : null;
                          if (details.localFocalPoint.dx >
                                  editController.width.value - 40 &&
                              details.localFocalPoint.dy < 40) {
                            editController.isRotate.value = true;
                          }
                        },
                        onScaleUpdate: (details) {
                          widget.item.fontSize =
                              (widget.item.fontSize * details.scale)
                                  .clamp(8.0, 50.0);
                          editController.selectedFontSize.value =
                              widget.item.fontSize;

                          if (kIsWeb
                              ? (selectedIndexPostWeb.value != widget.index ||
                                  selectedIndexCard != widget.index)
                              : selectedIndexPost.value != widget.index) {
                            editController.isRotate.value = false;
                          }
                          if (editController.show.value == false) {
                            editController.isRotate.value = false;
                          }
                          if (editController.isRotate.value) {
                            Offset centerOfGestureDetector = Offset(
                                editController.width.value / 2,
                                editController.height.value / 2);

                            final touchPositionFromCenter =
                                details.localFocalPoint -
                                    centerOfGestureDetector;

                            widget.item.rotation =
                                (touchPositionFromCenter.direction -
                                    editController.offsetAngle.value);
                          } else {
                            if (kIsWeb) {
                              if (initialPosition != null &&
                                  currentPosition != null) {
                                Offset delta =
                                    details.focalPoint - initialPosition!;
                                setState(() {
                                  widget.item.offset = currentPosition! + delta;
                                });
                              }
                            } else {
                              var positionG =
                                  widget.item.offset + details.focalPoint;
                              var positiong2 = positionG - touchPosition;
                              widget.item.offset =
                                  (positiong2 - widget.item.offset);
                            }
                          }
                          setState(() {});
                        },
                        onScaleEnd: (details) {
                          editController.isRotate.value = false;
                          editController.show.value = false;
                        },
                        child: Container(
                          margin: const EdgeInsets.all(15),
                          constraints: BoxConstraints(
                            maxHeight: 0.15 * h,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: editController.show.value &&
                                      (kIsWeb
                                          ? (selectedIndexPostWeb.value ==
                                                  widget.index ||
                                              selectedIndexCard == widget.index)
                                          : selectedIndexPost.value ==
                                              widget.index)
                                  ? kEditFetureColor
                                  : transparentColor,
                              width: 2,
                            ),
                          ),
                          child: GestureDetector(
                            onTap: () {
                              editController.show.value = true;
                              kIsWeb
                                  ? {
                                      selectedIndexCard = widget.index,
                                      selectedIndexPostWeb.value = widget.index,
                                    }
                                  : selectedIndexPost.value = widget.index;
                              editController.isRotate.value = false;
                              setState(() {});
                            },
                            child: Center(
                              child: GestureDetector(
                                onScaleStart: (details) {
                                  initialScale = scale;
                                  initialPanOffset = panOffset;
                                  lastFocalPoint = details.focalPoint;

                                  Offset centerOfGestureDetector = Offset(
                                      editController.width.value / 2,
                                      editController.height.value / 2);

                                  final touchPositionFromCenter =
                                      details.localFocalPoint -
                                          centerOfGestureDetector;
                                  editController.offsetAngle.value =
                                      touchPositionFromCenter.direction -
                                          widget.item.rotation;

                                  final RenderBox referenceBox = kIsWeb
                                      ? context.findRenderObject()
                                      : widget.item.parentKey.currentContext
                                          .findRenderObject();
                                  var x = kIsWeb
                                      ? referenceBox.localToGlobal(Offset.zero)
                                      : referenceBox
                                          .globalToLocal(details.focalPoint);

                                  touchPosition = editController
                                              .imageHeight.value ==
                                          double.infinity
                                      ? Offset(x.dx, x.dy + 100)
                                      : editController.imageHeight.value ==
                                              0.65 * h
                                          ? Offset(x.dx, x.dy + 155)
                                          : editController.imageHeight.value ==
                                                  0.6 * h
                                              ? Offset(x.dx, x.dy + 170)
                                              : editController
                                                          .imageHeight.value ==
                                                      0.65 * h
                                                  ? Offset(x.dx, x.dy + 155)
                                                  : editController.imageHeight
                                                              .value ==
                                                          0.62 * h
                                                      ? Offset(
                                                          x.dx + 30, x.dy + 180)
                                                      : Offset(x.dx + 30,
                                                          x.dy + 200);
                                  kIsWeb
                                      ? initialPosition = details.focalPoint
                                      : null;
                                  kIsWeb
                                      ? currentPosition = widget.item.offset
                                      : null;
                                  if (details.localFocalPoint.dx >
                                          editController.width.value - 40 &&
                                      details.localFocalPoint.dy < 40) {
                                    editController.isRotate.value = true;
                                  }
                                },
                                onScaleUpdate: (details) {
                                  widget.item.fontSize =
                                      (widget.item.fontSize * details.scale)
                                          .clamp(8.0, 50.0);
                                  editController.selectedFontSize.value =
                                      widget.item.fontSize;

                                  if (kIsWeb
                                      ? (selectedIndexPostWeb.value !=
                                              widget.index ||
                                          selectedIndexCard != widget.index)
                                      : selectedIndexPost.value !=
                                          widget.index) {
                                    editController.isRotate.value = false;
                                  } else {
                                    if (kIsWeb) {
                                      if (initialPosition != null &&
                                          currentPosition != null) {
                                        Offset delta = details.focalPoint -
                                            initialPosition!;
                                        setState(() {
                                          widget.item.offset =
                                              currentPosition! + delta;
                                        });
                                      }
                                    } else {
                                      var positionG = widget.item.offset +
                                          details.focalPoint;
                                      var positiong2 =
                                          positionG - touchPosition;
                                      widget.item.offset =
                                          (positiong2 - widget.item.offset);
                                    }
                                  }
                                  setState(() {});
                                },
                                onScaleEnd: (details) {
                                  editController.isRotate.value = false;
                                  editController.show.value = false;
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: widget.item.isStrokeCheck
                                      ? Stack(
                                          children: [
                                            Text(
                                              widget.item.text,
                                              textAlign: TextAlign.center,
                                              maxLines: null,
                                              style: GoogleFonts.getFont(
                                                widget.item.fontFamily,
                                                fontSize: widget.item.fontSize,
                                                fontWeight:
                                                    widget.item.fontWeight,
                                                decoration:
                                                    widget.item.textDecoration,
                                                fontStyle:
                                                    widget.item.fontStyle,
                                                foreground: Paint()
                                                  ..style = PaintingStyle.stroke
                                                  ..strokeWidth =
                                                      widget.item.strokeWidth
                                                  ..color = widget
                                                      .item.forgroundColor,
                                              ),
                                            ),
                                            Text(
                                              widget.item.text,
                                              textAlign: TextAlign.center,
                                              maxLines: null,
                                              style: GoogleFonts.getFont(
                                                widget.item.fontFamily,
                                                fontSize: widget.item.fontSize,
                                                color:
                                                    widget.item.backgroundColor,
                                                fontWeight:
                                                    widget.item.fontWeight,
                                                decoration:
                                                    widget.item.textDecoration,
                                                fontStyle:
                                                    widget.item.fontStyle,
                                              ),
                                            ),
                                          ],
                                        )
                                      : Text(
                                          widget.item.text,
                                          textAlign: TextAlign.center,
                                          maxLines: null,
                                          style: GoogleFonts.getFont(
                                            widget.item.fontFamily,
                                            fontSize: widget.item.fontSize,
                                            color: widget.item.textColor,
                                            fontWeight: widget.item.fontWeight,
                                            decoration:
                                                widget.item.textDecoration,
                                            fontStyle: widget.item.fontStyle,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // top right
                      Positioned(
                        top: 0,
                        right: 0,
                        child: IgnorePointer(
                          child: Align(
                            alignment: Alignment.center,
                            child: editController.show.value &&
                                    (kIsWeb
                                        ? (selectedIndexPostWeb.value ==
                                                widget.index ||
                                            selectedIndexCard == widget.index)
                                        : selectedIndexPost.value ==
                                            widget.index)
                                ? Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color.fromARGB(255, 65, 64, 64),
                                    ),
                                    child: const Icon(
                                      Icons.flip_camera_android,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                  )
                                : Container(),
                          ),
                        ),
                      ),
                      // top left
                      Positioned(
                        top: 0,
                        left: 0,
                        child: editController.show.value &&
                                (kIsWeb
                                    ? (selectedIndexPostWeb.value ==
                                            widget.index ||
                                        selectedIndexCard == widget.index)
                                    : selectedIndexPost.value == widget.index)
                            ? GestureDetector(
                                onTap: widget.onRemove,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color.fromARGB(255, 65, 64, 64),
                                  ),
                                  height: 40,
                                  width: 40,
                                  child: const Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              )
                            : Container(),
                      ),

                      // bottom right
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: editController.show.value &&
                                (kIsWeb
                                    ? (selectedIndexPostWeb.value ==
                                            widget.index ||
                                        selectedIndexCard == widget.index)
                                    : selectedIndexPost.value == widget.index)
                            ? GestureDetector(
                                onPanUpdate: onResizePanUpdate,
                                onPanCancel: () {
                                  editController.show.value = false;
                                },
                                onPanEnd: (details) {
                                  editController.show.value = false;
                                },
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Color.fromARGB(255, 65, 64, 64),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(9.0),
                                        child: GestureDetector(
                                          onTap: () {
                                            editController.isSizeIconTap.value =
                                                true;
                                            setState(() {});
                                          },
                                          child: const Icon(
                                            Icons.open_in_full_outlined,
                                            size: 20,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : Container(),
                      ),

                      // bottom Left
                      Positioned(
                        bottom: 0,
                        left: 0,
                        child: editController.show.value &&
                                (kIsWeb
                                    ? (selectedIndexPostWeb.value ==
                                            widget.index ||
                                        selectedIndexCard == widget.index)
                                    : selectedIndexPost.value == widget.index)
                            ? GestureDetector(
                                onTap: () {
                                  editController.isEditIconTap.value = true;
                                  editController.isTextTap.value = true;
                                  editController.isTextFieldTextAdd.value =
                                      true;
                                  widget.onEdit();
                                },
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Color.fromARGB(255, 65, 64, 64),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(9.0),
                                        child: Icon(
                                          Icons.edit,
                                          size: 20,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : Container(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  onResizePanUpdate(DragUpdateDetails details) {
    setState(() {
      widget.item.fontSize =
          (widget.item.fontSize + details.delta.dy).clamp(8.0, 50.0);

      editController.selectedFontSize.value = widget.item.fontSize;

      print(
          "-------- Font Size -------- ${editController.selectedFontSize.value}");
    });
  }
}

class ImageWidget extends StatefulWidget {
  final image;
  final VoidCallback onRemove;
  int index;

  ImageWidget({
    super.key,
    required this.image,
    required this.onRemove,
    required this.index,
  });

  @override
  State<ImageWidget> createState() => _ImageWidgetState();
}

class _ImageWidgetState extends State<ImageWidget> {
  double imageRotate = 0;
  Offset imagePosition = const Offset(100, 100);
  double imageSize = 130;
  double scale = 1.0;
  double previousScale = 1.0;
  Offset panOffset = Offset.zero;
  double initialScale = 1.0;
  Offset initialPanOffset = Offset.zero;
  Offset lastFocalPoint = Offset.zero;
  // Offset touchPosition = Offset.zero;

  onResizePanUpdate(DragUpdateDetails details) {
    setState(() {
      imageSize =
          (imageSize + details.delta.dy * scale).clamp(50.0, double.infinity);
    });
  }

  @override
  Widget build(BuildContext context) {
    return item();
  }

  Widget item() {
    return Positioned(
      left: imagePosition.dx,
      top: imagePosition.dy,
      child: widget.image == null
          ? Container()
          : Obx(
              () => Transform.rotate(
                angle: imageRotate,
                child: Transform.scale(
                  scale: scale,
                  child: SizedBox(
                    child: Stack(
                      children: [
                        GestureDetector(
                          onPanStart: onPanStart,
                          onPanUpdate: onPanUpdate,
                          onPanEnd: (details) {
                            editController.isRotate.value = false;
                          },
                          child: Obx(
                            () => Container(
                              margin: EdgeInsets.all(15 / scale),
                              // margin: EdgeInsets.all(
                              //     15 / safeScale.clamp(0.0, double.infinity)),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: editController.isImageShow.value &&
                                          (kIsWeb
                                              ? selectedImageIndexWeb.value ==
                                                  widget.index
                                              : selectedImageIndex.value ==
                                                  widget.index)
                                      ? kEditFetureColor
                                      : transparentColor,
                                  width: 1,
                                ),
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  editController.isImageShow.value = true;
                                  editController.isLogoImageTap.value = true;
                                  kIsWeb
                                      ? selectedImageIndexWeb.value =
                                          widget.index
                                      : selectedImageIndex.value = widget.index;
                                  editController.isFilterTap.value = false;
                                  editController.isTextTap.value = false;
                                  editController.isContrastTap.value = false;
                                  editController.isRotateTap.value = false;
                                  editController.isSizeBoxTap.value = false;
                                  print(
                                      "------------- Image Tap Index -------- ${widget.index}");
                                },
                                child: editController
                                            .pickLogos[widget.index]
                                                ["shapeIndex"]
                                            .value ==
                                        0
                                    ? GestureDetector(
                                        onTap: () {
                                          editController.isImageShow.value =
                                              true;
                                        },
                                        child: SizedBox(
                                          height: imageSize,
                                          width: imageSize,
                                        ),
                                      )
                                    : editController
                                                .pickLogos[widget.index]
                                                    ["shapeIndex"]
                                                .value ==
                                            1
                                        ? Container(
                                            height: imageSize,
                                            width: imageSize,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: kIsWeb
                                                  ? DecorationImage(
                                                      image: MemoryImage(
                                                          widget.image),
                                                      fit: BoxFit.fill,
                                                    )
                                                  : DecorationImage(
                                                      image: FileImage(
                                                        File(widget.image),
                                                      ),
                                                      fit: BoxFit.fill,
                                                    ),
                                            ),
                                          )
                                        : editController
                                                    .pickLogos[widget.index]
                                                        ["shapeIndex"]
                                                    .value ==
                                                2
                                            ? Container(
                                                height: imageSize,
                                                width: imageSize,
                                                decoration: BoxDecoration(
                                                  image: kIsWeb
                                                      ? DecorationImage(
                                                          image: MemoryImage(
                                                              widget.image),
                                                          fit: BoxFit.fill,
                                                        )
                                                      : DecorationImage(
                                                          image: FileImage(
                                                            File(widget.image),
                                                          ),
                                                          fit: BoxFit.fill,
                                                        ),
                                                ),
                                              )
                                            : editController
                                                        .pickLogos[widget.index]
                                                            ["shapeIndex"]
                                                        .value ==
                                                    3
                                                ? ClipPath(
                                                    clipper: TriangleClipper(),
                                                    child: kIsWeb
                                                        ? Image.memory(
                                                            widget.image,
                                                            fit: BoxFit.fill,
                                                            width: imageSize,
                                                            height: imageSize,
                                                          )
                                                        : Image.file(
                                                            File(widget.image),
                                                            fit: BoxFit.fill,
                                                            width: imageSize,
                                                            height: imageSize,
                                                          ),
                                                  )
                                                : editController
                                                            .pickLogos[widget.index]
                                                                ["shapeIndex"]
                                                            .value ==
                                                        4
                                                    ? Container(
                                                        height: imageSize / 2,
                                                        width: imageSize,
                                                        decoration:
                                                            BoxDecoration(
                                                          image: kIsWeb
                                                              ? DecorationImage(
                                                                  image: MemoryImage(
                                                                      widget
                                                                          .image),
                                                                  fit: BoxFit
                                                                      .fill,
                                                                )
                                                              : DecorationImage(
                                                                  image:
                                                                      FileImage(
                                                                    File(widget
                                                                        .image),
                                                                  ),
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                        ),
                                                      )
                                                    : editController
                                                                .pickLogos[
                                                                    widget
                                                                        .index]
                                                                    ["shapeIndex"]
                                                                .value ==
                                                            5
                                                        ? ClipPath(
                                                            clipper:
                                                                PolygonClipper(),
                                                            child: kIsWeb
                                                                ? Image.memory(
                                                                    widget
                                                                        .image,
                                                                    fit: BoxFit
                                                                        .fill,
                                                                    width:
                                                                        imageSize,
                                                                    height:
                                                                        imageSize,
                                                                  )
                                                                : Image.file(
                                                                    File(widget
                                                                        .image),
                                                                    fit: BoxFit
                                                                        .fill,
                                                                    width:
                                                                        imageSize,
                                                                    height:
                                                                        imageSize,
                                                                  ),
                                                          )
                                                        : Container(),
                              ),
                            ),
                          ),
                        ),

                        // top right
                        Positioned(
                          top: 2,
                          right: 2,
                          child: IgnorePointer(
                            child: Align(
                              alignment: Alignment.topRight,
                              child: editController.isImageShow.value &&
                                      (kIsWeb
                                          ? selectedImageIndexWeb.value ==
                                              widget.index
                                          : selectedImageIndex.value ==
                                              widget.index)
                                  ? Container(
                                      padding: EdgeInsets.all(5 / scale),
                                      // padding: EdgeInsets.all(5 - scale),
                                      // padding: EdgeInsets.all(safeScale.clamp(
                                      //     0.0, double.infinity)),
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: whiteColor,
                                      ),
                                      child: Icon(
                                        Icons.flip_camera_android,
                                        color: kPrimeryColor,
                                        size: 20 / scale,
                                      ),
                                    )
                                  : Container(),
                            ),
                          ),
                        ),

                        // top left
                        Positioned(
                          top: 2,
                          left: 2,
                          child: editController.isImageShow.value &&
                                  (kIsWeb
                                      ? selectedImageIndexWeb.value ==
                                          widget.index
                                      : selectedImageIndex.value ==
                                          widget.index)
                              ? GestureDetector(
                                  onTap: widget.onRemove,
                                  child: Container(
                                    padding: EdgeInsets.all(5 / scale),
                                    // padding: EdgeInsets.all(5 -
                                    //     safeScale.clamp(0.0, double.infinity)),
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: whiteColor,
                                    ),
                                    child: Icon(
                                      Icons.delete,
                                      color: kPrimeryColor,
                                      size: 20 / scale,
                                    ),
                                  ),
                                )
                              : Container(),
                        ),

                        // bottom right
                        Positioned(
                          bottom: 2,
                          right: 2,
                          child: editController.isImageShow.value &&
                                  (kIsWeb
                                      ? selectedImageIndexWeb.value ==
                                          widget.index
                                      : selectedImageIndex.value ==
                                          widget.index)
                              ? GestureDetector(
                                  onPanUpdate: onResizePanUpdate,
                                  onPanEnd: (details) {
                                    kIsWeb
                                        ? selectedImageIndexWeb.value !=
                                            widget.index
                                        : selectedImageIndex.value !=
                                            widget.index;
                                  },
                                  onPanCancel: () {
                                    kIsWeb
                                        ? selectedImageIndexWeb.value !=
                                            widget.index
                                        : selectedImageIndex.value !=
                                            widget.index;
                                  },
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: whiteColor,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(5 / scale),
                                          // padding: EdgeInsets.all(5 -
                                          //     safeScale.clamp(
                                          //         0.0, double.infinity)),
                                          // padding: EdgeInsets.zero,
                                          child: GestureDetector(
                                            onTap: () {
                                              editController
                                                  .isSizeIconTap.value = true;
                                            },
                                            child: Icon(
                                              Icons.open_in_full_outlined,
                                              color: kPrimeryColor,
                                              size: 20 / scale,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : Container(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Offset touchPosition = Offset.zero;

  onPanStart(DragStartDetails details) {
    Offset centerOfGestureDetector =
        Offset(editController.width.value / 2, editController.height.value / 2);

    final touchPositionFromCenter =
        details.localPosition - centerOfGestureDetector;
    editController.offsetAngle.value =
        touchPositionFromCenter.direction - imageRotate;

    if (details.localPosition.dx > (editController.width.value - 40) &&
        details.localPosition.dy <= 40) {
      editController.isRotate.value = true;
    } else {
      editController.isRotate.value = false;
    }

    touchPosition = details.localPosition;
  }

  onPanUpdate(DragUpdateDetails details) {
    if (editController.isRotate.value) {
      Offset centerOfGestureDetector = Offset(
          editController.width.value / 2, editController.height.value / 2);
      final touchPositionFromCenter =
          details.localPosition - centerOfGestureDetector;
      imageRotate =
          touchPositionFromCenter.direction - editController.offsetAngle.value;
    } else {
      final rotatedDelta = Offset(
        details.delta.dx * cos(imageRotate) -
            details.delta.dy * sin(imageRotate),
        details.delta.dx * sin(imageRotate) +
            details.delta.dy * cos(imageRotate),
      );

      imagePosition += rotatedDelta;
    }

    setState(() {});
  }
}

Widget fontFamilyDropDown(BuildContext context) {
  var w = MediaQuery.of(context).size.width;
  return Obx(
    () => Expanded(
      child: Theme(
        data: ThemeData(
          splashColor: transparentColor,
          hoverColor: transparentColor,
          highlightColor: transparentColor,
          focusColor: transparentColor,
        ),
        child: DropdownButtonHideUnderline(
          child: Container(
            margin: const EdgeInsets.only(left: 12),
            child: DropdownButton2(
              value: editController.selectedFontFamily.value.isEmpty
                  ? null
                  : editController.selectedFontFamily.value,
              isExpanded: true,
              isDense: false,
              items: fontFamilyList.map((e) {
                return DropdownMenuItem<String>(
                  value: e,
                  child: Text(
                    e,
                    style: GoogleFonts.getFont(
                      e,
                      fontWeight: FontWeight.w600,
                      color: blackColor,
                      fontSize: kIsWeb
                          ? w < 600
                              ? 11
                              : 13
                          : 13,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (String? value) {
                editController.selectedFontFamily.value = value!;
              },
              dropdownStyleData: DropdownStyleData(
                width: 140,
                padding: const EdgeInsets.symmetric(vertical: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: whiteColor,
                ),
                offset: const Offset(-20, -4),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

Widget fontSizeDropDown(BuildContext context) {
  var w = MediaQuery.of(context).size.width;
  return Obx(
    () => Expanded(
      child: Theme(
        data: ThemeData(
          splashColor: transparentColor,
          hoverColor: transparentColor,
          highlightColor: transparentColor,
          focusColor: transparentColor,
        ),
        child: DropdownButtonHideUnderline(
          child: Container(
            margin: const EdgeInsets.only(left: kIsWeb ? 20 : 20),
            child: DropdownButton2<double>(
              value:
                  fontSizeList.contains(editController.selectedFontSize.value)
                      ? editController.selectedFontSize.value
                      : null,
              isExpanded: true,
              isDense: false,
              items: fontSizeList.map((e) {
                return DropdownMenuItem<double>(
                  value: e,
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "${e.toInt()}",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            color: blackColor,
                            fontSize: kIsWeb
                                ? w < 600
                                    ? 13
                                    : 14
                                : 14,
                          ),
                        ),
                        TextSpan(
                          text: "  PX",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            color: blackColor,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
              hint: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: editController.selectedFontSize.value
                          .toStringAsFixed(0),
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: blackColor,
                        fontSize: 13,
                      ),
                    ),
                    TextSpan(
                      text: "  PX",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: blackColor,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              onChanged: (value) {
                editController.selectedFontSize.value = value!;
              },
              dropdownStyleData: DropdownStyleData(
                width: 70,
                padding: const EdgeInsets.symmetric(vertical: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: whiteColor,
                ),
                offset: const Offset(-20, -4),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

Widget colorPickerText() {
  return Obx(
    () => GestureDetector(
      onTap: () {
        editController.isColorIconTap.value =
            !editController.isColorIconTap.value;
        editController.isMoreIconTap.value = false;
      },
      child: Container(
        margin: const EdgeInsets.only(
            right: kIsWeb ? 25 : 0, left: kIsWeb ? 25 : 0),
        height: 25,
        width: 25,
        decoration: BoxDecoration(
          color: editController.textBlackColor.value,
          shape: BoxShape.circle,
        ),
      ),
    ),
  );
}

Widget colorPickPad(BuildContext context) {
  return Obx(
    () => Align(
      alignment: Alignment.topRight,
      child: editController.isColorIconTap.value == true
          ? GestureDetector(
              onTap: () {
                editController.isTextTap.value = true;
              },
              child: Container(
                margin: const EdgeInsets.only(top: 5, left: 50, right: 50),
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 10,
                      color: blackColor.withOpacity(0.4),
                    ),
                  ],
                ),
                child: Container(
                  margin: const EdgeInsets.only(
                    top: 20,
                    bottom: 20,
                    left: 20,
                    right: 20,
                  ),
                  child: Wrap(
                    children: [
                      Text(
                        "Color",
                        style: GoogleFonts.poppins(
                          fontWeight: ui.FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            alignment: WrapAlignment.spaceAround,
                            children: [
                              color(color: Colors.red),
                              color(color: Colors.indigo.shade900),
                              color(color: Colors.purple.shade800),
                              color(color: Colors.grey.shade700),
                              color(color: Colors.green.shade800),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Wrap(
                            children: [
                              color(color: Colors.lightBlue.shade200),
                              color(color: Colors.green),
                              color(color: Colors.deepOrange.shade300),
                              color(color: Colors.indigo.shade400),
                              color(color: Colors.teal.shade300),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Wrap(
                            children: [
                              color(color: Colors.black),
                              color(color: kPrimeryColor),
                              color(color: Colors.amber),
                              Container(
                                margin: const EdgeInsets.only(left: 7),
                                height: 20,
                                width: 20,
                                child: Stack(
                                  children: [
                                    ClipOval(
                                      child: colorPicker(context),
                                    ),
                                    const IgnorePointer(
                                      child: Center(
                                        child: Icon(
                                          Icons.add,
                                          color: whiteColor,
                                          size: 15,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )
          : Container(),
    ),
  );
}

Widget textBoldIcon() {
  return Obx(
    () => GestureDetector(
      onTap: () {
        editController.isBoldIconTap.value =
            !editController.isBoldIconTap.value;
        editController.isBoldIconTap.value
            ? editController.fontWeight.value = ui.FontWeight.bold
            : editController.fontWeight.value = ui.FontWeight.normal;
      },
      child: Container(
        color:
            editController.isBoldIconTap.value ? blackColor : transparentColor,
        child: Icon(
          Icons.format_bold,
          size: 18,
          color: editController.isBoldIconTap.value ? whiteColor : blackColor,
        ),
      ),
    ),
  );
}

Widget textFontStyleIcon() {
  return Obx(
    () => GestureDetector(
      onTap: () {
        editController.isTextItalicIconTap.value =
            !editController.isTextItalicIconTap.value;

        editController.isTextItalicIconTap.value
            ? editController.fontStyle.value = ui.FontStyle.italic
            : editController.fontStyle.value = ui.FontStyle.normal;
      },
      child: Container(
        color: editController.isTextItalicIconTap.value
            ? blackColor
            : transparentColor,
        child: Icon(
          Icons.format_italic,
          size: 18,
          color: editController.isTextItalicIconTap.value
              ? whiteColor
              : blackColor,
        ),
      ),
    ),
  );
}

Widget textDecorationIcon() {
  return Obx(
    () => GestureDetector(
      onTap: () {
        editController.isTextUnderLineIconTap.value =
            !editController.isTextUnderLineIconTap.value;
        editController.isTextUnderLineIconTap.value
            ? editController.textDecoration.value = TextDecoration.underline
            : editController.textDecoration.value = TextDecoration.none;
      },
      child: Container(
        color: editController.isTextUnderLineIconTap.value
            ? blackColor
            : transparentColor,
        child: Icon(
          Icons.format_underline,
          size: 18,
          color: editController.isTextUnderLineIconTap.value
              ? whiteColor
              : blackColor,
        ),
      ),
    ),
  );
}

Widget buildEditableTextItem(
    EditableTextItem item, int index, bool isFront, setState) {
  onPanStart(DragStartDetails details) {
    if (shareCardStates[isFrontTap] == true) {
      return true;
    }
    Offset centerOfGestureDetector =
        Offset(editController.width.value / 2, editController.height.value / 2);

    final touchPositionFromCenter =
        details.localPosition - centerOfGestureDetector;
    editController.offsetAngle.value =
        touchPositionFromCenter.direction - item.rotation;
  }

  onPanUpdate(DragUpdateDetails details) {
    if (shareCardStates[isFrontTap] == true) {
      return true;
    }
    final rotatedDelta = Offset(
      details.delta.dx * cos(item.rotation) -
          details.delta.dy * sin(item.rotation),
      details.delta.dx * sin(item.rotation) +
          details.delta.dy * cos(item.rotation),
    );
    item.position += rotatedDelta;
    setState(() {});
  }

  return Positioned(
    left: item.position.dx,
    top: item.position.dy,
    child: Transform.rotate(
      angle: item.rotation,
      child: Stack(
        children: [
          GestureDetector(
            onPanStart: onPanStart,
            onPanUpdate: onPanUpdate,
            onPanEnd: (details) {
              editController.isRotate.value = false;
              setState(() {});
            },
            onPanCancel: () {
              editController.isRotate.value = false;
            },
            child: Container(
              margin: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                border: selectedIndexCard == index && editController.show.value
                    ? Border.all(color: blackColor)
                    : null,
              ),
              child: GestureDetector(
                onTap: shareCardStates[isFrontTap] == true
                    ? null
                    : () {
                        isDrawTap = false;
                        isQRTap = false;
                        isImageTap = false;
                        if (selectedIndexCard == index) {
                          editController.show.value =
                              !editController.show.value;
                          isFunctionTap = !isFunctionTap;
                        } else {
                          editController.show.value = true;
                          selectedIndexCard = index;
                          isFunctionTap = true;
                        }
                        setState(() {});
                      },
                child: Padding(
                  padding: const EdgeInsets.only(right: 10, left: 10),
                  child: Text(
                    item.text,
                    textAlign: TextAlign.center,
                    maxLines: null,
                    style: GoogleFonts.getFont(
                      item.fontFamily,
                      fontSize: item.fontSize,
                      color: item.color,
                      fontWeight: item.fontWeight,
                      decoration: item.textDecoration,
                      fontStyle: item.fontStyle,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

void showPermissionDeniedDialog(
    {required String title, required String description}) {
  Get.dialog(AlertDialog(
    title: Text(title),
    content: Text(description),
    insetPadding: const EdgeInsets.all(22),
    actions: [
      TextButton(
        child: const Text(
          openSettings,
          style: TextStyle(color: kPrimeryColor),
        ),
        onPressed: () {
          openAppSettings();
          Get.close(0);
        },
      ),
      TextButton(
        child: const Text(
          cancel,
          style: TextStyle(color: Colors.black),
        ),
        onPressed: () {
          Get.close(0);
        },
      ),
    ],
  ));
}

void showSurveyDialog(BuildContext context) {
  int pageNumber = 0;
  int questionNumber = 0;
  final List qnaList = [
    {
      "question": "Do you find the application easy to use?",
      "answer": "YES",
    },
    {
      "question": "Are you satisfied with the features provided?",
      "answer": "YES",
    },
    {
      "question": "Do you think the app meets your expectations?",
      "answer": "YES",
    },
    {
      "question": "Did you experience any issues or bugs while using the app?",
      "answer": "YES",
    },
  ];
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController txtDescription = TextEditingController();
  TextEditingController txtEmail = TextEditingController();
  showGeneralDialog(
    barrierDismissible: false,
    context: context,
    pageBuilder: (context, animation, secondaryAnimation) {
      return Container();
    },
    transitionBuilder: (context, a1, a2, widget) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: Transform.scale(
          scale: a1.value,
          child: StatefulBuilder(
            builder: (context, newSetState) {
              return Opacity(
                opacity: a1.value,
                child: Center(
                  child: isLoader
                      ? commonLoader()
                      : Stack(
                          children: [
                            Form(
                              key: formKey,
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 20),
                                decoration: BoxDecoration(
                                  color: whiteColor,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                width: double.infinity,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 36, horizontal: 34),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: switch (pageNumber) {
                                        0 => [
                                            Center(
                                              child: SizedBox(
                                                  height: 50,
                                                  width: 50,
                                                  child: Image.asset(
                                                    'assets/images/AppLogo.png',
                                                  )),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              weLoveYourFeedback,
                                              style: GoogleFonts.poppins(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500,
                                                color: kPrimeryColor,
                                              ),
                                            ),
                                            Text(
                                              feedbackDescription,
                                              style: GoogleFonts.poppins(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: const Color(0xff7D7E80),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            TextFormField(
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return 'Please enter your email address';
                                                }
                                                if (!value.isEmail) {
                                                  return 'Please enter a valid email address';
                                                }
                                                return null;
                                              },
                                              maxLines: 1,
                                              controller: txtEmail,
                                              cursorColor: kPrimeryColor,
                                              style: GoogleFonts.poppins(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: kPrimeryColor,
                                              ),
                                              decoration: InputDecoration(
                                                isDense: true,
                                                hintText: enteryouremailid,
                                                hintStyle: GoogleFonts.poppins(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w300,
                                                  color:
                                                      const Color(0xff686767),
                                                ),
                                                border:
                                                    const OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Color(0xff929292)),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(10),
                                                  ),
                                                ),
                                                focusedBorder:
                                                    const OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: kPrimeryColor),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(10),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            InkWell(
                                              onTap: () {
                                                if (formKey.currentState!
                                                    .validate()) {
                                                  newSetState(() {
                                                    pageNumber = 1;
                                                  });
                                                }
                                              },
                                              child: Container(
                                                height: 48,
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                    color: kPrimeryColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8)),
                                                alignment: Alignment.center,
                                                child: Text(
                                                  taketheSurvey,
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        1 => [
                                            Center(
                                              child: SizedBox(
                                                  height: 50,
                                                  width: 50,
                                                  child: Image.asset(
                                                    'assets/images/AppLogo.png',
                                                  )),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              qnaList[questionNumber]
                                                  ['question'],
                                              style: GoogleFonts.poppins(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500,
                                                color: kPrimeryColor,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: InkWell(
                                                    onTap: () {
                                                      newSetState(() {
                                                        qnaList[questionNumber]
                                                            ['answer'] = "YES";
                                                      });
                                                    },
                                                    child: Container(
                                                      height: 42,
                                                      decoration: BoxDecoration(
                                                          color: qnaList[questionNumber]
                                                                      [
                                                                      'answer'] ==
                                                                  "YES"
                                                              ? const Color(
                                                                  0xffDEE8FE)
                                                              : null,
                                                          border: Border.all(
                                                              width: 2,
                                                              color: qnaList[questionNumber]
                                                                          [
                                                                          'answer'] ==
                                                                      "YES"
                                                                  ? kPrimeryColor
                                                                  : const Color(
                                                                      0xffDEE8FE)),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8)),
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                        'YES',
                                                        style:
                                                            GoogleFonts.poppins(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: kPrimeryColor,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 8,
                                                ),
                                                Expanded(
                                                  child: InkWell(
                                                    onTap: () {
                                                      newSetState(() {
                                                        qnaList[questionNumber]
                                                            ['answer'] = "NO";
                                                      });
                                                    },
                                                    child: Container(
                                                      height: 42,
                                                      decoration: BoxDecoration(
                                                          color: qnaList[questionNumber]
                                                                      [
                                                                      'answer'] ==
                                                                  "NO"
                                                              ? const Color(
                                                                  0xffDEE8FE)
                                                              : null,
                                                          border: Border.all(
                                                              width: 2,
                                                              color: qnaList[questionNumber]
                                                                          [
                                                                          'answer'] ==
                                                                      "NO"
                                                                  ? kPrimeryColor
                                                                  : const Color(
                                                                      0xffDEE8FE)),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8)),
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                        'NO',
                                                        style:
                                                            GoogleFonts.poppins(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: kPrimeryColor,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 24,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                questionNumber == 0
                                                    ? Container()
                                                    : InkWell(
                                                        onTap: () {
                                                          newSetState(() {
                                                            questionNumber--;
                                                          });
                                                        },
                                                        child: Text(
                                                          'Previous',
                                                          style: GoogleFonts
                                                              .poppins(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color:
                                                                kPrimeryColor,
                                                          ),
                                                        ),
                                                      ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    newSetState(() {
                                                      if (questionNumber >= 3) {
                                                        pageNumber = 2;
                                                      } else {
                                                        questionNumber++;
                                                      }
                                                    });
                                                  },
                                                  child: Container(
                                                    height: 34,
                                                    decoration: BoxDecoration(
                                                        color: kPrimeryColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8)),
                                                    alignment: Alignment.center,
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      horizontal: 20,
                                                    ),
                                                    child: Text(
                                                      next,
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        2 => [
                                            Center(
                                              child: SizedBox(
                                                  height: 50,
                                                  width: 50,
                                                  child: Image.asset(
                                                    'assets/images/AppLogo.png',
                                                  )),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              "What improvements would you like to see in the app?",
                                              style: GoogleFonts.poppins(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500,
                                                color: kPrimeryColor,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            TextField(
                                              maxLines: 4,
                                              controller: txtDescription,
                                              cursorColor: kPrimeryColor,
                                              style: GoogleFonts.poppins(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: kPrimeryColor,
                                              ),
                                              decoration: InputDecoration(
                                                hintText:
                                                    'Share your thoughts here',
                                                hintStyle: GoogleFonts.poppins(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w300,
                                                  color:
                                                      const Color(0xff686767),
                                                ),
                                                border:
                                                    const OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Color(0xff929292)),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(10),
                                                  ),
                                                ),
                                                focusedBorder:
                                                    const OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: kPrimeryColor),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(10),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            InkWell(
                                              onTap: () {
                                                newSetState(() {
                                                  pageNumber = 3;
                                                  SharedPreference
                                                      .sharedPreference
                                                      .setSurveyComplated(
                                                          isSurveyComplated:
                                                              true);
                                                  DateTime now =
                                                      DateTime.now().toLocal();
                                                  var dateTime = DateFormat(
                                                          "dd-MM-yyyy hh:mm a")
                                                      .format(now);
                                                  print(
                                                      "--------- Current Date Time ------------ ${dateTime}");

                                                  FirebaseFirestore.instance
                                                      .collection('survey')
                                                      .add(
                                                    {
                                                      "email":
                                                          txtEmail.text.trim(),
                                                      'qna_1': {
                                                        'question': qnaList[0]
                                                            ['question'],
                                                        'answer': qnaList[0]
                                                            ['answer'],
                                                      },
                                                      'qna_2': {
                                                        'question': qnaList[1]
                                                            ['question'],
                                                        'answer': qnaList[1]
                                                            ['answer'],
                                                      },
                                                      'qna_3': {
                                                        'question': qnaList[2]
                                                            ['question'],
                                                        'answer': qnaList[2]
                                                            ['answer'],
                                                      },
                                                      'qna_4': {
                                                        'question': qnaList[3]
                                                            ['question'],
                                                        'answer': qnaList[3]
                                                            ['answer'],
                                                      },
                                                      'improvements':
                                                          txtDescription.text
                                                              .trim(),
                                                      "date_time": dateTime,
                                                    },
                                                  );

                                                  // EmailService.instance.sendSurvey(
                                                  //     body:
                                                  //         '''1.${qnaList[0]['question']} = ${qnaList[0]['answer']}\n2.${qnaList[1]['question']} = ${qnaList[1]['answer']}\n3.${qnaList[2]['question']} = ${qnaList[2]['answer']}\n4.${qnaList[3]['question']} = ${qnaList[3]['answer']}\n5.What improvements would you like to see in the app? = ${txtDescription.text.trim()}''');
                                                });
                                              },
                                              child: Container(
                                                height: 48,
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                    color: kPrimeryColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8)),
                                                alignment: Alignment.center,
                                                child: Text(
                                                  submit,
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        3 => [
                                            Center(
                                              child: SizedBox(
                                                  height: 72,
                                                  width: 72,
                                                  child: Image.asset(
                                                    'assets/images/success_survey.png',
                                                  )),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              "Thank you for your feedback! We appreciate your input and will use it to improve our services.",
                                              style: GoogleFonts.poppins(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500,
                                                color: kPrimeryColor,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            InkWell(
                                              onTap: () {
                                                Navigator.pop(context);
                                              },
                                              child: Container(
                                                height: 48,
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                    color: kPrimeryColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8)),
                                                alignment: Alignment.center,
                                                child: Text(
                                                  ok,
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        int() => [],
                                      }),
                                ),
                              ),
                            ),
                            Positioned(
                              right: 8,
                              top: 8,
                              child: GestureDetector(
                                onTap: () {
                                  image = null;
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  height: 35,
                                  width: 35,
                                  decoration: const BoxDecoration(
                                    color: kPrimeryColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.close,
                                    color: whiteColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
              );
            },
          ),
        ),
      );
    },
  );
}

void showCommonSnackBar(BuildContext context, String message,
    {Color backgroundColor = Colors.black,
    Duration duration = const Duration(seconds: 2)}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: backgroundColor,
      duration: duration,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16),
    ),
  );
}

Widget commonLoader() {
  return const Center(
    child: CircularProgressIndicator(
      color: kPrimeryColor,
    ),
  );
}

Widget commonBackArrow() {
  return const Icon(
    Icons.arrow_back_rounded,
    color: whiteColor,
  );
}

Widget saveLoader() {
  return Container(
    height: double.infinity,
    width: double.infinity,
    color: transparentColor,
    child: Center(
      child: Container(
        decoration: BoxDecoration(
            color: blackColor.withOpacity(0.7),
            borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                color: whiteColor,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Please wait..",
                style: TextStyle(color: whiteColor, fontSize: 15),
              )
            ],
          ),
        ),
      ),
    ),
  );
}
