import 'dart:ui' as ui;
import 'package:crop_image/crop_image.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_frame/Contstant/Strings.dart';
import 'package:share_plus/share_plus.dart';
import 'package:universal_html/html.dart' as html;
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:photo_frame/Contstant/AppColor.dart';
import 'package:photo_frame/Contstant/CommonMethod.dart';
import 'package:photo_frame/Contstant/getXController.dart';
import 'package:photo_frame/Contstant/itemModel.dart';
import 'package:photo_frame/Screen/Templates.dart';
import 'package:photo_frame/WebScreen/HomeScreenWeb.dart';
import 'package:responsive_builder/responsive_builder.dart';

bool isDrawerIconTap = false;
Rxn<int> selectedIndexPostWeb = Rxn();
Rxn<int> selectedImageIndexWeb = Rxn();

class EditImageScreenWeb extends StatefulWidget {
  final image;
  final wallPaper;
  const EditImageScreenWeb({super.key, this.image, this.wallPaper});

  @override
  State<EditImageScreenWeb> createState() => _EditImageScreenWebState();
}

class _EditImageScreenWebState extends State<EditImageScreenWeb> {
  EditController editController = Get.put(EditController());
  TextEditingController textController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  TextEditingController widthController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  int functionTap = -1;
  bool isAddTextTap = false;
  final TransformationController transformationController =
      TransformationController();
  String duplicate = "";
  Item? selectedItem;
  int? selectedIndex;
  late Uint8List pngBytes;
  GlobalKey globalKey = GlobalKey();
  int cropIndex = 0;
  var cropController = CropController(
    aspectRatio: 100.0 / 140.0,
    defaultCrop: const Rect.fromLTRB(0.05, 0.05, 0.95, 0.95),
  );
  Image? imageCrop;
  bool isCropDoneIconTap = false;
  double highlightValue = 1.0;
  double shadowValue = 1.0;
  double blackValue = 1.0;
  double constrastValue = 1.0;
  double saturationValue = 1.0;
  double tintValue = 1.0;
  double rotateAngle = 0.0;
  double height = 600;
  double width = 380;

  // double height = 748;
  // double width = 1319;

  // double height = 750;
  // double width = 1920;
  double mobileHeight = 450;
  double mobileWidth = 300;
  double tabletHeight = 440;
  double tabletWidth = 300;
  ImagePicker picker = ImagePicker();
  XFile? pickLogo;
  Uint8List? pickLogoBytes;
  bool isContainerOpen = false;
  List<Item> textItems = [];
  int? imageIndex;
  bool isSearchImageTap = false;
  String? selectedImagePath;
  String? selectedImagePosterPath;
  int? seeMoreIndex;
  List cropRatio = [
    {
      "image": "assets/webImages/cropFreeWeb.png",
      "ratio": "Freeform",
    },
    {
      "image": "assets/webImages/crop1:1Web.png",
      "ratio": "1:1",
    },
    {
      "image": "assets/webImages/crop16:9Web.png",
      "ratio": "16:9",
    },
    {
      "image": "assets/webImages/crop9:16Web.png",
      "ratio": "9:16",
    },
    {
      "image": "assets/webImages/crop5:4Web.png",
      "ratio": "5:4",
    },
    {
      "image": "assets/webImages/crop4:5Web.png",
      "ratio": "4:5",
    },
    {
      "image": "assets/webImages/crop4:3Web.png",
      "ratio": "4:3",
    },
    {
      "image": "assets/webImages/crop3:4Web.png",
      "ratio": "3:4",
    },
    {
      "image": "assets/webImages/crop3:2Web.png",
      "ratio": "3:2",
    },
    {
      "image": "assets/webImages/crop2:3Web.png",
      "ratio": "2:3",
    },
  ];

  List sizeList = [
    {
      "image": "assets/webImages/sizeOriginal.png",
      "name": "Original",
      "size": "816 x 1056 px",
      // "width": 408,
      // "height": 528,
      "width": 380,
      "height": 600,
      // "width": 1319,
      // "height": 748,
    },
    {
      "image": "assets/webImages/sizeFacebookProfile.png",
      "name": "Facebook Profile",
      "size": "1080 x 1080 px",
      "width": 540,
      "height": 540,
    },
    {
      "image": "assets/webImages/sizeInstaStory.png",
      "name": "Instagram Story",
      "size": "1080 x 1920 px",
      "width": 540,
      "height": 640,
    },
    {
      "image": "assets/webImages/sizeTwitchOverlay.png",
      "name": "Twitch Overlay",
      "size": "1920 x 1080 px",
      "width": 960,
      "height": 540,
    },
    {
      "image": "assets/webImages/sizeInstaPotrait.png",
      "name": "Instagram Potrait",
      "size": "1080 x 1350 px",
      "width": 540,
      "height": 675,
    },
    {
      "image": "assets/webImages/sizeYoutubeThumbnail.png",
      "name": "Youtube Thumbnail",
      "size": "1280 x 720 px",
      "width": 640,
      "height": 360,
    },
    {
      "image": "assets/webImages/sizeFacebookStory.png",
      "name": "Facebook Story",
      "size": "1080 x 1920 px",
      "width": 540,
      "height": 640,
    },
    {
      "image": "assets/webImages/sizeFacebookPost.png",
      "name": "Facebook Post",
      "size": "1200 x 630 px",
      "width": 600,
      "height": 315,
    },
    {
      "image": "assets/webImages/sizeLinkdinPost.png",
      "name": "LinkedIn Post",
      "size": "1200 x 628 px",
      "width": 600,
      "height": 314,
    },
    {
      "image": "assets/webImages/sizeBanner.png",
      "name": "Banner",
      "size": "468 x 60 px",
      "width": 468,
      "height": 60,
    },
    {
      "image": "assets/webImages/sizeXHeader.png",
      "name": "X Header",
      "size": "1500 x 500 px",
      "width": 750,
      "height": 250,
    },
    {
      "image": "assets/webImages/sizeFacebookCover.png",
      "name": "Facebook Cover",
      "size": "820 x 312 px",
      "width": 410,
      "height": 156,
    },
    {
      "image": "assets/webImages/sizeYoutubeCover.png",
      "name": "Youtube Cover",
      "size": "2560 x 1440 px",
      "width": 853,
      "height": 480,
    },
    {
      "image": "assets/webImages/sizeYoutubeProfile.png",
      "name": "Youtube Profile",
      "size": "1080 x 1080 px",
      "width": 540,
      "height": 540,
    },
  ];

  List<double> contrastMatrix(double contrast) {
    return [
      contrast,
      0,
      0,
      0,
      (1 - contrast) * 128,
      0,
      contrast,
      0,
      0,
      (1 - contrast) * 128,
      0,
      0,
      contrast,
      0,
      (1 - contrast) * 128,
      0,
      0,
      0,
      1,
      0,
    ];
  }

  List<double> highlightMatrix(double highlight) {
    double yellowValue = highlight < 1 ? (1 - highlight) : 0;
    double amberValue = highlight > 1 ? (highlight - 1) : 0;

    return [
      1 + amberValue,
      yellowValue,
      0,
      0,
      0,
      amberValue,
      1 + yellowValue,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
    ];
  }

  List dataList = [];
  List filterList = [];

  void searchTemplate(String search) {
    dataList.clear();
    filterList.clear();
    if (search.isEmpty) {
      dataList = List.from(templateWithImageList);
    } else {
      for (var searchData in templateWithImageList) {
        if (searchData["searchText"]
            .toLowerCase()
            .contains(search.toLowerCase())) {
          filterList.add(searchData);
        }
      }
      dataList = List.from(filterList);
    }
    setState(() {});
  }

  Future<void> shareImage(key) async {
    RenderRepaintBoundary boundary =
        key.currentContext!.findRenderObject() as RenderRepaintBoundary;

    ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    pngBytes = byteData!.buffer.asUint8List();
    final blob = html.Blob([pngBytes], 'image/png');
    final url = html.Url.createObjectUrlFromBlob(blob);

    await Share.share(url);
    html.Url.revokeObjectUrl(url);
  }

  Future<void> saveImage(GlobalKey key,
      {double width = 800, double height = 600}) async {
    try {
      RenderRepaintBoundary boundary =
          key.currentContext!.findRenderObject() as RenderRepaintBoundary;

      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      pngBytes = byteData!.buffer.asUint8List();

      String fileName = '${DateTime.now().millisecondsSinceEpoch}.png';

      var blob = html.Blob([pngBytes]);
      var url = html.Url.createObjectUrlFromBlob(blob);
      print('url url url  •••••••        $url');
      html.AnchorElement(href: url)
        ..setAttribute("download", fileName)
        ..click();
    } catch (e) {
      print("-------- Save Image Error ------- $e");
    }
  }

  // Future<void> saveImage(
  //   GlobalKey key,
  //   // {double width = 1920, double height = 1080}
  // ) async {
  //   try {
  //     // Create a new RenderRepaintBoundary with the specified width and height
  //     final boundary =
  //         key.currentContext!.findRenderObject() as RenderRepaintBoundary;

  //     // Create a new image with the specified width and height
  //     final image = await boundary.toImage(pixelRatio: 3.0);
  //     ByteData? byteData =
  //         await image.toByteData(format: ui.ImageByteFormat.png);
  //     pngBytes = byteData!.buffer.asUint8List();

  //     // Create a new image with the specified dimensions
  //     final recorder = ui.PictureRecorder();
  //     final canvas = Canvas(
  //         recorder, Rect.fromPoints(const Offset(0, 0), Offset(width, height)));

  //     // Draw the original image onto the canvas with the specified dimensions
  //     canvas.drawImageRect(
  //       image,
  //       Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
  //       Rect.fromLTWH(0, 0, width, height),
  //       Paint(),
  //     );

  //     // End the recording and convert to image
  //     final newImage =
  //         await recorder.endRecording().toImage(width.toInt(), height.toInt());
  //     ByteData? newByteData =
  //         await newImage.toByteData(format: ui.ImageByteFormat.png);
  //     pngBytes = newByteData!.buffer.asUint8List();

