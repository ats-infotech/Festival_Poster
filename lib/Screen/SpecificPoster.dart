import 'dart:io';

import 'package:auto_animated/auto_animated.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:photo_frame/Contstant/AppColor.dart';
import 'package:photo_frame/Contstant/CommonMethod.dart';
import 'package:photo_frame/Screen/EditImageScreen.dart';
import 'package:photo_frame/Screen/HomePage.dart';
import 'package:photo_frame/Screen/HomeSearchPage.dart';
import 'package:photo_frame/Screen/Templates.dart';
import 'package:shimmer/shimmer.dart';

class SpecificPoster extends StatefulWidget {
  const SpecificPoster({super.key});

  @override
  State<SpecificPoster> createState() => _SpecificPosterState();
}

class _SpecificPosterState extends State<SpecificPoster> {
  List specificList = [];

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
                  image: specificList[index]["image"],
                  wallPaper: specificList[index]["image_2"],
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

  void getSpecificPoster() {
    for (var specificImage in templateWithImageList) {
      if (selectedName == "Diwali") {
        if (specificImage["searchText"] == "Happy New Year") {
          specificList.add(specificImage);
        }
      } else if (selectedName == "Raksha Bandhan") {
        if (specificImage["searchText"] == "Raksha Bandhan") {
          specificList.add(specificImage);
        }
      } else if (selectedName == "Independence") {
        if (specificImage["searchText"] == "Independence Day") {
          specificList.add(specificImage);
        }
      } else if (selectedName == "Mother Day") {
        if (specificImage["searchText"] == "Mother Day") {
          specificList.add(specificImage);
        }
      } else if (selectedName == "Ganesh Chaturthi") {
        if (specificImage["searchText"] == "Ganesh Chaturthi") {
          specificList.add(specificImage);
        }
      } else if (selectedName == "Holi") {
        if (specificImage["searchText"] == "Holi") {
          specificList.add(specificImage);
        }
      } else if (selectedName == "Environment Day") {
        if (specificImage["searchText"] == "Environment Day") {
          specificList.add(specificImage);
        }
      } else if (selectedName == "Father Day") {
        if (specificImage["searchText"] == "Father Day") {
          specificList.add(specificImage);
        }
      } else if (selectedName == "Valentines") {
        if (specificImage["searchText"] == "Valentine Day") {
          specificList.add(specificImage);
        }
      } else if (selectedName == "Republic Day") {
        if (specificImage["searchText"] == "Republic Day") {
          specificList.add(specificImage);
        }
      } else if (selectedName == "Rath Yatra") {
        if (specificImage["searchText"] == "Rath Yatra") {
          specificList.add(specificImage);
        }
      } else {
        return null;
      }
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSpecificPoster();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: kPrimeryColor,
        title: Text(
          selectedName == "Diwali"
              ? "Diwali"
              : selectedName == "Raksha Bandhan"
                  ? "Raksha Bandhan"
                  : selectedName == "Independence"
                      ? "Independence Day"
                      : selectedName == "Mother Day"
                          ? "Mother Day"
                          : selectedName == "Ganesh Chaturthi"
                              ? "Ganesh Chaturthi"
                              : selectedName == "Holi"
                                  ? "Holi"
                                  : selectedName == "Environment Day"
                                      ? "Environment Day"
                                      : selectedName == "Father Day"
                                          ? "Father Day"
                                          : selectedName == "Valentines"
                                              ? "Valentine Day"
                                              : selectedName == "Republic Day"
                                                  ? "Republic Day"
                                                  : selectedName == "Rath Yatra"
                                                      ? "Rath Yatra"
                                                      : "",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            setState(() {});
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: WillPopScope(
        onWillPop: () async {
          return true;
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 0, top: 10),
          child: LiveGrid.options(
            padding: const EdgeInsets.only(bottom: 20),
            itemCount: specificList.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemBuilder: (context, index, animation) {
              return FutureBuilder(
                  future: loadImageSkeleton(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting ||
                        !snapshot.hasData) {
                      return Shimmer.fromColors(
                        baseColor: skeletonBaseColor,
                        highlightColor: skeletonhighlightColor,
                        child: Container(
                          margin: const EdgeInsets.only(
                            top: 15,
                            left: 15,
                            right: 15,
                          ),
                          height: 180,
                          decoration: BoxDecoration(
                            color: skeletonBaseColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Shimmer.fromColors(
                        baseColor: skeletonBaseColor,
                        highlightColor: skeletonhighlightColor,
                        child: Container(
                          height: 180,
                        ),
                      );
                    } else {
                      return FadeTransition(
                        opacity: Tween<double>(
                          begin: 0,
                          end: 1,
                        ).animate(animation),
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, -0.1),
                            end: Offset.zero,
                          ).animate(animation),
                          child: GestureDetector(
                            onTap: () async {
                              templateName = specificList[index]["title"];
                              print("----------- ${templateName}");
                              reviewCount(context);
                              await imageDialog(
                                context,
                                index,
                                
                              );
                              cropImage(index);
                            },
                            child: Container(
                              margin: const EdgeInsets.only(top: 15),
                              child: Image.asset(
                                specificList[index]["image"],
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                  });
            },
            options: const LiveOptions(
              delay: Duration(milliseconds: 10),
              showItemInterval: Duration(milliseconds: 10),
              showItemDuration: Duration(milliseconds: 0),
              reAnimateOnVisibility: false,
            ),
          ),
        ),
      ),
    );
  }
}
