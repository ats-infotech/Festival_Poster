import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';
import 'package:crop_image/crop_image.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';
import 'package:flutter_drawing_board/helpers.dart';
import 'package:flutter_drawing_board/paint_contents.dart';
// import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:ui' as ui;
import 'package:photo_frame/Contstant/AppColor.dart';
import 'package:photo_frame/Contstant/CommonMethod.dart';
import 'package:photo_frame/Contstant/EditableTextItem.dart';
import 'package:photo_frame/Contstant/Strings.dart';
import 'package:photo_frame/Screen/BottomNavBar.dart';
import 'package:photo_frame/Screen/EditImageScreen.dart';
import 'package:photo_frame/Triangle.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:share_extend/share_extend.dart';

String duplicate = "";
bool isFrontTap = true;
bool isBackTap = false;
// File? frontImage;
// File? backImage;
List<EditableTextItem> frontTextItems = [];
List<EditableTextItem> backTextItems = [];
Color drawLineFrontColor = blackColor;
Color drawLineBackColor = blackColor;
int? selectedIndexCard;
bool isDrawTap = false;
bool isQRTap = false;
bool isImageTap = false;
bool isFunctionTap = false;
Map<bool, bool> shareCardStates = {
  true: false, // Front side
  false: false // Back side
};
Rxn<int> frontLogoShapeIndex = Rxn();
Rxn<int> backLogoShapeIndex = Rxn();
Rxn<int> logoShapeIndex = Rxn();
int selectedFrontLogoIndex = 0;
int selectedBackLogoIndex = 0;

double frontImageRadius = 35.0;
double backImageRadius = 35.0;
double frontImageRotate = 0;
double backImageRotate = 0;
Offset frontImagePosition = const Offset(100, 100);
Offset backImagePosition = const Offset(100, 100);

class EditVisitingCard extends StatefulWidget {
  String frontSide;
  String backSide;

  EditVisitingCard(
      {super.key, required this.frontSide, required this.backSide});

  @override
  _EditVisitingCardState createState() => _EditVisitingCardState();
}

class _EditVisitingCardState extends State<EditVisitingCard> {
  double? currentFontSize;
  TextEditingController textController = TextEditingController();
  TextEditingController qrFrontController = TextEditingController();
  TextEditingController qrBackController = TextEditingController();
  DrawingController frontDrawingController = DrawingController(
      config: DrawConfig.def(color: drawLineFrontColor, contentType: Type));
  DrawingController backDrawingController = DrawingController(
      config: DrawConfig.def(color: drawLineBackColor, contentType: Type));
  Uint8List? frontBytes;
  Uint8List? bytes;
  Uint8List? backBytes;
  bool isVisitingCardTextTap = false;
  bool isAddIconTap = false;
  String duplicate = "";
  bool isTextFieldTap = false;
  final GlobalKey frontKey = GlobalKey();
  final GlobalKey backKey = GlobalKey();
  final GlobalKey combinedKey = GlobalKey();

  var picker = ImagePicker();

  Offset frontQrPosition = const Offset(50, 50);
  Offset backQrPosition = const Offset(50, 50);
  int selectAlignOrColor = 0;
  int functionTap = -1;
  Color qrCodeFrontColor = blackColor;
  Color qrCodeBackColor = blackColor;
  double qrFrontSize = 50;
  double qrBackSize = 50;
  XFile? qrFrontLogo;
  XFile? qrBackLogo;

  FocusNode focusNode = FocusNode();
  EditableTextItem? textItem;
  Image? frontCropImage;
  Image? backCropImage;
  bool isFree = false;
  bool isSquare = false;
  bool is21 = false;
  bool is12 = false;
  bool is43 = false;
  bool is169 = false;
  String text = "";
  EditableTextItem? selectedItem;

  bool isQrCodeTap = false;

  double frontQRRotate = 0;
  double backQRRotate = 0;
  double selectedQrSize = 50.0;
  double qrFrontLogoSize = 0.2;
  double qrBackLogoSize = 0.2;
  double qrLogoSizeSelect = 0.2;
  // double frontImageRotate = 0;
  // double backImageRotate = 0;
  // Offset frontImagePosition = const Offset(100, 100);
  // Offset backImagePosition = const Offset(100, 100);
  // double frontImageRadius = 35.0;
  // double backImageRadius = 35.0;
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
  int frontDrawIndex = 0;
  int backDrawIndex = 0;
  bool isCardSaveLoader = false;
  bool isShareCard = false;
  String? frontFileName;
  String? backFileName;
  List<Uint8List> bytesList = [];
  bool isFrontShareCard = false;
  bool isBackShareCard = false;

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

  final List<String> fontFamilyList = [
    'Poppins',
    'Roboto',
    'Lobster',
    'Oswald',
    'Merriweather',
    "Lexend",
  ];

  List<double> qrSizeList = [
    50.0,
    60.0,
    70.0,
    80.0,
    90.0,
    100.0,
  ];

  List<double> textReSizeList = [
    8.0,
    9.0,
    10.0,
    11.0,
    12.0,
    13.0,
    14.0,
    15.0,
    16.0,
    17.0,
    18.0,
    19.0,
    20.0,
    21.0,
    22.0,
    23.0,
    24.0,
    25.0,
    26.0,
    27.0,
    28.0,
    29.0,
    30.0,
    31.0,
    32.0,
    33.0,
    34.0,
    35.0,
    36.0,
    37.0,
    38.0,
    39.0,
    40.0,
    41.0,
    42.0,
    43.0,
    44.0,
    45.0,
    46.0,
    47.0,
    48.0,
    49.0,
    50.0,
  ];

  List<double> qrLogoSizeList = [
    0.1,
    0.2,
    0.3,
    0.4,
    0.5,
  ];

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