  //     String fileName = '${DateTime.now().millisecondsSinceEpoch}.png';

  //     var blob = html.Blob([pngBytes]);
  //     var url = html.Url.createObjectUrlFromBlob(blob);
  //     html.AnchorElement(href: url)
  //       ..setAttribute("download", fileName)
  //       ..click();
  //   } catch (e) {
  //     print("-------- Save Image Error ------- $e");
  //   }
  // }

  @override
  void initState() {
    super.initState();
    widthController.text = width.toString();
    heightController.text = height.toString();
    searchTemplate("");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: GestureDetector(
        onTap: () {
          editController.isImageShow.value = false;
          editController.show.value = false;
        },
        child: ScreenTypeLayout.builder(
          mobile: (BuildContext context) => mobileLayout(),
          tablet: (BuildContext context) => tabletLayout(),
          desktop: (BuildContext context) => desktopLayout(),
        ),
      ),
    );
  }

  desktopLayout() {
    return WillPopScope(
      onWillPop: () async {
        editController.selectedFontFamily.value = "Poppins";
        editController.selectedFontSize.value = 16.0;
        editController.isColorIconTap.value = false;
        editController.textBlackColor.value = blackColor;
        editController.isBoldIconTap.value = false;
        editController.fontWeight.value = FontWeight.normal;
        editController.isTextItalicIconTap.value = false;
        editController.fontStyle.value = FontStyle.normal;
        editController.isTextUnderLineIconTap.value = false;
        editController.textDecoration.value = TextDecoration.none;
        editController.filterContainerColor.value = transparentColor;
        editController.logoIndex.value = 1;
        imageBytes = null;
        editController.isEditIconTap.value = false;
        textItems.clear();
        editController.pickLogos.clear();
        selectedIndexPostWeb.value = null;
        editController.checkBoxValue.value = false;
        editController.forgroundStrokeColor.value = blackColor;
        editController.backgroundStrokeColor.value = blackColor;
        editController.selectedStrokeWidth.value = 1.0;
        return true;
      },
      child: SingleChildScrollView(
        child: Column(
          children: [
            topHader(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    allFeture(),
                    isDrawerIconTap
                        ? Container(
                            margin: const EdgeInsets.only(left: 10),
                            height: MediaQuery.of(context).size.height - 130,
                            width: 400,
                            decoration: BoxDecoration(
                              color: whiteColor,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 5,
                                  color: blackColor.withOpacity(0.4),
                                ),
                              ],
                            ),
                            child: isDrawerIconTap && functionTap == -1
                                ? allPosterCardShow()
                                : functionTap == 0
                                    ? filterFeture()
                                    : functionTap == 1
                                        ? textFeture()
                                        : functionTap == 2
                                            ? cropFeture()
                                            : functionTap == 3
                                                ? contrastFeture()
                                                : functionTap == 4
                                                    ? rotateFeture()
                                                    : functionTap == 5
                                                        ? sizeFeture()
                                                        : logoFeture(),
                          )
                        : Container(),
                    InkWell(
                      hoverColor: transparentColor,
                      splashColor: transparentColor,
                      highlightColor: transparentColor,
                      onTap: () {
                        setState(() {
                          isDrawerIconTap = !isDrawerIconTap;
                          functionTap = -1;
                        });
                      },
                      child: Container(
                        height: 100,
                        width: 15,
                        decoration: const BoxDecoration(
                          color: kPrimeryColor,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(8),
                            bottomRight: Radius.circular(8),
                          ),
                        ),
                        child: const Icon(
                          Icons.arrow_forward_ios,
                          color: whiteColor,
                          size: 15,
                        ),
                      ),
                    ),
                  ],
                ),
                imageShow(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  tabletLayout() {
    return WillPopScope(
      onWillPop: () async {
        editController.selectedFontFamily.value = "Poppins";
        editController.selectedFontSize.value = 16.0;
        editController.isColorIconTap.value = false;
        editController.textBlackColor.value = blackColor;
        editController.isBoldIconTap.value = false;
        editController.fontWeight.value = FontWeight.normal;
        editController.isTextItalicIconTap.value = false;
        editController.fontStyle.value = FontStyle.normal;
        editController.isTextUnderLineIconTap.value = false;
        editController.textDecoration.value = TextDecoration.none;
        editController.filterContainerColor.value = transparentColor;
        editController.logoIndex.value = 1;
        imageBytes = null;
        textItems.clear();
        editController.pickLogos.clear();
        selectedIndexPostWeb.value = null;
        editController.checkBoxValue.value = false;
        editController.forgroundStrokeColor.value = blackColor;
        editController.backgroundStrokeColor.value = blackColor;
        editController.selectedStrokeWidth.value = 1.0;
        return true;
      },
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Column(
            children: [
              topHader(),
              const SizedBox(
                height: 20,
              ),
              imageShow(),
              const SizedBox(
                height: 20,
              ),
              functionTap != -1
                  ? Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          height: 200,
                          width: double.infinity,
                          child: Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 20, right: 50, left: 50, bottom: 20),
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: whiteColor,
                                    borderRadius: BorderRadius.circular(5),
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 5,
                                        color: blackColor.withOpacity(0.2),
                                      ),
                                    ],
                                  ),
                                  child: functionTap == 0
                                      ? filterFeture()
                                      : functionTap == 1
                                          ? textFeture()
                                          : functionTap == 2
                                              ? cropFeture()
                                              : functionTap == 3
                                                  ? contrastFeture()
                                                  : functionTap == 4
                                                      ? rotateFeture()
                                                      : functionTap == 5
                                                          ? sizeFeture()
                                                          : logoFeture(),
                                ),
                              ),
                              Positioned(
                                top: 5,
                                right: 35,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      functionTap = -1;
                                    });
                                  },
                                  child: Container(
                                    height: 30,
                                    width: 30,
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
                      ],
                    )
                  : Container(),
            ],
          ),
          functionTap == -1 ? allFeture() : Container(),
        ],
      ),
    );
  }

  mobileLayout() {
    return WillPopScope(
      onWillPop: () async {
        editController.selectedFontFamily.value = "Poppins";
        editController.selectedFontSize.value = 16.0;
        editController.isColorIconTap.value = false;
        editController.textBlackColor.value = blackColor;
        editController.isBoldIconTap.value = false;
        editController.fontWeight.value = FontWeight.normal;
        editController.isTextItalicIconTap.value = false;
        editController.fontStyle.value = FontStyle.normal;
        editController.isTextUnderLineIconTap.value = false;
        editController.textDecoration.value = TextDecoration.none;
        editController.filterContainerColor.value = transparentColor;
        editController.logoIndex.value = 1;
        imageBytes = null;
        textItems.clear();
        editController.pickLogos.clear();
        selectedIndexPostWeb.value = null;
        editController.checkBoxValue.value = false;
        editController.forgroundStrokeColor.value = blackColor;
        editController.backgroundStrokeColor.value = blackColor;
        editController.selectedStrokeWidth.value = 1.0;
        return true;
      },
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Column(
            children: [
              topHader(),
              const SizedBox(
                height: 20,
              ),
              imageShow(),
              const SizedBox(
                height: 20,
              ),
              functionTap != -1
                  ? Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          height: 200,
                          width: double.infinity,
                          child: Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 20, right: 20, left: 20, bottom: 20),
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: whiteColor,
                                    borderRadius: BorderRadius.circular(5),
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 5,
                                        color: blackColor.withOpacity(0.2),
                                      ),
                                    ],
                                  ),
                                  child: functionTap == 0
                                      ? filterFeture()
                                      : functionTap == 1
                                          ? textFeture()
                                          : functionTap == 2
                                              ? cropFeture()
                                              : functionTap == 3
                                                  ? contrastFeture()
                                                  : functionTap == 4
                                                      ? rotateFeture()
                                                      : functionTap == 5
                                                          ? sizeFeture()
                                                          : logoFeture(),
                                ),
                              ),
                              Positioned(
                                top: 5,
                                right: 5,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      functionTap = -1;
                                    });
                                  },
                                  child: Container(
                                    height: 30,
                                    width: 30,
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
                      ],
                    )
                  : Container(),
            ],
          ),
          functionTap == -1 ? allFeture() : Container(),
        ],
      ),
    );
  }

  Widget topHader() {
    var w = MediaQuery.of(context).size.width;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 25),
      width: double.infinity,
      color: kPrimeryColor,
      child: Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: w > 600 ? 50 : 15),
          width: double.infinity,
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            children: [
              Wrap(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      setState(() {
                        editController.selectedFontFamily.value = "Poppins";
                        editController.selectedFontSize.value = 16.0;
                        editController.isColorIconTap.value = false;
                        editController.textBlackColor.value = blackColor;
                        editController.isBoldIconTap.value = false;
                        editController.fontWeight.value = FontWeight.normal;
                        editController.isTextItalicIconTap.value = false;
                        editController.fontStyle.value = FontStyle.normal;
                        editController.isTextUnderLineIconTap.value = false;
                        editController.textDecoration.value =
                            TextDecoration.none;
                        editController.filterContainerColor.value =
                            transparentColor;
                        editController.logoIndex.value = 1;
                        imageBytes = null;
                        editController.isEditIconTap.value = false;
                        textItems.clear();
                        editController.pickLogos.clear();
                        selectedIndexPostWeb.value = null;
                        editController.checkBoxValue.value = false;
                        editController.forgroundStrokeColor.value = blackColor;
                        editController.backgroundStrokeColor.value = blackColor;
                        editController.selectedStrokeWidth.value = 1.0;
                      });
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: whiteColor,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: w > 600 ? 5 : 10, right: w > 600 ? 20 : 15),
                    child: Text(
                      festivalPoster,
                      style: GoogleFonts.poppins(
                        fontSize: w > 600 ? 20 : 14,
                        fontWeight: FontWeight.w600,
                        color: whiteColor,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ],
              ),
              Wrap(
                children: [
                  InkWell(
                    splashColor: transparentColor,
                    hoverColor: transparentColor,
                    highlightColor: transparentColor,
                    onTap: () {
                      shareImage(globalKey);
                    },
                    child: Container(
                      height: w > 670
                          ? 50
                          : w > 600
                              ? 50
                              : 35,
                      width: w > 670
                          ? 150
                          : w > 600
                              ? 50
                              : 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        border: Border.all(
                            color: whiteColor, width: w > 670 ? 2 : 1),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.share,
                            color: whiteColor,
                            size: w > 670 ? null : 18,
                          ),
                          SizedBox(
                            width: w > 670 ? 15 : 0,
                          ),
                          w > 670
                              ? Text(
                                  share,
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: whiteColor,
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  InkWell(
                    splashColor: transparentColor,
                    hoverColor: transparentColor,
                    highlightColor: const ui.Color.fromRGBO(0, 0, 0, 0),
                    onTap: () {
                      // await saveImage(globalKey, width: 1920, height: 1080);
                      saveImage(
                        globalKey,
                        // width: MediaQuery.of(context).size.width,
                        // height: MediaQuery.of(context).size.height,
                        // width: 1920,
                        // height: 1080,
                        // width: width,
                        // height: height,
                      );
                    },
                    child: Container(
                      height: w > 670
                          ? 50
                          : w > 600
                              ? 50
                              : 35,
                      width: w > 670
                          ? 150
                          : w > 600
                              ? 50
                              : 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: w > 670 ? whiteColor : transparentColor,
                        border: w > 670
                            ? null
                            : Border.all(
                                color: whiteColor, width: w > 670 ? 2 : 1),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ImageIcon(
                            const AssetImage(
                                "assets/webImages/downloadIconWeb.png"),
                            color: w > 670 ? kPrimeryColor : whiteColor,
                            size: w > 670 ? null : 18,
                          ),
                          SizedBox(
                            width: w > 670 ? 15 : 0,
                          ),
                          w > 670
                              ? Text(
                                  "Download",
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
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget allFeture() {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        margin: EdgeInsets.symmetric(
          horizontal: constraints.maxWidth > 949
              ? 0
              : constraints.maxWidth > 600
                  ? 80
                  : 20,
          vertical: constraints.maxWidth > 949 ? 0 : 20,
        ),
        height: constraints.maxWidth > 949
            ? MediaQuery.of(context).size.height - 100
            : constraints.maxWidth > 600
                ? 75
                : 65,
        width: constraints.maxWidth > 949 ? 100 : double.infinity,
        color: kPrimeryColor,
        child: constraints.maxWidth < 950 && constraints.maxWidth > 600
            ? SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(
                      editController.functionList.length,
                      (index) {
                        return InkWell(
                          hoverColor: transparentColor,
                          splashColor: transparentColor,
                          highlightColor: transparentColor,
                          onTap: () {
                            setState(() {
                              functionTap = index;
                              isDrawerIconTap = true;
                            });
                          },
                          child: Container(
                            height: 100,
                            width: 85,
                            color: functionTap == index
                                ? whiteColor
                                : kPrimeryColor,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  editController.functionList[index]["image"],
                                  scale: constraints.maxWidth > 949 ? 5.5 : 7,
                                  color: functionTap == index
                                      ? kPrimeryColor
                                      : whiteColor,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  editController.functionList[index]["size"],
                                  style: GoogleFonts.poppins(
                                    fontSize:
                                        constraints.maxWidth > 949 ? 14 : 12,
                                    fontWeight: FontWeight.w500,
                                    color: functionTap == index
                                        ? kPrimeryColor
                                        : whiteColor,
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
            : ListView.builder(
                scrollDirection: constraints.maxWidth > 949
                    ? Axis.vertical
                    : Axis.horizontal,
                shrinkWrap: true,
                itemCount: editController.functionList.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    hoverColor: transparentColor,
                    splashColor: transparentColor,
                    highlightColor: transparentColor,
                    onTap: () {
                      setState(() {
                        functionTap = index;
                        isDrawerIconTap = true;
                      });
                    },
                    child: Container(
                      height: 100,
                      width: 85,
                      color: functionTap == index ? whiteColor : kPrimeryColor,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            editController.functionList[index]["image"],
                            scale: constraints.maxWidth > 949 ? 5.5 : 7,
                            color: functionTap == index
                                ? kPrimeryColor
                                : whiteColor,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            editController.functionList[index]["size"],
                            style: GoogleFonts.poppins(
                              fontSize: constraints.maxWidth > 949 ? 14 : 12,
                              fontWeight: FontWeight.w500,
                              color: functionTap == index
                                  ? kPrimeryColor
                                  : whiteColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      );
    });
  }

  Widget imageShow() {
    var w = MediaQuery.of(context).size.width;
    return Expanded(
      child: Center(
        child: SingleChildScrollView(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              margin: EdgeInsets.only(
                left: w > 315 ? 0 : 20,
                right: w > 315 ? 0 : 20,
                bottom: w > 949
                    ? 0
                    : w > 600
                        ? functionTap != -1
                            ? 0
                            : 50
                        : functionTap != -1
                            ? 0
                            : 100,
                // top: w > 949 ? 20 : 0,
              ),
              child: RepaintBoundary(
                key: globalKey,
                child: ColorFiltered(
                  colorFilter: ColorFilter.matrix(
                    contrastMatrix(constrastValue),
                  ),
                  child: ColorFiltered(
                    colorFilter: ColorFilter.matrix(
                      highlightMatrix(highlightValue),
                    ),
                    child: Transform.rotate(
                      angle: rotateAngle,
                      child: Stack(
                        children: [
                          Container(
                            height: w > 949
                                ? height
                                // ? h - 120
                                : w > 600
                                    ? tabletHeight
                                    : mobileHeight,
                            width: w > 949
                                ? width - 1
                                // ? w - 150
                                // ? w - 601
                                // ? width
                                : w > 600
                                    ? tabletWidth
                                    : mobileWidth,
                            decoration: const BoxDecoration(
                              color: blackColor,
                            ),
                            child: InteractiveViewer(
                              transformationController:
                                  transformationController,
                              // minScale: 0.5,
                              minScale: 0.1,
                              maxScale: 4.0,
                              boundaryMargin:
                                  const EdgeInsets.all(double.infinity),
                              child: AspectRatio(
                                aspectRatio: 1.0,
                                child: imageBytes != null
                                    ? Image.memory(
                                        imageBytes!,
                                        // fit: BoxFit.cover,
                                        fit: BoxFit.contain,
                                      )
                                    : Container(),
                              ),
                            ),
                          ),
                          functionTap == 2
                              ? Container()
                              : IgnorePointer(
                                  child: SizedBox(
                                    height: w > 949
                                        ? height
                                        // ? h - 120
                                        : w > 600
                                            ? tabletHeight
                                            : mobileHeight,
                                    width: w > 949
                                        ? width
                                        // ? w - 150
                                        // ? w - 600
                                        // ? width
                                        : w > 600
                                            ? tabletWidth
                                            : mobileWidth,
                                    child: isCropDoneIconTap == true &&
                                            imageCrop != null
                                        ? Image(
                                            image: imageCrop!.image,
                                            fit: BoxFit.fill,
                                          )
                                        : Image.asset(
                                            selectedImagePath ??
                                                widget.wallPaper,
                                            // "assets/webImages/Christmas2Web.png",
                                            fit: BoxFit.fill,
                                            // fit: BoxFit.cover,
                                          ),
                                  ),
                                ),
                          IgnorePointer(
                            child: Obx(
                              () => Container(
                                height: w > 949
                                    ? height
                                    // ? h - 120
                                    : w > 600
                                        ? tabletHeight
                                        : mobileHeight,
                                width: w > 949
                                    ? width
                                    // ? w - 150
                                    // ? w - 600
                                    // ? width
                                    : w > 600
                                        ? tabletWidth
                                        : mobileWidth,
                                color:
                                    editController.filterContainerColor.value,
                              ),
                            ),
                          ),
                          imageBytes != null
                              // ? ImageWidget(
                              //     image: pickLogoBytes,
                              //     onRemove: () {
                              //       setState(() {
                              //         pickLogoBytes = null;
                              //       });
                              //     },
                              //     index: 0,
                              //   )
                              ? Obx(
                                  () => SizedBox(
                                    height: w > 949
                                        ? height
                                        : w > 600
                                            ? tabletHeight
                                            : mobileHeight,
                                    width: w > 949
                                        ? width
                                        : w > 600
                                            ? tabletWidth
                                            : mobileWidth,
                                    child: Stack(
                                      children: List.generate(
                                        editController.pickLogos.length,
                                        (index) {
                                          return ImageWidget(
                                            image: editController
                                                .pickLogos[index]["image"],
                                            onRemove: () {
                                              editController.pickLogos
                                                  .removeAt(index);
                                              editController.isImageShow.value =
                                                  false;
                                              editController
                                                  .isLogoImageTap.value = false;
                                            },
                                            index: index,
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                )
                              : Container(),
                          ...textItems.map(
                            (item) {
                              int index = textItems.indexOf(item);
                              return TextWidget(
                                key: item.parentKey,
                                item: item,
                                onRemove: () {
                                  setState(() {
                                    textItems.remove(item);
                                  });
                                },
                                onEdit: () {
                                  // editTextItem(index);
                                  selectedItem = item;
                                  selectedIndexPostWeb.value = index;
                                  textController.text = item.text;
                                  editController.isEditIconTap.value = true;
                                  editController.textBlackColor.value =
                                      item.textColor;
                                  editController.selectedFontSize.value =
                                      item.fontSize;
                                  editController.fontWeight.value =
                                      item.fontWeight;
                                  editController.fontWeight.value ==
                                          ui.FontWeight.bold
                                      ? editController.isBoldIconTap.value =
                                          true
                                      : editController.isBoldIconTap.value =
                                          false;
                                  editController.textDecoration.value =
                                      item.textDecoration;
                                  editController.textDecoration.value ==
                                          TextDecoration.underline
                                      ? editController
                                          .isTextUnderLineIconTap.value = true
                                      : editController
                                          .isTextUnderLineIconTap.value = false;
                                  editController.fontStyle.value =
                                      item.fontStyle;
                                  editController.fontStyle.value ==
                                          ui.FontStyle.italic
                                      ? editController
                                          .isTextItalicIconTap.value = true
                                      : editController
                                          .isTextItalicIconTap.value = false;
                                  editController.selectedTitle.value =
                                      item.selectTitle;
                                  editController.selectedFontFamily.value =
                                      item.fontFamily;
                                  editController.selectedStrokeWidth.value =
                                      item.strokeWidth;
                                  editController.forgroundStrokeColor.value =
                                      item.forgroundColor;
                                  editController.backgroundStrokeColor.value =
                                      item.backgroundColor;
                                  editController.checkBoxValue.value =
                                      item.isStrokeCheck;
                                  setState(() {});
                                },
                                index: index,
                              );
                            },
                          ),
                          functionTap == 2 ? cropImage() : Container(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget allPosterCardShow() {
    var w = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(left: 30, top: 30),
              child: seeMoreIndex == 0 || seeMoreIndex == 1 || seeMoreIndex == 2
                  ? IconButton(
                      onPressed: () {
                        setState(() {
                          seeMoreIndex = null;
                        });
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        color: kPrimeryColor,
                      ),
                    )
                  : Text(
                      all,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: kPrimeryColor,
                      ),
                    ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              height: 50,
              width: 360,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                border: Border.all(
                  color: const Color(0xffd0d0d0),
                  width: 1.5,
                ),
                color: const Color(0xfff0f0f0),
              ),
              child: Center(
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: Image.asset(
                        "assets/webImages/searchIconWeb.png",
                        scale: 5,
                      ),
                    ),
                    hintText: "Find More Business Cards And Templates",
                    hintStyle: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xffa6a4a4),
                    ),
                    contentPadding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                  ),
                  cursorColor: kPrimeryColor,
                  onChanged: (value) {
                    searchTemplate(value);
                    setState(() {});
                  },
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                searchController.text != ""
                    ? GridView.count(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 3,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        children: List.generate(
                          dataList.length,
                          (index) {
                            return InkWell(
                              hoverColor: transparentColor,
                              highlightColor: transparentColor,
                              splashColor: transparentColor,
                              onTap: () {
                                setState(() {
                                  selectedImagePosterPath =
                                      dataList[index]["image"];
                                  selectedImagePath =
                                      dataList[index]["image_2"];
                                  isCropDoneIconTap = false;
                                });
                              },
                              child: Container(
                                width: w / 3 - 20,
                                height: w / 3 - 20,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Image.asset(
                                  dataList[index]["image"],
                                  fit: BoxFit.fill,
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    : Column(
                        children: [
                          seeMoreIndex == 1 || seeMoreIndex == 2
                              ? Container()
                              : rowTextWeb(patrioticDay,
                                  seeMoreIndex == 0 ? "" : "See More", () {
                                  setState(() {
                                    seeMoreIndex = 0;
                                  });
                                }),
                          SizedBox(
                            height:
                                seeMoreIndex == 1 || seeMoreIndex == 2 ? 0 : 20,
                          ),
                          seeMoreIndex == 1 || seeMoreIndex == 2
                              ? Container()
                              : seeMoreIndex == 0
                                  ? GridView.builder(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10),
                                      shrinkWrap: true,
                                      itemCount: patrioticDayList.length,
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        crossAxisSpacing: 10,
                                        mainAxisSpacing: 15,
                                      ),
                                      itemBuilder: (context, index) {
                                        return InkWell(
                                          hoverColor: transparentColor,
                                          highlightColor: transparentColor,
                                          splashColor: transparentColor,
                                          onTap: () {
                                            setState(() {
                                              selectedImagePosterPath =
                                                  patrioticDayList[index]
                                                      ["image"];
                                              selectedImagePath =
                                                  patrioticDayList[index]
                                                      ["image_2"];
                                              isCropDoneIconTap = false;
                                            });
                                          },
                                          child: SizedBox(
                                            // margin: const EdgeInsets.only(
                                            //     right: 20),
                                            height: 130,
                                            width: 130,
                                            child: Image.asset(
                                              patrioticDayList[index]["image"],
                                            ),
                                          ),
                                        );
                                      },
                                    )
                                  : SizedBox(
                                      height: 150,
                                      width: 400,
                                      child: ScrollConfiguration(
                                        behavior: WebScrollBehavior(),
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          padding:
                                              const EdgeInsets.only(left: 10),
                                          scrollDirection: Axis.horizontal,
                                          itemCount: patrioticDayList.length,
                                          itemBuilder: (context, index) {
                                            return InkWell(
                                              hoverColor: transparentColor,
                                              highlightColor: transparentColor,
                                              splashColor: transparentColor,
                                              onTap: () {
                                                setState(() {
                                                  selectedImagePosterPath =
                                                      patrioticDayList[index]
                                                          ["image"];
                                                  selectedImagePath =
                                                      patrioticDayList[index]
                                                          ["image_2"];
                                                  isCropDoneIconTap = false;
                                                });
                                              },
                                              child: Container(
                                                margin: const EdgeInsets.only(
                                                    right: 20),
                                                height: 130,
                                                width: 130,
                                                child: Image.asset(
                                                  patrioticDayList[index]
                                                      ["image"],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                          SizedBox(
                            height: seeMoreIndex == 0 ||
                                    seeMoreIndex == 1 ||
                                    seeMoreIndex == 2
                                ? 0
                                : 40,
                          ),
                          seeMoreIndex == 0 || seeMoreIndex == 2
                              ? Container()
                              : rowTextWeb(festivalDay,
                                  seeMoreIndex == 1 ? "" : "See More", () {
                                  setState(() {
                                    seeMoreIndex = 1;
                                  });
                                }),
                          SizedBox(
                            height:
                                seeMoreIndex == 0 || seeMoreIndex == 2 ? 0 : 20,
                          ),
                          seeMoreIndex == 0 || seeMoreIndex == 2
                              ? Container()
                              : seeMoreIndex == 1
                                  ? GridView.builder(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10),
                                      shrinkWrap: true,
                                      itemCount: festivalsEventList.length,
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        crossAxisSpacing: 10,
                                        mainAxisSpacing: 15,
                                      ),
                                      itemBuilder: (context, index) {
                                        return InkWell(
                                          hoverColor: transparentColor,
                                          highlightColor: transparentColor,
                                          splashColor: transparentColor,
                                          onTap: () {
                                            setState(() {
                                              selectedImagePosterPath =
                                                  festivalsEventList[index]
                                                      ["image"];
                                              selectedImagePath =
                                                  festivalsEventList[index]
                                                      ["image_2"];
                                              isCropDoneIconTap = false;
                                            });
                                          },
                                          child: SizedBox(
                                            // margin: const EdgeInsets.only(
                                            //     right: 20),
                                            height: 130,
                                            width: 130,
                                            child: Image.asset(
                                              festivalsEventList[index]
                                                  ["image"],
                                            ),
                                          ),
                                        );
                                      },
                                    )
                                  : SizedBox(
                                      height: 150,
                                      width: 400,
                                      child: ScrollConfiguration(
                                        behavior: WebScrollBehavior(),
                                        child: ListView.builder(
                                          padding:
                                              const EdgeInsets.only(left: 10),
                                          scrollDirection: Axis.horizontal,
                                          itemCount: festivalsEventList.length,
                                          itemBuilder: (context, index) {
                                            return InkWell(
                                              hoverColor: transparentColor,
                                              highlightColor: transparentColor,
                                              splashColor: transparentColor,
                                              onTap: () {
                                                setState(() {
                                                  selectedImagePosterPath =
                                                      festivalsEventList[index]
                                                          ["image"];
                                                  selectedImagePath =
                                                      festivalsEventList[index]
                                                          ["image_2"];
                                                  isCropDoneIconTap = false;
                                                });
                                              },
                                              child: Container(
                                                margin: const EdgeInsets.only(
                                                    right: 20),
                                                height: 130,
                                                width: 130,
                                                child: Image.asset(
                                                  festivalsEventList[index]
                                                      ["image"],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                          // SizedBox(
                          //   height: seeMoreIndex == 2 ? 0 : 40,
                          //   // height: 0,
                          // ),
                          SizedBox(
                            height: seeMoreIndex == 0 ||
                                    seeMoreIndex == 1 ||
                                    seeMoreIndex == 2
                                ? 0
                                : 40,
                          ),
                          seeMoreIndex == 0 || seeMoreIndex == 1
                              ? Container()
                              : rowTextWeb(specialDay,
                                  seeMoreIndex == 2 ? "" : "See More", () {
                                  setState(() {
                                    seeMoreIndex = 2;
                                  });
                                }),
                          const SizedBox(
                            height: 20,
                          ),
                          seeMoreIndex == 0 || seeMoreIndex == 1
                              ? Container()
                              : seeMoreIndex == 2
                                  ? GridView.builder(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10),
                                      shrinkWrap: true,
                                      itemCount: specialDaysList.length,
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        crossAxisSpacing: 10,
                                        mainAxisSpacing: 15,
                                      ),
                                      itemBuilder: (context, index) {
                                        return InkWell(
                                          hoverColor: transparentColor,
                                          highlightColor: transparentColor,
                                          splashColor: transparentColor,
                                          onTap: () {
                                            setState(() {
                                              selectedImagePosterPath =
                                                  specialDaysList[index]
                                                      ["image"];
                                              selectedImagePath =
                                                  specialDaysList[index]
                                                      ["image_2"];
                                              isCropDoneIconTap = false;
                                            });
                                          },
                                          child: SizedBox(
                                            // margin: const EdgeInsets.only(
                                            //     right: 20),
                                            height: 130,
                                            width: 130,
                                            child: Image.asset(
                                              specialDaysList[index]["image"],
                                            ),
                                          ),
                                        );
                                      },
                                    )
                                  : SizedBox(
                                      height: 150,
                                      width: 400,
                                      child: ScrollConfiguration(
                                        behavior: WebScrollBehavior(),
                                        child: ListView.builder(
                                          padding:
                                              const EdgeInsets.only(left: 10),
                                          scrollDirection: Axis.horizontal,
                                          itemCount: specialDaysList.length,
                                          itemBuilder: (context, index) {
                                            return InkWell(
                                              hoverColor: transparentColor,
                                              highlightColor: transparentColor,
                                              splashColor: transparentColor,
                                              onTap: () {
                                                setState(() {
                                                  selectedImagePosterPath =
                                                      specialDaysList[index]
                                                          ["image"];
                                                  selectedImagePath =
                                                      specialDaysList[index]
                                                          ["image_2"];
                                                  isCropDoneIconTap = false;
                                                });
                                              },
                                              child: Container(
                                                margin: const EdgeInsets.only(
                                                    right: 20),
                                                height: 130,
                                                width: 130,
                                                child: Image.asset(
                                                  specialDaysList[index]
                                                      ["image"],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                          const SizedBox(
                            height: 40,
                          ),
                        ],
                      ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget filterFeture() {
    var w = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        w > 949
            ? Container(
                margin: const EdgeInsets.only(left: 20, top: 30),
                child: Text(
                  filters,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: kPrimeryColor,
                  ),
                ),
              )
            : Container(),
        SizedBox(
          height: w > 949 ? 30 : 15,
        ),
        w > 949
            ? Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Center(
                          child: SizedBox(
                        width: 350,
                        child: GridView(
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.875,
                          ),
                          children: [
                            filterWidget(
                                Colors.transparent,
                                normal,
                                selectedImagePosterPath ?? widget.image,
                                140,
                                140),
                            filterWidget(
                                blackColor.withOpacity(0.4),
                                lofi,
                                selectedImagePosterPath ?? widget.image,
                                140,
                                140),
                            filterWidget(
                                const Color(0xffEDEDED).withOpacity(0.2),
                                inkwell,
                                selectedImagePosterPath ?? widget.image,
                                140,
                                140),
                            filterWidget(
                                const Color(0xffFED914).withOpacity(0.18),
                                warm,
                                selectedImagePosterPath ?? widget.image,
                                140,
                                140),
                            filterWidget(
                                const Color(0xff9F2860).withOpacity(0.42),
                                pop,
                                selectedImagePosterPath ?? widget.image,
                                140,
                                140),
                            filterWidget(
                                const Color(0xff5DE147).withOpacity(0.2),
                                nature,
                                selectedImagePosterPath ?? widget.image,
                                140,
                                140),
                            filterWidget(
                                blackColor.withOpacity(0.58),
                                bandW,
                                selectedImagePosterPath ?? widget.image,
                                140,
                                140),
                            filterWidget(
                                const Color(0xff00A3FF).withOpacity(0.5),
                                icy,
                                selectedImagePosterPath ?? widget.image,
                                140,
                                140),
                            filterWidget(
                                const Color(0xffD49029).withOpacity(0.2),
                                ludwig,
                                selectedImagePosterPath ?? widget.image,
                                140,
                                140),
                            filterWidget(
                                const Color(0xff0066FF).withOpacity(0.2),
                                ocean,
                                selectedImagePosterPath ?? widget.image,
                                140,
                                140),
                          ],
                        ),
                      )),
                    ],
                  ),
                ),
              )
            : Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Center(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 150,
                          child: ListView(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            children: [
                              filterWidget(Colors.transparent, normal,
                                  widget.image, 80, 80),
                              filterWidget(blackColor.withOpacity(0.4), lofi,
                                  widget.image, 80, 80),
                              filterWidget(
                                  const Color(0xffEDEDED).withOpacity(0.2),
                                  inkwell,
                                  widget.image,
                                  80,
                                  80),
                              filterWidget(
                                  const Color(0xffFED914).withOpacity(0.18),
                                  warm,
                                  widget.image,
                                  80,
                                  80),
                              filterWidget(
                                  const Color(0xff9F2860).withOpacity(0.42),
                                  pop,
                                  widget.image,
                                  80,
                                  80),
                              filterWidget(
                                  const Color(0xff5DE147).withOpacity(0.2),
                                  nature,
                                  widget.image,
                                  80,
                                  80),
                              filterWidget(blackColor.withOpacity(0.58), bandW,
                                  widget.image, 80, 80),
                              filterWidget(
                                  const Color(0xff00A3FF).withOpacity(0.5),
                                  icy,
                                  widget.image,
                                  80,
                                  80),
                              filterWidget(
                                  const Color(0xffD49029).withOpacity(0.2),
                                  ludwig,
                                  widget.image,
                                  80,
                                  80),
                              filterWidget(
                                  const Color(0xff0066FF).withOpacity(0.2),
                                  ocean,
                                  widget.image,
                                  80,
                                  80),
                            ],
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

  Widget textFeture() {
    var w = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        w > 949
            ? Container(
                margin: const EdgeInsets.only(left: 20, top: 30),
                child: Text(
                  "Text",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: kPrimeryColor,
                  ),
                ),
              )
            : Container(),
        SizedBox(
          height: w > 600 ? 20 : 10,
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                    hoverColor: transparentColor,
                    splashColor: transparentColor,
                    highlightColor: transparentColor,
                    onTap: () {
                      setState(() {
                        isAddTextTap = true;
                        // if (textController.text.isNotEmpty) {
                        //   setState(() {
                        //     textItems.add(
                        //       Item(
                        //         parentKey: GlobalKey(),
                        //         size: const Size(100, 100),
                        //         offset: const Offset(100, 100),
                        //         rotation: 0,
                        //         text: textController.text,
                        //         textColor: editController.textBlackColor.value,
                        //         fontSize: editController.selectedFontSize.value,
                        //         fontWeight: editController.fontWeight.value,
                        //         textDecoration:
                        //             editController.textDecoration.value,
                        //         fontStyle: editController.fontStyle.value,
                        //         selectTitle: "",
                        //         fontFamily:
                        //             editController.selectedFontFamily.value,
                        //       ),
                        //     );

                        // editController.selectedFontFamily.value = "Poppins";
                        // editController.selectedFontSize.value = 16.0;
                        // editController.isColorIconTap.value = false;
                        // editController.textBlackColor.value = blackColor;
                        // editController.isBoldIconTap.value = false;
                        // editController.fontWeight.value = FontWeight.normal;
                        // editController.isTextItalicIconTap.value = false;
                        // editController.fontStyle.value = FontStyle.normal;
                        // editController.isTextUnderLineIconTap.value = false;
                        // editController.textDecoration.value =
                        //     TextDecoration.none;

                        // textController.clear();
                        //   });
                        // }

                        editController.isTextTap.value == true
                            ? {
                                editController.isTextTap.value = false,
                                editController.isEditIconTap.value == true
                                    ? textItems[selectedIndexPostWeb.value!] =
                                        Item(
                                        parentKey: selectedItem!.parentKey,
                                        size: selectedItem!.size,
                                        offset: selectedItem!.offset,
                                        rotation: selectedItem!.rotation,
                                        text: textController.text,
                                        textColor:
                                            editController.textBlackColor.value,
                                        fontSize: editController
                                            .selectedFontSize.value,
                                        fontWeight:
                                            editController.fontWeight.value,
                                        textDecoration:
                                            editController.textDecoration.value,
                                        fontStyle:
                                            editController.fontStyle.value,
                                        selectTitle:
                                            editController.selectedTitle.value,
                                        fontFamily: editController
                                            .selectedFontFamily.value,
                                        isStrokeCheck:
                                            editController.checkBoxValue.value,
                                        strokeWidth: editController
                                            .selectedStrokeWidth.value,
                                        forgroundColor: editController
                                            .forgroundStrokeColor.value,
                                        backgroundColor: editController
                                            .backgroundStrokeColor.value,
                                      )
                                    : textItems.add(
                                        Item(
                                          parentKey: GlobalKey(),
                                          size: const Size(100, 100),
                                          offset: const Offset(100, 100),
                                          rotation: 0,
                                          text: textController.text,
                                          textColor: editController
                                              .textBlackColor.value,
                                          fontSize: editController
                                              .selectedFontSize.value,
                                          fontWeight:
                                              editController.fontWeight.value,
                                          textDecoration: editController
                                              .textDecoration.value,
                                          fontStyle:
                                              editController.fontStyle.value,
                                          selectTitle: editController
                                              .selectedTitle.value,
                                          fontFamily: editController
                                              .selectedFontFamily.value,
                                          isStrokeCheck: editController
                                              .checkBoxValue.value,
                                          strokeWidth: editController
                                              .selectedStrokeWidth.value,
                                          forgroundColor: editController
                                              .forgroundStrokeColor.value,
                                          backgroundColor: editController
                                              .backgroundStrokeColor.value,
                                        ),
                                      ),
                                // textController.text = "",
                                editController.selectedFontFamily.value =
                                    "Poppins",
                                editController.selectedFontSize.value = 16.0,
                                editController.isColorIconTap.value = false,
                                editController.textBlackColor.value =
                                    blackColor,
                                editController.isBoldIconTap.value = false,
                                editController.fontWeight.value =
                                    FontWeight.normal,
                                editController.isTextItalicIconTap.value =
                                    false,
                                editController.fontStyle.value =
                                    FontStyle.normal,
                                editController.isTextUnderLineIconTap.value =
                                    false,
                                editController.textDecoration.value =
                                    TextDecoration.none,

                                textController.clear(),
                                editController.isEditIconTap.value = false,

                                editController.checkBoxValue.value = false,
                                editController.forgroundStrokeColor.value =
                                    blackColor,
                                editController.backgroundStrokeColor.value =
                                    blackColor,
                                editController.selectedStrokeWidth.value = 1.0,

                                setState(() {}),
                              }
                            : null;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 20, top: 10),
                      child: Text(
                        "Add Text",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: kPrimeryColor,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border.all(color: greyColor, width: 1.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Obx(
                    () => TextField(
                      style: GoogleFonts.getFont(
                        editController.selectedFontFamily.value,
                        // fontSize: editController.selectedFontSize.value,
                        fontWeight: editController.fontWeight.value,
                        color: editController.textBlackColor.value,
                        fontStyle: editController.fontStyle.value,
                        decoration: editController.textDecoration.value,
                      ),
                      controller: textController,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        hintText: writeAText,
                        hintStyle: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xffa6a4a4),
                        ),
                        contentPadding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                      ),
                      onTap: () {
                        editController.selectedFontSize.value = 16.0;
                        editController.isTextTap.value = true;
                      },
                      onChanged: (value) {
                        setState(() {});
                      },
                      cursorColor: kPrimeryColor,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                textController.text.trim() != ""
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 10),
                            height: 20,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Stroke",
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Obx(
                                  () => Transform.scale(
                                    scale: 0.8,
                                    child: Checkbox(
                                      activeColor: kPrimeryColor,
                                      value: editController.checkBoxValue.value,
                                      onChanged: (value) {
                                        editController.checkBoxValue.value =
                                            value!;
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : Container(),
                const SizedBox(
                  height: 20,
                ),
                textController.text.trim() != ""
                    ? Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: whiteColor,
                        ),
                        child: Material(
                          elevation: 5,
                          color: whiteColor,
                          borderRadius: BorderRadius.circular(10),
                          child: Row(
                            children: [
                              fontFamilyDropDown(context),
                              fontSizeDropDown(context),
                              colorPickerText(),
                            ],
                          ),
                        ),
                      )
                    : Container(),
                textController.text.trim() != ""
                    ? colorPickPad(context)
                    : Container(),
                const SizedBox(
                  height: 20,
                ),
                textController.text.trim() != ""
                    ? Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: whiteColor,
                        ),
                        child: Material(
                          elevation: 5,
                          borderRadius: BorderRadius.circular(10),
                          color: whiteColor,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              textBoldIcon(),
                              const VerticalDivider(
                                indent: 10,
                                endIndent: 10,
                              ),
                              textFontStyleIcon(),
                              const VerticalDivider(
                                indent: 10,
                                endIndent: 10,
                              ),
                              textDecorationIcon(),
                            ],
                          ),
                        ),
                      )
                    : Container(),
                const SizedBox(
                  height: 20,
                ),
                textController.text.trim() != ""
                    ? Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: whiteColor,
                        ),
                        child: Material(
                          elevation: 5,
                          borderRadius: BorderRadius.circular(10),
                          color: whiteColor,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              InkWell(
                                splashColor: transparentColor,
                                highlightColor: transparentColor,
                                hoverColor: transparentColor,
                                onTap: () {
                                  FlutterClipboard.copy(textController.text);
                                  setState(() {});
                                },
                                child: Row(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: ImageIcon(
                                        AssetImage(
                                          "assets/images/copy.png",
                                        ),
                                        size: 16,
                                      ),
                                    ),
                                    SizedBox(
                                      width: w > 949 ? 5 : 10,
                                    ),
                                    w > 600
                                        ? Text(
                                            "Copy",
                                            style: GoogleFonts.poppins(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          )
                                        : Container(),
                                  ],
                                ),
                              ),
                              const VerticalDivider(
                                indent: 10,
                                endIndent: 10,
                              ),
                              InkWell(
                                splashColor: transparentColor,
                                highlightColor: transparentColor,
                                hoverColor: transparentColor,
                                onTap: () {
                                  duplicate =
                                      "${textController.text}\n${textController.text}";
                                  textController.text = duplicate;
                                  setState(() {});
                                },
                                child: Row(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: ImageIcon(
                                        AssetImage(
                                          "assets/images/duplicate.png",
                                        ),
                                        size: 16,
                                      ),
                                    ),
                                    SizedBox(
                                      width: w > 949 ? 5 : 10,
                                    ),
                                    w > 600
                                        ? Text(
                                            "Duplicate",
                                            style: GoogleFonts.poppins(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          )
                                        : Container(),
                                  ],
                                ),
                              ),
                              const VerticalDivider(
                                indent: 10,
                                endIndent: 10,
                              ),
                              InkWell(
                                splashColor: transparentColor,
                                highlightColor: transparentColor,
                                hoverColor: transparentColor,
                                onTap: () {
                                  FlutterClipboard.copy(textController.text);
                                  textController.text = "";
                                  setState(() {});
                                },
                                child: Row(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: ImageIcon(
                                        AssetImage(
                                          "assets/images/cut.png",
                                        ),
                                        size: 16,
                                      ),
                                    ),
                                    SizedBox(
                                      width: w > 949 ? 5 : 10,
                                    ),
                                    w > 600
                                        ? Text(
                                            "Cut",
                                            style: GoogleFonts.poppins(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          )
                                        : Container(),
                                  ],
                                ),
                              ),
                              const VerticalDivider(
                                indent: 10,
                                endIndent: 10,
                              ),
                              InkWell(
                                splashColor: transparentColor,
                                highlightColor: transparentColor,
                                hoverColor: transparentColor,
                                onTap: () {
                                  textController.text = "";
                                  setState(() {});
                                },
                                child: const Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: ImageIcon(
                                        AssetImage(
                                          "assets/images/delete.png",
                                        ),
                                        size: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Container(),
                const SizedBox(
                  height: 20,
                ),
                textController.text.trim() != ""
                    ? Obx(
                        () => textController.text.trim() != "" &&
                                editController.checkBoxValue.value
                            ? strokeTextFeture(context)
                            : Container(),
                      )
                    : Container(),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void editTextItem(int index) {
    textController.text = textItems[index].text;

    editController.selectedFontFamily.value = textItems[index].fontFamily;
    editController.selectedFontSize.value = textItems[index].fontSize;
    editController.textBlackColor.value = textItems[index].textColor;
    editController.fontWeight.value = textItems[index].fontWeight;
    editController.fontStyle.value = textItems[index].fontStyle;
    editController.textDecoration.value = textItems[index].textDecoration;

    setState(() {
      textItems.removeAt(index);
    });
  }

  Widget cropFeture() {
    var w = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 20, top: w > 949 ? 30 : 10, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              w > 949
                  ? Text(
                      "Aspect Ratio",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: kPrimeryColor,
                      ),
                    )
                  : Container(),
              IconButton(
                onPressed: () async {
                  imageCrop = await cropController.croppedImage();
                  isCropDoneIconTap = true;
                  functionTap = -1;
                  isDrawerIconTap = false;
                  setState(() {});
                },
                icon: const Icon(
                  Icons.done,
                  color: kPrimeryColor,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: w > 949 ? 20 : 10,
        ),
        w > 949
            ? Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      GridView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        shrinkWrap: true,
                        itemCount: cropRatio.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 0.82,
                        ),
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  splashColor: transparentColor,
                                  hoverColor: transparentColor,
                                  highlightColor: transparentColor,
                                  onTap: () {
                                    setState(() {
                                      cropIndex = index;
                                      if (cropIndex == 0) {
                                        cropController.aspectRatio = null;
                                        cropController.crop =
                                            const Rect.fromLTRB(
                                                0.1, 0.1, 0.9, 0.9);
                                      } else if (cropIndex == 1) {
                                        cropController.aspectRatio = 1.0;
                                        cropController.crop =
                                            const Rect.fromLTRB(
                                                0.1, 0.1, 0.9, 0.9);
                                      } else if (cropIndex == 2) {
                                        cropController.aspectRatio = 16 / 9;
                                        cropController.crop =
                                            const Rect.fromLTRB(
                                                0.1, 0.1, 0.9, 0.9);
                                      } else if (cropIndex == 3) {
                                        cropController.aspectRatio = 9 / 16;
                                        cropController.crop =
                                            const Rect.fromLTRB(
                                                0.1, 0.1, 0.9, 0.9);
                                      } else if (cropIndex == 4) {
                                        cropController.aspectRatio = 5 / 4;
                                        cropController.crop =
                                            const Rect.fromLTRB(
                                                0.1, 0.1, 0.9, 0.9);
                                      } else if (cropIndex == 5) {
                                        cropController.aspectRatio = 4 / 5;
                                        cropController.crop =
                                            const Rect.fromLTRB(
                                                0.1, 0.1, 0.9, 0.9);
                                      } else if (cropIndex == 6) {
                                        cropController.aspectRatio = 4 / 3;
                                        cropController.crop =
                                            const Rect.fromLTRB(
                                                0.1, 0.1, 0.9, 0.9);
                                      } else if (cropIndex == 7) {
                                        cropController.aspectRatio = 3 / 4;
                                        cropController.crop =
                                            const Rect.fromLTRB(
                                                0.1, 0.1, 0.9, 0.9);
                                      } else if (cropIndex == 8) {
                                        cropController.aspectRatio = 3 / 2;
                                        cropController.crop =
                                            const Rect.fromLTRB(
                                                0.1, 0.1, 0.9, 0.9);
                                      } else if (cropIndex == 9) {
                                        cropController.aspectRatio = 2 / 3;
                                        cropController.crop =
                                            const Rect.fromLTRB(
                                                0.1, 0.1, 0.9, 0.9);
                                      }
                                    });
                                  },
                                  child: Container(
                                    height: 100,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: cropIndex == index
                                          ? kPrimeryColor
                                          : const Color(0xfff8f8f8),
                                      border: cropIndex == index
                                          ? null
                                          : Border.all(
                                              color: const Color(0xffbbbbbb)),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Image.asset(
                                      cropRatio[index]["image"],
                                      scale: 5,
                                      color: cropIndex == index
                                          ? whiteColor
                                          : kPrimeryColor,
                                    ),
                                  ),
                                ),
                                Text(
                                  cropRatio[index]["ratio"],
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: kPrimeryColor,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              )
            : Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 90,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          shrinkWrap: true,
                          itemCount: cropRatio.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                    splashColor: transparentColor,
                                    hoverColor: transparentColor,
                                    highlightColor: transparentColor,
                                    onTap: () {
                                      setState(() {
                                        cropIndex = index;
                                        if (cropIndex == 0) {
                                          cropController.aspectRatio = null;
                                          cropController.crop =
                                              const Rect.fromLTRB(
                                                  0.1, 0.1, 0.9, 0.9);
                                        } else if (cropIndex == 1) {
                                          cropController.aspectRatio = 1.0;
                                          cropController.crop =
                                              const Rect.fromLTRB(
                                                  0.1, 0.1, 0.9, 0.9);
                                        } else if (cropIndex == 2) {
                                          cropController.aspectRatio = 16 / 9;
                                          cropController.crop =
                                              const Rect.fromLTRB(
                                                  0.1, 0.1, 0.9, 0.9);
                                        } else if (cropIndex == 3) {
                                          cropController.aspectRatio = 9 / 16;
                                          cropController.crop =
                                              const Rect.fromLTRB(
                                                  0.1, 0.1, 0.9, 0.9);
                                        } else if (cropIndex == 4) {
                                          cropController.aspectRatio = 5 / 4;
                                          cropController.crop =
                                              const Rect.fromLTRB(
                                                  0.1, 0.1, 0.9, 0.9);
                                        } else if (cropIndex == 5) {
                                          cropController.aspectRatio = 4 / 5;
                                          cropController.crop =
                                              const Rect.fromLTRB(
                                                  0.1, 0.1, 0.9, 0.9);
                                        } else if (cropIndex == 6) {
                                          cropController.aspectRatio = 4 / 3;
                                          cropController.crop =
                                              const Rect.fromLTRB(
                                                  0.1, 0.1, 0.9, 0.9);
                                        } else if (cropIndex == 7) {
                                          cropController.aspectRatio = 3 / 4;
                                          cropController.crop =
                                              const Rect.fromLTRB(
                                                  0.1, 0.1, 0.9, 0.9);
                                        } else if (cropIndex == 8) {
                                          cropController.aspectRatio = 3 / 2;
                                          cropController.crop =
                                              const Rect.fromLTRB(
                                                  0.1, 0.1, 0.9, 0.9);
                                        } else if (cropIndex == 9) {
                                          cropController.aspectRatio = 2 / 3;
                                          cropController.crop =
                                              const Rect.fromLTRB(
                                                  0.1, 0.1, 0.9, 0.9);
                                        }
                                      });
                                    },
                                    child: Container(
                                      height: 60,
                                      width: 60,
                                      decoration: BoxDecoration(
                                        color: cropIndex == index
                                            ? kPrimeryColor
                                            : const Color(0xfff8f8f8),
                                        border: cropIndex == index
                                            ? null
                                            : Border.all(
                                                color: const Color(0xffbbbbbb)),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Image.asset(
                                        cropRatio[index]["image"],
                                        scale: 7,
                                        color: cropIndex == index
                                            ? whiteColor
                                            : kPrimeryColor,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    cropRatio[index]["ratio"],
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: kPrimeryColor,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              )
      ],
    );
  }

  Widget cropImage() {
    var w = MediaQuery.of(context).size.width;
    return SizedBox(
      height: w > 949
          ? height
          : w > 600
              ? tabletHeight
              : mobileHeight,
      width: w > 949
          ? width - 3
          : w > 600
              ? tabletWidth
              : mobileWidth,
      child: CropImage(
        image: Image.asset(
          selectedImagePath ?? widget.wallPaper,
          fit: BoxFit.fill,
        ),
        controller: cropController,
      ),
    );
  }

  Widget contrastFeture() {
    var w = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        w > 949
            ? Container(
                margin: const EdgeInsets.only(left: 20, top: 30, right: 20),
                child: Text(
                  "Contrast",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: kPrimeryColor,
                  ),
                ),
              )
            : Container(),
        SizedBox(
          height: w > 949 ? 40 : 20,
        ),
        Expanded(
          child: SingleChildScrollView(
            child: SizedBox(
              height: 200,
              width: w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  contrastSlider(
                    "Highlights",
                    highlightValue,
                    (value) {
                      setState(() {
                        highlightValue = value;
                      });
                    },
                  ),
                  contrastSlider(
                    "Contrast",
                    constrastValue,
                    (value) {
                      setState(() {
                        constrastValue = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget contrastSlider(
      String text, double sliderValue, ValueChanged<double> onChanged) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: kPrimeryColor,
              ),
            ),
          ),
          Slider(
            value: sliderValue,
            min: 0.0,
            max: 2.0,
            activeColor: kPrimeryColor,
            inactiveColor: kPrimeryColor.withOpacity(0.4),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget rotateFeture() {
    var w = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        w > 949
            ? Container(
                margin: const EdgeInsets.only(left: 20, top: 30, right: 20),
                child: Text(
                  "Rotate",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: kPrimeryColor,
                  ),
                ),
              )
            : Container(),
        SizedBox(
          height: w > 949 ? 40 : 50,
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Text(
                    "Rotate",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: kPrimeryColor,
                    ),
                  ),
                ),
                Slider(
                  value: rotateAngle,
                  min: -6.283,
                  max: 6.283,
                  activeColor: kPrimeryColor,
                  inactiveColor: kPrimeryColor.withOpacity(0.4),
                  onChanged: (value) {
                    setState(() {
                      rotateAngle = value;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget sizeFeture() {
    var w = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        w > 949
            ? Container(
                margin: const EdgeInsets.only(left: 20, top: 30, right: 20),
                child: Text(
                  "Sizes",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: kPrimeryColor,
                  ),
                ),
              )
            : Container(),
        SizedBox(
          height: w > 949 ? 30 : 0,
        ),
        // w > 949
        //     ? Container(
        //         margin: const EdgeInsets.only(left: 20, right: 20),
        //         child: Text(
        //           "Custom",
        //           style: GoogleFonts.poppins(
        //             fontSize: 16,
        //             fontWeight: FontWeight.w500,
        //             color: kPrimeryColor,
        //           ),
        //         ),
        //       )
        //     : Container(),
        // SizedBox(
        //   height: w > 949 ? 15 : 0,
        // ),
        // w > 949
        // ? Container(
        //     margin: const EdgeInsets.only(left: 20, right: 50),
        //     height: 40,
        //     width: double.infinity,
        //     child: Row(
        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //       children: [
        //         Container(
        //           margin: const EdgeInsets.symmetric(horizontal: 5),
        //           height: 40,
        //           width: 100,
        //           decoration: BoxDecoration(
        //             border: Border.all(color: kPrimeryColor),
        //             borderRadius: BorderRadius.circular(5),
        //             color: kPrimeryColor.withOpacity(0.1),
        //           ),
        //           child: Row(
        //             mainAxisAlignment: MainAxisAlignment.center,
        //             children: [
        //               SizedBox(
        //                 width: 50,
        //                 child: TextField(
        //                   controller: widthController,
        //                   keyboardType: TextInputType.number,
        //                   style: GoogleFonts.poppins(
        //                     fontSize: 14,
        //                     fontWeight: FontWeight.w600,
        //                     color: kPrimeryColor,
        //                   ),
        //                   decoration: const InputDecoration(
        //                     border: OutlineInputBorder(
        //                       borderSide: BorderSide.none,
        //                     ),
        //                     counterText: "",
        //                     contentPadding:
        //                         EdgeInsets.fromLTRB(10, 10, 0, 0),
        //                   ),
        //                   maxLength: 4,
        //                   cursorColor: kPrimeryColor,
        //                   inputFormatters: <TextInputFormatter>[
        //                     FilteringTextInputFormatter.digitsOnly,
        //                   ],
        //                   onChanged: (value) {
        //                     setState(() {
        //                       width = double.parse(value);
        //                     });
        //                   },
        //                 ),
        //               ),
        //               Text(
        //                 "Width",
        //                 style: GoogleFonts.poppins(
        //                   fontSize: 10,
        //                   fontWeight: FontWeight.w500,
        //                   color: const Color(0xffa4a4a4),
        //                 ),
        //               ),
        //             ],
        //           ),
        //         ),
        //         Container(
        //           margin: const EdgeInsets.symmetric(horizontal: 5),
        //           height: 40,
        //           width: 100,
        //           decoration: BoxDecoration(
        //             border: Border.all(color: kPrimeryColor),
        //             borderRadius: BorderRadius.circular(5),
        //             color: kPrimeryColor.withOpacity(0.1),
        //           ),
        //           child: Row(
        //             mainAxisAlignment: MainAxisAlignment.center,
        //             children: [
        //               SizedBox(
        //                 width: 50,
        //                 child: TextField(
        //                   controller: heightController,
        //                   keyboardType: TextInputType.number,
        //                   style: GoogleFonts.poppins(
        //                     fontSize: 14,
        //                     fontWeight: FontWeight.w600,
        //                     color: kPrimeryColor,
        //                   ),
        //                   decoration: const InputDecoration(
        //                     border: OutlineInputBorder(
        //                       borderSide: BorderSide.none,
        //                     ),
        //                     counterText: "",
        //                     contentPadding:
        //                         EdgeInsets.fromLTRB(10, 10, 0, 0),
        //                   ),
        //                   cursorColor: kPrimeryColor,
        //                   maxLength: 4,
        //                   inputFormatters: <TextInputFormatter>[
        //                     FilteringTextInputFormatter.digitsOnly,
        //                   ],
        //                   onChanged: (value) {
        //                     setState(() {
        //                       height = double.parse(value);
        //                     });
        //                   },
        //                 ),
        //               ),
        //               Text(
        //                 "Height",
        //                 style: GoogleFonts.poppins(
        //                   fontSize: 10,
        //                   fontWeight: FontWeight.w500,
        //                   color: const Color(0xffa4a4a4),
        //                 ),
        //               ),
        //             ],
        //           ),
        //         ),
        //         Container(
        //           height: 40,
        //           width: 50,
        //           decoration: BoxDecoration(
        //             color: kPrimeryColor.withOpacity(0.1),
        //             borderRadius: BorderRadius.circular(5),
        //           ),
        //           child: Center(
        //             child: Text(
        //               "PX",
        //               style: GoogleFonts.poppins(
        //                 fontSize: 12,
        //                 fontWeight: FontWeight.w500,
        //                 color: kPrimeryColor,
        //               ),
        //             ),
        //           ),
        //         ),
        //       ],
        //     ),
        //   )
        // : Container(),
        // const SizedBox(
        //   height: 20,
        // ),
        // Expanded(
        //   child: SingleChildScrollView(
        //     child: Column(
        //       children: [
        //         GridView.builder(
        //           padding: const EdgeInsets.symmetric(horizontal: 10),
        //           shrinkWrap: true,
        //           itemCount: editController.sizeList.length,
        //           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        //             crossAxisCount: 2,
        //             mainAxisExtent: 150,
        //             crossAxisSpacing: 20,
        //           ),
        //           itemBuilder: (context, index) {
        //             return InkWell(
        //               splashColor: transparentColor,
        //               highlightColor: transparentColor,
        //               hoverColor: transparentColor,
        //               onTap: () {
        //                 setState(() {
        //                   // height = sizeList[index]["height"];
        //                   // width = sizeList[index]["width"];
        //                   // height = index == 0
        //                   //     ? double.infinity
        //                   //     : index == 1
        //                   //         ? 0.65 * h
        //                   //         : index == 2
        //                   //             ? 0.6 * h
        //                   //             : index == 3
        //                   //                 ? 0.65 * h
        //                   //                 : index == 4
        //                   //                     ? 0.62 * h
        //                   //                     : 0.5 * h;
        //                 });
        //               },
        //               child: Container(
        //                 margin: const EdgeInsets.symmetric(
        //                     vertical: 10, horizontal: 15),
        //                 height: 100,
        //                 width: 100,
        //                 decoration: BoxDecoration(
        //                   color: const Color(0xffededed).withOpacity(0.3),
        //                   borderRadius: BorderRadius.circular(5),
        //                 ),
        //                 child: Column(
        //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //                   children: [
        //                     SizedBox(
        //                       // height: 110,
        //                       // width: 110,
        //                       child: Center(
        //                         child: Image.asset(
        //                           editController.sizeList[index]["image"],
        //                           scale: 3,
        //                           color: kPrimeryColor,
        //                         ),
        //                       ),
        //                     ),
        //                     Text(
        //                       editController.sizeList[index]["size"],
        //                       style: GoogleFonts.poppins(

        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                w > 949
                    ? GridView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        shrinkWrap: true,
                        itemCount: sizeList.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                        ),
                        itemBuilder: (context, index) {
                          return InkWell(
                            splashColor: transparentColor,
                            highlightColor: transparentColor,
                            hoverColor: transparentColor,
                            onTap: () {
                              setState(() {
                                height = sizeList[index]["height"];
                                width = sizeList[index]["width"];
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 15),
                              height: 150,
                              width: 150,
                              decoration: BoxDecoration(
                                color: const Color(0xffededed).withOpacity(0.3),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 110,
                                    width: 110,
                                    child: Center(
                                      child: Image.asset(
                                        sizeList[index]["image"],
                                        scale: 5,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    sizeList[index]["name"],
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: kPrimeryColor,
                                    ),
                                  ),
                                  Text(
                                    sizeList[index]["size"],
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: kPrimeryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      )
                    : SizedBox(
                        height: 150,
                        width: w,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          shrinkWrap: true,
                          itemCount: sizeList.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                InkWell(
                                  splashColor: transparentColor,
                                  highlightColor: transparentColor,
                                  hoverColor: transparentColor,
                                  onTap: () {
                                    setState(() {
                                      w > 600
                                          ? tabletHeight =
                                              sizeList[index]["height"]
                                          : mobileHeight =
                                              sizeList[index]["height"];
                                      w > 600
                                          ? tabletWidth =
                                              sizeList[index]["width"]
                                          : mobileWidth =
                                              sizeList[index]["width"];
                                    });
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 15),
                                    height: 70,
                                    width: 70,
                                    decoration: BoxDecoration(
                                      color: const Color(0xffededed)
                                          .withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: SizedBox(
                                      child: Center(
                                        child: Image.asset(
                                          sizeList[index]["image"],
                                          scale: 7,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Text(
                                  sizeList[index]["name"],
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: kPrimeryColor,
                                  ),
                                ),
                                Text(
                                  sizeList[index]["size"],
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    fontSize: 8,
                                    fontWeight: FontWeight.w500,
                                    color: kPrimeryColor,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget logoFeture() {
    var w = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        w > 949
            ? Container(
                margin: const EdgeInsets.only(left: 20, top: 30, right: 20),
                child: Text(
                  "Image",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: kPrimeryColor,
                  ),
                ),
              )
            : Container(),
        SizedBox(
          height: w > 949 ? 30 : 20,
        ),
        w > 949
            ? Container(
                margin: const EdgeInsets.only(left: 20, right: 20),
                child: Text(
                  "Shape",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: kPrimeryColor,
                  ),
                ),
              )
            : Container(),
        const SizedBox(
          height: 20,
        ),
        Expanded(
          child: SingleChildScrollView(
            child: w > 949
                ? GridView.builder(
                    shrinkWrap: true,
                    itemCount: editController.logotypeList.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2),
                    itemBuilder: (context, index) {
                      return index != 0
                          ? editController.pickLogos.isNotEmpty
                              ? Obx(
                                  () {
                                    if (selectedImageIndexWeb.value! <
                                        editController.pickLogos.length) {
                                      return GestureDetector(
                                        // hoverColor: transparentColor,
                                        // highlightColor: transparentColor,
                                        // splashColor: transparentColor,
                                        onTap: () {
                                          // editController.logoIndex.value = index;
                                          editController.pickLogos[
                                              selectedImageIndexWeb.value!] = {
                                            "image": editController.pickLogos[
                                                selectedImageIndexWeb
                                                    .value!]["image"],
                                            "shapeIndex": index.obs
                                          };
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 20),
                                          height: 100,
                                          width: 100,
                                          child: Image.asset(
                                            editController.logotypeList[index],
                                            scale: 1.2,
                                            color: editController
                                                        .pickLogos[
                                                            selectedImageIndexWeb
                                                                .value!]
                                                            ["shapeIndex"]
                                                        .value ==
                                                    index
                                                ? kPrimeryColor
                                                : const Color(0xffd9d9d9),
                                          ),
                                        ),
                                      );
                                    } else {
                                      return Container();
                                    }
                                  },
                                )
                              : Container()
                          : Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 15),
                              height: 100,
                              width: 100,
                              child: InkWell(
                                hoverColor: transparentColor,
                                highlightColor: transparentColor,
                                splashColor: transparentColor,
                                onTap: () async {
                                  pickLogo = await picker.pickImage(
                                      source: ImageSource.gallery);
                                  pickLogoBytes = await pickLogo!.readAsBytes();
                                  if (pickLogoBytes != null) {
                                    editController.pickLogos.add({
                                      "image": pickLogoBytes,
                                      "shapeIndex": editController.logoIndex,
                                    });
                                    selectedImageIndexWeb.value = 1;
                                  }
                                  setState(() {});
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.add,
                                      color: kPrimeryColor,
                                    ),
                                    Text(
                                      addLogo,
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        color: kPrimeryColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                    },
                  )
                : SizedBox(
                    height: 100,
                    width: w,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: editController.logotypeList.length,
                      itemBuilder: (context, index) {
                        return index != 0
                            ? editController.pickLogos.isNotEmpty
                                ? Obx(
                                    () {
                                      if (selectedImageIndexWeb.value! <
                                          editController.pickLogos.length) {
                                        return GestureDetector(
                                          // hoverColor: transparentColor,
                                          // highlightColor: transparentColor,
                                          // splashColor: transparentColor,
                                          onTap: () {
                                            // editController.logoIndex.value = index;
                                            editController.pickLogos[
                                                selectedImageIndexWeb
                                                    .value!] = {
                                              "image": editController.pickLogos[
                                                  selectedImageIndexWeb
                                                      .value!]["image"],
                                              "shapeIndex": index.obs
                                            };
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 20),
                                            child: Image.asset(
                                              editController
                                                  .logotypeList[index],
                                              scale: 2,
                                              color: editController
                                                          .pickLogos[
                                                              selectedImageIndexWeb
                                                                  .value!]
                                                              ["shapeIndex"]
                                                          .value ==
                                                      index
                                                  ? kPrimeryColor
                                                  : const Color(0xffd9d9d9),
                                            ),
                                          ),
                                        );
                                      } else {
                                        return Container();
                                      }
                                    },
                                  )
                                : Container()
                            : Container(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 15),
                                height: 100,
                                width: 100,
                                child: InkWell(
                                  hoverColor: transparentColor,
                                  highlightColor: transparentColor,
                                  splashColor: transparentColor,
                                  onTap: () async {
                                    pickLogo = await picker.pickImage(
                                        source: ImageSource.gallery);
                                    pickLogoBytes =
                                        await pickLogo!.readAsBytes();
                                    if (pickLogoBytes != null) {
                                      editController.pickLogos.add({
                                        "image": pickLogoBytes,
                                        "shapeIndex": editController.logoIndex,
                                      });
                                      selectedImageIndexWeb.value = 1;
                                    }
                                    setState(() {});
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.add,
                                        color: kPrimeryColor,
                                      ),
                                      Text(
                                        addLogo,
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          color: kPrimeryColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                      },
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
