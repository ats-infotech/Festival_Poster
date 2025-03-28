import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_frame/Contstant/AppColor.dart';
import 'package:photo_frame/Contstant/sharedPreference.dart';
import 'package:photo_frame/Screen/EditImageScreen.dart';
import 'package:photo_frame/Screen/HomeScreen.dart';
import 'package:photo_frame/Screen/Templates.dart';
import 'package:url_launcher/url_launcher.dart';

ImagePicker picker = ImagePicker();
File? pickImage;
XFile? pickedImage;

bool isLoader = false;
var isInternetConnected = false;

// Image Pick Dialog
imageDialog(BuildContext context, int index, setState) {
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
                    ? const CircularProgressIndicator(
                        color: kPrimeryColor,
                      )
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
                                      setState(() {
                                        isLoader = true;
                                        newSetState(() {});
                                      });
                                      if (pickedImage != null) {
                                        File f1 = File(pickedImage!.path);
                                        f1.delete().then((value) {
                                          print(
                                              "----------- Delete --------- $value");
                                        });
                                      }
                                      pickedImage = await picker.pickImage(
                                        source: ImageSource.camera,
                                        imageQuality: 80,
                                      );
                                      if (pickedImage != null) {
                                        var imagePath =
                                            await pickedImage!.readAsBytes();
                                        var fileSize = imagePath.length;
                                        final kb = fileSize / 1024;
                                        final mb = kb / 1024;
                                        print(
                                            "------------ Image Size ----------- $mb.MB");
                                        if (mb < 3) {
                                          Navigator.pop(context);
                                          image = pickedImage;
                                        } else {
                                          Navigator.pop(context);
                                          image = await compressImage(
                                              File(pickedImage!.path), ".jpg");
                                        }
                                      } else {
                                        setState(() {
                                          isLoader = false;
                                          image = null;
                                          newSetState(() {});
                                          Navigator.pop(context);
                                        });
                                      }
                                      Future.delayed(const Duration(seconds: 2),
                                          () {
                                        setState(() {
                                          isLoader = false;
                                        });
                                      });
                                    } catch (e) {
                                      print(
                                          "------------ Image Pick Camera Error --------- $e");
                                    }
                                    setState(() {});
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
                                      setState(() {
                                        isLoader = true;
                                        newSetState(() {});
                                      });
                                      if (pickedImage != null) {
                                        File f1 = File(pickedImage!.path);
                                        f1.delete().then((value) {
                                          print(
                                              "----------- Delete --------- $value");
                                        });
                                      }
                                      pickedImage = await picker.pickImage(
                                        source: ImageSource.gallery,
                                        imageQuality: 50,
                                      );
                                      if (pickedImage != null) {
                                        var imagePath =
                                            await pickedImage!.readAsBytes();
                                        var fileSize = imagePath.length;
                                        final kb = fileSize / 1024;
                                        final mb = kb / 1024;
                                        print(
                                            "------------ Image Size ----------- $mb.MB");
                                        if (mb < 3) {
                                          image = pickedImage;
                                          Navigator.pop(context);
                                        } else {
                                          image = await compressImage(
                                              File(pickedImage!.path), ".jpg");
                                          Navigator.pop(context);
                                        }
                                      } else if (pickedImage == null) {
                                        setState(() {
                                          isLoader = false;
                                          image = null;
                                          newSetState(() {});
                                          Navigator.pop(context);
                                        });
                                      }
                                      Future.delayed(const Duration(seconds: 2),
                                          () {
                                        setState(() {
                                          isLoader = false;
                                        });
                                      });
                                    } catch (e) {
                                      print(
                                          "----------- Image pick gallery Error ---------- $e");
                                    }
                                    setState(() {});
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
              child: const Text("OK"),
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
checkInternet(BuildContext context, navigate,
    {required VoidCallback onNavigate}) {
  internetConnectivity(context, (bool isInternet) {
    if (!isInternet) {
      print("----------- Dialog Open ------------");
      showInternetDialog(context);
    } else {
      if (navigate) {
        onNavigate();
      }
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
              await urlLaunch(Uri.parse("https://www.google.co.in/"));
            },
          ),
          versionList[0]["forceUpdate"] == false
              ? TextButton(
                  child: const Text('Cancel'),
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

// Url Launch
Future<void> urlLaunch(url) async {
  if (!await canLaunchUrl(url)) {
    await launchUrl(url);
  } else {
    print("--------- Url Not Lanuch ------------");
  }
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
          "Give Us Feedback",
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
                                  child: GridView.builder(
                                    padding: EdgeInsets.zero,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
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
                                      'Your feedback has been submitted.',
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
                                          setState(() {
                                            isSubmitButton = true;
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
                                        'Submit',
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
                                            'Done',
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
                                                "CANCEL",
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
}

// Image Save Success Dialog
imageSaveSuccessDialog(BuildContext context, onTap) {
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
                      "Your images have been saved successfully",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 3.5 * w,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Please check your Gallery",
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
                                'OK',
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
                                'Share',
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

pickLogoDialog(BuildContext context, setState) {
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
                    ? const CircularProgressIndicator(
                        color: kPrimeryColor,
                      )
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
                                    final pickedFile = await picker.pickImage(
                                        source: ImageSource.camera);
                                    if (pickedFile != null) {
                                      editController.pickLogo.value =
                                          File(pickedFile.path);
                                      print(
                                          "----------path------${editController.pickLogo.value}");
                                      Navigator.of(context).pop();
                                      setState(() {});
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
                                    final pickedFile = await picker.pickImage(
                                        source: ImageSource.gallery);
                                    if (pickedFile != null) {
                                      editController.pickLogo.value =
                                          File(pickedFile.path);
                                      print(
                                          "----------path------${editController.pickLogo.value}");
                                      Navigator.of(context).pop();
                                      setState(() {});
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
