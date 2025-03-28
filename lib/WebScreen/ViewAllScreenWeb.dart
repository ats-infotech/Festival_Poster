import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:photo_frame/Contstant/AppColor.dart';
import 'package:photo_frame/Screen/Templates.dart';
import 'package:photo_frame/WebScreen/EditCardScreenWeb.dart';
import 'package:photo_frame/WebScreen/EditImageScreenWeb.dart';
import 'package:photo_frame/WebScreen/HomeScreenWeb.dart';
import 'package:responsive_builder/responsive_builder.dart';

class ViewAllScreenWeb extends StatefulWidget {
  const ViewAllScreenWeb({super.key});

  @override
  State<ViewAllScreenWeb> createState() => _ViewAllScreenWebState();
}

class _ViewAllScreenWebState extends State<ViewAllScreenWeb> {
  int tabTap = 0;
  int? hoverIndex;
  int currentIndex = 0;
  List tabList = [
    "All",
    "Patriotic Day",
    "Festivals Day",
    "Special Days",
    "Visiting Card",
    "Transparent Visiting Card",
    "Premium Visiting Card",
    "Folded Visiting Cards",
    "Photographic Visiting Cards",
  ];
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
        tabBar(45),
        const SizedBox(
          height: 50,
        ),
        listDataShow(250, 250),
      ],
    );
  }

  tabletLayout() {
    return Column(
      children: [
        topHeader(),
        const SizedBox(
          height: 30,
        ),
        tabBar(45),
        const SizedBox(
          height: 50,
        ),
        listDataShow(200, 200),
      ],
    );
  }

  mobileLayout() {
    return Column(
      children: [
        topHeader(),
        const SizedBox(
          height: 30,
        ),
        tabBar(45),
        const SizedBox(
          height: 50,
        ),
        listDataShow(130, 130),
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
              "All  Templates  &  Cards",
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

  Widget tabBar(height) {
    return SizedBox(
      height: height,
      width: 1224,
      child: ScrollConfiguration(
        behavior: WebScrollBehavior(),
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          scrollDirection: Axis.horizontal,
          itemCount: tabList.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(
                left: 5.0,
                right: 15.0,
              ),
              child: GestureDetector(
                onTap: () {
                  tabTap = index;
                  currentIndex = 0;
                  setState(() {});
                },
                child: MouseRegion(
                  onEnter: (event) => setState(() {
                    hoverIndex = index;
                  }),
                  onExit: (event) => setState(() {
                    hoverIndex = null;
                  }),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      border: const GradientBoxBorder(
                        gradient: LinearGradient(
                          colors: [kPrimeryColor, kSecondaryColor],
                        ),
                        width: 2,
                      ),
                      gradient: hoverIndex == index || tabTap == index
                          ? const LinearGradient(
                              colors: [kPrimeryColor, kSecondaryColor],
                            )
                          : null,
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 30,
                          right: 30,
                        ),
                        child: Text(
                          tabList[index],
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: hoverIndex == index || tabTap == index
                                ? whiteColor
                                : kPrimeryColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget listDataShow(height, width) {
    var w = MediaQuery.of(context).size.width;
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            tabTap == 0
                ? Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    padding:
                        EdgeInsets.symmetric(horizontal: w > 600 ? 20 : 10),
                    width: w > 949 ? 1224 : w,
                    child: Center(
                      child: Wrap(
                        alignment: WrapAlignment.start,
                        spacing: 30.0,
                        runSpacing: 30.0,
                        children: List.generate(
                          templateWithImageList.length,
                          (index) {
                            return GestureDetector(
                              onTap: () {
                                imageTapAndPageNavigate(
                                    templateWithImageList, index);
                              },
                              child: SizedBox(
                                height: height,
                                width: width,
                                child: Image.asset(
                                  templateWithImageList[index]["image"],
                                  fit: BoxFit.fill,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  )
                : tabTap == 1
                    ? Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        padding:
                            EdgeInsets.symmetric(horizontal: w > 600 ? 30 : 10),
                        width: w > 949 ? 1224 : w,
                        child: Center(
                          child: Wrap(
                            alignment: WrapAlignment.start,
                            spacing: 30.0,
                            runSpacing: 30.0,
                            children: List.generate(
                              patrioticDayList.length,
                              (index) {
                                return GestureDetector(
                                  onTap: () {
                                    imageTapAndPageNavigate(
                                        patrioticDayList, index);
                                  },
                                  child: SizedBox(
                                    height: height,
                                    width: width,
                                    child: Image.asset(
                                      patrioticDayList[index]["image"],
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      )
                    : tabTap == 2
                        ? Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            padding: EdgeInsets.symmetric(
                                horizontal: w > 600 ? 30 : 10),
                            width: w > 949 ? 1224 : w,
                            child: Center(
                              child: Wrap(
                                alignment: WrapAlignment.start,
                                spacing: 30.0,
                                runSpacing: 30.0,
                                children: List.generate(
                                  festivalsEventList.length,
                                  (index) {
                                    return GestureDetector(
                                      onTap: () {
                                        imageTapAndPageNavigate(
                                            festivalsEventList, index);
                                      },
                                      child: SizedBox(
                                        height: height,
                                        width: width,
                                        child: Image.asset(
                                          festivalsEventList[index]["image"],
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          )
                        : tabTap == 3
                            ? Container(
                                margin: const EdgeInsets.only(bottom: 20),
                                padding: EdgeInsets.symmetric(
                                    horizontal: w > 600 ? 30 : 10),
                                width: w > 949 ? 1224 : w,
                                child: Wrap(
                                  alignment: WrapAlignment.start,
                                  spacing: 30.0,
                                  runSpacing: 30.0,
                                  children: List.generate(
                                    specialDaysList.length,
                                    (index) {
                                      return GestureDetector(
                                        onTap: () {
                                          imageTapAndPageNavigate(
                                              specialDaysList, index);
                                        },
                                        child: SizedBox(
                                          height: height,
                                          width: width,
                                          child: Image.asset(
                                            specialDaysList[index]["image"],
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              )
                            : tabTap == 4
                                ? Container(
                                    margin: const EdgeInsets.only(bottom: 20),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: w > 600 ? 30 : 10),
                                    width: w > 949 ? 1224 : w,
                                    child: Wrap(
                                      alignment: WrapAlignment.start,
                                      spacing: 30.0,
                                      runSpacing: 30.0,
                                      children: List.generate(
                                        visitingCardList.length,
                                        (index) {
                                          return GestureDetector(
                                            onTap: () {
                                              imageTapAndPageNavigate(
                                                  visitingCardList, index);
                                            },
                                            child: SizedBox(
                                              height: height,
                                              width: width,
                                              child: Image.asset(
                                                visitingCardList[index]
                                                    ["image"],
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  )
                                : tabTap == 5
                                    ? Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 20),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: w > 600 ? 30 : 10),
                                        width: w > 949 ? 1224 : w,
                                        child: Wrap(
                                          alignment: WrapAlignment.start,
                                          spacing: 30.0,
                                          runSpacing: 30.0,
                                          children: List.generate(
                                            visitingCardList.length,
                                            (index) {
                                              return GestureDetector(
                                                onTap: () {
                                                  imageTapAndPageNavigate(
                                                      visitingCardList, index);
                                                },
                                                child: SizedBox(
                                                  height: height,
                                                  width: width,
                                                  child: Image.asset(
                                                    visitingCardList[index]
                                                        ["image"],
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      )
                                    : tabTap == 6
                                        ? Container(
                                            margin: const EdgeInsets.only(
                                                bottom: 20),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: w > 600 ? 30 : 10),
                                            width: w > 949 ? 1224 : w,
                                            child: Wrap(
                                              alignment: WrapAlignment.start,
                                              spacing: 30.0,
                                              runSpacing: 30.0,
                                              children: List.generate(
                                                visitingCardList.length,
                                                (index) {
                                                  return GestureDetector(
                                                    onTap: () {
                                                      imageTapAndPageNavigate(
                                                          visitingCardList,
                                                          index);
                                                    },
                                                    child: SizedBox(
                                                      height: height,
                                                      width: width,
                                                      child: Image.asset(
                                                        visitingCardList[index]
                                                            ["image"],
                                                        fit: BoxFit.fill,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          )
                                        : tabTap == 7
                                            ? Container(
                                                margin: const EdgeInsets.only(
                                                    bottom: 20),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal:
                                                        w > 600 ? 30 : 10),
                                                width: w > 949 ? 1224 : w,
                                                child: Wrap(
                                                  alignment:
                                                      WrapAlignment.start,
                                                  spacing: 30.0,
                                                  runSpacing: 30.0,
                                                  children: List.generate(
                                                    visitingCardList.length,
                                                    (index) {
                                                      return GestureDetector(
                                                        onTap: () {
                                                          imageTapAndPageNavigate(
                                                              visitingCardList,
                                                              index);
                                                        },
                                                        child: SizedBox(
                                                          height: height,
                                                          width: width,
                                                          child: Image.asset(
                                                            visitingCardList[
                                                                index]["image"],
                                                            fit: BoxFit.fill,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              )
                                            : Container(
                                                margin: const EdgeInsets.only(
                                                    bottom: 20),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal:
                                                        w > 600 ? 30 : 10),
                                                width: w > 949 ? 1224 : w,
                                                child: Wrap(
                                                  alignment:
                                                      WrapAlignment.start,
                                                  spacing: 30.0,
                                                  runSpacing: 30.0,
                                                  children: List.generate(
                                                    visitingCardList.length,
                                                    (index) {
                                                      return GestureDetector(
                                                        onTap: () {
                                                          imageTapAndPageNavigate(
                                                              visitingCardList,
                                                              index);
                                                        },
                                                        child: SizedBox(
                                                          height: height,
                                                          width: width,
                                                          child: Image.asset(
                                                            visitingCardList[
                                                                index]["image"],
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
