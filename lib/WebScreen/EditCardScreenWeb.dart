import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:clipboard/clipboard.dart';
import 'package:crop_image/crop_image.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';
import 'package:flutter_drawing_board/helpers.dart';
import 'package:flutter_drawing_board/paint_contents.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_frame/Contstant/AppColor.dart';
import 'package:photo_frame/Contstant/CommonMethod.dart';
import 'package:photo_frame/Contstant/EditableTextItem.dart';
import 'package:photo_frame/Contstant/Strings.dart';
import 'package:photo_frame/Contstant/getXController.dart';
import 'package:photo_frame/Contstant/itemModel.dart';
import 'package:photo_frame/Screen/EditImageScreen.dart';
import 'package:photo_frame/Screen/EditVisitingCard.dart';
import 'package:photo_frame/Screen/Templates.dart';
import 'package:photo_frame/Triangle.dart';
import 'package:photo_frame/WebScreen/HomeScreenWeb.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:share_plus/share_plus.dart';
import 'package:universal_html/html.dart' as html;

bool isCardDrawerIconTap = false;

class EditCardSCreenWeb extends StatefulWidget {
  String frontSide;
  String backSide;
  EditCardSCreenWeb(
      {super.key, required this.frontSide, required this.backSide});

  @override
  State<EditCardSCreenWeb> createState() => _EditCardSCreenWebState();
}

