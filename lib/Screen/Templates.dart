import 'dart:developer';
import 'dart:io';
import 'package:auto_animated/auto_animated.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:photo_frame/Contstant/AppColor.dart';
import 'package:photo_frame/Contstant/CommonMethod.dart';
import 'package:photo_frame/Screen/EditImageScreen.dart';
import 'package:photo_frame/Screen/EditVisitingCard.dart';
import 'package:photo_frame/Screen/HomePage.dart';
import 'package:photo_frame/service/firebase_analytics_service.dart';
import 'package:shimmer/shimmer.dart';

int tabTap = 0;

XFile? image;
List templateWithImageList = [];
List visitingCardWithPreviewList = [];
FocusNode focusNode = FocusNode();
List patrioticDayList = [];
List festivalsEventList = [];
List specialDaysList = [];
List dataList = [];
List filterList = [];
List visitingCardList = [];

class Templates extends StatefulWidget {
  final double scrollPosition;

  const Templates({super.key, required this.scrollPosition});

  @override
  State<Templates> createState() => _TemplatesState();
}

class _TemplatesState extends State<Templates> {
  List tabList = [
    "All",
    "Patriotic Day",
    "Festivals Event",
    "Special Days",
    "Cards"
  ];
  bool isSerachTap = false;
  ImagePicker picker = ImagePicker();

  bool isLoading = true;

