import 'dart:convert';
import 'dart:math';
import 'dart:ui';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:photo_frame/Contstant/AppColor.dart';
import 'package:photo_frame/Contstant/CommonMethod.dart';
import 'package:photo_frame/Screen/GradientText.dart';
import 'package:photo_frame/Screen/Templates.dart';
import 'package:photo_frame/WebScreen/DrawerScreenWeb.dart';
import 'package:photo_frame/WebScreen/EditCardScreenWeb.dart';
import 'package:photo_frame/WebScreen/EditImageScreenWeb.dart';
import 'package:photo_frame/WebScreen/SpecificPosterWeb.dart';
import 'package:photo_frame/WebScreen/ViewAllScreenWeb.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:url_launcher/url_launcher.dart';

XFile? pickImage;
Uint8List? imageBytes;

class HomeScreenWeb extends StatefulWidget {
  const HomeScreenWeb({super.key});

  @override
  State<HomeScreenWeb> createState() => _HomeScreenWebState();
}

class _HomeScreenWebState extends State<HomeScreenWeb>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> zoomAnimation;
  final CarouselSliderController carouselSliderController =
      CarouselSliderController();
  bool isHover = false;
  bool isGifHover1 = false;
  bool isGifHover2 = false;
  bool isCradEdit = false;
  bool isPosterEdit = false;
  bool isListEditPoster = false;
  bool isViewMoreHover = false;
  bool isHoverBusinessCrad = false;
  bool isHoverFestivalPoster = false;
  int? hoverIndex;
  int tabTap = 0;
  int? imageHoverIndex;
  double scale = 1.0;
  int currentIndex = 0;
  final int itemsPerPage = 4;
  int? awesomeHoverIndex;
  ImagePicker imagePicker = ImagePicker();
  bool isTemplateTap = false;
  bool isBusinessCardTap = false;
  String? selectedName;
  int? postHoverIndex;
  int? cardHoverIndex;
  int? linkHoverIndex;
  int? productHelpHoverIndex;

  List categoryList = [
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
  Map<String, List<String>> footerList = {
    "Posters": [
      "Patriotic Day",
      "Festivals Day",
      "Special Day",
    ],
    "Business Card": [
      "Transparent Visiting Card",
      "Premium Visiting Card",
      "Folded Visiting Cards",
      "Photographic Visiting Cards",
    ],
    "Links": [
      "Support",
      "Privacy & Policy",
      "Terms & Conditions",
    ],
    "Product Help": [
      "FAQ",
      "Reviews",
      "Feedback",
      "API",
    ],
  };

  List awesomeFetureList = [
    {
      "icon": "assets/webImages/customFrame.png",
      "title": "Custom Frame",
      "description":
          "Add a creative edge to your photos with customizable frames tailored for every occasion. Design, personalize, and make your memories truly unique.",
    },
    {
      "icon": "assets/webImages/multiPosterAndCard.png",
      "title": "Multiple Poster And Card Choose",
      "description":
          "Discover a wide variety of poster and card designs to suit every occasion. From festive celebrations to professional events, choose and customize multiple options effortlessly to match your style and purpose.",
    },
    {
      "icon": "assets/webImages/customTemplate.png",
      "title": "Custom Templates",
      "description":
          "Explore a wide range of customizable templates crafted for every occasion. Perfectly designed to match your style and needs.",
    },
    {
      "icon": "assets/webImages/voiceToPoster.png",
      "title": "Voice-to-Poster Conversion",
      "description":
          "Transform your spoken ideas into beautifully designed posters with our Voice-to-Poster Conversion tool.",
    },
    {
      "icon": "assets/webImages/socialShare.png",
      "title": "Social Share",
      "description":
          "Effortlessly share your creations across social media platforms and let your designs shine with just a click",
    },
    {
      "icon": "assets/webImages/advanceQR.png",
      "title": "Advanced QR Code Features",
      "description":
          "Elevate your designs with our Advanced QR Code Features. Customize QR codes with colors, logos, and patterns to make them blend seamlessly with your posters and cards.",
    },
  ];

  // Get Json File Data
  Future<void> getImages() async {
    try {
      var imageResponse = await rootBundle.loadString('assets/images.json');
      templateWithImageList = jsonDecode(imageResponse).toList();
    } catch (e) {
      print("-------------- Json Get Data Error -------------- $e");
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300),
      );

      zoomAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInOut),
      );
      await getImages();
      getPatrioticImage();
      getFestivalImage();
      getSpecialImage();
      getVisitingCard();

      setState(() {});
    });
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
    return LayoutBuilder(builder: (context, constraints) {
      return SingleChildScrollView(
        child: Column(
          children: [
            Container(
              // height: 850,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    kPrimeryColor,
                    kSecondaryColor,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          headerTopPart(),
                          headerCenterPart(25, 12),
                        ],
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      headerGif(),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 100,
            ),
            SizedBox(
              height: 45,
              width: 775,
              child: Text(
                "You'll love our free templates. Customize in a snap.",
                style: GoogleFonts.poppins(
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                  color: kPrimeryColor,
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            tabList(),
            const SizedBox(
              height: 40,
            ),
            tabTap == 0
                ? imageList(
                    (currentIndex + itemsPerPage <= templateWithImageList.length)
                        ? itemsPerPage
                        : templateWithImageList.length - currentIndex,
                    templateWithImageList,
                    templateWithImageList.length)
                : tabTap == 1
                    ? imageList(
                        (currentIndex + itemsPerPage <= patrioticDayList.length)
                            ? itemsPerPage
                            : patrioticDayList.length - currentIndex,
                        patrioticDayList,
                        patrioticDayList.length)
                    : tabTap == 2
                        ? imageList(
                            currentIndex + itemsPerPage <= festivalsEventList.length
                                ? itemsPerPage
                                : festivalsEventList.length - currentIndex,
                            festivalsEventList,
                            festivalsEventList.length)
                        : tabTap == 3
                            ? imageList(
                                currentIndex + itemsPerPage <= specialDaysList.length
                                    ? itemsPerPage
                                    : specialDaysList.length - currentIndex,
                                specialDaysList,
                                specialDaysList.length)
                            : tabTap == 4
                                ? imageList(
                                    currentIndex + itemsPerPage <= visitingCardList.length
                                        ? itemsPerPage
                                        : visitingCardList.length -
                                            currentIndex,
                                    visitingCardList,
                                    visitingCardList.length)
                                : tabTap == 5
                                    ? imageList(
                                        currentIndex + itemsPerPage <=
                                                visitingCardList.length
                                            ? itemsPerPage
                                            : visitingCardList.length -
                                                currentIndex,
                                        visitingCardList,
                                        visitingCardList.length)
                                    : tabTap == 6
                                        ? imageList(
                                            currentIndex + itemsPerPage <=
                                                    visitingCardList.length
                                                ? itemsPerPage
                                                : visitingCardList.length -
                                                    currentIndex,
                                            visitingCardList,
                                            visitingCardList.length)
                                        : tabTap == 7
                                            ? imageList(
                                                currentIndex + itemsPerPage <=
                                                        visitingCardList.length
                                                    ? itemsPerPage
                                                    : visitingCardList.length -
                                                        currentIndex,
                                                visitingCardList,
                                                visitingCardList.length)
                                            : imageList(
                                                currentIndex + itemsPerPage <=
                                                        visitingCardList.length
                                                    ? itemsPerPage
                                                    : visitingCardList.length - currentIndex,
                                                visitingCardList,
                                                visitingCardList.length),
            const SizedBox(
              height: 50,
            ),
            viewMoreButton(60, 240),
            const SizedBox(
              height: 100,
            ),
            Center(
              child: Text(
                "Awesome Features",
                style: GoogleFonts.poppins(
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                  color: kPrimeryColor,
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            constraints.maxWidth < 1460
                ? SizedBox(
                    height: 470,
                    width: 450,
                    child: Image.asset(
                      "assets/webImages/awsomeFeature.gif",
                      fit: BoxFit.fill,
                    ),
                  )
                : Container(),
            Container(
              margin: EdgeInsets.symmetric(
                  horizontal: constraints.maxWidth < 1460 ? 15 : 0),
              height: 470,
              width: 1430,
              child: Row(
                mainAxisAlignment: constraints.maxWidth > 1460
                    ? MainAxisAlignment.spaceBetween
                    : MainAxisAlignment.spaceAround,
                children: [
                  awesomeOddItem(),
                  constraints.maxWidth > 1460
                      ? SizedBox(
                          height: 470,
                          width: 450,
                          child: Image.asset(
                            "assets/webImages/awsomeFeature.gif",
                            fit: BoxFit.fill,
                          ),
                        )
                      : Container(),
                  awesomeEvenItem(),
                ],
              ),
            ),
            const SizedBox(
              height: 60,
            ),
            SizedBox(
              height: constraints.maxWidth > 1430 ? 1300 : null,
              width: 1360,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: constraints.maxWidth > 1430 ? 600 : null,
                    width: 1340,
                    child: constraints.maxWidth > 1430
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              cardTextColumn(CrossAxisAlignment.start,
                                  TextAlign.start, 260, 0),
                              cardGif(600, 640),
                            ],
                          )
                        : Column(
                            children: [
                              cardTextColumn(CrossAxisAlignment.start,
                                  TextAlign.start, 260, 0),
                              const SizedBox(
                                height: 50,
                              ),
                              cardGif(600, 640),
                              const SizedBox(
                                height: 50,
                              ),
                            ],
                          ),
                  ),
                  SizedBox(
                    height: constraints.maxWidth > 1430 ? 600 : null,
                    width: 1340,
                    child: constraints.maxWidth > 1430
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              posterGif(600, 640),
                              posterTextColumn(CrossAxisAlignment.end,
                                  TextAlign.end, 260, 0),
                            ],
                          )
                        : Column(
                            children: [
                              posterTextColumn(CrossAxisAlignment.end,
                                  TextAlign.end, 260, 0),
                              const SizedBox(
                                height: 50,
                              ),
                              posterGif(600, 640),
                              const SizedBox(
                                height: 50,
                              ),
                            ],
                          ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 80,
            ),
            Container(
              width: double.infinity,
              color: kPrimeryColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 30),
                    width: 1350,
                    child: Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      runAlignment: WrapAlignment.spaceBetween,
                      spacing: 20.0,
                      runSpacing: 10.0,
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                              top: 10,
                              left: constraints.maxWidth > 1430 ? 0 : 50),
                          height: 260,
                          width: 375,
                          child: footerPlayStore(0),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            top: constraints.maxWidth > 1350 ? 10 : 30,
                            left: constraints.maxWidth > 1350 ? 0 : 50,
                          ),
                          height: 230,
                          width: constraints.maxWidth > 1350
                              ? 880
                              : double.infinity,
                          child: Wrap(
                            alignment: WrapAlignment.spaceBetween,
                            runAlignment: WrapAlignment.spaceBetween,
                            children: [
                              footerPosterText(),
                              footerCardText(),
                              footerLinkText(),
                              footerProductHelpText(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Divider(
                    color: whiteColor.withOpacity(0.5),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  footerTextSpan(18, 20),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  tabletLayout() {
    var w = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  kPrimeryColor,
                  kSecondaryColor,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                headerTopPart(),
                headerCenterPart(24, 15),
                const SizedBox(
                  height: 50,
                ),
                directHeaderGif(),
                const SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 60),
            width: 750,
            child: Center(
              child: Text(
                "You'll love our free templates. Customize in a snap.",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: w > 420 ? 24 : 18,
                  fontWeight: FontWeight.w600,
                  color: kPrimeryColor,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          tabList(),
          const SizedBox(
            height: 50,
          ),
          SizedBox(
            height: 250,
            width: double.infinity,
            child: tabTap == 0
                ? carouselSlider(templateWithImageList)
                : tabTap == 1
                    ? carouselSlider(patrioticDayList)
                    : tabTap == 2
                        ? carouselSlider(festivalsEventList)
                        : tabTap == 3
                            ? carouselSlider(specialDaysList)
                            : tabTap == 4
                                ? carouselSlider(visitingCardList)
                                : tabTap == 5
                                    ? carouselSlider(visitingCardList)
                                    : tabTap == 6
                                        ? carouselSlider(visitingCardList)
                                        : tabTap == 7
                                            ? carouselSlider(visitingCardList)
                                            : tabTap == 8
                                                ? carouselSlider(
                                                    visitingCardList)
                                                : Container(),
          ),
          const SizedBox(
            height: 50,
          ),
          mobileTabletNextBackImage(),
          const SizedBox(
            height: 50,
          ),
          viewMoreButton(50, 200),
          const SizedBox(
            height: 60,
          ),
          Center(
            child: Text(
              "Awesome Features",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 25,
                fontWeight: FontWeight.w600,
                color: kPrimeryColor,
              ),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          SizedBox(
            height: 470,
            width: 450,
            child: Image.asset(
              "assets/webImages/awsomeFeature.gif",
              fit: BoxFit.fill,
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          awesomeOddItem(),
          awesomeEvenItem(),
          const SizedBox(
            height: 50,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 40),
            child: cardGif(500, 640),
          ),
          const SizedBox(
            height: 50,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 40),
            child: cardTextColumn(
                CrossAxisAlignment.center, TextAlign.center, null, 30),
          ),
          const SizedBox(
            height: 50,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 40),
            child: posterGif(500, 640),
          ),
          const SizedBox(
            height: 50,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 40),
            child: posterTextColumn(
                CrossAxisAlignment.center, TextAlign.center, null, 30),
          ),
          const SizedBox(
            height: 50,
          ),
          Container(
            width: double.infinity,
            color: kPrimeryColor,
            child: Container(
              margin: const EdgeInsets.only(left: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 40),
                    width: 350,
                    child: footerPlayStore(20),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Center(
                    child: Container(
                      margin: const EdgeInsets.only(right: 20),
                      width: 800,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              footerPosterText(),
                              footerCardText(),
                            ],
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              footerLinkText(),
                              footerProductHelpText(),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Divider(
                    indent: 60,
                    endIndent: 60,
                    color: whiteColor.withOpacity(0.4),
                    thickness: 2,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Center(
                    child: footerTextSpan(12, 15),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  mobileLayout() {
    return LayoutBuilder(builder: (context, constraints) {
      return SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    kPrimeryColor,
                    kSecondaryColor,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      headerTopPart(),
                      headerCenterPart(constraints.maxWidth > 400 ? 24 : 16,
                          constraints.maxWidth > 400 ? 15 : 12),
                      const SizedBox(
                        height: 50,
                      ),
                      directHeaderGif(),
                      const SizedBox(
                        height: 50,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 30),
              width: 775,
              child: Center(
                child: Text(
                  "You'll love our free templates. Customize in a snap.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: constraints.maxWidth > 420 ? 24 : 18,
                    fontWeight: FontWeight.w600,
                    color: kPrimeryColor,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            tabList(),
            const SizedBox(
              height: 50,
            ),
            SizedBox(
              height: 250,
              width: double.infinity,
              child: tabTap == 0
                  ? carouselSlider(templateWithImageList)
                  : tabTap == 1
                      ? carouselSlider(patrioticDayList)
                      : tabTap == 2
                          ? carouselSlider(festivalsEventList)
                          : tabTap == 3
                              ? carouselSlider(specialDaysList)
                              : tabTap == 4
                                  ? carouselSlider(visitingCardList)
                                  : tabTap == 5
                                      ? carouselSlider(visitingCardList)
                                      : tabTap == 6
                                          ? carouselSlider(visitingCardList)
                                          : tabTap == 7
                                              ? carouselSlider(visitingCardList)
                                              : tabTap == 8
                                                  ? carouselSlider(
                                                      visitingCardList)
                                                  : Container(),
            ),
            const SizedBox(
              height: 50,
            ),
            mobileTabletNextBackImage(),
            const SizedBox(
              height: 50,
            ),
            viewMoreButton(50, 200),
            const SizedBox(
              height: 60,
            ),
            Center(
              child: Text(
                "Awesome Features",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                  color: kPrimeryColor,
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            SizedBox(
              height: 470,
              width: 450,
              child: Image.asset(
                "assets/webImages/awsomeFeature.gif",
                fit: BoxFit.fill,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            awesomeOddItem(),
            awesomeEvenItem(),
            const SizedBox(
              height: 50,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 40),
              child: cardGif(500, 640),
            ),
            const SizedBox(
              height: 50,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 40),
              child: cardTextColumn(
                  CrossAxisAlignment.center, TextAlign.center, null, 30),
            ),
            const SizedBox(
              height: 50,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 40),
              child: posterGif(500, 640),
            ),
            const SizedBox(
              height: 50,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 40),
              child: posterTextColumn(
                  CrossAxisAlignment.center, TextAlign.center, null, 30),
            ),
            const SizedBox(
              height: 50,
            ),
            Container(
              width: double.infinity,
              color: kPrimeryColor,
              child: Container(
                margin: const EdgeInsets.only(left: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 40),
                      width: 350,
                      child: footerPlayStore(20),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    footerPosterText(),
                    const SizedBox(
                      height: 50,
                    ),
                    footerCardText(),
                    const SizedBox(
                      height: 50,
                    ),
                    footerLinkText(),
                    const SizedBox(
                      height: 50,
                    ),
                    footerProductHelpText(),
                    const SizedBox(
                      height: 50,
                    ),
                    Divider(
                      indent: 60,
                      endIndent: 60,
                      color: whiteColor.withOpacity(0.4),
                      thickness: 2,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Center(
                      child: footerTextSpan(12, 15),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget carouselSlider(listName) {
    var w = MediaQuery.of(context).size.width;
    return (listName != null && listName.isNotEmpty)
        ? CarouselSlider.builder(
            carouselController: carouselSliderController,
            itemCount: listName.length,
            itemBuilder: (context, index, realIndex) {
              return GestureDetector(
                onTap: () async {
                  if (listName[index]["type"] == "Post") {
                    pickImage = await imagePicker.pickImage(
                        source: ImageSource.gallery);

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
                    print("No image selected.");
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
                },
                child: Image.asset(
                  listName[index]["image"],
                  fit: BoxFit.fill,
                ),
              );
            },
            options: CarouselOptions(
              height: 400.0,
              autoPlay: false,
              viewportFraction: w > 949
                  ? 0.45
                  : w > 730
                      ? 0.32
                      : w > 670
                          ? 0.35
                          : w > 580
                              ? 0.4
                              : w > 530
                                  ? 0.42
                                  : w > 460
                                      ? 0.45
                                      : w > 350
                                          ? 0.5
                                          : 0.55,
              enlargeCenterPage: true,
              initialPage: currentIndex,
              aspectRatio: 16 / 9,
              onPageChanged: (index, reason) {
                setState(() {
                  currentIndex = index;
                });
              },
            ),
          )
        : Container();
  }

  Widget mobileTabletNextBackImage() {
    return Wrap(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              carouselSliderController.previousPage();
            });
          },
          child: Container(
            height: 50,
            width: 50,
            decoration: const BoxDecoration(
              border: GradientBoxBorder(
                gradient: LinearGradient(
                  colors: [kPrimeryColor, kSecondaryColor],
                ),
                width: 2,
              ),
              shape: BoxShape.circle,
            ),
            child: Align(
              alignment: Alignment.center,
              child: Container(
                margin: const EdgeInsets.only(left: 10),
                child: const Icon(
                  Icons.arrow_back_ios,
                  color: kPrimeryColor,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 80,
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              carouselSliderController.nextPage();
            });
          },
          child: Container(
            height: 50,
            width: 50,
            decoration: const BoxDecoration(
              border: GradientBoxBorder(
                gradient: LinearGradient(
                  colors: [kPrimeryColor, kSecondaryColor],
                ),
                width: 2,
              ),
              shape: BoxShape.circle,
            ),
            child: const Align(
              alignment: Alignment.center,
              child: Icon(
                Icons.arrow_forward_ios,
                color: kPrimeryColor,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget directHeaderGif() {
    return Column(
      children: [
        Container(
          height: 300,
          width: 250,
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.circular(20),
            image: const DecorationImage(
              image: AssetImage("assets/webImages/WebAnimated_1.gif"),
              fit: BoxFit.fill,
            ),
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        GestureDetector(
          onTap: () {},
          child: Container(
            height: 40,
            width: 140,
            decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [kPrimeryColor, kSecondaryColor],
                ),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 10,
                    color: blackColor.withOpacity(0.4),
                  ),
                ]),
            child: Center(
              child: Text(
                "Poster Edit",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: whiteColor,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 50,
        ),
        Container(
          height: 300,
          width: 250,
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.circular(20),
            image: const DecorationImage(
              image: AssetImage("assets/webImages/WebAnimated_2.gif"),
              fit: BoxFit.fill,
            ),
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        GestureDetector(
          onTap: () {},
          child: Container(
            height: 40,
            width: 140,
            decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [kPrimeryColor, kSecondaryColor],
                ),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 10,
                    color: blackColor.withOpacity(0.4),
                  ),
                ]),
            child: Center(
              child: Text(
                "Poster Edit",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: whiteColor,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget headerTopPart() {
    return LayoutBuilder(builder: (context, constraints) {
      return SizedBox(
        height: 100,
        width: double.infinity,
        child: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 50),
            width: 1320,
            height: 52,
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: constraints.maxWidth > 150 ? 52 : 20,
                      width: constraints.maxWidth > 150 ? 52 : 20,
                      child: Image.asset("assets/images/AppLogo.png"),
                    ),
                    SizedBox(
                      width: constraints.maxWidth > 1000 ? 20 : 0,
                    ),
                    constraints.maxWidth > 1000
                        ? Text(
                            "Festival Poster",
                            style: GoogleFonts.reemKufiFun(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                              color: whiteColor,
                            ),
                          )
                        : Container(),
                  ],
                ),
                constraints.maxWidth > 949
                    ? Container(
                        margin: const EdgeInsets.only(top: 12),
                        height: 30,
                        width: 650,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            PopupMenuTheme(
                              data: PopupMenuThemeData(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: PopupMenuButton(
                                offset: Offset(
                                    constraints.maxWidth > 1134 ? 70 : -70, 50),
                                onSelected: (value) {
                                  selectedName = value.toString();
                                  print('Selected: $selectedName');
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                      type: PageTransitionType.rightToLeft,
                                      duration:
                                          const Duration(milliseconds: 400),
                                      child: SpecificPosterWeb(
                                        selectedName: selectedName,
                                      ),
                                    ),
                                  );
                                },
                                itemBuilder: (context) {
                                  return List.generate(
                                    templateList.length,
                                    (index) {
                                      return PopupMenuItem(
                                        value: templateList[index],
                                        child: Center(
                                          child: GradientText(
                                            templateList[index],
                                            style: GoogleFonts.poppins(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            gradient: const LinearGradient(
                                              colors: [
                                                Color(0xff276EB6),
                                                Color(0xff443995),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      "Templates",
                                      style: GoogleFonts.poppins(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(top: 2),
                                      child: const Icon(
                                        Icons.keyboard_arrow_down_outlined,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            PopupMenuTheme(
                              data: PopupMenuThemeData(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: PopupMenuButton(
                                offset: const Offset(70, 50),
                                onSelected: (value) {
                                  selectedName = value.toString();
                                  print('Selected: $selectedName');
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                      type: PageTransitionType.rightToLeft,
                                      duration:
                                          const Duration(milliseconds: 400),
                                      child: SpecificPosterWeb(
                                        selectedName: selectedName,
                                      ),
                                    ),
                                  );
                                },
                                itemBuilder: (context) {
                                  return List.generate(
                                    businessCardList.length,
                                    (index) {
                                      return PopupMenuItem(
                                        value: businessCardList[index],
                                        child: Center(
                                          child: GradientText(
                                            businessCardList[index],
                                            style: GoogleFonts.poppins(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            gradient: const LinearGradient(
                                              colors: [
                                                Color(0xff276EB6),
                                                Color(0xff443995),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      "Business card",
                                      style: GoogleFonts.poppins(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(top: 2),
                                      child: const Icon(
                                        Icons.keyboard_arrow_down_outlined,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Text(
                              "About Us",
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: whiteColor,
                              ),
                            ),
                            Text(
                              "Contact Us",
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: whiteColor,
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(
                        margin: const EdgeInsets.only(top: 8),
                        child: IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.topToBottom,
                                duration: const Duration(milliseconds: 400),
                                child: const DrawerScreenWeb(),
                              ),
                            );
                          },
                          icon: const ImageIcon(
                            AssetImage("assets/webImages/webDrawer.png"),
                            color: whiteColor,
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget headerCenterPart(mainTextSize, subTextSize) {
    return LayoutBuilder(builder: (context, constraints) {
      return Center(
        child: Container(
          margin: EdgeInsets.only(
              top: constraints.maxWidth > 950 ? 20 : 80, left: 20, right: 20),
          width: constraints.maxWidth > 950 ? 550 : 500,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Free customizable festival templates for every occasion",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: mainTextSize,
                  fontWeight: FontWeight.w600,
                  color: whiteColor,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 450,
                child: Text(
                  "Unleash your creativity with our free customizable festival templates! Perfect for every celebration, our designs make it easy to craft stunning posters that capture the spirit of any occasion.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: subTextSize,
                    fontWeight: FontWeight.w500,
                    color: whiteColor,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  print("--------- Start Creating Tap -----------");
                  Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.rightToLeft,
                      duration: const Duration(milliseconds: 400),
                      child: const ViewAllScreenWeb(),
                    ),
                  );
                },
                child: MouseRegion(
                  onEnter: (event) => setState(() {
                    isHover = true;
                  }),
                  onExit: (event) => setState(() {
                    isHover = false;
                  }),
                  child: Container(
                    height: 50,
                    width: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: isHover ? kPrimeryColor : whiteColor,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        constraints.maxWidth > 550
                            ? Text(
                                "Start Creating",
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: isHover ? whiteColor : kPrimeryColor,
                                ),
                              )
                            : Flexible(
                                child: Text(
                                  "Start Creating",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: isHover ? whiteColor : kPrimeryColor,
                                  ),
                                ),
                              ),
                        const SizedBox(
                          width: 5,
                        ),
                        isHover
                            ? Container(
                                margin: const EdgeInsets.only(top: 6),
                                child: const Icon(
                                  Icons.arrow_forward,
                                  color: whiteColor,
                                  size: 18,
                                ),
                              )
                            : Container()
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget headerGif() {
    return LayoutBuilder(builder: (context, constraints) {
      return Align(
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            MouseRegion(
              onEnter: (event) => setState(() {
                isGifHover1 = true;
              }),
              onExit: (event) => setState(() {
                isGifHover1 = false;
              }),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    isGifHover1 = !isGifHover1;
                    isGifHover2 = false;
                  });
                },
                child: Stack(
                  alignment: AlignmentDirectional.bottomStart,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      height: isGifHover1 ? 446 : 250,
                      width: 446,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(40),
                          topLeft: Radius.circular(40),
                        ),
                        border: isGifHover1
                            ? null
                            : Border.all(color: whiteColor, width: 2),
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 10,
                            blurStyle: BlurStyle.outer,
                            color: whiteColor,
                          ),
                        ],
                        image: DecorationImage(
                          image: AssetImage(
                            isGifHover1
                                ? "assets/webImages/WebAnimated_1.gif"
                                : "assets/webImages/WebAnimated_1.png",
                          ),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      height: isGifHover1 ? 446 : 250,
                      width: 446,
                      decoration: BoxDecoration(
                        color: isGifHover1
                            ? blackColor.withOpacity(0.4)
                            : transparentColor,
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(40),
                          topLeft: Radius.circular(40),
                        ),
                      ),
                    ),
                    isGifHover1
                        ? Positioned(
                            bottom: 30,
                            right: 0,
                            left: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {},
                                  child: MouseRegion(
                                    onEnter: (event) => setState(() {
                                      isPosterEdit = true;
                                    }),
                                    onExit: (event) => setState(() {
                                      isPosterEdit = false;
                                    }),
                                    child: Center(
                                      child: Container(
                                        height: 55,
                                        width: 200,
                                        decoration: BoxDecoration(
                                          gradient: isPosterEdit
                                              ? const LinearGradient(colors: [
                                                  kPrimeryColor,
                                                  kSecondaryColor
                                                ])
                                              : null,
                                          border: const GradientBoxBorder(
                                            gradient: LinearGradient(
                                              colors: [
                                                kPrimeryColor,
                                                kSecondaryColor
                                              ],
                                            ),
                                            width: 2,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Poster Edit",
                                            style: GoogleFonts.poppins(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                              color: whiteColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: constraints.maxWidth > 1000 ? 50 : 25,
            ),
            MouseRegion(
              onEnter: (event) => setState(() {
                isGifHover2 = true;
              }),
              onExit: (event) => setState(() {
                isGifHover2 = false;
              }),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    isGifHover2 = !isGifHover2;
                    isGifHover1 = false;
                  });
                },
                child: Stack(
                  alignment: AlignmentDirectional.bottomStart,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      transformAlignment: Alignment.bottomCenter,
                      height: isGifHover2 ? 446 : 250,
                      width: 446,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(40),
                          topLeft: Radius.circular(40),
                        ),
                        border: isGifHover2
                            ? null
                            : Border.all(color: whiteColor, width: 2),
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 10,
                            blurStyle: BlurStyle.outer,
                            color: whiteColor,
                          ),
                        ],
                        image: DecorationImage(
                          image: AssetImage(isGifHover2
                              ? "assets/webImages/webAnimated_2.gif"
                              : "assets/webImages/WebAnimated_2.png"),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      height: isGifHover2 ? 446 : 250,
                      width: 446,
                      decoration: BoxDecoration(
                        color: isGifHover2
                            ? blackColor.withOpacity(0.4)
                            : transparentColor,
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(40),
                          topLeft: Radius.circular(40),
                        ),
                      ),
                    ),
                    isGifHover2
                        ? Positioned(
                            bottom: 30,
                            right: 0,
                            left: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {},
                                  child: MouseRegion(
                                    onEnter: (event) => setState(() {
                                      isCradEdit = true;
                                    }),
                                    onExit: (event) => setState(() {
                                      isCradEdit = false;
                                    }),
                                    child: Center(
                                      child: Container(
                                        height: 55,
                                        width: 200,
                                        decoration: BoxDecoration(
                                          gradient: isCradEdit
                                              ? const LinearGradient(colors: [
                                                  kPrimeryColor,
                                                  kSecondaryColor
                                                ])
                                              : null,
                                          border: const GradientBoxBorder(
                                            gradient: LinearGradient(
                                              colors: [
                                                kPrimeryColor,
                                                kSecondaryColor
                                              ],
                                            ),
                                            width: 2,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Card Edit",
                                            style: GoogleFonts.poppins(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                              color: whiteColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget tabList() {
    return LayoutBuilder(builder: (context, constraints) {
      return SizedBox(
        height: 45,
        width: 1224,
        child: ScrollConfiguration(
          behavior: WebScrollBehavior(),
          child: ListView.builder(
            padding: EdgeInsets.symmetric(
                horizontal: constraints.maxWidth > 1270 ? 0 : 30),
            scrollDirection: Axis.horizontal,
            itemCount: categoryList.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(
                  top: 0.0,
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
                      height: 55,
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
                                colors: [kPrimeryColor, kSecondaryColor])
                            : null,
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 30,
                            right: 30,
                          ),
                          child: Text(
                            categoryList[index],
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
    });
  }

  Widget awesomeOddItem() {
    return LayoutBuilder(
      builder: (context, constraints) {
        double responsiveFactor =
            constraints.maxWidth < 600 ? constraints.maxWidth / 600 : 1.0;

        return Container(
          margin: EdgeInsets.symmetric(
              horizontal: constraints.maxWidth > 949 ? 0 : 20),
          width: constraints.maxWidth > 949 ? 450 : 600,
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: awesomeFetureList.length,
            itemBuilder: (context, index) {
              return index % 2 == 0
                  ? MouseRegion(
                      onEnter: (event) => setState(() {
                        awesomeHoverIndex = index;
                      }),
                      onExit: (event) => setState(() {
                        awesomeHoverIndex = null;
                      }),
                      child: Container(
                        margin: EdgeInsets.only(
                          top: 15,
                          right: constraints.maxWidth > 600 ? 0 : 20,
                          left: constraints.maxWidth > 600 ? 0 : 20,
                        ),
                        width: 450,
                        decoration: BoxDecoration(
                          color: awesomeHoverIndex == index
                              ? kPrimeryColor
                              : whiteColor,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 10,
                              color: blackColor.withOpacity(0.2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              margin:
                                  const EdgeInsets.only(left: 20, right: 20),
                              height: 70 * responsiveFactor,
                              width: 70 * responsiveFactor,
                              decoration: BoxDecoration(
                                color: kPrimeryColor,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  awesomeHoverIndex == index
                                      ? BoxShadow(
                                          blurRadius: 10,
                                          color: whiteColor.withOpacity(0.3),
                                        )
                                      : const BoxShadow(),
                                ],
                              ),
                              child: Image.asset(
                                awesomeFetureList[index]["icon"],
                                scale: 5.5,
                              ),
                            ),
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      awesomeFetureList[index]["title"],
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: awesomeHoverIndex == index
                                            ? whiteColor
                                            : kPrimeryColor,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      awesomeFetureList[index]["description"],
                                      style: GoogleFonts.poppins(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                        color: awesomeHoverIndex == index
                                            ? whiteColor
                                            : const Color(0xff747474),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Container();
            },
          ),
        );
      },
    );
  }

  Widget awesomeEvenItem() {
    return LayoutBuilder(
      builder: (context, constraints) {
        double responsiveFactor =
            constraints.maxWidth < 600 ? constraints.maxWidth / 600 : 1.0;

        return Container(
          margin: EdgeInsets.symmetric(
              horizontal: constraints.maxWidth > 949 ? 0 : 20),
          width: constraints.maxWidth > 949 ? 450 : 600,
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: awesomeFetureList.length,
            itemBuilder: (context, index) {
              return index % 2 == 1
                  ? MouseRegion(
                      onEnter: (event) => setState(() {
                        awesomeHoverIndex = index;
                      }),
                      onExit: (event) => setState(() {
                        awesomeHoverIndex = null;
                      }),
                      child: Container(
                        margin: EdgeInsets.only(
                          top: 15,
                          right: constraints.maxWidth > 600 ? 0 : 20,
                          left: constraints.maxWidth > 600 ? 0 : 20,
                        ),
                        width: 450,
                        decoration: BoxDecoration(
                          color: awesomeHoverIndex == index
                              ? kPrimeryColor
                              : whiteColor,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 10,
                              color: blackColor.withOpacity(0.2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              margin:
                                  const EdgeInsets.only(left: 20, right: 20),
                              height: 70 * responsiveFactor,
                              width: 70 * responsiveFactor,
                              decoration: BoxDecoration(
                                color: kPrimeryColor,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  awesomeHoverIndex == index
                                      ? BoxShadow(
                                          blurRadius: 10,
                                          color: whiteColor.withOpacity(0.3),
                                        )
                                      : const BoxShadow(),
                                ],
                              ),
                              child: Image.asset(
                                awesomeFetureList[index]["icon"],
                                scale: 5.5,
                              ),
                            ),
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      awesomeFetureList[index]["title"],
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: awesomeHoverIndex == index
                                            ? whiteColor
                                            : kPrimeryColor,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      awesomeFetureList[index]["description"],
                                      style: GoogleFonts.poppins(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                        color: awesomeHoverIndex == index
                                            ? whiteColor
                                            : const Color(0xff747474),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Container();
            },
          ),
        );
      },
    );
  }

  Widget imageList(int itemCount, listName, int itemLength) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int adjustedItemsPerPage = constraints.maxWidth > 1550
            ? 4
            : constraints.maxWidth > 1250
                ? 3
                : 2;

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  if (currentIndex > 0) {
                    currentIndex = max(0, currentIndex - adjustedItemsPerPage);
                  }
                });
              },
              child: Container(
                height: 64,
                width: 64,
                decoration: const BoxDecoration(
                  border: GradientBoxBorder(
                    gradient: LinearGradient(
                      colors: [kPrimeryColor, kSecondaryColor],
                    ),
                    width: 2,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    margin: const EdgeInsets.only(left: 10),
                    child: const Icon(
                      Icons.arrow_back_ios,
                      color: kPrimeryColor,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 50),
            SizedBox(
              height: 340,
              width: constraints.maxWidth > 1550
                  ? 1280
                  : constraints.maxWidth > 1250
                      ? 960
                      : 640,
              child: ScrollConfiguration(
                behavior: WebScrollBehavior(),
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: itemCount,
                  itemBuilder: (context, index) {
                    int itemIndex = currentIndex + index;
                    return GestureDetector(
                      onTap: () async {
                        if (listName[itemIndex]["type"] == "Post") {
                          pickImage = await imagePicker.pickImage(
                              source: ImageSource.gallery);
                          imageBytes = await pickImage!.readAsBytes();
                          if (imageBytes != null) {
                            isDrawerIconTap = true;
                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.rightToLeft,
                                duration: const Duration(milliseconds: 400),
                                child: EditImageScreenWeb(
                                  image: listName[itemIndex]["image"],
                                  wallPaper: listName[itemIndex]["image_2"],
                                ),
                              ),
                            );
                          }
                        } else if (listName[itemIndex]["type"] ==
                            "Visiting Card") {
                          isCardDrawerIconTap = true;
                          Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.rightToLeft,
                              duration: const Duration(milliseconds: 400),
                              child: EditCardSCreenWeb(
                                frontSide: listName[itemIndex]["image_2"],
                                backSide: listName[itemIndex]["image_3"],
                              ),
                            ),
                          );
                        }
                        setState(() {});
                      },
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        height: 300,
                        width: constraints.maxWidth < 1200 ? 320 : 320,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: MouseRegion(
                          onEnter: (event) => setState(() {
                            imageHoverIndex = itemIndex;
                            controller.forward();
                          }),
                          onExit: (event) => setState(() {
                            imageHoverIndex = null;
                            controller.reverse();
                          }),
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(40),
                                child: AnimatedBuilder(
                                  animation: zoomAnimation,
                                  builder: (context, child) {
                                    return Transform.scale(
                                      scale: imageHoverIndex == itemIndex
                                          ? zoomAnimation.value
                                          : 1.0,
                                      child: child,
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(40),
                                      image: DecorationImage(
                                        image: AssetImage(
                                          listName[itemIndex]["image"],
                                        ),
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              if (imageHoverIndex == itemIndex) ...[
                                Container(
                                  height: 300,
                                  width: 320,
                                  decoration: BoxDecoration(
                                    color: blackColor.withOpacity(0.4),
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                ),
                                Positioned(
                                  bottom: 30,
                                  right: 0,
                                  left: 0,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          if (listName[itemIndex]["type"] ==
                                              "Post") {
                                            pickImage =
                                                await imagePicker.pickImage(
                                                    source:
                                                        ImageSource.gallery);
                                            imageBytes =
                                                await pickImage!.readAsBytes();
                                            if (imageBytes != null) {
                                              isDrawerIconTap = true;
                                              Navigator.push(
                                                context,
                                                PageTransition(
                                                  type: PageTransitionType
                                                      .rightToLeft,
                                                  duration: const Duration(
                                                      milliseconds: 400),
                                                  child: EditImageScreenWeb(
                                                    image: listName[itemIndex]
                                                        ["image"],
                                                    wallPaper:
                                                        listName[itemIndex]
                                                            ["image_2"],
                                                  ),
                                                ),
                                              );
                                            }
                                          } else if (listName[itemIndex]
                                                  ["type"] ==
                                              "Visiting Card") {
                                            isCardDrawerIconTap = true;
                                            Navigator.push(
                                              context,
                                              PageTransition(
                                                type: PageTransitionType
                                                    .rightToLeft,
                                                duration: const Duration(
                                                    milliseconds: 400),
                                                child: EditCardSCreenWeb(
                                                  frontSide: listName[itemIndex]
                                                      ["image_2"],
                                                  backSide: listName[itemIndex]
                                                      ["image_3"],
                                                ),
                                              ),
                                            );
                                          }
                                          setState(() {});
                                        },
                                        child: MouseRegion(
                                          onEnter: (event) => setState(() {
                                            isListEditPoster = true;
                                          }),
                                          onExit: (event) => setState(() {
                                            isListEditPoster = false;
                                          }),
                                          child: Container(
                                            height: 40,
                                            width: 150,
                                            decoration: BoxDecoration(
                                              gradient: isListEditPoster
                                                  ? const LinearGradient(
                                                      colors: [
                                                        kPrimeryColor,
                                                        kSecondaryColor
                                                      ],
                                                    )
                                                  : null,
                                              color: whiteColor,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Center(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  GradientText(
                                                    listName[itemIndex]
                                                                ["type"] ==
                                                            "Post"
                                                        ? "Edit Poster"
                                                        : "Edit Card",
                                                    gradient: isListEditPoster
                                                        ? const LinearGradient(
                                                            colors: [
                                                              whiteColor,
                                                              whiteColor
                                                            ],
                                                          )
                                                        : const LinearGradient(
                                                            colors: [
                                                              kPrimeryColor,
                                                              kSecondaryColor
                                                            ],
                                                          ),
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: isListEditPoster
                                                          ? whiteColor
                                                          : null,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: isListEditPoster
                                                        ? 5
                                                        : 0,
                                                  ),
                                                  if (isListEditPoster)
                                                    Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              top: 2),
                                                      child: const Icon(
                                                        Icons.arrow_forward,
                                                        color: whiteColor,
                                                        size: 16,
                                                      ),
                                                    )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 50),
            GestureDetector(
              onTap: () {
                setState(() {
                  int maxIndex = itemLength - adjustedItemsPerPage;
                  if (currentIndex < maxIndex) {
                    currentIndex =
                        min(maxIndex, currentIndex + adjustedItemsPerPage);
                  }
                });
              },
              child: Container(
                height: 64,
                width: 64,
                decoration: const BoxDecoration(
                  border: GradientBoxBorder(
                    gradient: LinearGradient(
                      colors: [kPrimeryColor, kSecondaryColor],
                    ),
                    width: 2,
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Align(
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: kPrimeryColor,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget cardTextColumn(crossAxisAlignment, textAlign, height, sizedBoxHeight) {
    return LayoutBuilder(builder: (context, constraints) {
      return SizedBox(
        height: height,
        width: 600,
        child: Column(
          crossAxisAlignment: crossAxisAlignment,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Business Card Maker",
              style: GoogleFonts.poppins(
                fontSize: 30,
                fontWeight: FontWeight.w600,
                color: kPrimeryColor,
              ),
            ),
            SizedBox(
              height: sizedBoxHeight,
            ),
            Text(
              "Create professional and personalized business cards in minutes with our easy-to-use Business Card Maker. Choose from a variety of modern templates, customize your design with logos, text, and colors, and ensure your brand leaves a lasting impression. Perfect for entrepreneurs, professionals, and creatives looking to stand out.",
              textAlign: textAlign,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: const Color(0xff747474),
              ),
            ),
            SizedBox(
              height: sizedBoxHeight,
            ),
            GestureDetector(
              onTap: () {},
              child: MouseRegion(
                onEnter: (event) => setState(() {
                  isHoverBusinessCrad = true;
                }),
                onExit: (event) => setState(() {
                  isHoverBusinessCrad = false;
                }),
                child: Container(
                  height: 70,
                  width: 280,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: isHoverBusinessCrad ? kPrimeryColor : whiteColor,
                    border: Border.all(
                      color: kPrimeryColor,
                      width: 2,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      constraints.maxWidth > 550
                          ? Text(
                              "Business Card Maker",
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: isHoverBusinessCrad
                                    ? whiteColor
                                    : kPrimeryColor,
                              ),
                            )
                          : Flexible(
                              child: Text(
                                "Business Card Maker",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: isHoverBusinessCrad
                                      ? whiteColor
                                      : kPrimeryColor,
                                ),
                              ),
                            ),
                      const SizedBox(
                        width: 5,
                      ),
                      isHoverBusinessCrad
                          ? Container(
                              margin: const EdgeInsets.only(top: 4),
                              child: const Icon(
                                Icons.arrow_forward,
                                color: whiteColor,
                                size: 22,
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget cardGif(height, weight) {
    return Container(
      height: height,
      width: weight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        image: const DecorationImage(
          image: AssetImage("assets/webImages/card.gif"),
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  Widget posterTextColumn(
      crossAxisAlignment, textAlign, height, sizedBoxHeight) {
    return LayoutBuilder(builder: (context, constraints) {
      return SizedBox(
        height: height,
        width: 600,
        child: Column(
          crossAxisAlignment: crossAxisAlignment,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Festival Poster Maker",
              style: GoogleFonts.poppins(
                fontSize: 30,
                fontWeight: FontWeight.w600,
                color: kPrimeryColor,
              ),
            ),
            SizedBox(
              height: sizedBoxHeight,
            ),
            Text(
              "Create professional and personalized business cards in minutes with our easy-to-use Business Card Maker. Choose from a variety of modern templates, customize your design with logos, text, and colors, and ensure your brand leaves a lasting impression. Perfect for entrepreneurs, professionals, and creatives looking to stand out.",
              textAlign: textAlign,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: const Color(0xff747474),
              ),
            ),
            SizedBox(
              height: sizedBoxHeight,
            ),
            GestureDetector(
              onTap: () {},
              child: MouseRegion(
                onEnter: (event) => setState(() {
                  isHoverFestivalPoster = true;
                }),
                onExit: (event) => setState(() {
                  isHoverFestivalPoster = false;
                }),
                child: Container(
                  height: 70,
                  width: 280,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: isHoverFestivalPoster ? kPrimeryColor : whiteColor,
                    border: Border.all(
                      color: kPrimeryColor,
                      width: 2,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      constraints.maxWidth > 550
                          ? Center(
                              child: Text(
                                "Festival Poster Maker",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: isHoverFestivalPoster
                                      ? whiteColor
                                      : kPrimeryColor,
                                ),
                              ),
                            )
                          : Flexible(
                              child: Center(
                                child: Text(
                                  "Festival Poster Maker",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: isHoverFestivalPoster
                                        ? whiteColor
                                        : kPrimeryColor,
                                  ),
                                ),
                              ),
                            ),
                      const SizedBox(
                        width: 5,
                      ),
                      isHoverFestivalPoster
                          ? Container(
                              margin: const EdgeInsets.only(top: 4),
                              child: const Icon(
                                Icons.arrow_forward,
                                color: whiteColor,
                                size: 22,
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget posterGif(height, width) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        image: const DecorationImage(
          image: AssetImage("assets/webImages/posterFrame.gif"),
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  Widget footerPlayStore(sizeBoxHeight) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          children: [
            SizedBox(
              height: 52,
              width: 52,
              child: Image.asset("assets/images/AppLogo.png"),
            ),
            const SizedBox(
              width: 20,
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: Text(
                "Festival Poster",
                style: GoogleFonts.reemKufiFun(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  color: whiteColor,
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: sizeBoxHeight,
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 20),
          child: Text(
            "Festival Post is one of the Leading Company in India that has mastered in the Latest Image Post.",
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: whiteColor,
            ),
          ),
        ),
        SizedBox(
          height: sizeBoxHeight,
        ),
        GestureDetector(
          onTap: () async {
            await launchUrl(
              Uri.parse(
                  "https://play.google.com/store/apps/details?id=com.festival.posterImage&pcampaignid=web_share"),
            );
          },
          child: Container(
            height: 60,
            width: 200,
            decoration: BoxDecoration(
              border: Border.all(color: whiteColor, width: 1.5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 10),
                  height: 30,
                  width: 27,
                  child: Image.asset(
                    "assets/webImages/playStore.png",
                    fit: BoxFit.fill,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  width: 110,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Wrap(
                          children: [
                            Text(
                              "Available on",
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: whiteColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        child: Wrap(
                          children: [
                            Text(
                              "Google Play",
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: whiteColor,
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
          ),
        ),
      ],
    );
  }

  Widget footerPosterText() {
    return LayoutBuilder(builder: (context, constraints) {
      return SizedBox(
        width: 108,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Posters",
              style: GoogleFonts.poppins(
                fontSize: 26,
                fontWeight: FontWeight.w600,
                color: whiteColor,
              ),
            ),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: footerList["Posters"]!.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.rightToLeft,
                          duration: const Duration(milliseconds: 400),
                          child: SpecificPosterWeb(
                            selectedName: footerList["Posters"]![index],
                          ),
                        ),
                      );
                    },
                    child: MouseRegion(
                      onEnter: (event) => setState(() {
                        postHoverIndex = index;
                      }),
                      onExit: (event) => setState(() {
                        postHoverIndex = null;
                      }),
                      child: Text(
                        footerList["Posters"]![index],
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: whiteColor,
                          decoration: postHoverIndex == index
                              ? TextDecoration.underline
                              : TextDecoration.none,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      );
    });
  }

  Widget footerCardText() {
    return LayoutBuilder(builder: (context, constraints) {
      return SizedBox(
        width: 230,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Business Card",
              style: GoogleFonts.poppins(
                fontSize: 26,
                fontWeight: FontWeight.w600,
                color: whiteColor,
              ),
            ),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: footerList["Business Card"]!.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.rightToLeft,
                          duration: const Duration(milliseconds: 400),
                          child: SpecificPosterWeb(
                            selectedName: footerList["Business Card"]![index],
                          ),
                        ),
                      );
                    },
                    child: MouseRegion(
                      onEnter: (event) => setState(() {
                        cardHoverIndex = index;
                      }),
                      onExit: (event) => setState(() {
                        cardHoverIndex = null;
                      }),
                      child: Text(
                        footerList["Business Card"]![index],
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: whiteColor,
                          decoration: cardHoverIndex == index
                              ? TextDecoration.underline
                              : TextDecoration.none,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      );
    });
  }

  Widget footerLinkText() {
    return LayoutBuilder(builder: (context, constraints) {
      return SizedBox(
        width: 185,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Links",
              style: GoogleFonts.poppins(
                fontSize: 26,
                fontWeight: FontWeight.w600,
                color: whiteColor,
              ),
            ),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: footerList["Links"]!.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: GestureDetector(
                    onTap: () {
                      if (index == 0) {
                      } else if (index == 1) {
                        launchUrl(
                          Uri.parse(
                              "https://docs.google.com/document/d/10MKid3JVccHZLHtZ1khu7gc766utLQJbRjQ4UK8zcs0/edit"),
                        );
                      } else if (index == 2) {}
                    },
                    child: MouseRegion(
                      onEnter: (event) => setState(() {
                        linkHoverIndex = index;
                      }),
                      onExit: (event) => setState(() {
                        linkHoverIndex = null;
                      }),
                      child: Text(
                        footerList["Links"]![index],
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: whiteColor,
                          decoration: linkHoverIndex == index
                              ? TextDecoration.underline
                              : TextDecoration.none,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      );
    });
  }

  Widget footerProductHelpText() {
    return LayoutBuilder(builder: (context, constraints) {
      return SizedBox(
        width: 230,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Product Help",
              style: GoogleFonts.poppins(
                fontSize: 26,
                fontWeight: FontWeight.w600,
                color: whiteColor,
              ),
            ),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: footerList["Product Help"]!.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: GestureDetector(
                    onTap: () {},
                    child: MouseRegion(
                      onEnter: (event) => setState(() {
                        productHelpHoverIndex = index;
                      }),
                      onExit: (event) => setState(() {
                        productHelpHoverIndex = null;
                      }),
                      child: Text(
                        footerList["Product Help"]![index],
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: whiteColor,
                          decoration: productHelpHoverIndex == index
                              ? TextDecoration.underline
                              : TextDecoration.none,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      );
    });
  }

  Widget footerTextSpan(fontSize, iconSize) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: "Copyright  ",
              style: GoogleFonts.poppins(
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
                color: whiteColor,
              ),
            ),
            WidgetSpan(
              child: ImageIcon(
                const AssetImage("assets/webImages/copyright.png"),
                color: whiteColor,
                size: iconSize,
              ),
            ),
            TextSpan(
              text: "  2024 Festival Poster All Rights Reserved",
              style: GoogleFonts.poppins(
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
                color: whiteColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget viewMoreButton(buttonHeight, buttonWidth) {
    return LayoutBuilder(builder: (context, constraints) {
      return MouseRegion(
        onEnter: (event) => setState(() {
          isViewMoreHover = true;
        }),
        onExit: (event) => setState(() {
          isViewMoreHover = false;
        }),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.rightToLeft,
                duration: const Duration(milliseconds: 400),
                child: const ViewAllScreenWeb(),
              ),
            );
          },
          child: Container(
            height: buttonHeight,
            width: buttonWidth,
            decoration: BoxDecoration(
              color: kPrimeryColor,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                constraints.maxWidth > 550
                    ? Text(
                        "View More",
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: whiteColor,
                        ),
                      )
                    : Flexible(
                        child: Text(
                          "View More",
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: whiteColor,
                          ),
                        ),
                      ),
                SizedBox(
                  width: isViewMoreHover ? 5 : 0,
                ),
                isViewMoreHover
                    ? Container(
                        margin: const EdgeInsets.only(top: 4),
                        child: const Icon(
                          Icons.arrow_forward,
                          color: whiteColor,
                          size: 20,
                        ),
                      )
                    : Container()
              ],
            ),
          ),
        ),
      );
    });
  }
}

class WebScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.stylus,
        PointerDeviceKind.trackpad,
        PointerDeviceKind.invertedStylus,
        PointerDeviceKind.unknown
      };
}
