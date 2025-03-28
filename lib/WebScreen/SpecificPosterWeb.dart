import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:photo_frame/Contstant/AppColor.dart';
import 'package:photo_frame/Screen/Templates.dart';
import 'package:photo_frame/WebScreen/EditCardScreenWeb.dart';
import 'package:photo_frame/WebScreen/EditImageScreenWeb.dart';
import 'package:photo_frame/WebScreen/HomeScreenWeb.dart';
import 'package:responsive_builder/responsive_builder.dart';

class SpecificPosterWeb extends StatefulWidget {
  final selectedName;
  const SpecificPosterWeb({super.key, required this.selectedName});

  @override
  State<SpecificPosterWeb> createState() => _SpecificPosterWebState();
}

class _SpecificPosterWebState extends State<SpecificPosterWeb> {
  List specificList = [];

  void getSpecificImage() {
    for (var specificImage in templateWithImageList) {
      if (widget.selectedName == "Happy Independence Day") {
        if (specificImage["searchText"] == "Independence Day" ||
            specificImage["searchText"] == "Republic Day") {
          specificList.add(specificImage);
        }
      } else if (widget.selectedName == "Happy Holi Day") {
        if (specificImage["searchText"] == "Holi") {
          specificList.add(specificImage);
        }
      } else if (widget.selectedName == "Happy Father Day") {
        if (specificImage["searchText"] == "Father Day") {
          specificList.add(specificImage);
        }
      } else if (widget.selectedName == "Happy Environment Day") {
        if (specificImage["searchText"] == "Environment Day") {
          specificList.add(specificImage);
        }
      } else if (widget.selectedName == "Happy Janmahastami Day") {
        if (specificImage["searchText"] == "Janmashtami") {
          specificList.add(specificImage);
        }
      } else if (widget.selectedName == "Happy Raksha Bandhan Day") {
        if (specificImage["searchText"] == "Raksha Bandhan") {
          specificList.add(specificImage);
        }
      } else if (widget.selectedName == "Happy Rath Yatra") {
        if (specificImage["searchText"] == "Rath Yatra") {
          specificList.add(specificImage);
        }
      } else if (widget.selectedName == "Ganesh Chaturthi") {
        if (specificImage["searchText"] == "Ganesh Chaturthi") {
          specificList.add(specificImage);
        }
      } else if (widget.selectedName == "Happy Mother Day") {
        if (specificImage["searchText"] == "Mother Day") {
          specificList.add(specificImage);
        }
      } else if (widget.selectedName == "Happy Valentine's Day") {
        if (specificImage["searchText"] == "Valentine Day") {
          specificList.add(specificImage);
        }
      } else if (widget.selectedName == "Happy New Year") {
        if (specificImage["searchText"] == "Happy New Year") {
          specificList.add(specificImage);
        }
      } else if (widget.selectedName == "Marry Christmas") {
        if (specificImage["searchText"] == "Merry Christmas") {
          specificList.add(specificImage);
        }
      } else if (widget.selectedName == "Transparent Visiting Card") {
        if (specificImage["searchText"] == "Visiting Card") {
          specificList.add(specificImage);
        }
      } else if (widget.selectedName == "Premium Visiting Card") {
        if (specificImage["searchText"] == "Visiting Card") {
          specificList.add(specificImage);
        }
      } else if (widget.selectedName == "Folded Visiting Cards") {
        if (specificImage["searchText"] == "Visiting Card") {
          specificList.add(specificImage);
        }
      } else if (widget.selectedName == "Photographic Visiting Cards") {
        if (specificImage["searchText"] == "Visiting Card") {
          specificList.add(specificImage);
        }
      } else if (widget.selectedName == "Patriotic Day") {
        if (specificImage["title"] == "Patriotic Day") {
          specificList.add(specificImage);
        }
      } else if (widget.selectedName == "Festivals Day") {
        if (specificImage["title"] == "Festivals Event") {
          specificList.add(specificImage);
        }
      } else if (widget.selectedName == "Special Day") {
        if (specificImage["title"] == "Special Days") {
          specificList.add(specificImage);
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getSpecificImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: ScreenTypeLayout.builder(
        mobile: (BuildContext context) => mobileLayout(),
        tablet: (BuildContext context) => tabletLayout(),
        desktop: (BuildContext context) => desktopLayout(),
      ),
    );
  }

  desktopLayout() {
    return Column(
      children: [
        topHeader(),
        const SizedBox(
          height: 30,
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  width: 1150,
                  child: Wrap(
                    alignment: WrapAlignment.start,
                    spacing: 30.0,
                    runSpacing: 30.0,
                    children: List.generate(
                      specificList.length,
                      (index) {
                        return GestureDetector(
                          onTap: () {
                            imageTapAndPageNavigate(specificList, index);
                          },
                          child: SizedBox(
                            height: 250,
                            width: 250,
                            child: Image.asset(
                              specificList[index]["image"],
                              fit: BoxFit.fill,
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
    );
  }

  tabletLayout() {
    var w = MediaQuery.of(context).size.width;
    return Column(
      children: [
        topHeader(),
        const SizedBox(
          height: 30,
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  width: w,
                  child: Center(
                    child: Wrap(
                      alignment: WrapAlignment.start,
                      spacing: 30.0,
                      runSpacing: 30.0,
                      children: List.generate(
                        specificList.length,
                        (index) {
                          return GestureDetector(
                            onTap: () {
                              imageTapAndPageNavigate(specificList, index);
                            },
                            child: SizedBox(
                              height: 200,
                              width: 200,
                              child: Image.asset(
                                specificList[index]["image"],
                                fit: BoxFit.fill,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  mobileLayout() {
    var w = MediaQuery.of(context).size.width;
    return Column(
      children: [
        topHeader(),
        const SizedBox(
          height: 30,
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  width: w,
                  child: Center(
                    child: Wrap(
                      alignment: WrapAlignment.start,
                      spacing: 30.0,
                      runSpacing: 30.0,
                      children: List.generate(
                        specificList.length,
                        (index) {
                          return GestureDetector(
                            onTap: () {
                              imageTapAndPageNavigate(specificList, index);
                            },
                            child: SizedBox(
                              height: 130,
                              width: 130,
                              child: Image.asset(
                                specificList[index]["image"],
                                fit: BoxFit.fill,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget topHeader() {
    var w = MediaQuery.of(context).size.width;
    return Container(
      height: 100,
      width: double.infinity,
      color: kPrimeryColor,
      child: Wrap(
        runAlignment: WrapAlignment.center,
        children: [
          Container(
            margin:
                EdgeInsets.only(top: w > 600 ? 5 : 0, left: w > 600 ? 50 : 30),
            child: InkWell(
              hoverColor: transparentColor,
              splashColor: transparentColor,
              highlightColor: transparentColor,
              onTap: () {
                Navigator.of(context).pop();
                setState(() {});
              },
              child: const Icon(
                Icons.arrow_back,
                color: whiteColor,
              ),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: w > 285 ? 0 : 20),
            child: Text(
              widget.selectedName,
              style: GoogleFonts.reemKufiFun(
                fontSize: w > 600 ? 20 : 15,
                fontWeight: FontWeight.w400,
                color: whiteColor,
                letterSpacing: 1,
              ),
            ),
          )
        ],
      ),
    );
  }

  void imageTapAndPageNavigate(listName, index) async {
    if (listName[index]["type"] == "Post") {
      ImagePicker imagePicker = ImagePicker();
      pickImage = await imagePicker.pickImage(source: ImageSource.gallery);
      imageBytes = await pickImage!.readAsBytes();
      if (imageBytes != null) {
        isDrawerIconTap = true;
        Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.rightToLeft,
            duration: const Duration(milliseconds: 400),
            child: EditImageScreenWeb(
              image: listName[index]["image"],
              wallPaper: listName[index]["image_2"],
            ),
          ),
        );
      }
    } else if (listName[index]["type"] == "Visiting Card") {
      Navigator.push(
        context,
        PageTransition(
          type: PageTransitionType.rightToLeft,
          duration: const Duration(milliseconds: 400),
          child: EditCardSCreenWeb(
            frontSide: listName[index]["image_2"],
            backSide: listName[index]["image_3"],
          ),
        ),
      );
    }
    setState(() {});
  }
}