  // Pick Image Crop From Tempaltes
  Future<void> cropImage(index) async {
    try {
      if (image != null) {
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
                  image: tabTap == 0
                      ? dataList[index]["image"]
                      : tabTap == 1
                          ? patrioticDayList[index]["image"]
                          : tabTap == 2
                              ? festivalsEventList[index]["image"]
                              : specialDaysList[index]["image"],
                  wallPaper: tabTap == 0
                      ? dataList[index]["image_2"]
                      : tabTap == 1
                          ? patrioticDayList[index]["image_2"]
                          : tabTap == 2
                              ? festivalsEventList[index]["image_2"]
                              : specialDaysList[index]["image_2"],
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
      print("------------ Image Crop Erro --------------");
    }
  }

  // Search Templates
  void serchData(String search) {
    dataList.clear();
    filterList.clear();
    if (search.isEmpty) {
      dataList = List.from(templateWithImageList);
    } else {
      for (var searchData in templateWithImageList) {
        if (searchData['searchText']
            .toLowerCase()
            .contains(search.toLowerCase())) {
          filterList.add(searchData);
        }
      }
      dataList = List.from(filterList);
    }
  }

  // Image Load Data
  void addLoadingData() {
    for (var i = 0; i < dataList.length; i++) {
      dataList[i]['isLoaded'] = false;
    }
    for (var i = 0; i < templateWithImageList.length; i++) {
      templateWithImageList[i]["isLoaded"] = false;
    }
  }

  @override
  void initState() {
    super.initState();
    serchData('');
    getPatrioticImage();
    getFestivalImage();
    getSpecialImage();
    getVisitingCard();
    getVisitingCard();
    addLoadingData();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        tabScrollController.jumpTo(widget.scrollPosition);
      },
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: kscaffoldBgColor,
      appBar: AppBar(
        backgroundColor: kPrimeryColor,
        centerTitle: true,
        title: Text(
          "Templates",
          style: GoogleFonts.poppins(
            color: whiteColor,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: GestureDetector(
          onTap: () {
            drawerContainer = 0;
            isPatrioticImageTap = false;
            isFestivalImageTap = false;
            isSpecialImageTap = false;
            Navigator.of(context).pop();
            setState(() {});
          },
          child: const Icon(
            Icons.arrow_back_rounded,
            color: whiteColor,
          ),
        ),
        actions: [
          isSerachTap == true
              ? Container()
              : GestureDetector(
                  onTap: () {
                    isSerachTap = true;
                    tabTap = 0;
                    setState(() {});
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Icon(
                      Icons.search_rounded,
                      color: whiteColor,
                    ),
                  ),
                ),
        ],
      ),
      body: WillPopScope(
        onWillPop: () async {
          drawerContainer = 0;
          isPatrioticImageTap = false;
          isFestivalImageTap = false;
          isSpecialImageTap = false;
          Navigator.of(context).pop();
          return true;
        },
        child: Stack(
          children: [
            Column(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: w,
                  height: isSerachTap == true ? 65 : 50,
                  child: isSerachTap == true
                      ? Container(
                          margin: const EdgeInsets.only(
                            top: 10,
                            left: 20,
                            right: 20,
                          ),
                          child: TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: kPrimeryColor),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              hintText: "Search...",
                              hintStyle: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                              ),
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  isSerachTap = false;
                                  serchData('');
                                  setState(() {});
                                },
                                child: const Icon(
                                  Icons.close,
                                  color: kPrimeryColor,
                                ),
                              ),
                              contentPadding:
                                  const EdgeInsets.fromLTRB(20, 10, 10, 0),
                            ),
                            cursorColor: kPrimeryColor,
                            focusNode: focusNode,
                            onChanged: (value) {
                              serchData(value);
                              FirebaseAnalyticsService.instance.logEvent(
                          name: 'search_template', parameters: {"query": value});
                              setState(() {});
                            },
                          ),
                        )
                      : ListView.builder(
                          controller: tabScrollController,
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          itemCount: tabList.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                top: 10.0,
                                left: 5.0,
                                right: 5.0,
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  if (index != tabTap) {
                                    tabTap = index;
                                    setState(() {});
                                  }
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 250),
                                  decoration: BoxDecoration(
                                    color:
                                        tabTap == index ? kPrimeryColor : null,
                                    borderRadius: BorderRadius.circular(40),
                                    border: Border.all(
                                      color: tabTap == index
                                          ? whiteColor
                                          : kPrimeryColor,
                                    ),
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
                                          color: tabTap == index
                                              ? whiteColor
                                              : kPrimeryColor,
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
                Expanded(
                  child: tabTap == 0
                      ? Container(
                          margin: const EdgeInsets.only(bottom: 0, top: 10),
                          child: isSerachTap == true
                              ? GridView.builder(
                                  controller: ScrollController(),
                                  padding: const EdgeInsets.only(bottom: 20),
                                  itemCount: dataList.length,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                  ),
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () async {
                                        templateName = dataList[index]["title"];
                                        templateSearchName = dataList[index]["searchText"];
                                        print(
                                            " ---------- Template Name -------- ${templateName}");
                                        reviewCount(context);
                                        await imageDialog(
                                          context,
                                          index,
                                          templateName: dataList[index]["searchText"],
                                        );
                                        cropImage(index);
                                        setState(() {});
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.only(top: 15),
                                        height: h,
                                        child: Image.asset(
                                          dataList[index]["image"],
                                        ),
                                      ),
                                    );
                                  },
                                )
                              : LiveGrid.options(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  itemCount: dataList.length,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                  ),
                                  itemBuilder: (context, index, animation) {
                                    return FutureBuilder(
                                        future: loadImage(),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                                  ConnectionState.waiting ||
                                              !snapshot.hasData) {
                                            return Shimmer.fromColors(
                                              baseColor: Colors.grey.shade300,
                                              highlightColor:
                                                  Colors.grey.shade100,
                                              child: Container(
                                                margin: const EdgeInsets.only(
                                                  top: 15,
                                                  left: 15,
                                                  right: 15,
                                                ),
                                                height: 180,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey.shade300,
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                              ),
                                            );
                                          } else if (snapshot.hasError) {
                                            return Shimmer.fromColors(
                                              baseColor: Colors.grey.shade300,
                                              highlightColor:
                                                  Colors.grey.shade100,
                                              child: Container(
                                                height: 180,
                                              ),
                                            );
                                          } else {
                                            return SlideTransition(
                                              position: Tween<Offset>(
                                                begin: const Offset(0, -0.1),
                                                end: Offset.zero,
                                              ).animate(animation),
                                              child: GestureDetector(
                                                onTap: () async {
                                                  focusNode.unfocus();
                                                  reviewCount(context);
                                                  await imageDialog(
                                                    context,
                                                    index,
                                                    templateName: dataList[index]['searchText']
                                                    // setState,
                                                  );
                                                  cropImage(index);
                                                },
                                                child: Container(
                                                  margin: const EdgeInsets.only(
                                                      top: 15,
                                                      left: 10,
                                                      right: 10),
                                                  height: h,
                                                  child: Image.asset(
                                                    dataList[index]["image"],
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                              ),
                                            );
                                          }
                                        });
                                  },
                                  options: const LiveOptions(
                                    delay: Duration(milliseconds: 10),
                                    showItemInterval:
                                        Duration(milliseconds: 10),
                                    showItemDuration: Duration(milliseconds: 0),
                                    reAnimateOnVisibility: true,
                                  ),
                                ),
                        )
                      : tabTap == 1
                          ? Container(
                              margin: const EdgeInsets.only(bottom: 0, top: 10),
                              child: LiveGrid.options(
                                controller: ScrollController(),
                                padding: const EdgeInsets.only(bottom: 20),
                                itemCount: patrioticDayList.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                ),
                                itemBuilder: (context, index, animation) {
                                  return FutureBuilder(
                                      future: loadImage(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                                ConnectionState.waiting ||
                                            !snapshot.hasData) {
                                          return Shimmer.fromColors(
                                            baseColor: Colors.grey.shade300,
                                            highlightColor:
                                                Colors.grey.shade100,
                                            child: Container(
                                              margin: const EdgeInsets.only(
                                                top: 15,
                                                left: 15,
                                                right: 15,
                                              ),
                                              height: 180,
                                              decoration: BoxDecoration(
                                                color: Colors.grey.shade300,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                            ),
                                          );
                                        } else if (snapshot.hasError) {
                                          return Shimmer.fromColors(
                                            baseColor: Colors.grey.shade300,
                                            highlightColor:
                                                Colors.grey.shade100,
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
                                                  templateName =
                                                      patrioticDayList[index]
                                                          ["title"];
                                                  templateSearchName =
                                                      patrioticDayList[index]
                                                          ["searchText"];
                                                  print(
                                                      " ---------- Template Name -------- ${templateName}");
                                                  reviewCount(context);
                                                  await imageDialog(
                                                    templateName: patrioticDayList[index]
                                                          ["searchText"],
                                                    context,
                                                    index,
                                                  );
                                                  cropImage(index);
                                                },
                                                child: Container(
                                                  margin: const EdgeInsets.only(
                                                      top: 15),
                                                  child: Image.asset(
                                                    patrioticDayList[index]
                                                        ["image"],
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
                            )
                          : tabTap == 2
                              ? Container(
                                  margin:
                                      const EdgeInsets.only(bottom: 0, top: 10),
                                  child: LiveGrid.options(
                                    controller: ScrollController(),
                                    padding: const EdgeInsets.only(bottom: 20),
                                    itemCount: festivalsEventList.length,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                    ),
                                    itemBuilder: (context, index, animation) {
                                      return FutureBuilder(
                                          future: loadImage(),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                    ConnectionState.waiting ||
                                                !snapshot.hasData) {
                                              return Shimmer.fromColors(
                                                baseColor: Colors.grey.shade300,
                                                highlightColor:
                                                    Colors.grey.shade100,
                                                child: Container(
                                                  margin: const EdgeInsets.only(
                                                    top: 15,
                                                    left: 15,
                                                    right: 15,
                                                  ),
                                                  height: 180,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey.shade300,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                ),
                                              );
                                            } else if (snapshot.hasError) {
                                              return Shimmer.fromColors(
                                                baseColor: Colors.grey.shade300,
                                                highlightColor:
                                                    Colors.grey.shade100,
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
                                                    begin:
                                                        const Offset(0, -0.1),
                                                    end: Offset.zero,
                                                  ).animate(animation),
                                                  child: GestureDetector(
                                                    onTap: () async {
                                                      templateName =
                                                          festivalsEventList[
                                                              index]["title"];
                                                      templateSearchName =
                                                          festivalsEventList[
                                                              index]["searchText"];
                                                      print(
                                                          " ---------- Template Name -------- ${templateName}");
                                                      reviewCount(context);
                                                      await imageDialog(
                                                        templateName: festivalsEventList[
                                                              index]["searchText"],
                                                        context,
                                                        index,
                                                      );
                                                      cropImage(index);
                                                    },
                                                    child: Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              top: 15,
                                                              left: 10,
                                                              right: 10),
                                                      child: Image.asset(
                                                        festivalsEventList[
                                                            index]["image"],
                                                        fit: BoxFit.fill,
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
                                      showItemInterval:
                                          Duration(milliseconds: 10),
                                      showItemDuration:
                                          Duration(milliseconds: 0),
                                      reAnimateOnVisibility: false,
                                    ),
                                  ),
                                )
                              : tabTap == 3
                                  ? Container(
                                      margin: const EdgeInsets.only(
                                          bottom: 0, top: 10),
                                      child: LiveGrid.options(
                                        padding:
                                            const EdgeInsets.only(bottom: 20),
                                        itemCount: specialDaysList.length,
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                        ),
                                        itemBuilder:
                                            (context, index, animation) {
                                          return FutureBuilder(
                                              future: loadImage(),
                                              builder: (context, snapshot) {
                                                if (snapshot.connectionState ==
                                                        ConnectionState
                                                            .waiting ||
                                                    !snapshot.hasData) {
                                                  return Shimmer.fromColors(
                                                    baseColor:
                                                        Colors.grey.shade300,
                                                    highlightColor:
                                                        Colors.grey.shade100,
                                                    child: Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                        top: 15,
                                                        left: 15,
                                                        right: 15,
                                                      ),
                                                      height: 180,
                                                      decoration: BoxDecoration(
                                                        color: Colors
                                                            .grey.shade300,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                      ),
                                                    ),
                                                  );
                                                } else if (snapshot.hasError) {
                                                  return Shimmer.fromColors(
                                                    baseColor:
                                                        Colors.grey.shade300,
                                                    highlightColor:
                                                        Colors.grey.shade100,
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
                                                        begin: const Offset(
                                                            0, -0.1),
                                                        end: Offset.zero,
                                                      ).animate(animation),
                                                      child: GestureDetector(
                                                        onTap: () async {
                                                          templateName =
                                                              specialDaysList[
                                                                      index]
                                                                  ["title"];
                                                          templateSearchName =
                                                              specialDaysList[
                                                                      index]
                                                                  ["searchText"];
                                                          print(
                                                              " ---------- Template Name -------- ${templateName}");
                                                          reviewCount(context);
                                                          await imageDialog(
                                                            templateName: specialDaysList[
                                                                      index]
                                                                  ["searchText"],
                                                            context,
                                                            index,
                                                          );
                                                          cropImage(index);
                                                        },
                                                        child: Container(
                                                          margin:
                                                              const EdgeInsets
                                                                  .only(
                                                                  top: 15,
                                                                  left: 10,
                                                                  right: 10),
                                                          child: Image.asset(
                                                            specialDaysList[
                                                                index]["image"],
                                                            fit: BoxFit.fill,
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
                                          showItemInterval:
                                              Duration(milliseconds: 10),
                                          showItemDuration:
                                              Duration(milliseconds: 0),
                                          reAnimateOnVisibility: false,
                                        ),
                                      ),
                                    )
                                  : Container(
                                      margin: const EdgeInsets.only(
                                          bottom: 0, top: 10),
                                      child: LiveGrid.options(
                                        padding:
                                            const EdgeInsets.only(bottom: 20),
                                        itemCount: visitingCardList.length,
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                        ),
                                        itemBuilder:
                                            (context, index, animation) {
                                          return FutureBuilder(
                                              future: loadImage(),
                                              builder: (context, snapshot) {
                                                if (snapshot.connectionState ==
                                                        ConnectionState
                                                            .waiting ||
                                                    !snapshot.hasData) {
                                                  return Shimmer.fromColors(
                                                    baseColor:
                                                        Colors.grey.shade300,
                                                    highlightColor:
                                                        Colors.grey.shade100,
                                                    child: Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                        top: 15,
                                                        left: 15,
                                                        right: 15,
                                                      ),
                                                      height: 180,
                                                      decoration: BoxDecoration(
                                                        color: Colors
                                                            .grey.shade300,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                      ),
                                                    ),
                                                  );
                                                } else if (snapshot.hasError) {
                                                  return Shimmer.fromColors(
                                                    baseColor:
                                                        Colors.grey.shade300,
                                                    highlightColor:
                                                        Colors.grey.shade100,
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
                                                        begin: const Offset(
                                                            0, -0.1),
                                                        end: Offset.zero,
                                                      ).animate(animation),
                                                      child: GestureDetector(
                                                        onTap: () async {
                                                          templateName =
                                                              visitingCardList[
                                                                      index]
                                                                  ["title"];
                                                          templateSearchName =
                                                              visitingCardList[
                                                                      index]
                                                                  ["searchText"];
                                                          print(
                                                              " ---------- Template Name -------- ${templateName}");
                                                          reviewCount(context);
                                                          Navigator.push(
                                                            context,
                                                            PageTransition(
                                                              type: PageTransitionType
                                                                  .rightToLeftWithFade,
                                                              child:
                                                                  EditVisitingCard(
                                                                frontSide:
                                                                    visitingCardList[
                                                                            index]
                                                                        [
                                                                        "image_2"],
                                                                backSide:
                                                                    visitingCardList[
                                                                            index]
                                                                        [
                                                                        "image_3"],
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                        child: Container(
                                                          margin:
                                                              const EdgeInsets
                                                                  .only(
                                                                  top: 15),
                                                          child: Image.asset(
                                                            visitingCardList[
                                                                index]["image"],
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
                                          showItemInterval:
                                              Duration(milliseconds: 10),
                                          showItemDuration:
                                              Duration(milliseconds: 0),
                                          reAnimateOnVisibility: false,
                                        ),
                                      ),
                                    ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