class _EditCardSCreenWebState extends State<EditCardSCreenWeb> {
  EditController editController = Get.put(EditController());
  TextEditingController searchController = TextEditingController();
  TextEditingController textController = TextEditingController();
  DrawingController frontDrawingController = DrawingController(
      config: DrawConfig.def(color: drawLineFrontColor, contentType: Type));
  DrawingController backDrawingController = DrawingController(
      config: DrawConfig.def(color: drawLineBackColor, contentType: Type));
  TextEditingController qrFrontController = TextEditingController();
  TextEditingController qrBackController = TextEditingController();
  bool isFrontTap = true;
  bool isBackTap = false;
  List<EditableTextItem> frontTextItems = [];
  List<EditableTextItem> backTextItems = [];
  int functionTap = -1;
  bool isAddTextTap = false;
  String duplicate = "";
  List<Item> textItems = [];
  bool isQrCodeTap = false;
  Image? frontCropImage;
  Image? backCropImage;
  final GlobalKey frontKey = GlobalKey();
  final GlobalKey backKey = GlobalKey();
  String text = "";
  late Uint8List pngBytes;
  double frontImageRotate = 0;
  double backImageRotate = 0;
  Offset frontImagePosition = const Offset(100, 100);
  Offset backImagePosition = const Offset(100, 100);
  double frontImageRadius = 35.0;
  double backImageRadius = 35.0;
  ImagePicker picker = ImagePicker();
  Uint8List? frontBytes;
  Uint8List? backBytes;
  double imageSize = 130;
  int frontLogoIndex = 1;
  int backLogoIndex = 1;
  int frontDrawIndex = 0;
  int backDrawIndex = 0;
  bool isFrontDrawEditTap = true;
  bool isFrontDrawBrushTap = false;
  bool isFrontDrawChartTap = false;
  bool isFrontDrawRectangleTap = false;
  bool isFrontDrawCircleTap = false;
  bool isFrontDrawEraseTap = false;
  bool isBackDrawEditTap = true;
  bool isBackDrawBrushTap = false;
  bool isBackDrawChartTap = false;
  bool isBackDrawRectangleTap = false;
  bool isBackDrawCircleTap = false;
  bool isBackDrawEraseTap = false;
  double frontQRRotate = 0;
  double backQRRotate = 0;
  double selectedQrSize = 50.0;
  double qrFrontLogoSize = 0.2;
  double qrBackLogoSize = 0.2;
  double qrLogoSizeSelect = 0.2;
  double qrFrontSize = 50;
  double qrBackSize = 50;
  Color qrCodeFrontColor = blackColor;
  Color qrCodeBackColor = blackColor;
  Offset frontQrPosition = const Offset(50, 50);
  Offset backQrPosition = const Offset(50, 50);
  Uint8List? qrFrontLogoBytes;
  Uint8List? qrBackLogoBytes;
  var cropController = CropController(
    aspectRatio: 100.0 / 140.0,
    defaultCrop: const Rect.fromLTRB(0.05, 0.05, 0.95, 0.95),
  );
  int cropCardIndex = -1;
  Image? imageCrop;
  bool isCropDoneIconTap = false;
  String? selectedFrontSide;
  String? selectedBackSide;
  int? seeMoreIndex;
  int selectedFrontLogoIndex = 0;
  int selectedBackLogoIndex = 0;
  List functionList = [
    {
      "image": "assets/images/text.png",
      "size": "Text",
    },
    {
      "image": "assets/images/crop.png",
      "size": "Crop",
    },
    {
      "image": "assets/images/addLogo.png",
      "size": "Images",
    },
    {
      "image": "assets/images/draw.png",
      "size": "Draw",
    },
    {
      "image": "assets/images/QR.png",
      "size": "QR",
    },
  ];
  List<double> qrSizeList = [
    50.0,
    60.0,
    70.0,
    80.0,
    90.0,
    100.0,
  ];
  List<double> qrLogoSizeList = [
    0.1,
    0.2,
    0.3,
    0.4,
    0.5,
  ];
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
  void searchTemplate(String search) {
    dataList.clear();
    filterList.clear();
    if (search.isEmpty) {
      dataList = List.from(visitingCardList);
    } else {
      for (var searchData in visitingCardList) {
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

  colorPickerDraw(context) {
    return ColorIndicator(
      width: 40,
      height: 40,
      borderRadius: 0,
      color: isFrontTap ? drawLineFrontColor : drawLineBackColor,
      elevation: 1,
      onSelectFocus: false,
      onSelect: () async {
        final Color newColor = await showColorPickerDialog(
          context,
          isFrontTap ? drawLineFrontColor : drawLineBackColor,
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
            minHeight: 450,
            minWidth: 320,
            maxWidth: 320,
          ),
        );
        // isFrontTap
        //     ? frontDrawingController.drawConfig.value.color = newColor
        //     : backDrawingController.drawConfig.value.color = newColor;
        isFrontTap
            ? drawLineFrontColor = newColor
            : drawLineBackColor = newColor;
        setState(() {});
      },
    );
  }

  colorPickerQRCode(context) {
    return ColorIndicator(
      width: 40,
      height: 40,
      borderRadius: 0,
      color: isFrontTap ? qrCodeFrontColor : qrCodeBackColor,
      elevation: 1,
      onSelectFocus: false,
      onSelect: () async {
        final Color newColor = await showColorPickerDialog(
          context,
          isFrontTap ? qrCodeFrontColor : qrCodeBackColor,
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
            minHeight: 450,
            minWidth: 320,
            maxWidth: 320,
          ),
        );
        isFrontTap ? qrCodeFrontColor = newColor : qrCodeBackColor = newColor;

        setState(() {});
      },
    );
  }

  Future<void> shareImage(key) async {
    RenderRepaintBoundary boundary =
        key.currentContext!.findRenderObject() as RenderRepaintBoundary;

    ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    pngBytes = byteData!.buffer.asUint8List();
    final blob = html.Blob([pngBytes], 'image/png');
    final url = html.Url.createObjectUrlFromBlob(blob);
    print("---------- File ----------- $url");

    await Share.share(url);
  }

  Future<void> saveImage(GlobalKey key) async {
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
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
        setState(() {
          editController.textBlackColor.value = blackColor;
          editController.isColorIconTap.value = false;
          editController.isBoldIconTap.value = false;
          editController.fontWeight.value = FontWeight.normal;
          editController.isTextItalicIconTap.value = false;
          editController.fontStyle.value = FontStyle.normal;
          editController.isTextUnderLineIconTap.value = false;
          editController.textDecoration.value = TextDecoration.none;
          editController.selectedFontFamily.value = "Poppins";
          editController.selectedFontSize.value = 16.0;
          drawLineFrontColor = blackColor;
          drawLineBackColor = blackColor;
        });
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
                    isCardDrawerIconTap
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
                            child: isCardDrawerIconTap && functionTap == -1
                                ? allPosterCardShow()
                                : functionTap == 0
                                    ? selectedIndexCard == null ||
                                            (isFrontTap
                                                    ? frontTextItems.length
                                                    : backTextItems.length) ==
                                                0 ||
                                            selectedIndexCard! < 0 ||
                                            selectedIndexCard! >=
                                                (isFrontTap
                                                    ? frontTextItems.length
                                                    : backTextItems.length)
                                        ? textFeture()
                                        : editController.show.value
                                            ? textFeture(
                                                item: isFrontTap
                                                    ? frontTextItems[
                                                        selectedIndexCard!]
                                                    : backTextItems[
                                                        selectedIndexCard!])
                                            : textFeture()
                                    : functionTap == 1
                                        ? cropFeture()
                                        : functionTap == 2
                                            ? logoFeture()
                                            : functionTap == 3
                                                ? drawFeture()
                                                : functionTap == 4
                                                    ? qrCodeFeture()
                                                    : Container(),
                          )
                        : Container(),
                    InkWell(
                      hoverColor: transparentColor,
                      splashColor: transparentColor,
                      highlightColor: transparentColor,
                      onTap: () {
                        setState(() {
                          isCardDrawerIconTap = !isCardDrawerIconTap;
                          isDrawTap = false;
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
        Navigator.of(context).pop();
        setState(() {
          editController.textBlackColor.value = blackColor;
          editController.isColorIconTap.value = false;
          editController.isBoldIconTap.value = false;
          editController.fontWeight.value = FontWeight.normal;
          editController.isTextItalicIconTap.value = false;
          editController.fontStyle.value = FontStyle.normal;
          editController.isTextUnderLineIconTap.value = false;
          editController.textDecoration.value = TextDecoration.none;
          editController.selectedFontFamily.value = "Poppins";
          editController.selectedFontSize.value = 16.0;
          drawLineFrontColor = blackColor;
          drawLineBackColor = blackColor;
        });
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
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 100),
                          height: functionTap == 0
                              ? 320
                              : functionTap == 3 || functionTap == 4
                                  ? 250
                                  : 210,
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
                                      ? selectedIndexCard == null ||
                                              (isFrontTap
                                                      ? frontTextItems.length
                                                      : backTextItems.length) ==
                                                  0 ||
                                              selectedIndexCard! < 0 ||
                                              selectedIndexCard! >=
                                                  (isFrontTap
                                                      ? frontTextItems.length
                                                      : backTextItems.length)
                                          ? textFeture()
                                          : editController.show.value
                                              ? textFeture(
                                                  item: isFrontTap
                                                      ? frontTextItems[
                                                          selectedIndexCard!]
                                                      : backTextItems[
                                                          selectedIndexCard!])
                                              : textFeture()
                                      : functionTap == 1
                                          ? cropFeture()
                                          : functionTap == 2
                                              ? logoFeture()
                                              : functionTap == 3
                                                  ? drawFeture()
                                                  : functionTap == 4
                                                      ? qrCodeFeture()
                                                      : Container(),
                                ),
                              ),
                              Positioned(
                                top: 5,
                                right: 5,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      functionTap = -1;
                                      isDrawTap = false;
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
        Navigator.of(context).pop();
        setState(() {
          editController.textBlackColor.value = blackColor;
          editController.isColorIconTap.value = false;
          editController.isBoldIconTap.value = false;
          editController.fontWeight.value = FontWeight.normal;
          editController.isTextItalicIconTap.value = false;
          editController.fontStyle.value = FontStyle.normal;
          editController.isTextUnderLineIconTap.value = false;
          editController.textDecoration.value = TextDecoration.none;
          editController.selectedFontFamily.value = "Poppins";
          editController.selectedFontSize.value = 16.0;
          drawLineFrontColor = blackColor;
          drawLineBackColor = blackColor;
        });
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
                        Container(
                          margin: const EdgeInsets.only(top: 0),
                          height: functionTap == 0
                              ? 380
                              : functionTap == 3 || functionTap == 4
                                  ? 250
                                  : 210,
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
                                      ? selectedIndexCard == null ||
                                              (isFrontTap
                                                      ? frontTextItems.length
                                                      : backTextItems.length) ==
                                                  0 ||
                                              selectedIndexCard! < 0 ||
                                              selectedIndexCard! >=
                                                  (isFrontTap
                                                      ? frontTextItems.length
                                                      : backTextItems.length)
                                          ? textFeture()
                                          : editController.show.value
                                              ? textFeture(
                                                  item: isFrontTap
                                                      ? frontTextItems[
                                                          selectedIndexCard!]
                                                      : backTextItems[
                                                          selectedIndexCard!])
                                              : textFeture()
                                      : functionTap == 1
                                          ? cropFeture()
                                          : functionTap == 2
                                              ? logoFeture()
                                              : functionTap == 3
                                                  ? drawFeture()
                                                  : functionTap == 4
                                                      ? qrCodeFeture()
                                                      : Container(),
                                ),
                              ),
                              Positioned(
                                top: 5,
                                right: 5,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      functionTap = -1;
                                      isDrawTap = false;
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
                        editController.textBlackColor.value = blackColor;
                        editController.isColorIconTap.value = false;
                        editController.isBoldIconTap.value = false;
                        editController.fontWeight.value = FontWeight.normal;
                        editController.isTextItalicIconTap.value = false;
                        editController.fontStyle.value = FontStyle.normal;
                        editController.isTextUnderLineIconTap.value = false;
                        editController.textDecoration.value =
                            TextDecoration.none;
                        editController.selectedFontFamily.value = "Poppins";
                        editController.selectedFontSize.value = 16.0;
                        drawLineFrontColor = blackColor;
                        drawLineBackColor = blackColor;
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
                    onTap: () async {
                      await shareImage(isFrontTap ? frontKey : backKey);
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
                    highlightColor: transparentColor,
                    onTap: () async {
                      await saveImage(isFrontTap ? frontKey : backKey);
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
                  ? 120
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
        child: constraints.maxWidth < 950 && constraints.maxWidth > 450
            ? SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(
                      functionList.length,
                      (index) {
                        return InkWell(
                          hoverColor: transparentColor,
                          splashColor: transparentColor,
                          highlightColor: transparentColor,
                          onTap: () {
                            setState(() {
                              functionTap = index;
                              functionTap == 3
                                  ? isDrawTap = true
                                  : isDrawTap = false;
                              isCardDrawerIconTap = true;
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
                                  functionList[index]["image"],
                                  scale: 7,
                                  color: functionTap == index
                                      ? kPrimeryColor
                                      : whiteColor,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  functionList[index]["size"],
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
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
                itemCount: functionList.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    hoverColor: transparentColor,
                    splashColor: transparentColor,
                    highlightColor: transparentColor,
                    onTap: () {
                      setState(() {
                        functionTap = index;
                        functionTap == 3 ? isDrawTap = true : isDrawTap = false;
                        isCardDrawerIconTap = true;
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
                            functionList[index]["image"],
                            scale: constraints.maxWidth > 600 ? 5.5 : 7,
                            color: functionTap == index
                                ? kPrimeryColor
                                : whiteColor,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            functionList[index]["size"],
                            style: GoogleFonts.poppins(
                              fontSize: constraints.maxWidth > 600 ? 14 : 12,
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

  Widget allPosterCardShow() {
    var w = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(left: 30, top: 30),
              child: seeMoreIndex == 0 ||
                      seeMoreIndex == 1 ||
                      seeMoreIndex == 2 ||
                      seeMoreIndex == 3
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
                              splashColor: transparentColor,
                              highlightColor: transparentColor,
                              onTap: () {
                                setState(() {
                                  selectedFrontSide =
                                      dataList[index]["image_2"];
                                  selectedBackSide = dataList[index]["image_3"];
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
                          seeMoreIndex == 1 ||
                                  seeMoreIndex == 2 ||
                                  seeMoreIndex == 3
                              ? Container()
                              : rowTextWeb(foldedVisitingCards,
                                  seeMoreIndex == 0 ? "" : "See More", () {
                                  setState(() {
                                    seeMoreIndex = 0;
                                  });
                                }),
                          SizedBox(
                            height: seeMoreIndex == 1 ||
                                    seeMoreIndex == 2 ||
                                    seeMoreIndex == 3
                                ? 0
                                : 20,
                          ),
                          seeMoreIndex == 1 ||
                                  seeMoreIndex == 2 ||
                                  seeMoreIndex == 3
                              ? Container()
                              : seeMoreIndex == 0
                                  ? GridView.builder(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10),
                                      shrinkWrap: true,
                                      itemCount: visitingCardList.length,
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        crossAxisSpacing: 10,
                                        mainAxisSpacing: 15,
                                      ),
                                      itemBuilder: (context, index) {
                                        return InkWell(
                                          hoverColor: transparentColor,
                                          splashColor: transparentColor,
                                          highlightColor: transparentColor,
                                          onTap: () {
                                            setState(() {
                                              selectedFrontSide =
                                                  visitingCardList[index]
                                                      ["image_2"];
                                              selectedBackSide =
                                                  visitingCardList[index]
                                                      ["image_3"];
                                              isCropDoneIconTap = false;
                                            });
                                          },
                                          child: SizedBox(
                                            height: 130,
                                            width: 130,
                                            child: Image.asset(
                                              visitingCardList[index]["image"],
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
                                          itemCount: visitingCardList.length,
                                          itemBuilder: (context, index) {
                                            return InkWell(
                                              hoverColor: transparentColor,
                                              splashColor: transparentColor,
                                              highlightColor: transparentColor,
                                              onTap: () {
                                                setState(() {
                                                  selectedFrontSide =
                                                      visitingCardList[index]
                                                          ["image_2"];
                                                  selectedBackSide =
                                                      visitingCardList[index]
                                                          ["image_3"];
                                                  isCropDoneIconTap = false;
                                                });
                                              },
                                              child: Container(
                                                margin: const EdgeInsets.only(
                                                    right: 20),
                                                height: 130,
                                                width: 130,
                                                child: Image.asset(
                                                  visitingCardList[index]
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
                                    seeMoreIndex == 2 ||
                                    seeMoreIndex == 3
                                ? 0
                                : 20,
                          ),
                          seeMoreIndex == 0 ||
                                  seeMoreIndex == 2 ||
                                  seeMoreIndex == 3
                              ? Container()
                              : rowTextWeb(transparentVisitingCard,
                                  seeMoreIndex == 1 ? "" : "See More", () {
                                  setState(() {
                                    seeMoreIndex = 1;
                                  });
                                }),
                          SizedBox(
                            height: seeMoreIndex == 0 ||
                                    seeMoreIndex == 2 ||
                                    seeMoreIndex == 3
                                ? 0
                                : 20,
                          ),
                          seeMoreIndex == 0 ||
                                  seeMoreIndex == 2 ||
                                  seeMoreIndex == 3
                              ? Container()
                              : seeMoreIndex == 1
                                  ? GridView.builder(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10),
                                      shrinkWrap: true,
                                      itemCount: visitingCardList.length,
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        crossAxisSpacing: 10,
                                        mainAxisSpacing: 15,
                                      ),
                                      itemBuilder: (context, index) {
                                        return InkWell(
                                          hoverColor: transparentColor,
                                          splashColor: transparentColor,
                                          highlightColor: transparentColor,
                                          onTap: () {
                                            setState(() {
                                              selectedFrontSide =
                                                  visitingCardList[index]
                                                      ["image_2"];
                                              selectedBackSide =
                                                  visitingCardList[index]
                                                      ["image_3"];
                                              isCropDoneIconTap = false;
                                            });
                                          },
                                          child: SizedBox(
                                            height: 130,
                                            width: 130,
                                            child: Image.asset(
                                              visitingCardList[index]["image"],
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
                                          padding: const EdgeInsets.only(
                                              left: 10, right: 0),
                                          scrollDirection: Axis.horizontal,
                                          itemCount: visitingCardList.length,
                                          itemBuilder: (context, index) {
                                            return InkWell(
                                              hoverColor: transparentColor,
                                              splashColor: transparentColor,
                                              highlightColor: transparentColor,
                                              onTap: () {
                                                setState(() {
                                                  selectedFrontSide =
                                                      visitingCardList[index]
                                                          ["image_2"];
                                                  selectedBackSide =
                                                      visitingCardList[index]
                                                          ["image_3"];
                                                  isCropDoneIconTap = false;
                                                });
                                              },
                                              child: Container(
                                                margin: const EdgeInsets.only(
                                                    right: 20),
                                                height: 130,
                                                width: 130,
                                                child: Image.asset(
                                                  visitingCardList[index]
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
                                    seeMoreIndex == 2 ||
                                    seeMoreIndex == 3
                                ? 0
                                : 20,
                          ),
                          seeMoreIndex == 0 ||
                                  seeMoreIndex == 1 ||
                                  seeMoreIndex == 3
                              ? Container()
                              : rowTextWeb(premiumVisitingCard,
                                  seeMoreIndex == 2 ? "" : "See More", () {
                                  setState(() {
                                    seeMoreIndex = 2;
                                  });
                                }),
                          SizedBox(
                            height: seeMoreIndex == 0 ||
                                    seeMoreIndex == 1 ||
                                    seeMoreIndex == 3
                                ? 0
                                : 20,
                          ),
                          seeMoreIndex == 0 ||
                                  seeMoreIndex == 1 ||
                                  seeMoreIndex == 3
                              ? Container()
                              : seeMoreIndex == 2
                                  ? GridView.builder(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10),
                                      shrinkWrap: true,
                                      itemCount: visitingCardList.length,
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        crossAxisSpacing: 10,
                                        mainAxisSpacing: 15,
                                      ),
                                      itemBuilder: (context, index) {
                                        return InkWell(
                                          hoverColor: transparentColor,
                                          splashColor: transparentColor,
                                          highlightColor: transparentColor,
                                          onTap: () {
                                            setState(() {
                                              selectedFrontSide =
                                                  visitingCardList[index]
                                                      ["image_2"];
                                              selectedBackSide =
                                                  visitingCardList[index]
                                                      ["image_3"];
                                              isCropDoneIconTap = false;
                                            });
                                          },
                                          child: SizedBox(
                                            height: 130,
                                            width: 130,
                                            child: Image.asset(
                                              visitingCardList[index]["image"],
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
                                          itemCount: visitingCardList.length,
                                          itemBuilder: (context, index) {
                                            return InkWell(
                                              hoverColor: transparentColor,
                                              splashColor: transparentColor,
                                              highlightColor: transparentColor,
                                              onTap: () {
                                                setState(() {
                                                  selectedFrontSide =
                                                      visitingCardList[index]
                                                          ["image_2"];
                                                  selectedBackSide =
                                                      visitingCardList[index]
                                                          ["image_3"];
                                                  isCropDoneIconTap = false;
                                                });
                                              },
                                              child: Container(
                                                margin: const EdgeInsets.only(
                                                    right: 20),
                                                height: 130,
                                                width: 130,
                                                child: Image.asset(
                                                  visitingCardList[index]
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
                                    seeMoreIndex == 2 ||
                                    seeMoreIndex == 3
                                ? 0
                                : 20,
                          ),
                          seeMoreIndex == 0 ||
                                  seeMoreIndex == 1 ||
                                  seeMoreIndex == 2
                              ? Container()
                              : rowTextWeb(photographicVisitingCards,
                                  seeMoreIndex == 3 ? "" : "See More", () {
                                  setState(() {
                                    seeMoreIndex = 3;
                                  });
                                }),
                          SizedBox(
                            height: seeMoreIndex == 0 ||
                                    seeMoreIndex == 1 ||
                                    seeMoreIndex == 2
                                ? 0
                                : 20,
                          ),
                          seeMoreIndex == 0 ||
                                  seeMoreIndex == 1 ||
                                  seeMoreIndex == 2
                              ? Container()
                              : seeMoreIndex == 3
                                  ? GridView.builder(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10),
                                      shrinkWrap: true,
                                      itemCount: visitingCardList.length,
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        crossAxisSpacing: 10,
                                        mainAxisSpacing: 15,
                                      ),
                                      itemBuilder: (context, index) {
                                        return InkWell(
                                          hoverColor: transparentColor,
                                          splashColor: transparentColor,
                                          highlightColor: transparentColor,
                                          onTap: () {
                                            setState(() {
                                              selectedFrontSide =
                                                  visitingCardList[index]
                                                      ["image_2"];
                                              selectedBackSide =
                                                  visitingCardList[index]
                                                      ["image_3"];
                                              isCropDoneIconTap = false;
                                            });
                                          },
                                          child: SizedBox(
                                            height: 130,
                                            width: 130,
                                            child: Image.asset(
                                              visitingCardList[index]["image"],
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
                                          padding: const EdgeInsets.only(
                                              left: 10, right: 0),
                                          scrollDirection: Axis.horizontal,
                                          itemCount: visitingCardList.length,
                                          itemBuilder: (context, index) {
                                            return InkWell(
                                              hoverColor: transparentColor,
                                              splashColor: transparentColor,
                                              highlightColor: transparentColor,
                                              onTap: () {
                                                setState(() {
                                                  selectedFrontSide =
                                                      visitingCardList[index]
                                                          ["image_2"];
                                                  selectedBackSide =
                                                      visitingCardList[index]
                                                          ["image_3"];
                                                  isCropDoneIconTap = false;
                                                });
                                              },
                                              child: Container(
                                                margin: const EdgeInsets.only(
                                                    right: 20),
                                                height: 130,
                                                width: 130,
                                                child: Image.asset(
                                                  visitingCardList[index]
                                                      ["image"],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                          const SizedBox(
                            height: 20,
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

  Widget imageShow() {
    var w = MediaQuery.of(context).size.width;
    return Expanded(
      child: Center(
        child: SingleChildScrollView(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: w > 360 ? 0 : 10),
                          decoration: BoxDecoration(
                            color: visitingCardBgColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              isFrontTap
                                  ? Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: RepaintBoundary(
                                        key: frontKey,
                                        child: buildCardFront(),
                                      ),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: RepaintBoundary(
                                        key: backKey,
                                        child: buildCardBack(),
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 15,
                              ),
                              height: 35,
                              width: 220,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Stack(
                                  children: [
                                    Container(
                                      width: 200,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: const Color(0xffE9E9E9),
                                      ),
                                    ),
                                    InkWell(
                                      hoverColor: transparentColor,
                                      splashColor: transparentColor,
                                      highlightColor: transparentColor,
                                      onTap: () {
                                        setState(() {
                                          isFrontTap = true;
                                          isBackTap = false;
                                        });
                                      },
                                      child: Container(
                                        width: 110,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: isFrontTap == true
                                              ? kPrimeryColor
                                              : const Color(0xffE9E9E9),
                                        ),
                                        child: Center(
                                          child: Text(
                                            frontSide,
                                            style: GoogleFonts.poppins(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: isFrontTap == true
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: InkWell(
                                          hoverColor: transparentColor,
                                          splashColor: transparentColor,
                                          highlightColor: transparentColor,
                                          onTap: () {
                                            setState(() {
                                              isBackTap = true;
                                              isFrontTap = false;
                                            });
                                          },
                                          child: Container(
                                            width: 110,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: isBackTap == true
                                                  ? kPrimeryColor
                                                  : const Color(0xffE9E9E9),
                                            ),
                                            child: Center(
                                              child: Text(
                                                backSide,
                                                style: GoogleFonts.poppins(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color: isBackTap == true
                                                      ? Colors.white
                                                      : Colors.black,
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
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCardFront() {
    var w = MediaQuery.of(context).size.width;
    return Stack(
      alignment: Alignment.center,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              editController.show.value = false;
              isFunctionTap = false;
              isImageTap = false;
              isQrCodeTap = false;
              isQRTap = false;
            });
          },
          child: Center(
            child: SizedBox(
              height: w > 600 ? 230 : 170,
              width: w > 600 ? 375 : 300,
              child: isCropDoneIconTap == true && frontCropImage != null
                  ? Image(
                      image: frontCropImage!.image,
                      fit: BoxFit.fill,
                    )
                  : Image.asset(
                      selectedFrontSide ?? widget.frontSide,
                      fit: BoxFit.fill,
                    ),
            ),
          ),
        ),
        SizedBox(
          height: w > 600 ? 230 : 170,
          width: w > 600 ? 375 : 300,
          child: DrawingBoard(
            controller: frontDrawingController,
            background: Container(
              height: w > 600 ? 230 : 170,
              width: w > 600 ? 375 : 300,
              color: transparentColor,
            ),
          ),
        ),
        isDrawTap == false || editController.isTextTap.value == true
            ? GestureDetector(
                onTap: () {
                  setState(() {
                    editController.show.value = false;
                    isFunctionTap = false;
                    isImageTap = false;
                    isQrCodeTap = false;
                    isQRTap = false;
                  });
                },
                child: Container(
                  height: w > 600 ? 230 : 170,
                  width: w > 600 ? 375 : 300,
                  color: transparentColor,
                ),
              )
            : Container(),
        functionTap == 1 ? cropImage() : Container(),
        for (int i = 0; i < frontTextItems.length; i++)
          buildEditableTextItem(frontTextItems[i], i, true, setState),
        // if (frontBytes != null) logoImage(frontBytes!),
        if (frontBytes != null)
          logoImage(
              // editController
              //   .pickLogosCardFrontSide[selectedFrontLogoIndex]["image"]
              ),
        qrFrontController.text != "" || qrFrontController.text.isNotEmpty
            ? qrCodeItem(qrFrontLogoBytes)
            : Container(),
      ],
    );
  }

  Widget buildCardBack() {
    var w = MediaQuery.of(context).size.width;
    return Stack(
      alignment: Alignment.center,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              editController.show.value = false;
              isFunctionTap = false;
              isImageTap = false;
              isQrCodeTap = false;
              isQRTap = false;
            });
          },
          child: Center(
            child: SizedBox(
              height: w > 600 ? 230 : 170,
              width: w > 600 ? 375 : 300,
              child: isCropDoneIconTap == true && backCropImage != null
                  ? Image(
                      image: backCropImage!.image,
                      fit: BoxFit.fill,
                    )
                  : Image.asset(
                      selectedBackSide ?? widget.backSide,
                      fit: BoxFit.fill,
                    ),
            ),
          ),
        ),
        SizedBox(
          height: w > 600 ? 230 : 170,
          width: w > 600 ? 375 : 300,
          child: DrawingBoard(
            controller: backDrawingController,
            background: Container(
              height: w > 600 ? 230 : 170,
              width: w > 600 ? 375 : 300,
              color: transparentColor,
            ),
          ),
        ),
        isDrawTap == false
            ? GestureDetector(
                onTap: () {
                  setState(() {
                    editController.show.value = false;
                    isFunctionTap = false;
                    isImageTap = false;
                    isQrCodeTap = false;
                    isQRTap = false;
                  });
                },
                child: Container(
                  height: w > 600 ? 230 : 170,
                  width: w > 600 ? 375 : 300,
                  color: transparentColor,
                ),
              )
            : Container(),
        functionTap == 1 ? cropImage() : Container(),
        for (int i = 0; i < backTextItems.length; i++)
          buildEditableTextItem(backTextItems[i], i, false, setState),
        if (backBytes != null) logoImage(),
        qrBackController.text != "" || qrBackController.text.isNotEmpty
            ? qrCodeItem(qrBackLogoBytes)
            : Container(),
        Container(),
      ],
    );
  }

  Widget textFeture({EditableTextItem? item}) {
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
        const SizedBox(
          height: 20,
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
                      isFunctionTap = false;
                      editController.isTextFieldTextAdd.value = false;
                      editController.isTextTap.value = false;
                      editController.show.value = false;
                      text = textController.text;
                      if (isFrontTap) {
                        editController.isEditIconTap.value == true
                            ? frontTextItems[selectedIndexCard!] =
                                frontTextItems[selectedIndexCard!].copyWith(
                                text: text,
                                color: editController.textBlackColor.value,
                                fontSize: editController.selectedFontSize.value,
                                fontWeight: editController.fontWeight.value,
                                textDecoration:
                                    editController.textDecoration.value,
                                fontStyle: editController.fontStyle.value,
                                fontFamily:
                                    editController.selectedFontFamily.value,
                              )
                            : frontTextItems.add(
                                EditableTextItem(
                                  position: const Offset(50, 50),
                                  rotation: 0,
                                  text: text,
                                  color: editController.textBlackColor.value,
                                  fontSize:
                                      editController.selectedFontSize.value,
                                  fontWeight: editController.fontWeight.value,
                                  textDecoration:
                                      editController.textDecoration.value,
                                  fontStyle: editController.fontStyle.value,
                                  fontFamily:
                                      editController.selectedFontFamily.value,
                                ),
                              );
                      } else {
                        editController.isEditIconTap.value == true
                            ? backTextItems[selectedIndexCard!] =
                                backTextItems[selectedIndexCard!].copyWith(
                                text: text,
                                color: editController.textBlackColor.value,
                                fontSize: editController.selectedFontSize.value,
                                fontWeight: editController.fontWeight.value,
                                textDecoration:
                                    editController.textDecoration.value,
                                fontStyle: editController.fontStyle.value,
                                fontFamily:
                                    editController.selectedFontFamily.value,
                              )
                            : backTextItems.add(
                                EditableTextItem(
                                  position: const Offset(50, 50),
                                  rotation: 0,
                                  text: text,
                                  color: editController.textBlackColor.value,
                                  fontSize:
                                      editController.selectedFontSize.value,
                                  fontWeight: editController.fontWeight.value,
                                  textDecoration:
                                      editController.textDecoration.value,
                                  fontStyle: editController.fontStyle.value,
                                  fontFamily:
                                      editController.selectedFontFamily.value,
                                ),
                              );
                      }
                      textController.text = "";
                      editController.isEditIconTap.value = false;
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
                      setState(() {});
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
                        fontSize: editController.selectedFontSize.value,
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
                // textController.text != ""
                //     ?
                Container(
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
                ),
                // : Container(),
                textController.text != "" ? colorPickPad(context) : Container(),
                const SizedBox(
                  height: 20,
                ),
                // textController.text != ""
                //     ?
                Container(
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
                        const SizedBox(
                          width: 0,
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              item!.rotation -= 0.1;
                            });
                          },
                          child: const Icon(
                            Icons.rotate_left,
                          ),
                        ),
                        const VerticalDivider(
                          indent: 10,
                          endIndent: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              item!.rotation += 0.1;
                            });
                          },
                          child: const Icon(
                            Icons.rotate_right,
                          ),
                        ),
                        const VerticalDivider(
                          indent: 10,
                          endIndent: 10,
                        ),
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
                        const VerticalDivider(
                          indent: 10,
                          endIndent: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            editController.isEditIconTap.value = true;
                            editController.isTextTap.value = true;
                            editController.isTextFieldTextAdd.value = true;
                            editController.isColorIconTap.value = false;
                            editController.isMoreIconTap.value = false;
                            isFunctionTap = true;
                            setState(() {
                              textController.text = item!.text;
                              editController.selectedFontFamily.value =
                                  item.fontFamily;
                              editController.selectedFontSize.value =
                                  item.fontSize;
                              editController.textBlackColor.value = item.color;
                              editController.fontWeight.value = item.fontWeight;
                              editController.fontWeight.value == FontWeight.bold
                                  ? editController.isBoldIconTap.value = true
                                  : editController.isBoldIconTap.value = false;
                              editController.textDecoration.value =
                                  item.textDecoration;
                              editController.textDecoration.value ==
                                      TextDecoration.underline
                                  ? editController
                                      .isTextUnderLineIconTap.value = true
                                  : editController
                                      .isTextUnderLineIconTap.value = false;
                              editController.fontStyle.value = item.fontStyle;
                              editController.fontStyle.value == FontStyle.italic
                                  ? editController.isTextItalicIconTap.value =
                                      true
                                  : editController.isTextItalicIconTap.value =
                                      false;
                            });
                          },
                          child: const Icon(Icons.edit),
                        ),
                        const SizedBox(
                          width: 0,
                        ),
                      ],
                    ),
                  ),
                ),
                // : Container(),
                const SizedBox(
                  height: 20,
                ),
                // textController.text != ""
                //     ?
                Container(
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
                            FlutterClipboard.copy(item!.text);
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
                              const SizedBox(
                                width: 5,
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
                            duplicate = "${item!.text}\n${item.text}";
                            item.text = duplicate;
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
                              const SizedBox(
                                width: 5,
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
                            FlutterClipboard.copy(item!.text);
                            item.text = "";
                            editController.show.value = false;
                            selectedIndexCard = null;
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
                              const SizedBox(
                                width: 5,
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
                            if (selectedIndexCard != null) {
                              if (isFrontTap) {
                                frontTextItems.removeAt(selectedIndexCard!);
                              } else {
                                backTextItems.removeAt(selectedIndexCard!);
                              }
                              textController.clear();
                              editController.isEditIconTap.value = false;
                              editController.show.value = false;
                              selectedIndexCard = null;

                              setState(() {});
                            }
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
                ),
                // : Container(),
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
                  isFrontTap
                      ? frontCropImage = await cropController.croppedImage()
                      : backCropImage = await cropController.croppedImage();
                  isCropDoneIconTap = true;
                  functionTap = -1;
                  isCardDrawerIconTap = false;
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
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                w > 949
                    ? GridView.builder(
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
                                      cropCardIndex = index;
                                      if (cropCardIndex == 0) {
                                        cropController.aspectRatio = null;
                                        cropController.crop =
                                            const Rect.fromLTRB(
                                                0.1, 0.1, 0.9, 0.9);
                                      } else if (cropCardIndex == 1) {
                                        cropController.aspectRatio = 1.0;
                                        cropController.crop =
                                            const Rect.fromLTRB(
                                                0.1, 0.1, 0.9, 0.9);
                                      } else if (cropCardIndex == 2) {
                                        cropController.aspectRatio = 16 / 9;
                                        cropController.crop =
                                            const Rect.fromLTRB(
                                                0.1, 0.1, 0.9, 0.9);
                                      } else if (cropCardIndex == 3) {
                                        cropController.aspectRatio = 9 / 16;
                                        cropController.crop =
                                            const Rect.fromLTRB(
                                                0.1, 0.1, 0.9, 0.9);
                                      } else if (cropCardIndex == 4) {
                                        cropController.aspectRatio = 5 / 4;
                                        cropController.crop =
                                            const Rect.fromLTRB(
                                                0.1, 0.1, 0.9, 0.9);
                                      } else if (cropCardIndex == 5) {
                                        cropController.aspectRatio = 4 / 5;
                                        cropController.crop =
                                            const Rect.fromLTRB(
                                                0.1, 0.1, 0.9, 0.9);
                                      } else if (cropCardIndex == 6) {
                                        cropController.aspectRatio = 4 / 3;
                                        cropController.crop =
                                            const Rect.fromLTRB(
                                                0.1, 0.1, 0.9, 0.9);
                                      } else if (cropCardIndex == 7) {
                                        cropController.aspectRatio = 3 / 4;
                                        cropController.crop =
                                            const Rect.fromLTRB(
                                                0.1, 0.1, 0.9, 0.9);
                                      } else if (cropCardIndex == 8) {
                                        cropController.aspectRatio = 3 / 2;
                                        cropController.crop =
                                            const Rect.fromLTRB(
                                                0.1, 0.1, 0.9, 0.9);
                                      } else if (cropCardIndex == 9) {
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
                                      color: cropCardIndex == index
                                          ? kPrimeryColor
                                          : const Color(0xfff8f8f8),
                                      border: cropCardIndex == index
                                          ? null
                                          : Border.all(
                                              color: const Color(0xffbbbbbb)),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Image.asset(
                                      cropRatio[index]["image"],
                                      scale: 5,
                                      color: cropCardIndex == index
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
                      )
                    : SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 100,
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          shrinkWrap: true,
                          itemCount: cropRatio.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 15),
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
                                        cropCardIndex = index;
                                        if (cropCardIndex == 0) {
                                          cropController.aspectRatio = null;
                                          cropController.crop =
                                              const Rect.fromLTRB(
                                                  0.1, 0.1, 0.9, 0.9);
                                        } else if (cropCardIndex == 1) {
                                          cropController.aspectRatio = 1.0;
                                          cropController.crop =
                                              const Rect.fromLTRB(
                                                  0.1, 0.1, 0.9, 0.9);
                                        } else if (cropCardIndex == 2) {
                                          cropController.aspectRatio = 16 / 9;
                                          cropController.crop =
                                              const Rect.fromLTRB(
                                                  0.1, 0.1, 0.9, 0.9);
                                        } else if (cropCardIndex == 3) {
                                          cropController.aspectRatio = 9 / 16;
                                          cropController.crop =
                                              const Rect.fromLTRB(
                                                  0.1, 0.1, 0.9, 0.9);
                                        } else if (cropCardIndex == 4) {
                                          cropController.aspectRatio = 5 / 4;
                                          cropController.crop =
                                              const Rect.fromLTRB(
                                                  0.1, 0.1, 0.9, 0.9);
                                        } else if (cropCardIndex == 5) {
                                          cropController.aspectRatio = 4 / 5;
                                          cropController.crop =
                                              const Rect.fromLTRB(
                                                  0.1, 0.1, 0.9, 0.9);
                                        } else if (cropCardIndex == 6) {
                                          cropController.aspectRatio = 4 / 3;
                                          cropController.crop =
                                              const Rect.fromLTRB(
                                                  0.1, 0.1, 0.9, 0.9);
                                        } else if (cropCardIndex == 7) {
                                          cropController.aspectRatio = 3 / 4;
                                          cropController.crop =
                                              const Rect.fromLTRB(
                                                  0.1, 0.1, 0.9, 0.9);
                                        } else if (cropCardIndex == 8) {
                                          cropController.aspectRatio = 3 / 2;
                                          cropController.crop =
                                              const Rect.fromLTRB(
                                                  0.1, 0.1, 0.9, 0.9);
                                        } else if (cropCardIndex == 9) {
                                          cropController.aspectRatio = 2 / 3;
                                          cropController.crop =
                                              const Rect.fromLTRB(
                                                  0.1, 0.1, 0.9, 0.9);
                                        }
                                      });
                                    },
                                    child: Container(
                                      height: 70,
                                      width: 70,
                                      decoration: BoxDecoration(
                                        color: cropCardIndex == index
                                            ? kPrimeryColor
                                            : const Color(0xfff8f8f8),
                                        border: cropCardIndex == index
                                            ? null
                                            : Border.all(
                                                color: const Color(0xffbbbbbb)),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Image.asset(
                                        cropRatio[index]["image"],
                                        scale: 7,
                                        color: cropCardIndex == index
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
      height: w > 600 ? 273 : 190,
      width: w > 600 ? 455 : 300,
      child: CropImage(
        image: isFrontTap
            ? Image.asset(
                selectedFrontSide ?? widget.frontSide,
                fit: BoxFit.fill,
              )
            : Image.asset(
                selectedBackSide ?? widget.backSide,
                fit: BoxFit.fill,
              ),
        controller: cropController,
      ),
    );
  }

  Widget logoFeture() {
    var w = MediaQuery.of(context).size.width;
    var image = isFrontTap ? frontBytes != null : backBytes != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        w > 949
            ? Container(
                margin: EdgeInsets.only(
                    left: 20, top: w > 949 ? 30 : 10, right: 20),
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
          height: w > 949 ? 30 : 15,
        ),
        Container(
          margin: const EdgeInsets.only(left: 20, right: 20),
          child: Text(
            "Shape",
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: kPrimeryColor,
            ),
          ),
        ),
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
                          ? image
                              ? (isFrontTap
                                      ? editController
                                          .pickLogosCardFrontSide.isNotEmpty
                                      : editController
                                          .pickLogosCardBackSide.isNotEmpty)
                                  ? InkWell(
                                      hoverColor: transparentColor,
                                      highlightColor: transparentColor,
                                      splashColor: transparentColor,
                                      onTap: () {
                                        isFrontTap
                                            ? frontLogoIndex = index
                                            : backLogoIndex = index;
                                        isFrontTap
                                            ? editController
                                                    .pickLogosCardFrontSide[
                                                selectedFrontLogoIndex] = {
                                                "image": editController
                                                            .pickLogosCardFrontSide[
                                                        selectedFrontLogoIndex]
                                                    ["image"],
                                                "shapeIndex": frontLogoIndex,
                                                "radius": editController
                                                            .pickLogosCardFrontSide[
                                                        selectedFrontLogoIndex]
                                                    ["radius"],
                                                "imageSize": editController
                                                            .pickLogosCardFrontSide[
                                                        selectedFrontLogoIndex]
                                                    ["imageSize"],
                                                "rotation": editController
                                                            .pickLogosCardFrontSide[
                                                        selectedFrontLogoIndex]
                                                    ["rotation"],
                                                "position": editController
                                                            .pickLogosCardFrontSide[
                                                        selectedFrontLogoIndex]
                                                    ["position"],
                                              }
                                            : editController
                                                    .pickLogosCardBackSide[
                                                selectedBackLogoIndex] = {
                                                "image": editController
                                                            .pickLogosCardBackSide[
                                                        selectedBackLogoIndex]
                                                    ["image"],
                                                "shapeIndex": backLogoIndex,
                                                "radius": editController
                                                            .pickLogosCardBackSide[
                                                        selectedBackLogoIndex]
                                                    ["radius"],
                                                "imageSize": editController
                                                            .pickLogosCardBackSide[
                                                        selectedBackLogoIndex]
                                                    ["imageSize"],
                                                "rotation": editController
                                                            .pickLogosCardBackSide[
                                                        selectedBackLogoIndex]
                                                    ["rotation"],
                                                "position": editController
                                                            .pickLogosCardBackSide[
                                                        selectedBackLogoIndex]
                                                    ["position"],
                                              };
                                        setState(() {});
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 20),
                                        height: 100,
                                        width: 100,
                                        child: Image.asset(
                                          editController.logotypeList[index],
                                          scale: 1.2,
                                          // color: isFrontTap
                                          //     ? frontLogoIndex == index
                                          //         ? kPrimeryColor
                                          //         : const Color(0xffd9d9d9)
                                          //     : backLogoIndex == index
                                          //         ? kPrimeryColor
                                          //         : const Color(0xffd9d9d9),

                                          color: (isFrontTap
                                                  ? editController.pickLogosCardFrontSide[
                                                              selectedFrontLogoIndex]
                                                          ["shapeIndex"] ==
                                                      index
                                                  : editController.pickLogosCardBackSide[
                                                              selectedBackLogoIndex]
                                                          ["shapeIndex"] ==
                                                      index)
                                              ? kPrimeryColor
                                              : const Color(0xffd9d9d9),
                                        ),
                                      ),
                                    )
                                  : Container()
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
                                  var pickLogo = await picker.pickImage(
                                      source: ImageSource.gallery);
                                  isFrontTap
                                      ? frontBytes =
                                          await pickLogo!.readAsBytes()
                                      : backBytes =
                                          await pickLogo!.readAsBytes();
                                  if (isFrontTap) {
                                    if (frontBytes != null) {
                                      print(
                                          "------- Front Side Logo Pick ---------");
                                      editController.pickLogosCardFrontSide
                                          .add({
                                        "image": frontBytes,
                                        "shapeIndex": editController.logoIndex,
                                        "radius": frontImageRadius,
                                        "imageSize": imageSize,
                                        // "radius": imageSize,
                                        "rotation": frontImageRotate,
                                        "position": frontImagePosition,
                                      });
                                      frontLogoIndex = 1;
                                    }
                                  } else {
                                    if (backBytes != null) {
                                      print(
                                          "------- back Side Logo Pick ---------");
                                      editController.pickLogosCardBackSide.add({
                                        "image": backBytes,
                                        "shapeIndex": editController.logoIndex,
                                        "radius": backImageRadius,
                                        "imageSize": imageSize,
                                        // "radius": imageSize,
                                        "rotation": backImageRotate,
                                        "position": backImagePosition,
                                      });
                                      backLogoIndex = 1;
                                    }
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
                            ? image
                                ? (isFrontTap
                                        ? editController
                                            .pickLogosCardFrontSide.isNotEmpty
                                        : editController
                                            .pickLogosCardBackSide.isNotEmpty)
                                    ? InkWell(
                                        hoverColor: transparentColor,
                                        highlightColor: transparentColor,
                                        splashColor: transparentColor,
                                        onTap: () {
                                          isFrontTap
                                              ? frontLogoIndex = index
                                              : backLogoIndex = index;
                                          isFrontTap
                                              ? editController
                                                      .pickLogosCardFrontSide[
                                                  selectedFrontLogoIndex] = {
                                                  "image": editController
                                                              .pickLogosCardFrontSide[
                                                          selectedFrontLogoIndex]
                                                      ["image"],
                                                  "shapeIndex": frontLogoIndex,
                                                  "radius": editController
                                                              .pickLogosCardFrontSide[
                                                          selectedFrontLogoIndex]
                                                      ["radius"],
                                                  "imageSize": editController
                                                              .pickLogosCardFrontSide[
                                                          selectedFrontLogoIndex]
                                                      ["imageSize"],
                                                  "rotation": editController
                                                              .pickLogosCardFrontSide[
                                                          selectedFrontLogoIndex]
                                                      ["rotation"],
                                                  "position": editController
                                                              .pickLogosCardFrontSide[
                                                          selectedFrontLogoIndex]
                                                      ["position"],
                                                }
                                              : editController
                                                      .pickLogosCardBackSide[
                                                  selectedBackLogoIndex] = {
                                                  "image": editController
                                                              .pickLogosCardBackSide[
                                                          selectedBackLogoIndex]
                                                      ["image"],
                                                  "shapeIndex": backLogoIndex,
                                                  "radius": editController
                                                              .pickLogosCardBackSide[
                                                          selectedBackLogoIndex]
                                                      ["radius"],
                                                  "imageSize": editController
                                                              .pickLogosCardBackSide[
                                                          selectedBackLogoIndex]
                                                      ["imageSize"],
                                                  "rotation": editController
                                                              .pickLogosCardBackSide[
                                                          selectedBackLogoIndex]
                                                      ["rotation"],
                                                  "position": editController
                                                              .pickLogosCardBackSide[
                                                          selectedBackLogoIndex]
                                                      ["position"],
                                                };
                                          setState(() {});
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 20),
                                          child: Image.asset(
                                            editController.logotypeList[index],
                                            scale: 2,
                                            color: isFrontTap
                                                ? frontLogoIndex == index
                                                    ? kPrimeryColor
                                                    : const Color(0xffd9d9d9)
                                                : backLogoIndex == index
                                                    ? kPrimeryColor
                                                    : const Color(0xffd9d9d9),
                                          ),
                                        ),
                                      )
                                    : Container()
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
                                    var pickLogo = await picker.pickImage(
                                        source: ImageSource.gallery);
                                    isFrontTap
                                        ? frontBytes =
                                            await pickLogo!.readAsBytes()
                                        : backBytes =
                                            await pickLogo!.readAsBytes();
                                    if (isFrontTap) {
                                      if (frontBytes != null) {
                                        print(
                                            "------- Front Side Logo Pick ---------");
                                        editController.pickLogosCardFrontSide
                                            .add({
                                          "image": frontBytes,
                                          "shapeIndex":
                                              editController.logoIndex,
                                          "radius": frontImageRadius,
                                          "imageSize": imageSize,
                                          // "radius": imageSize,
                                          "rotation": frontImageRotate,
                                          "position": frontImagePosition,
                                        });
                                        frontLogoIndex = 1;
                                      }
                                    } else {
                                      if (backBytes != null) {
                                        print(
                                            "------- back Side Logo Pick ---------");
                                        editController.pickLogosCardBackSide
                                            .add({
                                          "image": backBytes,
                                          "shapeIndex":
                                              editController.logoIndex,
                                          "radius": backImageRadius,
                                          "imageSize": imageSize,
                                          // "radius": imageSize,
                                          "rotation": backImageRotate,
                                          "position": backImagePosition,
                                        });
                                        backLogoIndex = 1;
                                      }
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

  Widget logoImage() {
    // onPanStart(DragStartDetails details) {
    //   if (shareCardStates[isFrontTap] == true) {
    //     return null;
    //   }
    //   Offset centerOfGestureDetector = Offset(
    //       editController.width.value / 2, editController.height.value / 2);
    //   final touchPositionFromCenter =
    //       details.localPosition - centerOfGestureDetector;
    //   isFrontTap
    //       ? editController.offsetAngle.value =
    //           touchPositionFromCenter.direction - frontImageRotate
    //       : editController.offsetAngle.value =
    //           touchPositionFromCenter.direction - backImageRotate;
    //   if (details.localPosition.dx > (editController.width.value - 40) &&
    //       details.localPosition.dy <= 40) {
    //     editController.isRotate.value = true;
    //   } else {
    //     editController.isRotate.value = false;
    //   }
    //   touchPosition = details.localPosition;
    // }

    // onPanUpdate(DragUpdateDetails details) {
    //   if (shareCardStates[isFrontTap] == true) {
    //     return null;
    //   }
    //   if (editController.isRotate.value) {
    //     Offset centerOfGestureDetector = Offset(
    //         editController.width.value / 2, editController.height.value / 2);
    //     final touchPositionFromCenter =
    //         details.localPosition - centerOfGestureDetector;
    //     isFrontTap
    //         ? frontImageRotate = touchPositionFromCenter.direction -
    //             editController.offsetAngle.value
    //         : backImageRotate = touchPositionFromCenter.direction -
    //             editController.offsetAngle.value;
    //   } else {
    //     double angle = isFrontTap ? frontImageRotate : backImageRotate;
    //     final rotatedDelta = Offset(
    //       details.delta.dx * cos(angle) - details.delta.dy * sin(angle),
    //       details.delta.dx * sin(angle) + details.delta.dy * cos(angle),
    //     );
    //     isFrontTap
    //         ? frontImagePosition += rotatedDelta
    //         : backImagePosition += rotatedDelta;
    //   }
    //   setState(() {});
    // }

    // resizeLogo(DragUpdateDetails details) {
    //   setState(() {
    //     isFrontTap
    //         ? frontImageRadius =
    //             (frontImageRadius + details.delta.dy).clamp(30.0, 70.0)
    //         : backImageRadius =
    //             (backImageRadius + details.delta.dy).clamp(30.0, 70.0);
    //     print(
    //         "-------- Image Logo Radius -------- ${isFrontTap ? frontImageRadius : backImageRadius}");
    //   });
    // }

    var w = MediaQuery.of(context).size.width;
    // Offset touchPosition = Offset.zero;

    onPanStart(DragStartDetails details) {
      if (shareCardStates[isFrontTap] == true) {
        return null;
      }
      Offset centerOfGestureDetector = Offset(
          editController.width.value / 2, editController.height.value / 2);
      final touchPositionFromCenter =
          details.localPosition - centerOfGestureDetector;
      isFrontTap
          ? editController.offsetAngle.value =
              // touchPositionFromCenter.direction - frontImageRotate
              touchPositionFromCenter.direction -
                  editController.pickLogosCardFrontSide[selectedFrontLogoIndex]
                      ["rotation"]
          : editController.offsetAngle.value =
              // touchPositionFromCenter.direction - backImageRotate;
              touchPositionFromCenter.direction -
                  editController.pickLogosCardBackSide[selectedBackLogoIndex]
                      ["rotation"];
      if (details.localPosition.dx > (editController.width.value - 40) &&
          details.localPosition.dy <= 40) {
        editController.isRotate.value = true;
      } else {
        editController.isRotate.value = false;
      }
    }

    onPanUpdate(DragUpdateDetails details) {
      if (shareCardStates[isFrontTap] == true) {
        return null;
      }
      if (editController.isRotate.value) {
        Offset centerOfGestureDetector = Offset(
            editController.width.value / 2, editController.height.value / 2);
        final touchPositionFromCenter =
            details.localPosition - centerOfGestureDetector;
        isFrontTap
            // ? frontImageRotate = touchPositionFromCenter.direction -
            ? editController.pickLogosCardFrontSide[selectedFrontLogoIndex]
                    ["rotation"] =
                touchPositionFromCenter.direction -
                    editController.offsetAngle.value
            : editController.pickLogosCardBackSide[selectedBackLogoIndex]
                    ["rotation"] =
                touchPositionFromCenter.direction -
                    editController.offsetAngle.value;
      } else {
        // double angle = isFrontTap ? frontImageRotate : backImageRotate;
        double angle = isFrontTap
            ? editController.pickLogosCardFrontSide[selectedFrontLogoIndex]
                ["rotation"]
            : editController.pickLogosCardBackSide[selectedBackLogoIndex]
                ["rotation"];
        final rotatedDelta = Offset(
          details.delta.dx * cos(angle) - details.delta.dy * sin(angle),
          details.delta.dx * sin(angle) + details.delta.dy * cos(angle),
        );
        isFrontTap
            // ? frontImagePosition += rotatedDelta
            ? editController.pickLogosCardFrontSide[selectedFrontLogoIndex]
                ["position"] += rotatedDelta
            : editController.pickLogosCardBackSide[selectedBackLogoIndex]
                ["position"] += rotatedDelta;
      }
      setState(() {});
    }

    resizeLogo(DragUpdateDetails details) {
      if (isFrontTap
          ? selectedFrontLogoIndex == -1
          : selectedBackLogoIndex == -1) return;
      // setState(() {
      // isFrontTap
      //       ? frontImageRadius =
      //           (frontImageRadius + details.delta.dy).clamp(30.0, 70.0)
      //       : backImageRadius =
      //           (backImageRadius + details.delta.dy).clamp(30.0, 70.0);
      //   print(
      //       "-------- Image Logo Radius-------- ${isFrontTap ? frontImageRadius : backImageRadius}");
      // });
      setState(() {
        isFrontTap
            ? editController.pickLogosCardFrontSide[selectedFrontLogoIndex]
                    ["radius"] =
                ((editController.pickLogosCardFrontSide[selectedFrontLogoIndex]
                            ["radius"]) +
                        details.delta.dy)
                    .clamp(30.0, 70.0)
            : editController.pickLogosCardBackSide[selectedBackLogoIndex]
                    ["radius"] =
                ((editController.pickLogosCardBackSide[selectedBackLogoIndex]
                            ["radius"]) +
                        details.delta.dy)
                    .clamp(30.0, 70.0);
      });
    }

    return SizedBox(
      // height: 200,
      // width: 400,
      height: w > 600 ? 230 : 170,
      width: w > 600 ? 375 : 300,
      child: Stack(
        children: List.generate(
          isFrontTap
              ? editController.pickLogosCardFrontSide.length
              : editController.pickLogosCardBackSide.length,
          (index) {
            return Positioned(
              left: isFrontTap
                  ? editController.pickLogosCardFrontSide[index]["position"].dx
                  : editController.pickLogosCardBackSide[index]["position"].dx,
              top: isFrontTap
                  ? editController
                          .pickLogosCardFrontSide[index]["position"].dy -
                      70
                  : editController.pickLogosCardBackSide[index]["position"].dy -
                      70,
              child: Transform.rotate(
                // angle: isFrontTap ? frontImageRotate : backImageRotate,
                angle: isFrontTap
                    ? editController.pickLogosCardFrontSide[index]["rotation"]
                    : editController.pickLogosCardBackSide[index]["rotation"],
                child: Stack(
                  children: [
                    SizedBox(
                      child: GestureDetector(
                        onPanStart: (isFrontTap
                                ? selectedFrontLogoIndex == index
                                : selectedBackLogoIndex == index)
                            ? onPanStart
                            : null,
                        onPanUpdate: (isFrontTap
                                ? selectedFrontLogoIndex == index
                                : selectedBackLogoIndex == index)
                            ? onPanUpdate
                            : null,
                        onTap: shareCardStates[isFrontTap] == true
                            ? null
                            : () {
                                isImageTap = true;
                                isFrontTap
                                    ? selectedFrontLogoIndex = index
                                    : selectedBackLogoIndex = index;
                                setState(() {});
                              },
                        child: Container(
                          margin: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: (isFrontTap
                                          ? selectedFrontLogoIndex == index
                                          : selectedBackLogoIndex == index) &&
                                      isImageTap
                                  ? kEditFetureColor
                                  : transparentColor,
                              width: 1,
                            ),
                          ),
                          child: isFrontTap
                              ? imageShowShap(index)
                              : imageShowShap(index),
                        ),
                      ),
                    ),

                    // top right
                    Positioned(
                      top: 5,
                      right: 5,
                      child: IgnorePointer(
                        child: Align(
                          alignment: Alignment.topRight,
                          child: (isFrontTap
                                      ? selectedFrontLogoIndex == index
                                      : selectedBackLogoIndex == index) &&
                                  isImageTap
                              ? Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: kPrimeryColor,
                                  ),
                                  child: const Icon(
                                    Icons.flip_camera_android,
                                    color: whiteColor,
                                    size: 15,
                                  ),
                                )
                              : Container(),
                        ),
                      ),
                    ),

                    // top left
                    Positioned(
                      top: 5,
                      left: 5,
                      child: (isFrontTap
                                  ? selectedFrontLogoIndex == index
                                  : selectedBackLogoIndex == index) &&
                              isImageTap
                          ? GestureDetector(
                              onTap: () {
                                setState(() {
                                  // isFrontTap
                                  //     ? frontBytes = null
                                  //     : backBytes = null;
                                  isFrontTap
                                      ? editController.pickLogosCardFrontSide
                                          .removeAt(index)
                                      : editController.pickLogosCardBackSide
                                          .removeAt(index);
                                  isFrontTap
                                      ? selectedFrontLogoIndex = 0
                                      : selectedBackLogoIndex = 0;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: kPrimeryColor,
                                ),
                                child: const Icon(
                                  Icons.delete,
                                  color: whiteColor,
                                  size: 13,
                                ),
                              ),
                            )
                          : Container(),
                    ),

                    // bottom right
                    Positioned(
                      bottom: 5,
                      right: 5,
                      child: (isFrontTap
                                  ? selectedFrontLogoIndex == index
                                  : selectedBackLogoIndex == index) &&
                              isImageTap
                          ? Container(
                              decoration: const BoxDecoration(
                                color: kPrimeryColor,
                                shape: BoxShape.circle,
                              ),
                              child: GestureDetector(
                                onPanUpdate: (isFrontTap
                                        ? selectedFrontLogoIndex == index
                                        : selectedBackLogoIndex == index)
                                    ? resizeLogo
                                    : null,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          editController.isSizeIconTap.value =
                                              true;
                                        },
                                        child: const Icon(
                                          Icons.open_in_full_outlined,
                                          color: whiteColor,
                                          size: 13,
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
            );
          },
        ),
      ),
    );
  }

  // Widget logoImage() {
  //   var h = MediaQuery.of(context).size.height;
  //   Offset touchPosition = Offset.zero;

  //   onPanStart(DragStartDetails details) {
  //     if (shareCardStates[isFrontTap] == true) {
  //       return null;
  //     }
  //     Offset centerOfGestureDetector = Offset(
  //         editController.width.value / 2, editController.height.value / 2);
  //     final touchPositionFromCenter =
  //         details.localPosition - centerOfGestureDetector;
  //     isFrontTap
  //         ? editController.offsetAngle.value =
  //             // touchPositionFromCenter.direction - frontImageRotate
  //             touchPositionFromCenter.direction -
  //                 editController.pickLogosCardFrontSide[selectedFrontLogoIndex]
  //                     ["rotation"]
  //         : editController.offsetAngle.value =
  //             // touchPositionFromCenter.direction - backImageRotate;
  //             touchPositionFromCenter.direction -
  //                 editController.pickLogosCardBackSide[selectedBackLogoIndex]
  //                     ["rotation"];
  //     if (details.localPosition.dx > (editController.width.value - 40) &&
  //         details.localPosition.dy <= 40) {
  //       editController.isRotate.value = true;
  //     } else {
  //       editController.isRotate.value = false;
  //     }
  //     touchPosition = details.localPosition;
  //   }

  //   onPanUpdate(DragUpdateDetails details) {
  //     if (shareCardStates[isFrontTap] == true) {
  //       return null;
  //     }
  //     if (editController.isRotate.value) {
  //       Offset centerOfGestureDetector = Offset(
  //           editController.width.value / 2, editController.height.value / 2);
  //       final touchPositionFromCenter =
  //           details.localPosition - centerOfGestureDetector;
  //       isFrontTap
  //           // ? frontImageRotate = touchPositionFromCenter.direction -
  //           ? editController.pickLogosCardFrontSide[selectedFrontLogoIndex]
  //                   ["rotation"] =
  //               touchPositionFromCenter.direction -
  //                   editController.offsetAngle.value
  //           : editController.pickLogosCardBackSide[selectedBackLogoIndex]
  //                   ["rotation"] =
  //               touchPositionFromCenter.direction -
  //                   editController.offsetAngle.value;
  //     } else {
  //       // double angle = isFrontTap ? frontImageRotate : backImageRotate;
  //       double angle = isFrontTap
  //           ? editController.pickLogosCardFrontSide[selectedFrontLogoIndex]
  //               ["rotation"]
  //           : editController.pickLogosCardBackSide[selectedBackLogoIndex]
  //               ["rotation"];
  //       final rotatedDelta = Offset(
  //         details.delta.dx * cos(angle) - details.delta.dy * sin(angle),
  //         details.delta.dx * sin(angle) + details.delta.dy * cos(angle),
  //       );
  //       isFrontTap
  //           // ? frontImagePosition += rotatedDelta
  //           ? editController.pickLogosCardFrontSide[selectedFrontLogoIndex]
  //               ["position"] += rotatedDelta
  //           : editController.pickLogosCardBackSide[selectedBackLogoIndex]
  //               ["position"] += rotatedDelta;
  //     }
  //     setState(() {});
  //   }

  //   resizeLogo(DragUpdateDetails details) {
  //     if (isFrontTap
  //         ? selectedFrontLogoIndex == -1
  //         : selectedBackLogoIndex == -1) return;
  //     // setState(() {
  //     // isFrontTap
  //     //       ? frontImageRadius =
  //     //           (frontImageRadius + details.delta.dy).clamp(30.0, 70.0)
  //     //       : backImageRadius =
  //     //           (backImageRadius + details.delta.dy).clamp(30.0, 70.0);
  //     //   print(
  //     //       "-------- Image Logo Radius-------- ${isFrontTap ? frontImageRadius : backImageRadius}");
  //     // });
  //     setState(() {
  //       isFrontTap
  //           ? editController.pickLogosCardFrontSide[selectedFrontLogoIndex]
  //                   ["radius"] =
  //               ((editController.pickLogosCardFrontSide[selectedFrontLogoIndex]
  //                           ["radius"]) +
  //                       details.delta.dy)
  //                   .clamp(30.0, 70.0)
  //           : editController.pickLogosCardBackSide[selectedBackLogoIndex]
  //                   ["radius"] =
  //               ((editController.pickLogosCardBackSide[selectedBackLogoIndex]
  //                           ["radius"]) +
  //                       details.delta.dy)
  //                   .clamp(30.0, 70.0);
  //     });
  //   }

  //   return SizedBox(
  //     height: 0.235 * h,
  //     child: Stack(
  //       children: List.generate(
  //           isFrontTap
  //               ? editController.pickLogosCardFrontSide.length
  //               : editController.pickLogosCardBackSide.length, (index) {
  //         final logo = isFrontTap
  //             ? editController.pickLogosCardFrontSide[index]["image"]
  //             : editController.pickLogosCardBackSide[index]["image"];

  //         return Positioned(
  //           left: isFrontTap
  //               ? editController.pickLogosCardFrontSide[index]["position"].dx
  //               : editController.pickLogosCardBackSide[index]["position"].dx,
  //           // top: isFrontTap ? frontImagePosition.dy - 70 : backImagePosition.dy - 70,
  //           top: isFrontTap
  //               ? editController.pickLogosCardFrontSide[index]["position"].dy -
  //                   70
  //               : editController.pickLogosCardBackSide[index]["position"].dy -
  //                   70,
  //           child: Transform.rotate(
  //             // angle: isFrontTap ? frontImageRotate : backImageRotate,
  //             angle: isFrontTap
  //                 ? editController.pickLogosCardFrontSide[index]["rotation"]
  //                 : editController.pickLogosCardBackSide[index]["rotation"],
  //             child: Stack(
  //               children: [
  //                 SizedBox(
  //                   child: GestureDetector(
  //                     onPanStart: (isFrontTap
  //                             ? selectedFrontLogoIndex == index
  //                             : selectedBackLogoIndex == index)
  //                         ? onPanStart
  //                         : null,
  //                     onPanUpdate: (isFrontTap
  //                             ? selectedFrontLogoIndex == index
  //                             : selectedBackLogoIndex == index)
  //                         ? onPanUpdate
  //                         : null,
  //                     onTap: () {
  //                       setState(() {
  //                         isFrontTap
  //                             ? selectedFrontLogoIndex = index
  //                             : selectedBackLogoIndex = index;
  //                         isImageTap = true;
  //                         isFunctionTap = true;
  //                         setState(() {});
  //                       });
  //                     },
  //                     child: Container(
  //                       margin: const EdgeInsets.all(15),
  //                       decoration: BoxDecoration(
  //                         border: Border.all(
  //                           color: isImageTap &&
  //                                   (isFrontTap
  //                                       ? selectedFrontLogoIndex == index
  //                                       : selectedBackLogoIndex == index)
  //                               ? kEditFetureColor
  //                               : transparentColor,
  //                           width: 1,
  //                         ),
  //                       ),
  //                       child: Padding(
  //                         padding: const EdgeInsets.all(5.0),
  //                         child:
  //                             //  (isFrontTap
  //                             //         ? frontLogoShapeIndex.value == 1
  //                             //         : backLogoShapeIndex.value == 1)
  //                             (isFrontTap
  //                                     ? editController.pickLogosCardFrontSide[index]
  //                                             ["shapeIndex"] ==
  //                                         1
  //                                     : editController.pickLogosCardBackSide[index]
  //                                             ["shapeIndex"] ==
  //                                         1)
  //                                 ? CircleAvatar(
  //                                     radius: isFrontTap
  //                                         ? editController
  //                                                 .pickLogosCardFrontSide[index]
  //                                             ["radius"]
  //                                         : editController
  //                                                 .pickLogosCardBackSide[index]
  //                                             ["radius"],
  //                                     backgroundColor: transparentColor,
  //                                     child: Container(
  //                                       decoration: BoxDecoration(
  //                                         shape: BoxShape.circle,
  //                                         image: DecorationImage(
  //                                           image: MemoryImage(
  //                                             (logo),
  //                                           ),
  //                                           fit: BoxFit.fill,
  //                                         ),
  //                                       ),
  //                                     ),
  //                                   )
  //                                 :
  //                                 // (isFrontTap
  //                                 //         ? frontLogoShapeIndex.value == 2
  //                                 //         : backLogoShapeIndex.value == 2)
  //                                 (isFrontTap
  //                                         ? editController.pickLogosCardFrontSide[index]
  //                                                 ["shapeIndex"] ==
  //                                             2
  //                                         : editController.pickLogosCardBackSide[index]
  //                                                 ["shapeIndex"] ==
  //                                             2)
  //                                     ? Container(
  //                                         height: isFrontTap
  //                                             ? editController
  //                                                         .pickLogosCardFrontSide[
  //                                                     index]["radius"] +
  //                                                 30
  //                                             : editController
  //                                                         .pickLogosCardBackSide[
  //                                                     index]["radius"] +
  //                                                 30,
  //                                         width: isFrontTap
  //                                             ? editController
  //                                                         .pickLogosCardFrontSide[
  //                                                     index]["radius"] +
  //                                                 30
  //                                             : editController
  //                                                         .pickLogosCardBackSide[
  //                                                     index]["radius"] +
  //                                                 30,
  //                                         decoration: BoxDecoration(
  //                                           image: DecorationImage(
  //                                             image: MemoryImage(
  //                                               (logo),
  //                                             ),
  //                                             fit: BoxFit.fill,
  //                                           ),
  //                                         ),
  //                                       )
  //                                     :
  //                                     // (isFrontTap
  //                                     //         ? frontLogoShapeIndex.value == 3
  //                                     //         : backLogoShapeIndex.value == 3)
  //                                     (isFrontTap
  //                                             ? editController.pickLogosCardFrontSide[index]
  //                                                     ["shapeIndex"] ==
  //                                                 3
  //                                             : editController.pickLogosCardBackSide[index]
  //                                                     ["shapeIndex"] ==
  //                                                 3)
  //                                         ? ClipPath(
  //                                             clipper: TriangleClipper(),
  //                                             child: Image.memory(
  //                                               (logo),
  //                                               fit: BoxFit.fill,
  //                                               height: isFrontTap
  //                                                   ? editController
  //                                                               .pickLogosCardFrontSide[
  //                                                           index]["radius"] +
  //                                                       30
  //                                                   : editController
  //                                                               .pickLogosCardBackSide[
  //                                                           index]["radius"] +
  //                                                       30,
  //                                               width: isFrontTap
  //                                                   ? editController
  //                                                               .pickLogosCardFrontSide[
  //                                                           index]["radius"] +
  //                                                       30
  //                                                   : editController
  //                                                               .pickLogosCardBackSide[
  //                                                           index]["radius"] +
  //                                                       30,
  //                                             ),
  //                                           )
  //                                         :
  //                                         // (isFrontTap
  //                                         //         ? frontLogoShapeIndex.value == 4
  //                                         //         : backLogoShapeIndex.value == 4)
  //                                         (isFrontTap
  //                                                 ? editController.pickLogosCardFrontSide[index]
  //                                                         ["shapeIndex"] ==
  //                                                     4
  //                                                 : editController
  //                                                             .pickLogosCardBackSide[index]
  //                                                         ["shapeIndex"] ==
  //                                                     4)
  //                                             ? Container(
  //                                                 height: isFrontTap
  //                                                     ? editController
  //                                                                 .pickLogosCardFrontSide[
  //                                                             index]["radius"] +
  //                                                         30 / 5
  //                                                     : editController
  //                                                                 .pickLogosCardBackSide[
  //                                                             index]["radius"] +
  //                                                         30 / 5,
  //                                                 width: isFrontTap
  //                                                     ? editController
  //                                                                 .pickLogosCardFrontSide[
  //                                                             index]["radius"] +
  //                                                         30
  //                                                     : editController
  //                                                                 .pickLogosCardBackSide[
  //                                                             index]["radius"] +
  //                                                         30,
  //                                                 decoration: BoxDecoration(
  //                                                   image: DecorationImage(
  //                                                     image:
  //                                                         MemoryImage((logo)),
  //                                                     fit: BoxFit.cover,
  //                                                   ),
  //                                                 ),
  //                                               )
  //                                             :
  //                                             // (isFrontTap
  //                                             //         ? frontLogoShapeIndex.value == 5
  //                                             //         : backLogoShapeIndex.value == 5)
  //                                             (isFrontTap
  //                                                     ? editController.pickLogosCardFrontSide[index]["shapeIndex"] == 5
  //                                                     : editController.pickLogosCardBackSide[index]["shapeIndex"] == 5)
  //                                                 ? ClipPath(
  //                                                     clipper: PolygonClipper(),
  //                                                     child: Image.memory(
  //                                                       (logo),
  //                                                       fit: BoxFit.fill,
  //                                                       height: isFrontTap
  //                                                           ? editController.pickLogosCardFrontSide[
  //                                                                       index]
  //                                                                   ["radius"] +
  //                                                               30
  //                                                           : editController.pickLogosCardBackSide[
  //                                                                       index]
  //                                                                   ["radius"] +
  //                                                               30,
  //                                                       width: isFrontTap
  //                                                           ? editController.pickLogosCardFrontSide[
  //                                                                       index]
  //                                                                   ["radius"] +
  //                                                               30
  //                                                           : editController.pickLogosCardBackSide[
  //                                                                       index]
  //                                                                   ["radius"] +
  //                                                               30,
  //                                                     ),
  //                                                   )
  //                                                 : Container(),
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //                 // top right
  //                 Positioned(
  //                   top: 5,
  //                   right: 5,
  //                   child: IgnorePointer(
  //                     child: Align(
  //                       alignment: Alignment.topRight,
  //                       child: isImageTap &&
  //                               (isFrontTap
  //                                   ? selectedFrontLogoIndex == index
  //                                   : selectedBackLogoIndex == index)
  //                           ? Container(
  //                               padding: const EdgeInsets.all(5),
  //                               decoration: const BoxDecoration(
  //                                 shape: BoxShape.circle,
  //                                 color: kPrimeryColor,
  //                               ),
  //                               child: const Icon(
  //                                 Icons.flip_camera_android,
  //                                 color: whiteColor,
  //                                 size: 15,
  //                               ),
  //                             )
  //                           : Container(),
  //                     ),
  //                   ),
  //                 ),
  //                 // top left
  //                 Positioned(
  //                   top: 5,
  //                   left: 5,
  //                   child: isImageTap &&
  //                           (isFrontTap
  //                               ? selectedFrontLogoIndex == index
  //                               : selectedBackLogoIndex == index)
  //                       ? GestureDetector(
  //                           onTap: () {
  //                             setState(() {
  //                               // isFrontTap
  //                               //     ? editController.frontImage.value = null
  //                               //     : editController.backImage.value = null;
  //                               isFrontTap
  //                                   ? editController.pickLogosCardFrontSide
  //                                       .removeAt(index)
  //                                   : editController.pickLogosCardBackSide
  //                                       .removeAt(index);
  //                             });
  //                           },
  //                           child: Container(
  //                             padding: const EdgeInsets.all(5),
  //                             decoration: const BoxDecoration(
  //                               shape: BoxShape.circle,
  //                               color: kPrimeryColor,
  //                             ),
  //                             child: const Icon(
  //                               Icons.delete,
  //                               color: whiteColor,
  //                               size: 13,
  //                             ),
  //                           ),
  //                         )
  //                       : Container(),
  //                 ),

  //                 // bottom right
  //                 Positioned(
  //                   bottom: 5,
  //                   right: 5,
  //                   child: isImageTap &&
  //                           (isFrontTap
  //                               ? selectedFrontLogoIndex == index
  //                               : selectedBackLogoIndex == index)
  //                       ? Container(
  //                           decoration: const BoxDecoration(
  //                             color: kPrimeryColor,
  //                             shape: BoxShape.circle,
  //                           ),
  //                           child: GestureDetector(
  //                             onPanUpdate: resizeLogo,
  //                             child: Stack(
  //                               alignment: Alignment.center,
  //                               children: [
  //                                 Padding(
  //                                   padding: const EdgeInsets.all(5.0),
  //                                   child: GestureDetector(
  //                                     onTap: () {
  //                                       editController.isSizeIconTap.value =
  //                                           true;
  //                                     },
  //                                     child: const Icon(
  //                                       Icons.open_in_full_outlined,
  //                                       color: whiteColor,
  //                                       size: 13,
  //                                     ),
  //                                   ),
  //                                 ),
  //                               ],
  //                             ),
  //                           ),
  //                         )
  //                       : Container(),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         );
  //       }),
  //     ),
  //   );
  // }

  Widget imageShowShap(index) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: CircleAvatar(
        // radius: isFrontTap ? frontImageRadius : backImageRadius,
        radius: isFrontTap
            ? editController.pickLogosCardFrontSide[index]["radius"]
            : editController.pickLogosCardBackSide[index]["radius"],
        backgroundColor: transparentColor,
        child: Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: (isFrontTap
                  ? editController.pickLogosCardFrontSide[index]["shapeIndex"] ==
                      0
                  : editController.pickLogosCardBackSide[index]["shapeIndex"] ==
                      0)
              ? GestureDetector(
                  onTap: () {
                    editController.isImageShow.value = true;
                  },
                  child: SizedBox(
                    height: imageSize,
                    width: imageSize,
                  ),
                )
              : (isFrontTap
                      ? editController.pickLogosCardFrontSide[index]["shapeIndex"] ==
                          1
                      : editController.pickLogosCardBackSide[index]["shapeIndex"] ==
                          1)
                  ? Container(
                      // height: imageSize,
                      // width: imageSize,
                      height: isFrontTap
                          ? editController.pickLogosCardFrontSide[
                              selectedFrontLogoIndex]["imageSize"]
                          : editController
                                  .pickLogosCardBackSide[selectedBackLogoIndex]
                              ["imageSize"],
                      width: isFrontTap
                          ? editController.pickLogosCardFrontSide[
                              selectedFrontLogoIndex]["imageSize"]
                          : editController
                                  .pickLogosCardBackSide[selectedBackLogoIndex]
                              ["imageSize"],
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: MemoryImage(
                            // isFrontTap ? frontBytes! : backBytes!,
                            isFrontTap
                                ? editController.pickLogosCardFrontSide[index]
                                    ["image"]
                                : editController.pickLogosCardBackSide[index]
                                    ["image"],
                          ),
                          fit: BoxFit.fill,
                        ),
                      ),
                    )
                  : (isFrontTap
                          ? editController.pickLogosCardFrontSide[index]
                                  ["shapeIndex"] ==
                              2
                          : editController.pickLogosCardBackSide[index]["shapeIndex"] ==
                              2)
                      ? Container(
                          // height: imageSize,
                          // width: imageSize,
                          height: isFrontTap
                              ? editController.pickLogosCardFrontSide[
                                  selectedFrontLogoIndex]["imageSize"]
                              : editController.pickLogosCardBackSide[
                                  selectedBackLogoIndex]["imageSize"],
                          width: isFrontTap
                              ? editController.pickLogosCardFrontSide[
                                  selectedFrontLogoIndex]["imageSize"]
                              : editController.pickLogosCardBackSide[
                                  selectedBackLogoIndex]["imageSize"],
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: MemoryImage(isFrontTap
                                  ? editController.pickLogosCardFrontSide[index]
                                      ["image"]
                                  : editController.pickLogosCardBackSide[index]
                                      ["image"]),
                              fit: BoxFit.fill,
                            ),
                          ),
                        )
                      : (isFrontTap
                              ? editController.pickLogosCardFrontSide[index]
                                      ["shapeIndex"] ==
                                  3
                              : editController.pickLogosCardBackSide[index]
                                      ["shapeIndex"] ==
                                  3)
                          ? ClipPath(
                              clipper: TriangleClipper(),
                              child: Image.memory(
                                isFrontTap
                                    ? editController
                                        .pickLogosCardFrontSide[index]["image"]
                                    : editController
                                        .pickLogosCardBackSide[index]["image"],
                                fit: BoxFit.fill,
                                // width: imageSize,
                                // height: imageSize,
                                height: isFrontTap
                                    ? editController.pickLogosCardFrontSide[
                                        selectedFrontLogoIndex]["imageSize"]
                                    : editController.pickLogosCardBackSide[
                                        selectedBackLogoIndex]["imageSize"],
                                width: isFrontTap
                                    ? editController.pickLogosCardFrontSide[
                                        selectedFrontLogoIndex]["imageSize"]
                                    : editController.pickLogosCardBackSide[
                                        selectedBackLogoIndex]["imageSize"],
                              ),
                            )
                          : (isFrontTap
                                  ? editController.pickLogosCardFrontSide[index]
                                          ["shapeIndex"] ==
                                      4
                                  : editController.pickLogosCardBackSide[index]
                                          ["shapeIndex"] ==
                                      4)
                              ? Container(
                                  // height: imageSize / 2,
                                  // width: imageSize,
                                  height: isFrontTap
                                      ? editController.pickLogosCardFrontSide[
                                                  selectedFrontLogoIndex]
                                              ["imageSize"] /
                                          2
                                      : editController.pickLogosCardBackSide[
                                                  selectedBackLogoIndex]
                                              ["imageSize"] /
                                          2,
                                  width: isFrontTap
                                      ? editController.pickLogosCardFrontSide[
                                          selectedFrontLogoIndex]["imageSize"]
                                      : editController.pickLogosCardBackSide[
                                          selectedBackLogoIndex]["imageSize"],
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: MemoryImage(isFrontTap
                                          ? editController
                                                  .pickLogosCardFrontSide[index]
                                              ["image"]
                                          : editController
                                                  .pickLogosCardBackSide[index]
                                              ["image"]),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                )
                              : (isFrontTap
                                      ? editController.pickLogosCardFrontSide[index]["shapeIndex"] == 5
                                      : editController.pickLogosCardBackSide[index]["shapeIndex"] == 5)
                                  ? ClipPath(
                                      clipper: PolygonClipper(),
                                      child: Image.memory(
                                        isFrontTap
                                            ? editController
                                                    .pickLogosCardFrontSide[
                                                index]["image"]
                                            : editController
                                                    .pickLogosCardBackSide[
                                                index]["image"],
                                        fit: BoxFit.fill,
                                        // width: imageSize,
                                        // height: imageSize,
                                        height: isFrontTap
                                            ? editController
                                                        .pickLogosCardFrontSide[
                                                    selectedFrontLogoIndex]
                                                ["imageSize"]
                                            : editController
                                                        .pickLogosCardBackSide[
                                                    selectedBackLogoIndex]
                                                ["imageSize"],
                                        width: isFrontTap
                                            ? editController
                                                        .pickLogosCardFrontSide[
                                                    selectedFrontLogoIndex]
                                                ["imageSize"]
                                            : editController
                                                        .pickLogosCardBackSide[
                                                    selectedBackLogoIndex]
                                                ["imageSize"],
                                      ),
                                    )
                                  : null,
        ),
      ),
    );
  }

  Widget drawFeture() {
    var w = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        w > 949
            ? Container(
                margin: const EdgeInsets.only(left: 20, top: 30),
                child: Text(
                  "Draw",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: kPrimeryColor,
                  ),
                ),
              )
            : Container(),
        Container(
          margin: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Material(
            elevation: 5,
            borderRadius: BorderRadius.circular(10),
            child: ExValueBuilder(
              valueListenable: isFrontTap
                  ? frontDrawingController.drawConfig
                  : backDrawingController.drawConfig,
              builder: (_, DrawConfig dc, ___) {
                return Row(
                  children: [
                    SizedBox(
                      height: 24,
                      width: 160,
                      child: Slider(
                        value: dc.strokeWidth,
                        max: 50,
                        min: 1,
                        activeColor: kPrimeryColor,
                        onChanged: (double v) => isFrontTap
                            ? frontDrawingController.setStyle(strokeWidth: v)
                            : backDrawingController.setStyle(strokeWidth: v),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 10),
                      height: 30,
                      width: 30,
                      child: ClipOval(
                        child: colorPickerDraw(context),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(left: 10),
                        child: IconButton(
                          onPressed: () {
                            isFrontTap
                                ? frontDrawingController.undo()
                                : backDrawingController.undo();
                            setState(() {});
                          },
                          icon: Icon(
                            CupertinoIcons.arrow_turn_up_left,
                            size: 20,
                            color: isFrontTap
                                ? frontDrawingController.canUndo()
                                    ? null
                                    : Colors.grey
                                : backDrawingController.canUndo()
                                    ? null
                                    : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(left: 10),
                        child: IconButton(
                          onPressed: () {
                            isFrontTap
                                ? frontDrawingController.redo()
                                : backDrawingController.redo();
                            setState(() {});
                          },
                          icon: Icon(
                            CupertinoIcons.arrow_turn_up_right,
                            size: 20,
                            color: isFrontTap
                                ? frontDrawingController.canRedo()
                                    ? null
                                    : Colors.grey
                                : backDrawingController.canRedo()
                                    ? null
                                    : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: IconButton(
                        onPressed: () {
                          isFrontTap
                              ? frontDrawingController.clear()
                              : backDrawingController.clear();
                          setState(() {});
                        },
                        icon: const Icon(
                          CupertinoIcons.trash,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: w > 949
                ? GridView.builder(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    shrinkWrap: true,
                    itemCount: drawList.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 30,
                      mainAxisExtent: 80,
                    ),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isFrontTap) {
                              frontDrawIndex = index;
                              index == 0
                                  ? frontDrawingController
                                      .setPaintContent(SimpleLine())
                                  : index == 1
                                      ? frontDrawingController
                                          .setPaintContent(SmoothLine())
                                      : index == 2
                                          ? frontDrawingController
                                              .setPaintContent(StraightLine())
                                          : index == 3
                                              ? frontDrawingController
                                                  .setPaintContent(Rectangle())
                                              : index == 4
                                                  ? frontDrawingController
                                                      .setPaintContent(Circle())
                                                  : index == 5
                                                      ? frontDrawingController
                                                          .setPaintContent(
                                                              Triangle())
                                                      : frontDrawingController
                                                          .setPaintContent(
                                                              Eraser());
                            } else {
                              backDrawIndex = index;
                              index == 0
                                  ? backDrawingController
                                      .setPaintContent(SimpleLine())
                                  : index == 1
                                      ? backDrawingController
                                          .setPaintContent(SmoothLine())
                                      : index == 2
                                          ? backDrawingController
                                              .setPaintContent(StraightLine())
                                          : index == 3
                                              ? backDrawingController
                                                  .setPaintContent(Rectangle())
                                              : index == 4
                                                  ? backDrawingController
                                                      .setPaintContent(Circle())
                                                  : index == 5
                                                      ? backDrawingController
                                                          .setPaintContent(
                                                              Triangle())
                                                      : backDrawingController
                                                          .setPaintContent(
                                                              Eraser());
                            }
                          });
                        },
                        child: Container(
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                            color: isFrontTap
                                ? frontDrawIndex == index
                                    ? kPrimeryColor
                                    : greyColor.withOpacity(0.1)
                                : backDrawIndex == index
                                    ? kPrimeryColor
                                    : greyColor.withOpacity(0.1),
                            border:
                                Border.all(color: greyColor.withOpacity(0.5)),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                drawList[index]["icon"],
                                size: 30,
                                color: isFrontTap
                                    ? frontDrawIndex == index
                                        ? whiteColor
                                        : kPrimeryColor
                                    : backDrawIndex == index
                                        ? whiteColor
                                        : kPrimeryColor,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                drawList[index]["name"],
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: isFrontTap
                                      ? frontDrawIndex == index
                                          ? whiteColor
                                          : kPrimeryColor
                                      : backDrawIndex == index
                                          ? whiteColor
                                          : kPrimeryColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                : SizedBox(
                    height: 120,
                    width: w,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: drawList.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (isFrontTap) {
                                frontDrawIndex = index;
                                index == 0
                                    ? frontDrawingController
                                        .setPaintContent(SimpleLine())
                                    : index == 1
                                        ? frontDrawingController
                                            .setPaintContent(SmoothLine())
                                        : index == 2
                                            ? frontDrawingController
                                                .setPaintContent(StraightLine())
                                            : index == 3
                                                ? frontDrawingController
                                                    .setPaintContent(
                                                        Rectangle())
                                                : index == 4
                                                    ? frontDrawingController
                                                        .setPaintContent(
                                                            Circle())
                                                    : index == 5
                                                        ? frontDrawingController
                                                            .setPaintContent(
                                                                Triangle())
                                                        : frontDrawingController
                                                            .setPaintContent(
                                                                Eraser());
                              } else {
                                backDrawIndex = index;
                                index == 0
                                    ? backDrawingController
                                        .setPaintContent(SimpleLine())
                                    : index == 1
                                        ? backDrawingController
                                            .setPaintContent(SmoothLine())
                                        : index == 2
                                            ? backDrawingController
                                                .setPaintContent(StraightLine())
                                            : index == 3
                                                ? backDrawingController
                                                    .setPaintContent(
                                                        Rectangle())
                                                : index == 4
                                                    ? backDrawingController
                                                        .setPaintContent(
                                                            Circle())
                                                    : index == 5
                                                        ? backDrawingController
                                                            .setPaintContent(
                                                                Triangle())
                                                        : backDrawingController
                                                            .setPaintContent(
                                                                Eraser());
                              }
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 10, left: 5),
                            width: 80,
                            decoration: BoxDecoration(
                              color: isFrontTap
                                  ? frontDrawIndex == index
                                      ? kPrimeryColor
                                      : greyColor.withOpacity(0.1)
                                  : backDrawIndex == index
                                      ? kPrimeryColor
                                      : greyColor.withOpacity(0.1),
                              border:
                                  Border.all(color: greyColor.withOpacity(0.5)),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  drawList[index]["icon"],
                                  size: 30,
                                  color: isFrontTap
                                      ? frontDrawIndex == index
                                          ? whiteColor
                                          : kPrimeryColor
                                      : backDrawIndex == index
                                          ? whiteColor
                                          : kPrimeryColor,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  drawList[index]["name"],
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: isFrontTap
                                        ? frontDrawIndex == index
                                            ? whiteColor
                                            : kPrimeryColor
                                        : backDrawIndex == index
                                            ? whiteColor
                                            : kPrimeryColor,
                                    fontWeight: FontWeight.w500,
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
        ),
      ],
    );
  }

  Widget qrCodeFeture() {
    var w = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        w > 949
            ? Container(
                margin: const EdgeInsets.only(left: 20, top: 30),
                child: Text(
                  "Generate QR Code",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: kPrimeryColor,
                  ),
                ),
              )
            : Container(),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 30,
                  ),
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Material(
                    elevation: 10,
                    borderRadius: BorderRadius.circular(10),
                    child: TextField(
                      controller:
                          isFrontTap ? qrFrontController : qrBackController,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: Icon(
                          CupertinoIcons.link,
                          color: Colors.grey[700],
                        ),
                        suffixIcon:
                            (isFrontTap && qrFrontController.text.isNotEmpty) ||
                                    (!isFrontTap &&
                                        qrBackController.text.isNotEmpty)
                                ? GestureDetector(
                                    onTap: () {
                                      if (isFrontTap) {
                                        qrFrontController.clear();
                                      } else {
                                        qrBackController.clear();
                                      }
                                      setState(() {});
                                    },
                                    child: const Icon(
                                      Icons.close,
                                      color: blackColor,
                                    ),
                                  )
                                : null,
                        hintText: "Please Enter Qr Code Generate Text",
                        hintStyle: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                        contentPadding:
                            const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      ),
                      cursorColor: blackColor,
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                isFrontTap
                    ? qrFrontController.text != ""
                        ? qrCodeFeturePannel()
                        : Container()
                    : qrBackController.text != ""
                        ? qrCodeFeturePannel()
                        : Container(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget qrCodeItem(Uint8List? qrLogo) {
    onPanStart(DragStartDetails details) {
      if (shareCardStates[isFrontTap] == true) {
        return null;
      }
      Offset centerOfGestureDetector = Offset(
          editController.width.value / 2, editController.height.value / 2);
      final touchPositionFromCenter =
          details.localPosition - centerOfGestureDetector;
      isFrontTap
          ? editController.offsetAngle.value =
              touchPositionFromCenter.direction - frontQRRotate
          : editController.offsetAngle.value =
              touchPositionFromCenter.direction - backQRRotate;
      if (details.localPosition.dx > (editController.width.value - 40) &&
          details.localPosition.dy <= 40) {
        editController.isRotate.value = true;
      } else {
        editController.isRotate.value = false;
      }
    }

    onPanUpdate(DragUpdateDetails details) {
      if (shareCardStates[isFrontTap] == true) {
        return null;
      }
      if (editController.isRotate.value) {
        Offset centerOfGestureDetector = Offset(
            editController.width.value / 2, editController.height.value / 2);
        final touchPositionFromCenter =
            details.localPosition - centerOfGestureDetector;
        isFrontTap
            ? frontQRRotate = touchPositionFromCenter.direction -
                editController.offsetAngle.value
            : backQRRotate = touchPositionFromCenter.direction -
                editController.offsetAngle.value;
      } else {
        double angle = isFrontTap ? frontQRRotate : backQRRotate;
        final rotatedDelta = Offset(
          details.delta.dx * cos(angle) - details.delta.dy * sin(angle),
          details.delta.dx * sin(angle) + details.delta.dy * cos(angle),
        );
        isFrontTap
            ? frontQrPosition += rotatedDelta
            : backQrPosition += rotatedDelta;
      }
      setState(() {});
    }

    resizeQrCode(DragUpdateDetails details) {
      setState(() {
        if (isFrontTap) {
          qrFrontSize = (qrFrontSize + details.delta.dy).clamp(50.0, 100.0);
          selectedQrSize = qrFrontSize;
        } else {
          qrBackSize = (qrBackSize + details.delta.dy).clamp(50.0, 100.0);
          selectedQrSize = qrBackSize;
        }
        print(
            "-------- Qr Code Size-------- ${isFrontTap ? qrFrontSize : qrBackSize}");
      });
    }

    return Positioned(
      left: isFrontTap ? frontQrPosition.dx : backQrPosition.dx,
      top: isFrontTap ? frontQrPosition.dy : backQrPosition.dy,
      child: Transform.rotate(
        angle: isFrontTap ? frontQRRotate : backQRRotate,
        child: SizedBox(
          child: Stack(
            children: [
              GestureDetector(
                onPanStart: onPanStart,
                onPanUpdate: onPanUpdate,
                onTap: shareCardStates[isFrontTap] == true
                    ? null
                    : () {
                        isQrCodeTap = !isQrCodeTap;
                        isFunctionTap = true;
                        isDrawTap = false;
                        editController.isTextTap.value = false;
                        isQRTap = true;
                        setState(() {});
                      },
                child: Container(
                  margin: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isQrCodeTap ? blackColor : transparentColor,
                      width: 1,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: isFrontTap ? qrFrontSize : qrBackSize,
                      width: isFrontTap ? qrFrontSize : qrBackSize,
                      child: PrettyQrView.data(
                        data: isFrontTap
                            ? qrFrontController.text
                            : qrBackController.text,
                        decoration: PrettyQrDecoration(
                          image: qrLogo != null
                              ? PrettyQrDecorationImage(
                                  image: MemoryImage(
                                    qrLogo,
                                  ),
                                  position:
                                      PrettyQrDecorationImagePosition.embedded,
                                  scale: isFrontTap
                                      ? qrFrontLogoSize
                                      : qrBackLogoSize,
                                )
                              : null,
                          shape: PrettyQrSmoothSymbol(
                            color:
                                isFrontTap ? qrCodeFrontColor : qrCodeBackColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // top right
              Positioned(
                top: 5,
                right: 5,
                child: IgnorePointer(
                  child: Align(
                    alignment: Alignment.topRight,
                    child: isQrCodeTap
                        ? Container(
                            padding: const EdgeInsets.all(5),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: kPrimeryColor,
                            ),
                            child: const Icon(
                              Icons.flip_camera_android,
                              color: whiteColor,
                              size: 15,
                            ),
                          )
                        : Container(),
                  ),
                ),
              ),

              // top left
              Positioned(
                top: 5,
                left: 5,
                child: isQrCodeTap
                    ? GestureDetector(
                        onTap: () {
                          setState(() {
                            isFrontTap
                                ? qrFrontController.text = ""
                                : qrBackController.text = "";
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: kPrimeryColor,
                          ),
                          child: const Icon(
                            Icons.delete,
                            color: whiteColor,
                            size: 13,
                          ),
                        ),
                      )
                    : Container(),
              ),

              // bottom right
              Positioned(
                bottom: 5,
                right: 5,
                child: isQrCodeTap
                    ? Container(
                        decoration: const BoxDecoration(
                          color: kPrimeryColor,
                          shape: BoxShape.circle,
                        ),
                        child: GestureDetector(
                          onPanUpdate: resizeQrCode,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: GestureDetector(
                                  onTap: () {
                                    editController.isSizeIconTap.value = true;
                                  },
                                  child: const Icon(
                                    Icons.open_in_full_outlined,
                                    color: whiteColor,
                                    size: 13,
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
    );
  }

  qrCodeFeturePannel() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
      height: 40,
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const SizedBox(
              width: 0,
            ),
            SizedBox(
              height: 30,
              width: 30,
              child: ClipOval(
                child: colorPickerQRCode(context),
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            VerticalDivider(
              color: greyColor.withOpacity(0.5),
              indent: 10,
              endIndent: 10,
            ),
            SizedBox(
              width: 80,
              child: DropdownButtonHideUnderline(
                child: DropdownButton2<double>(
                  value: qrSizeList.contains(selectedQrSize)
                      ? selectedQrSize
                      : null,
                  isExpanded: true,
                  isDense: false,
                  items: qrSizeList.map((e) {
                    return DropdownMenuItem<double>(
                      value: e,
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: "${e.toInt()}",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                color: blackColor,
                                fontSize: 14,
                              ),
                            ),
                            TextSpan(
                              text: "  PX",
                              style: GoogleFonts.poppins(
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
                          text: selectedQrSize.toStringAsFixed(0),
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
                    if (value != null) {
                      isFrontTap ? qrFrontSize = value : qrBackSize = value;
                      selectedQrSize = isFrontTap ? qrFrontSize : qrBackSize;
                      setState(() {});
                    }
                  },
                  dropdownStyleData: DropdownStyleData(
                    width: 80,
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: whiteColor,
                    ),
                    offset: const Offset(-5, -4),
                  ),
                ),
              ),
            ),
            VerticalDivider(
              color: greyColor.withOpacity(0.5),
              indent: 10,
              endIndent: 10,
            ),
            GestureDetector(
              onTap: () async {
                var pickLogo =
                    await picker.pickImage(source: ImageSource.gallery);
                isFrontTap
                    ? qrFrontLogoBytes = await pickLogo!.readAsBytes()
                    : qrBackLogoBytes = await pickLogo!.readAsBytes();
                if (isFrontTap) {
                  if (qrFrontLogoBytes != null) {
                    print("------- QR Front Logo Pick ---------");
                  }
                } else {
                  if (qrBackLogoBytes != null) {
                    print("------- QR Back Logo Pick ---------");
                  }
                }
                setState(() {});
              },
              child: const Icon(Icons.image),
            ),
            VerticalDivider(
              color: greyColor.withOpacity(0.5),
              indent: 10,
              endIndent: 10,
            ),
            SizedBox(
              width: 70,
              child: DropdownButtonHideUnderline(
                child: DropdownButton2<double>(
                  value: qrLogoSizeList.contains(qrLogoSizeSelect)
                      ? qrLogoSizeSelect
                      : null,
                  isExpanded: true,
                  isDense: false,
                  items: qrLogoSizeList.map((e) {
                    return DropdownMenuItem<double>(
                      value: e,
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: "${e.toDouble()}",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                color: blackColor,
                                fontSize: 14,
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
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      isFrontTap
                          ? qrFrontLogoSize = value
                          : qrBackLogoSize = value;
                      qrLogoSizeSelect =
                          isFrontTap ? qrFrontLogoSize : qrBackLogoSize;
                      setState(() {});
                    }
                  },
                  dropdownStyleData: DropdownStyleData(
                    width: 80,
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: whiteColor,
                    ),
                    offset: const Offset(-5, -4),
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 0,
            ),
          ],
        ),
      ),
    );
  }
}