  Future<void> qrPickLogo() {
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      final pickedFile = await picker.pickImage(
                                          source: ImageSource.camera);
                                      if (pickedFile != null) {
                                        setState(() {
                                          if (isFrontTap) {
                                            qrFrontLogo = pickedFile;
                                          } else {
                                            qrBackLogo = pickedFile;
                                          }
                                        });

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
                                        setState(() {
                                          if (isFrontTap) {
                                            qrFrontLogo = pickedFile;
                                          } else {
                                            qrBackLogo = pickedFile;
                                          }
                                        });
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

  var cropController = CropController(
    aspectRatio: 100.0 / 140.0,
    defaultCrop: const Rect.fromLTRB(0.05, 0.05, 0.95, 0.95),
  );

  Widget cropImage() {
    return CropImage(
      image: isFrontTap
          ? Image.asset(widget.frontSide)
          : Image.asset(widget.backSide),
      controller: cropController,
    );
  }

  Widget cropButton() {
    try {
      return SizedBox(
        height: 100,
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isFree = true;
                        isSquare = false;
                        is21 = false;
                        is12 = false;
                        is43 = false;
                        is169 = false;
                        cropController.aspectRatio = null;
                        cropController.crop =
                            const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9);
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.only(
                          top: 5, bottom: 5, left: 15, right: 15),
                      color: isFree == true ? whiteColor : transparentColor,
                      child: Text(
                        'free',
                        style: GoogleFonts.poppins(
                          color: isFree == true ? blackColor : whiteColor,
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isSquare = true;
                        isFree = false;
                        is21 = false;
                        is12 = false;
                        is43 = false;
                        is169 = false;
                        cropController.aspectRatio = 1.0;
                        cropController.crop =
                            const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9);
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.only(
                          top: 5, bottom: 5, left: 15, right: 15),
                      color: isSquare == true ? whiteColor : transparentColor,
                      child: Text(
                        'Square',
                        style: GoogleFonts.poppins(
                          color: isSquare == true ? blackColor : whiteColor,
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        is21 = true;
                        isFree = false;
                        isSquare = false;
                        is12 = false;
                        is43 = false;
                        is169 = false;
                        cropController.aspectRatio = 2.0;
                        cropController.crop =
                            const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9);
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.only(
                          top: 5, bottom: 5, left: 15, right: 15),
                      color: is21 == true ? whiteColor : transparentColor,
                      child: Text(
                        '2:1',
                        style: GoogleFonts.poppins(
                          color: is21 == true ? blackColor : whiteColor,
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        is12 = true;
                        isFree = false;
                        isSquare = false;
                        is21 = false;
                        is43 = false;
                        is169 = false;
                        cropController.aspectRatio = 1 / 2;
                        cropController.crop =
                            const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9);
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.only(
                        top: 5,
                        bottom: 5,
                        left: 15,
                        right: 15,
                      ),
                      color: is12 == true ? whiteColor : transparentColor,
                      child: Text(
                        '1:2',
                        style: GoogleFonts.poppins(
                          color: is12 == true ? blackColor : whiteColor,
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        is43 = true;
                        isFree = false;
                        isSquare = false;
                        is21 = false;
                        is12 = false;
                        is169 = false;
                        cropController.aspectRatio = 4 / 3;
                        cropController.crop =
                            const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9);
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.only(
                          top: 5, bottom: 5, left: 15, right: 15),
                      color: is43 == true ? whiteColor : transparentColor,
                      child: Text(
                        '4:3',
                        style: GoogleFonts.poppins(
                          color: is43 == true ? blackColor : whiteColor,
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        is169 = true;
                        isFree = false;
                        isSquare = false;
                        is21 = false;
                        is12 = false;
                        is43 = false;
                        cropController.aspectRatio = 16 / 9;
                        cropController.crop =
                            const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9);
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.only(
                          top: 5, bottom: 5, left: 15, right: 15),
                      color: is169 == true ? whiteColor : transparentColor,
                      child: Text(
                        '16:9',
                        style: GoogleFonts.poppins(
                          color: is169 == true ? blackColor : whiteColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: 1,
              color: whiteColor,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.close,
                    color: whiteColor,
                  ),
                  onPressed: () {
                    editController.isCropTap.value = false;
                    isFunctionTap = false;
                    setState(() {});
                  },
                ),
                TextButton(
                  onPressed: () async {
                    isFrontTap
                        ? frontCropImage = await cropController.croppedImage()
                        : backCropImage = await cropController.croppedImage();
                    editController.isCropImageDone.value = true;
                    editController.isCropTap.value = false;
                    isFunctionTap = false;
                    print(
                        "--------------- image Path --------- ${widget.backSide}");
                    setState(() {});
                  },
                  child: Text(
                    done,
                    style: GoogleFonts.poppins(
                      color: whiteColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    } catch (e) {
      print("--------------- Crop Button Error ----------- $e");
      return Container();
    }
  }

  Future<void> _saveCardToGallery(GlobalKey key) async {
    try {
      isCardSaveLoader = true;
      isImageTap = false;
      editController.show.value = false;
      setState(() {});

      await Future.delayed(const Duration(milliseconds: 300));

      RenderRepaintBoundary boundary =
          key.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      bytes = byteData!.buffer.asUint8List();

      final Directory? directory = await getExternalStorageDirectory();
      print("------- Folder Path ---------- $directory");
      if (!directory!.existsSync()) {
        await directory.create(recursive: true);
      }

      String fileName = "${DateTime.now().millisecondsSinceEpoch}.png";
      final File imageFile = File("${directory.path}/$fileName");
      await imageFile.writeAsBytes(bytes!);

      if (isFrontTap) {
        frontBytes = bytes;
      } else {
        backBytes = bytes;
      }

      print("-------- image File ------ ${imageFile.path}");
      // await GallerySaver.saveImage(imageFile.path,
          // albumName: "Festival Poster");
      imageSaveSuccessDialog(
        context,
        () {
          shareCard(bytes!, fileName);
          Navigator.of(context).pop();
        },
      );

      isCardSaveLoader = false;
      setState(() {});
    } catch (e) {
      print("-------- Save Image Error ------- $e");
      isCardSaveLoader = false;
      setState(() {});
    }
  }

  // Card Share
  Future<void> shareCard(Uint8List bytes, String filename) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/$filename');
      await file.writeAsBytes(bytes);
      // await ShareExtend.share(file.path, 'Visiting Card');
    } catch (e) {
      print("------------- Image Share Error ----------- $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: kPrimeryColor,
        title: Text(
          "Visiting Card",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: isFunctionTap == true
            ? IconButton(
                onPressed: () {
                  setState(() {
                    functionTap == 0
                        ? {
                            isFunctionTap = false,
                            editController.isTextTap.value = false,
                          }
                        : functionTap == 1
                            ? {
                                setState(() {
                                  isFunctionTap = false;
                                  editController.isCropTap.value = false;
                                }),
                              }
                            : functionTap == 2
                                ? {
                                    setState(() {
                                      isFunctionTap = false;
                                      isImageTap = false;
                                      if (isFrontTap) {
                                        editController.frontImage.value = null;
                                      } else {
                                        editController.backImage.value = null;
                                      }
                                    }),
                                  }
                                : functionTap == 3
                                    ? {
                                        setState(() {
                                          isFunctionTap = false;
                                          isDrawTap = false;
                                          if (isFrontTap) {
                                            frontDrawingController.clear();
                                          } else {}
                                          backDrawingController.clear();
                                        }),
                                      }
                                    : functionTap == 4
                                        ? {
                                            isFunctionTap = false,
                                            isQRTap = false,
                                            if (isFrontTap)
                                              {
                                                qrFrontController.text = "",
                                                qrFrontLogo = null,
                                                qrFrontSize = 50,
                                                qrCodeFrontColor = blackColor,
                                              }
                                            else
                                              {
                                                qrBackController.text = "",
                                                qrBackLogo = null,
                                                qrBackSize = 50,
                                                qrCodeBackColor = blackColor,
                                              },
                                            setState(() {}),
                                          }
                                        : null;
                  });
                },
                icon: const Icon(Icons.close),
              )
            : IconButton(
                onPressed: () {
                  setState(() {
                    isFrontTap = true;
                    isBackTap = false;

                    editController.backImage.value = null;
                    editController.frontImage.value = null;
                    editController.selectedFontFamily.value = "Poppins";
                    editController.isBoldIconTap.value = false;
                    editController.fontWeight.value = FontWeight.normal;
                    editController.isTextItalicIconTap.value = false;
                    editController.fontStyle.value = FontStyle.normal;
                    editController.isTextUnderLineIconTap.value = false;
                    editController.textDecoration.value = TextDecoration.none;
                    editController.isColorIconTap.value = false;
                    editController.textBlackColor.value = blackColor;
                    editController.isMoreIconTap.value = false;
                    editController.selectedFontSize.value = 16.0;
                    editController.selectedTitle.value = "Title";
                    editController.isTextTap.value = false;
                    editController.isCropTap.value = false;
                    editController.isCropImageDone.value = false;
                    isDrawTap = false;
                    isCardSaveLoader = false;
                    frontCropImage = null;
                    backCropImage = null;
                    frontTextItems = [];
                    backTextItems = [];
                    // editController.show.value = false;
                    editController.isTextTap.value = false;
                    editController.show.value = false;
                    editController.isImageShow.value = false;
                    editController.isLogoImageTap.value = false;
                    editController.pickLogos.clear();
                    editController.pickLogosCardFrontSide.clear();
                    editController.pickLogosCardBackSide.clear();
                    Get.offAll(
                      () => const BottomNavBarBar(),
                      transition: Transition.rightToLeftWithFade,
                    );
                  });
                },
                icon: const Icon(
                  Icons.arrow_back,
                ),
              ),
        actions: [
          // functionTap == 2
          //     ? IconButton(
          //         onPressed: () {
          //           isFunctionTap = true;
          //           isFrontTap ? frontImageRotate = 0 : backImageRotate = 0;
          //           pickLogoDialog(context);
          //           setState(() {});
          //         },
          //         icon: const Icon(Icons.add),
          //       )
          //     : Container(),
          isFunctionTap == true || editController.isEditIconTap.value == true
              ? editController.isCropTap.value == true
                  ? Container()
                  : IconButton(
                      onPressed: () {
                        functionTap == 0
                            ? {
                                isFunctionTap = false,
                                editController.isTextFieldTextAdd.value = false,
                                editController.isTextTap.value = false,
                                editController.show.value = false,
                                text = textController.text,
                                if (isFrontTap)
                                  {
                                    editController.isEditIconTap.value == true
                                        ? frontTextItems[selectedIndexCard!] =
                                            frontTextItems[selectedIndexCard!]
                                                .copyWith(
                                            text: text,
                                            color: editController
                                                .textBlackColor.value,
                                            fontSize: editController
                                                .selectedFontSize.value,
                                            fontWeight:
                                                editController.fontWeight.value,
                                            textDecoration: editController
                                                .textDecoration.value,
                                            fontStyle:
                                                editController.fontStyle.value,
                                            fontFamily: editController
                                                .selectedFontFamily.value,
                                          )
                                        : frontTextItems.add(
                                            EditableTextItem(
                                              position: const Offset(50, 50),
                                              rotation: 0,
                                              text: text,
                                              color: editController
                                                  .textBlackColor.value,
                                              fontSize: editController
                                                  .selectedFontSize.value,
                                              fontWeight: editController
                                                  .fontWeight.value,
                                              textDecoration: editController
                                                  .textDecoration.value,
                                              fontStyle: editController
                                                  .fontStyle.value,
                                              fontFamily: editController
                                                  .selectedFontFamily.value,
                                            ),
                                          ),
                                  }
                                else
                                  {
                                    editController.isEditIconTap.value == true
                                        ? backTextItems[selectedIndexCard!] =
                                            backTextItems[selectedIndexCard!]
                                                .copyWith(
                                            text: text,
                                            color: editController
                                                .textBlackColor.value,
                                            fontSize: editController
                                                .selectedFontSize.value,
                                            fontWeight:
                                                editController.fontWeight.value,
                                            textDecoration: editController
                                                .textDecoration.value,
                                            fontStyle:
                                                editController.fontStyle.value,
                                            fontFamily: editController
                                                .selectedFontFamily.value,
                                          )
                                        : backTextItems.add(
                                            EditableTextItem(
                                              position: const Offset(50, 50),
                                              rotation: 0,
                                              text: text,
                                              color: editController
                                                  .textBlackColor.value,
                                              fontSize: editController
                                                  .selectedFontSize.value,
                                              fontWeight: editController
                                                  .fontWeight.value,
                                              textDecoration: editController
                                                  .textDecoration.value,
                                              fontStyle: editController
                                                  .fontStyle.value,
                                              fontFamily: editController
                                                  .selectedFontFamily.value,
                                            ),
                                          ),
                                  },
                                textController.text = "",
                                editController.isEditIconTap.value = false,
                                setState(() {})
                              }
                            : functionTap == 1
                                ? {
                                    setState(() {
                                      isFunctionTap = false;
                                      editController.isCropImageDone.value =
                                          true;
                                      editController.isCropTap.value = false;
                                    }),
                                  }
                                : functionTap == 2
                                    ? {
                                        setState(() {
                                          isFunctionTap = false;
                                          isImageTap = false;
                                        }),
                                      }
                                    : functionTap == 3
                                        ? {
                                            setState(() {
                                              isFunctionTap = false;
                                              isDrawTap = false;
                                            }),
                                          }
                                        : functionTap == 4
                                            ? {
                                                setState(() {
                                                  isFunctionTap = false;
                                                  isQRTap = false;
                                                }),
                                              }
                                            : null;
                      },
                      icon: const Icon(
                        Icons.done,
                      ),
                    )
              : shareCardStates[isFrontTap] == true
                  ? Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: GestureDetector(
                        onTap: () {
                          shareCard(isFrontTap ? frontBytes! : backBytes!,
                              "${DateTime.now().millisecondsSinceEpoch}.png");

                          setState(() {
                            shareCardStates[isFrontTap] = true;
                          });
                        },
                        child: const Icon(
                          Icons.share,
                          color: whiteColor,
                        ),
                      ),
                    )
                  : IconButton(
                      onPressed: () async {
                        editController.show.value = false;
                        functionTap = -1;
                        await _saveCardToGallery(
                            isFrontTap ? frontKey : backKey);
                        setState(() {
                          shareCardStates[isFrontTap] = true;
                        });
                      },
                      icon: const Icon(Icons.save),
                    ),
        ],
      ),
      body: WillPopScope(
        onWillPop: () async {
          isFrontTap = true;
          isBackTap = false;
          isFunctionTap = false;
          isImageTap = false;
          isQRTap = false;
          editController.backImage.value = null;
          editController.frontImage.value = null;
          editController.selectedFontFamily.value = "Poppins";
          editController.isBoldIconTap.value = false;
          editController.fontWeight.value = FontWeight.normal;
          editController.isTextItalicIconTap.value = false;
          editController.fontStyle.value = FontStyle.normal;
          editController.isTextUnderLineIconTap.value = false;
          editController.textDecoration.value = TextDecoration.none;
          editController.isColorIconTap.value = false;
          editController.textBlackColor.value = blackColor;
          editController.isMoreIconTap.value = false;
          editController.selectedFontSize.value = 16.0;
          editController.selectedTitle.value = "Title";
          editController.isTextTap.value = false;
          editController.isCropTap.value = false;
          editController.isCropImageDone.value = false;
          editController.isTextTap.value = false;
          isDrawTap = false;
          isCardSaveLoader = false;
          frontCropImage = null;
          backCropImage = null;
          frontTextItems = [];
          backTextItems = [];
          editController.isTextTap.value = false;
          editController.show.value = false;
          editController.isImageShow.value = false;
          editController.isLogoImageTap.value = false;
          editController.pickLogos.clear();
          editController.pickLogosCardFrontSide.clear();
          editController.pickLogosCardBackSide.clear();
          Get.offAll(
            () => const BottomNavBarBar(),
            transition: Transition.rightToLeftWithFade,
          );
          return true;
        },
        child: Center(
          child: Stack(
            children: [
              selectedIndexCard == null ||
                      (isFrontTap
                              ? frontTextItems.length
                              : backTextItems.length) ==
                          0 ||
                      selectedIndexCard! < 0 ||
                      selectedIndexCard! >=
                          (isFrontTap
                              ? frontTextItems.length
                              : backTextItems.length)
                  ? Container()
                  : editController.show.value
                      ? textStyleChange(isFrontTap
                          ? frontTextItems[selectedIndexCard!]
                          : backTextItems[selectedIndexCard!])
                      : Container(),
              if (isFrontTap && isQRTap == true)
                qrFrontController.text != "" ? qrCodeFeture() : Container(),
              if (isBackTap && isQRTap == true)
                qrBackController.text != "" ? qrCodeFeture() : Container(),
              Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(
                          left: 20,
                          right: 20,
                          bottom: 10,
                        ),
                        decoration: BoxDecoration(
                          color: visitingCardBgColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        height: 0.55 * h,
                        width: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                color: visitingCardBgColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              height: 0.55 * h,
                              width: double.infinity,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  isFrontTap
                                      ? RepaintBoundary(
                                          key: frontKey,
                                          child: buildCardFront(),
                                        )
                                      : RepaintBoundary(
                                          key: backKey,
                                          child: buildCardBack(),
                                        ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      editController.isCropTap.value == false
                          ? Container(
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
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: const Color(0xffE9E9E9),
                                              ),
                                            ),
                                            InkWell(
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
                                                      fontWeight:
                                                          FontWeight.w600,
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
                                                alignment:
                                                    Alignment.centerRight,
                                                child: InkWell(
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
                                                          BorderRadius.circular(
                                                              10),
                                                      color: isBackTap == true
                                                          ? kPrimeryColor
                                                          : const Color(
                                                              0xffE9E9E9),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        backSide,
                                                        style:
                                                            GoogleFonts.poppins(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: isBackTap ==
                                                                  true
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
                          : Container(),
                    ],
                  ),
                ),
              ),
              editController.isCropTap.value
                  ? Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        color: kPrimeryColor,
                        child: cropButton(),
                      ),
                    )
                  : Container(),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  shareCardStates[isFrontTap] == true
                      ? Container()
                      : isFunctionTap == true
                          ? Container()
                          : SizedBox(
                              width: w,
                              child: Container(
                                height: 70,
                                color: kPrimeryColor,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: functionList.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        isFunctionTap = true;
                                        functionTap = index;
                                        functionTap == 0
                                            ? {
                                                textController.text = "",
                                                editController.isTextTap.value =
                                                    true,
                                                editController
                                                    .selectedFontFamily
                                                    .value = "Poppins",
                                                editController.selectedFontSize
                                                    .value = 16,
                                                editController.isColorIconTap
                                                    .value = false,
                                                editController.textBlackColor
                                                    .value = blackColor,
                                                editController.isBoldIconTap
                                                    .value = false,
                                                editController.fontWeight
                                                    .value = FontWeight.normal,
                                                editController
                                                    .isTextItalicIconTap
                                                    .value = false,
                                                editController.fontStyle.value =
                                                    FontStyle.normal,
                                                editController
                                                    .isTextUnderLineIconTap
                                                    .value = false,
                                                editController
                                                        .textDecoration.value =
                                                    TextDecoration.none,
                                                editController.isMoreIconTap
                                                    .value = false,
                                                editController
                                                    .isTextFieldTextAdd
                                                    .value = false,
                                                editController.isEditIconTap
                                                    .value = false,
                                                editController.focusNode
                                                    .requestFocus(),
                                              }
                                            : null;
                                        functionTap == 1
                                            ? editController.isCropTap.value =
                                                true
                                            : null;
                                        functionTap == 2
                                            ? {
                                                isImageTap = true,
                                              }
                                            : null;
                                        functionTap == 3
                                            ? {
                                                isDrawTap = true,
                                                isFrontTap
                                                    ? drawLineFrontColor =
                                                        blackColor
                                                    : drawLineBackColor =
                                                        blackColor,
                                              }
                                            : null;
                                        functionTap == 4
                                            ? {
                                                isQRTap = true,
                                                qrCodeFrontColor = blackColor,
                                                qrCodeBackColor = blackColor,
                                              }
                                            : null;
                                        setState(() {});
                                      },
                                      child: Center(
                                        child: Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 7),
                                          decoration: BoxDecoration(
                                            color: functionTap == index
                                                ? whiteColor
                                                : transparentColor,
                                          ),
                                          width: 70,
                                          child: Container(
                                            margin:
                                                const EdgeInsets.only(top: 5),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                  functionList[index]["image"]!,
                                                  scale: index == 0 ? 7.5 : 6.5,
                                                  color: functionTap == index
                                                      ? kEditFetureColor
                                                      : whiteColor,
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  functionList[index]["size"]!,
                                                  style: GoogleFonts.poppins(
                                                    color: functionTap == index
                                                        ? kEditFetureColor
                                                        : whiteColor,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize:
                                                        index == 0 ? 16 : 15,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                ],
              ),
              isImageTap == true
                  ? Obx(
                      () => Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            height: 80,
                            width: double.infinity,
                            decoration: const BoxDecoration(
                              color: logoAddContainerColor,
                            ),
                            child: ListView.builder(
                              padding: const EdgeInsets.only(
                                  right: 0, left: 15, bottom: 0),
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: editController.logotypeList.length,
                              itemBuilder: (context, index) {
                                return index != 0
                                    ? (isFrontTap
                                            ? editController.frontImage.value !=
                                                null
                                            : editController.backImage.value !=
                                                null)
                                        ? GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                isFrontTap
                                                    ? frontLogoShapeIndex
                                                        .value = index
                                                    : backLogoShapeIndex.value =
                                                        index;

                                                isFrontTap
                                                    ? editController
                                                                .pickLogosCardFrontSide[
                                                            selectedFrontLogoIndex] =
                                                        {
                                                        "image": editController
                                                                    .pickLogosCardFrontSide[
                                                                selectedFrontLogoIndex]
                                                            ["image"],
                                                        "shapeIndex":
                                                            frontLogoShapeIndex
                                                                .value,
                                                        "radius": editController
                                                                    .pickLogosCardFrontSide[
                                                                selectedFrontLogoIndex]
                                                            ["radius"],
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
                                                        "shapeIndex":
                                                            backLogoShapeIndex
                                                                .value,
                                                        "radius": editController
                                                                    .pickLogosCardBackSide[
                                                                selectedBackLogoIndex]
                                                            ["radius"],
                                                        "rotation": editController
                                                                    .pickLogosCardBackSide[
                                                                selectedBackLogoIndex]
                                                            ["rotation"],
                                                        "position": editController
                                                                    .pickLogosCardBackSide[
                                                                selectedBackLogoIndex]
                                                            ["position"],
                                                      };

                                                print(
                                                    "---------- Front Side List --------- ${editController.pickLogosCardFrontSide}");
                                                print(
                                                    "---------- Back Side List --------- ${editController.pickLogosCardBackSide}");
                                              });
                                            },
                                            child: Container(
                                              margin: const EdgeInsets.only(
                                                  right: 15),
                                              height: 20,
                                              width: 70,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(0.0),
                                                child: Image.asset(
                                                  editController
                                                      .logotypeList[index],
                                                  scale: 3,
                                                  color:
                                                      //  (isFrontTap
                                                      //         ? frontLogoShapeIndex
                                                      //                 .value ==
                                                      //             index
                                                      //         : backLogoShapeIndex
                                                      //                 .value ==
                                                      //             index)
                                                      (isFrontTap
                                                              ? editController.pickLogosCardFrontSide[
                                                                          selectedFrontLogoIndex]
                                                                      [
                                                                      "shapeIndex"] ==
                                                                  index
                                                              : editController.pickLogosCardBackSide[
                                                                          selectedBackLogoIndex]
                                                                      [
                                                                      "shapeIndex"] ==
                                                                  index)
                                                          ? kPrimeryColor
                                                          : null,
                                                ),
                                              ),
                                            ),
                                          )
                                        : Container()
                                    : Container(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 15),
                                        height: 100,
                                        width: 100,
                                        child: GestureDetector(
                                          onTap: () async {
                                            isFunctionTap = true;
                                            isFrontTap
                                                ? frontImageRotate = 0
                                                : backImageRotate = 0;
                                            await pickLogoDialog(context);
                                            isFrontTap
                                                ? frontLogoShapeIndex.value = 1
                                                : backLogoShapeIndex.value = 1;
                                            setState(() {});
                                          },
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
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
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(),
              isDrawTap == true
                  ? Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(10),
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
                                            ? frontDrawingController.setStyle(
                                                strokeWidth: v)
                                            : backDrawingController.setStyle(
                                                strokeWidth: v),
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
                                                ? frontDrawingController
                                                        .canUndo()
                                                    ? null
                                                    : Colors.grey
                                                : backDrawingController
                                                        .canUndo()
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
                                                ? frontDrawingController
                                                        .canRedo()
                                                    ? null
                                                    : Colors.grey
                                                : backDrawingController
                                                        .canRedo()
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
                      ],
                    )
                  : Container(),
              isDrawTap == true
                  ? Align(
                      alignment: Alignment.bottomCenter,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            height: 75,
                            width: w,
                            color: kPrimeryColor,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              primary: true,
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
                                                    .setPaintContent(
                                                        SmoothLine())
                                                : index == 2
                                                    ? frontDrawingController
                                                        .setPaintContent(
                                                            StraightLine())
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
                                                    .setPaintContent(
                                                        SmoothLine())
                                                : index == 2
                                                    ? backDrawingController
                                                        .setPaintContent(
                                                            StraightLine())
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
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(
                                          left: 18,
                                          right: 18,
                                          top: 5,
                                        ),
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: isFrontTap
                                              ? frontDrawIndex == index
                                                  ? kEditFetureBlueColor
                                                  : whiteColor
                                              : backDrawIndex == index
                                                  ? kEditFetureBlueColor
                                                  : whiteColor,
                                        ),
                                        child: Icon(
                                          drawList[index]["icon"],
                                          size: 20,
                                          color: isFrontTap
                                              ? frontDrawIndex == index
                                                  ? whiteColor
                                                  : blackColor
                                              : backDrawIndex == index
                                                  ? whiteColor
                                                  : blackColor,
                                        ),
                                      ),
                                      Text(
                                        drawList[index]["name"],
                                        style: GoogleFonts.poppins(
                                          color: whiteColor,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              },
                            ),
                          )
                        ],
                      ),
                    )
                  : Container(),
              editController.isTextTap.value == true
                  ? Obx(
                      () => Container(
                        child: textWidget(),
                      ),
                    )
                  : Container(),
              editController.isCropTap.value ? cropImage() : Container(),
              isQRTap == true
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(
                            left: 20,
                            right: 20,
                            top: 20,
                          ),
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Material(
                            elevation: 10,
                            borderRadius: BorderRadius.circular(10),
                            child: TextField(
                              controller: isFrontTap
                                  ? qrFrontController
                                  : qrBackController,
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide.none,
                                ),
                                prefixIcon: Icon(
                                  CupertinoIcons.link,
                                  color: Colors.grey[700],
                                ),
                                suffixIcon: (isFrontTap &&
                                            qrFrontController
                                                .text.isNotEmpty) ||
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
                      ],
                    )
                  : Container(),
              isCardSaveLoader == true
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: kPrimeryColor,
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  Widget qrCodeFeture() {
    return Column(
      children: [
        Container(
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
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 25),
                  height: 30,
                  width: 30,
                  child: ClipOval(
                    child: colorPickerQRCode(context),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                const VerticalDivider(
                  color: blackColor,
                  indent: 10,
                  endIndent: 10,
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 10),
                    width: 90,
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
                            isFrontTap
                                ? qrFrontSize = value
                                : qrBackSize = value;
                            selectedQrSize =
                                isFrontTap ? qrFrontSize : qrBackSize;
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
                ),
                const VerticalDivider(
                  color: blackColor,
                  indent: 10,
                  endIndent: 10,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 15, right: 15),
                  child: GestureDetector(
                    onTap: () {
                      qrPickLogo();
                    },
                    child: const Icon(Icons.image),
                  ),
                ),
                const VerticalDivider(
                  color: blackColor,
                  indent: 10,
                  endIndent: 10,
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 10, right: 10),
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
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildCardFront() {
    var h = MediaQuery.of(context).size.height;
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
            child: shareCardStates[isFrontTap] == true
                ? Center(
                    child: Image.memory(
                      frontBytes!,
                    ),
                  )
                : editController.isCropImageDone.value == true &&
                        frontCropImage != null
                    ? Center(
                        child: Image(
                          image: frontCropImage!.image,
                          fit: BoxFit.fill,
                        ),
                      )
                    : Image.asset(
                        widget.frontSide,
                        height: 0.235 * h,
                        fit: BoxFit.fill,
                      ),
          ),
        ),
        Align(
          child: SizedBox(
            height: 0.235 * h,
            child: DrawingBoard(
              controller: frontDrawingController,
              background: Container(
                width: 400,
                height: 400,
                color: transparentColor,
              ),
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
                  height: 0.235 * h,
                  width: 400,
                  color: transparentColor,
                ),
              )
            : Container(),
        for (int i = 0; i < frontTextItems.length; i++)
          buildEditableTextItem(frontTextItems[i], i, true, setState),
        if (editController.frontImage.value != null) logoImage(),
        // Obx(
        //   () => editController.frontImage.value != null
        //       // ? logoImage(editController.frontImage.value!)
        //       ? Container(
        //           // height: 0.235 * h,
        //           // width: 200,
        //           child: Row(
        //             children: List.generate(
        //               editController.pickLogosCardFrontSide.length,
        //               (index) {
        //                 print(
        //                     "----------- List Length --------- ${editController.pickLogosCardFrontSide.length}");
        //                 print(
        //                     "----------- List path --------- ${editController.pickLogosCardFrontSide[index]["image"]}");
        //                 return logoImage(
        //                   File(
        //                     editController.pickLogosCardFrontSide[index]
        //                         ["image"],
        //                   ),
        //                 );
        //               },
        //             ),
        //           ),
        //         )
        //       : Container(),
        // ),
        qrFrontController.text != "" || qrFrontController.text.isNotEmpty
            ? qrCodeItem(qrFrontLogo)
            : Container(),
      ],
    );
  }

  Widget buildCardBack() {
    var h = MediaQuery.of(context).size.height;
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
          child: shareCardStates[isFrontTap] == true
              ? Center(
                  child: Image.memory(
                    backBytes!,
                  ),
                )
              : Center(
                  child: editController.isCropImageDone.value == true &&
                          backCropImage != null
                      ? Center(
                          child: Image(
                            image: backCropImage!.image,
                            fit: BoxFit.fill,
                          ),
                        )
                      : Image.asset(
                          widget.backSide,
                          height: 0.235 * h,
                          fit: BoxFit.fill,
                        ),
                ),
        ),
        Align(
          child: SizedBox(
            height: 0.235 * h,
            child: DrawingBoard(
              controller: backDrawingController,
              background: Container(
                width: 400,
                height: 400,
                color: transparentColor,
              ),
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
                  height: 0.235 * h,
                  width: 400,
                  color: transparentColor,
                ),
              )
            : Container(),
        for (int i = 0; i < backTextItems.length; i++)
          buildEditableTextItem(backTextItems[i], i, false, setState),
        if (editController.backImage.value != null) logoImage(),
        // Obx(
        //   () => editController.backImage.value != null
        //       ? logoImage(editController.backImage.value!)
        //       : Container(),
        // ),
        qrBackController.text != "" || qrBackController.text.isNotEmpty
            ? qrCodeItem(qrBackLogo)
            : Container(),
        Container(),
      ],
    );
  }

  textWidget() {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        editController.isTextTap.value == true
            ? GestureDetector(
                onTap: () {
                  editController.isTextTap.value = true;
                },
                child: Container(
                  height: h,
                  width: w,
                  color: blackColor.withOpacity(0.5),
                ),
              )
            : Container(),
        editController.isTextTap.value == true
            ? SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 50),
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  editController.isTextTap.value = true;
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(
                                    left: 15,
                                    right: 15,
                                    top: 20,
                                    bottom: 5,
                                  ),
                                  height: 150,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: whiteColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: editController
                                              .isTextFieldTextAdd.value ==
                                          true
                                      ? Padding(
                                          padding: const EdgeInsets.only(
                                            left: 20,
                                            right: 20,
                                            bottom: 20,
                                          ),
                                          child: TextField(
                                            style: GoogleFonts.getFont(
                                              editController
                                                  .selectedFontFamily.value,
                                              fontSize: editController
                                                  .selectedFontSize.value,
                                              color: editController
                                                  .textBlackColor.value,
                                              fontWeight: editController
                                                  .fontWeight.value,
                                              decoration: editController
                                                  .textDecoration.value,
                                              fontStyle: editController
                                                  .fontStyle.value,
                                            ),
                                            decoration: const InputDecoration(
                                              border: InputBorder.none,
                                            ),
                                            focusNode: editController.focusNode,
                                            maxLines: null,
                                            cursorColor: kPrimeryColor,
                                            controller: textController,
                                          ),
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.only(
                                            top: 20,
                                            left: 20,
                                            right: 20,
                                            bottom: 20,
                                          ),
                                          child: GestureDetector(
                                            onTap: () {
                                              editController.isTextFieldTextAdd
                                                  .value = true;
                                            },
                                            child: Text(
                                              writeAText,
                                              style: GoogleFonts.poppins(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: greyColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                ),
                              ),
                              Positioned(
                                right: 5,
                                top: 2,
                                child: GestureDetector(
                                  onTap: () {
                                    editController.isTextTap.value = false;
                                    isFunctionTap = false;
                                    setState(() {});
                                  },
                                  child: Container(
                                    height: 32,
                                    width: 32,
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
                          editController.isTextFieldTextAdd.value == true
                              ? GestureDetector(
                                  onTap: () {
                                    editController.isTextTap.value = true;
                                  },
                                  child: Container(
                                    child: textFeture(
                                        context, setState, textController),
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            : Container(),
      ],
    );
  }

  Widget textStyleChange(EditableTextItem item) {
    var w = MediaQuery.of(context).size.width;
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
      width: w,
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
            DropdownButtonHideUnderline(
              child: Container(
                width: 90,
                padding: const EdgeInsets.only(left: 20),
                child: DropdownButton2<double>(
                  value: textReSizeList
                          .contains(editController.selectedFontSize.value)
                      ? editController.selectedFontSize.value
                      : null,
                  isExpanded: true,
                  isDense: false,
                  items: textReSizeList.map((e) {
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
                    item.fontSize = value!;
                    editController.selectedFontSize.value = item.fontSize;
                    setState(() {});
                  },
                  dropdownStyleData: DropdownStyleData(
                    width: 80,
                    maxHeight: 300,
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
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    item.rotation -= 0.1;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: const Icon(
                    Icons.rotate_left,
                    color: blackColor,
                    size: 25,
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    item.rotation += 0.1;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: const Icon(
                    Icons.rotate_right,
                    color: blackColor,
                    size: 25,
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  editController.isEditIconTap.value = true;
                  editController.isTextTap.value = true;
                  editController.isTextFieldTextAdd.value = true;
                  editController.isColorIconTap.value = false;
                  editController.isMoreIconTap.value = false;
                  isFunctionTap = true;
                  setState(() {
                    textController.text = item.text;
                    editController.selectedFontFamily.value = item.fontFamily;
                    editController.selectedFontSize.value = item.fontSize;
                    editController.textBlackColor.value = item.color;
                    editController.fontWeight.value = item.fontWeight;
                    editController.fontWeight.value == ui.FontWeight.bold
                        ? editController.isBoldIconTap.value = true
                        : editController.isBoldIconTap.value = false;
                    editController.textDecoration.value = item.textDecoration;
                    editController.textDecoration.value ==
                            TextDecoration.underline
                        ? editController.isTextUnderLineIconTap.value = true
                        : editController.isTextUnderLineIconTap.value = false;
                    editController.fontStyle.value = item.fontStyle;
                    editController.fontStyle.value == ui.FontStyle.italic
                        ? editController.isTextItalicIconTap.value = true
                        : editController.isTextItalicIconTap.value = false;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 5, left: 15),
                  child: const Icon(
                    Icons.edit,
                    color: blackColor,
                    size: 25,
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    if (isFrontTap) {
                      frontTextItems.removeAt(selectedIndexCard!);
                    } else {
                      backTextItems.removeAt(selectedIndexCard!);
                    }
                    editController.show.value = false;
                  });
                },
                child: const Icon(
                  Icons.close,
                  color: blackColor,
                  size: 25,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget logoImage(File image) {
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
  //             touchPositionFromCenter.direction - frontImageRotate
  //         : editController.offsetAngle.value =
  //             touchPositionFromCenter.direction - backImageRotate;
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
  //           ? frontImageRotate = touchPositionFromCenter.direction -
  //               editController.offsetAngle.value
  //           : backImageRotate = touchPositionFromCenter.direction -
  //               editController.offsetAngle.value;
  //     } else {
  //       double angle = isFrontTap ? frontImageRotate : backImageRotate;
  //       final rotatedDelta = Offset(
  //         details.delta.dx * cos(angle) - details.delta.dy * sin(angle),
  //         details.delta.dx * sin(angle) + details.delta.dy * cos(angle),
  //       );
  //       isFrontTap
  //           ? frontImagePosition += rotatedDelta
  //           : backImagePosition += rotatedDelta;
  //     }
  //     setState(() {});
  //   }

  //   resizeLogo(DragUpdateDetails details) {
  //     setState(() {
  //       isFrontTap
  //           ? frontImageRadius =
  //               (frontImageRadius + details.delta.dy).clamp(30.0, 70.0)
  //           : backImageRadius =
  //               (backImageRadius + details.delta.dy).clamp(30.0, 70.0);
  //       print(
  //           "-------- Image Logo Radius-------- ${isFrontTap ? frontImageRadius : backImageRadius}");
  //     });
  //   }

  //   return Positioned(
  //     left: isFrontTap ? frontImagePosition.dx : backImagePosition.dx,
  //     top: isFrontTap ? frontImagePosition.dy - 70 : backImagePosition.dy - 70,
  //     child: image.path.isEmpty
  //         ? Container()
  //         : Transform.rotate(
  //             angle: isFrontTap ? frontImageRotate : backImageRotate,
  //             child: SizedBox(
  //               child: Stack(
  //                 children: [
  //                   GestureDetector(
  //                     onPanStart: onPanStart,
  //                     onPanUpdate: onPanUpdate,
  //                     onTap: shareCardStates[isFrontTap] == true
  //                         ? null
  //                         : () {
  //                             isImageTap = !isImageTap;
  //                             setState(() {});
  //                           },
  //                     child: Container(
  //                       margin: const EdgeInsets.all(15),
  //                       decoration: BoxDecoration(
  //                         border: Border.all(
  //                           color: isImageTap
  //                               ? kEditFetureColor
  //                               : transparentColor,
  //                           width: 1,
  //                         ),
  //                       ),
  //                       child: Padding(
  //                         padding: const EdgeInsets.all(5.0),
  //                         child: (isFrontTap
  //                                 ? frontLogoShapeIndex.value == 1
  //                                 : backLogoShapeIndex.value == 1)
  //                             ? CircleAvatar(
  //                                 radius: isFrontTap
  //                                     ? frontImageRadius
  //                                     : backImageRadius,
  //                                 backgroundColor: transparentColor,
  //                                 child: Container(
  //                                   decoration: BoxDecoration(
  //                                     shape: BoxShape.circle,
  //                                     image: DecorationImage(
  //                                       image: FileImage(
  //                                         File(image.path),
  //                                       ),
  //                                       fit: BoxFit.fill,
  //                                     ),
  //                                   ),
  //                                 ),
  //                               )
  //                             : (isFrontTap
  //                                     ? frontLogoShapeIndex.value == 2
  //                                     : backLogoShapeIndex.value == 2)
  //                                 ? Container(
  //                                     height: isFrontTap
  //                                         ? frontImageRadius + 30
  //                                         : backImageRadius + 30,
  //                                     width: isFrontTap
  //                                         ? frontImageRadius + 30
  //                                         : backImageRadius + 30,
  //                                     decoration: BoxDecoration(
  //                                       image: DecorationImage(
  //                                         image: FileImage(
  //                                           File(image.path),
  //                                         ),
  //                                         fit: BoxFit.fill,
  //                                       ),
  //                                     ),
  //                                   )
  //                                 : (isFrontTap
  //                                         ? frontLogoShapeIndex.value == 3
  //                                         : backLogoShapeIndex.value == 3)
  //                                     ? ClipPath(
  //                                         clipper: TriangleClipper(),
  //                                         child: Image.file(
  //                                           File(image.path),
  //                                           fit: BoxFit.fill,
  //                                           height: isFrontTap
  //                                               ? frontImageRadius + 30
  //                                               : backImageRadius + 30,
  //                                           width: isFrontTap
  //                                               ? frontImageRadius + 30
  //                                               : backImageRadius + 30,
  //                                         ),
  //                                       )
  //                                     : (isFrontTap
  //                                             ? frontLogoShapeIndex.value == 4
  //                                             : backLogoShapeIndex.value == 4)
  //                                         ? Container(
  //                                             // height: imageSize / 2,
  //                                             // width: imageSize,
  //                                             height: isFrontTap
  //                                                 ? frontImageRadius + 30 / 5
  //                                                 : backImageRadius + 30 / 5,
  //                                             width: isFrontTap
  //                                                 ? frontImageRadius + 30
  //                                                 : backImageRadius + 30,
  //                                             decoration: BoxDecoration(
  //                                               image: DecorationImage(
  //                                                 image: FileImage(
  //                                                   File(image.path),
  //                                                 ),
  //                                                 fit: BoxFit.cover,
  //                                               ),
  //                                             ),
  //                                           )
  //                                         : (isFrontTap
  //                                                 ? frontLogoShapeIndex.value ==
  //                                                     5
  //                                                 : backLogoShapeIndex.value ==
  //                                                     5)
  //                                             ? ClipPath(
  //                                                 clipper: PolygonClipper(),
  //                                                 child: Image.file(
  //                                                   File(image.path),
  //                                                   fit: BoxFit.fill,
  //                                                   height: isFrontTap
  //                                                       ? frontImageRadius + 30
  //                                                       : backImageRadius + 30,
  //                                                   width: isFrontTap
  //                                                       ? frontImageRadius + 30
  //                                                       : backImageRadius + 30,
  //                                                 ),
  //                                               )
  //                                             : Container(),
  //                       ),
  //                     ),
  //                   ),

  //                   // top right
  //                   Positioned(
  //                     top: 5,
  //                     right: 5,
  //                     child: IgnorePointer(
  //                       child: Align(
  //                         alignment: Alignment.topRight,
  //                         child: isImageTap
  //                             ? Container(
  //                                 padding: const EdgeInsets.all(5),
  //                                 decoration: const BoxDecoration(
  //                                   shape: BoxShape.circle,
  //                                   color: kPrimeryColor,
  //                                 ),
  //                                 child: const Icon(
  //                                   Icons.flip_camera_android,
  //                                   color: whiteColor,
  //                                   size: 15,
  //                                 ),
  //                               )
  //                             : Container(),
  //                       ),
  //                     ),
  //                   ),

  //                   // top left
  //                   Positioned(
  //                     top: 5,
  //                     left: 5,
  //                     child: isImageTap
  //                         ? GestureDetector(
  //                             onTap: () {
  //                               setState(() {
  //                                 isFrontTap
  //                                     ? editController.frontImage.value = null
  //                                     : editController.backImage.value = null;
  //                               });
  //                             },
  //                             child: Container(
  //                               padding: const EdgeInsets.all(5),
  //                               decoration: const BoxDecoration(
  //                                 shape: BoxShape.circle,
  //                                 color: kPrimeryColor,
  //                               ),
  //                               child: const Icon(
  //                                 Icons.delete,
  //                                 color: whiteColor,
  //                                 size: 13,
  //                               ),
  //                             ),
  //                           )
  //                         : Container(),
  //                   ),

  //                   // bottom right
  //                   Positioned(
  //                     bottom: 5,
  //                     right: 5,
  //                     child: isImageTap
  //                         ? Container(
  //                             decoration: const BoxDecoration(
  //                               color: kPrimeryColor,
  //                               shape: BoxShape.circle,
  //                             ),
  //                             child: GestureDetector(
  //                               onPanUpdate: resizeLogo,
  //                               child: Stack(
  //                                 alignment: Alignment.center,
  //                                 children: [
  //                                   Padding(
  //                                     padding: const EdgeInsets.all(5.0),
  //                                     child: GestureDetector(
  //                                       onTap: () {
  //                                         editController.isSizeIconTap.value =
  //                                             true;
  //                                       },
  //                                       child: const Icon(
  //                                         Icons.open_in_full_outlined,
  //                                         color: whiteColor,
  //                                         size: 13,
  //                                       ),
  //                                     ),
  //                                   ),
  //                                 ],
  //                               ),
  //                             ),
  //                           )
  //                         : Container(),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //   );
  // }

  Widget logoImage() {
    var h = MediaQuery.of(context).size.height;

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
      height: 0.235 * h,
      child: Stack(
        children: List.generate(
            isFrontTap
                ? editController.pickLogosCardFrontSide.length
                : editController.pickLogosCardBackSide.length, (index) {
          final logo = isFrontTap
              ? editController.pickLogosCardFrontSide[index]["image"]
              : editController.pickLogosCardBackSide[index]["image"];

          return Positioned(
            left: isFrontTap
                ? editController.pickLogosCardFrontSide[index]["position"].dx
                : editController.pickLogosCardBackSide[index]["position"].dx,
            // top: isFrontTap ? frontImagePosition.dy - 70 : backImagePosition.dy - 70,
            top: isFrontTap
                ? editController.pickLogosCardFrontSide[index]["position"].dy -
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
                      onTap: () {
                        setState(() {
                          isFrontTap
                              ? selectedFrontLogoIndex = index
                              : selectedBackLogoIndex = index;
                          isImageTap = true;
                          isFunctionTap = true;
                          setState(() {});
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isImageTap &&
                                    (isFrontTap
                                        ? selectedFrontLogoIndex == index
                                        : selectedBackLogoIndex == index)
                                ? kEditFetureColor
                                : transparentColor,
                            width: 1,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child:
                              //  (isFrontTap
                              //         ? frontLogoShapeIndex.value == 1
                              //         : backLogoShapeIndex.value == 1)
                              (isFrontTap
                                      ? editController.pickLogosCardFrontSide[index]
                                              ["shapeIndex"] ==
                                          1
                                      : editController.pickLogosCardBackSide[index]
                                              ["shapeIndex"] ==
                                          1)
                                  ? CircleAvatar(
                                      radius: isFrontTap
                                          ? editController
                                                  .pickLogosCardFrontSide[index]
                                              ["radius"]
                                          : editController
                                                  .pickLogosCardBackSide[index]
                                              ["radius"],
                                      backgroundColor: transparentColor,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                            image: FileImage(
                                              File(logo),
                                            ),
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                    )
                                  :
                                  // (isFrontTap
                                  //         ? frontLogoShapeIndex.value == 2
                                  //         : backLogoShapeIndex.value == 2)
                                  (isFrontTap
                                          ? editController.pickLogosCardFrontSide[index]
                                                  ["shapeIndex"] ==
                                              2
                                          : editController.pickLogosCardBackSide[index]
                                                  ["shapeIndex"] ==
                                              2)
                                      ? Container(
                                          height: isFrontTap
                                              ? editController
                                                          .pickLogosCardFrontSide[
                                                      index]["radius"] +
                                                  30
                                              : editController
                                                          .pickLogosCardBackSide[
                                                      index]["radius"] +
                                                  30,
                                          width: isFrontTap
                                              ? editController
                                                          .pickLogosCardFrontSide[
                                                      index]["radius"] +
                                                  30
                                              : editController
                                                          .pickLogosCardBackSide[
                                                      index]["radius"] +
                                                  30,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: FileImage(
                                                File(logo),
                                              ),
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        )
                                      :
                                      // (isFrontTap
                                      //         ? frontLogoShapeIndex.value == 3
                                      //         : backLogoShapeIndex.value == 3)
                                      (isFrontTap
                                              ? editController.pickLogosCardFrontSide[index]
                                                      ["shapeIndex"] ==
                                                  3
                                              : editController.pickLogosCardBackSide[index]
                                                      ["shapeIndex"] ==
                                                  3)
                                          ? ClipPath(
                                              clipper: TriangleClipper(),
                                              child: Image.file(
                                                File(logo),
                                                fit: BoxFit.fill,
                                                height: isFrontTap
                                                    ? editController
                                                                .pickLogosCardFrontSide[
                                                            index]["radius"] +
                                                        30
                                                    : editController
                                                                .pickLogosCardBackSide[
                                                            index]["radius"] +
                                                        30,
                                                width: isFrontTap
                                                    ? editController
                                                                .pickLogosCardFrontSide[
                                                            index]["radius"] +
                                                        30
                                                    : editController
                                                                .pickLogosCardBackSide[
                                                            index]["radius"] +
                                                        30,
                                              ),
                                            )
                                          :
                                          // (isFrontTap
                                          //         ? frontLogoShapeIndex.value == 4
                                          //         : backLogoShapeIndex.value == 4)
                                          (isFrontTap
                                                  ? editController.pickLogosCardFrontSide[index]
                                                          ["shapeIndex"] ==
                                                      4
                                                  : editController
                                                              .pickLogosCardBackSide[index]
                                                          ["shapeIndex"] ==
                                                      4)
                                              ? Container(
                                                  height: isFrontTap
                                                      ? editController
                                                                  .pickLogosCardFrontSide[
                                                              index]["radius"] +
                                                          30 / 5
                                                      : editController
                                                                  .pickLogosCardBackSide[
                                                              index]["radius"] +
                                                          30 / 5,
                                                  width: isFrontTap
                                                      ? editController
                                                                  .pickLogosCardFrontSide[
                                                              index]["radius"] +
                                                          30
                                                      : editController
                                                                  .pickLogosCardBackSide[
                                                              index]["radius"] +
                                                          30,
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                      image:
                                                          FileImage(File(logo)),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                )
                                              :
                                              // (isFrontTap
                                              //         ? frontLogoShapeIndex.value == 5
                                              //         : backLogoShapeIndex.value == 5)
                                              (isFrontTap
                                                      ? editController.pickLogosCardFrontSide[index]["shapeIndex"] == 5
                                                      : editController.pickLogosCardBackSide[index]["shapeIndex"] == 5)
                                                  ? ClipPath(
                                                      clipper: PolygonClipper(),
                                                      child: Image.file(
                                                        File(logo),
                                                        fit: BoxFit.fill,
                                                        height: isFrontTap
                                                            ? editController.pickLogosCardFrontSide[
                                                                        index]
                                                                    ["radius"] +
                                                                30
                                                            : editController.pickLogosCardBackSide[
                                                                        index]
                                                                    ["radius"] +
                                                                30,
                                                        width: isFrontTap
                                                            ? editController.pickLogosCardFrontSide[
                                                                        index]
                                                                    ["radius"] +
                                                                30
                                                            : editController.pickLogosCardBackSide[
                                                                        index]
                                                                    ["radius"] +
                                                                30,
                                                      ),
                                                    )
                                                  : Container(),
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
                        child: isImageTap &&
                                (isFrontTap
                                    ? selectedFrontLogoIndex == index
                                    : selectedBackLogoIndex == index)
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
                    child: isImageTap &&
                            (isFrontTap
                                ? selectedFrontLogoIndex == index
                                : selectedBackLogoIndex == index)
                        ? GestureDetector(
                            onTap: () {
                              setState(() {
                                // isFrontTap
                                //     ? editController.frontImage.value = null
                                //     : editController.backImage.value = null;
                                isFrontTap
                                    ? editController.pickLogosCardFrontSide
                                        .removeAt(index)
                                    : editController.pickLogosCardBackSide
                                        .removeAt(index);
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
                    child: isImageTap &&
                            (isFrontTap
                                ? selectedFrontLogoIndex == index
                                : selectedBackLogoIndex == index)
                        ? Container(
                            decoration: const BoxDecoration(
                              color: kPrimeryColor,
                              shape: BoxShape.circle,
                            ),
                            child: GestureDetector(
                              onPanUpdate: resizeLogo,
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
        }),
      ),
    );
  }

  Widget qrCodeItem(XFile? qrLogo) {
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
                                  image: FileImage(
                                    File(qrLogo.path),
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
}
