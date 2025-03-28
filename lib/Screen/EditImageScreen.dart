import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';
import 'package:crop_image/crop_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:photo_frame/Contstant/AppColor.dart';
import 'package:photo_frame/Contstant/getXController.dart';
import 'package:photo_frame/Contstant/itemModel.dart';
import 'package:photo_frame/Contstant/CommonMethod.dart';
import 'package:photo_frame/Screen/BottomNavBar.dart';
import 'package:photo_frame/Screen/HomePage.dart';
import 'package:photo_view/photo_view.dart';
import 'package:share_extend/share_extend.dart';

EditController editController = Get.put(EditController());
Rxn<int> selectedIndexPost = Rxn();
Rxn<int> selectedImageIndex = Rxn();

class EditImageScreen extends StatefulWidget {
  final cropImage;
  final wallPaper;
  final image;
  const EditImageScreen({
    super.key,
    required this.cropImage,
    required this.wallPaper,
    required this.image,
  });

  @override
  State<EditImageScreen> createState() => _EditImageScreenState();
}

class _EditImageScreenState extends State<EditImageScreen> {
  Image? image;
  Uint8List? bytes;
  String text = "";
  Item? selectedItem;
  TransformationController transformationController =
      TransformationController();

  String duplicate = "";

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

  Widget filterContainer() {
    var w = MediaQuery.of(context).size.width;
    return Column(
      children: [
        const Divider(
          thickness: 0.2,
          color: Colors.grey,
        ),
        SizedBox(
          height: 140,
          width: w,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            scrollDirection: Axis.horizontal,
            children: [
              filterWidget(Colors.transparent, "Normal", widget.image, 90, 110),
              filterWidget(
                  blackColor.withOpacity(0.4), "Lo-fi", widget.image, 90, 110),
              filterWidget(const Color(0xffEDEDED).withOpacity(0.2), "Inkwell",
                  widget.image, 90, 110),
              filterWidget(const Color(0xffFED914).withOpacity(0.18), "Warm",
                  widget.image, 90, 110),
              filterWidget(const Color(0xff9F2860).withOpacity(0.42), "Pop",
                  widget.image, 90, 110),
              filterWidget(const Color(0xff5DE147).withOpacity(0.2), "Nature",
                  widget.image, 90, 110),
              // filterWidget(
              //     blackColor.withOpacity(0.58), "B&W", widget.image, 90, 110),
              ColorFiltered(
                colorFilter: const ColorFilter.matrix([
                  0.2126, 0.7152, 0.0722, 0, 0, // Red
                  0.2126, 0.7152, 0.0722, 0, 0, // Green
                  0.2126, 0.7152, 0.0722, 0, 0, // Blue
                  0, 0, 0, 1, 0, // Alpha
                ]),
                child: filterWidget(
                    // const HSLColor.fromAHSL(0.0, 0.5, 1.0, 0.5).toColor(),
                    Colors.black.withOpacity(0.05),
                    "B&W",
                    widget.image,
                    90,
                    110),
              ),
              filterWidget(const Color(0xff00A3FF).withOpacity(0.5), "Icy",
                  widget.image, 90, 110),
              filterWidget(const Color(0xffD49029).withOpacity(0.2), "Ludwig",
                  widget.image, 90, 110),
              filterWidget(const Color(0xff0066FF).withOpacity(0.2), "Ocean",
                  widget.image, 90, 110),
            ],
          ),
        ),
      ],
    );
  }

  var controller = CropController(
    aspectRatio: 100.0 / 140.0,
    defaultCrop: const Rect.fromLTRB(0.05, 0.05, 0.95, 0.95),
  );

  Widget cropImage() {
    return CropImage(
      image: Image.asset(widget.wallPaper),
      controller: controller,
    );
  }

  Widget cropButton() {
    try {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              editController.isCropTap.value = false;
            },
          ),
          IconButton(
            icon: const Icon(Icons.aspect_ratio),
            onPressed: _aspectRatios,
          ),
          IconButton(
            icon: const Icon(Icons.rotate_90_degrees_ccw_outlined),
            onPressed: _rotateLeft,
          ),
          IconButton(
            icon: const Icon(Icons.rotate_90_degrees_cw_outlined),
            onPressed: _rotateRight,
          ),
          TextButton(
            onPressed: () async {
              image = await controller.croppedImage();
              editController.isCropImageDone.value = true;
              editController.isCropTap.value = false;
              print("--------------- image Path --------- $image");
              setState(() {});
            },
            child: const Text('Done'),
          ),
        ],
      );
    } catch (e) {
      print("--------------- Crop Button Error ----------- $e");
      return Container();
    }
  }

  Future<void> _aspectRatios() async {
    final value = await showDialog<double>(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('Select aspect ratio'),
          children: [
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, -1.0),
              child: const Text('free'),
            ),
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, 1.0),
              child: const Text('square'),
            ),
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, 2.0),
              child: const Text('2:1'),
            ),
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, 1 / 2),
              child: const Text('1:2'),
            ),
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, 4.0 / 3.0),
              child: const Text('4:3'),
            ),
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, 16.0 / 9.0),
              child: const Text('16:9'),
            ),
          ],
        );
      },
    );
    if (value != null) {
      controller.aspectRatio = value == -1 ? null : value;
      controller.crop = const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9);
    }
  }

  Future<void> _rotateLeft() async => controller.rotateLeft();

  Future<void> _rotateRight() async => controller.rotateRight();

  Widget imageContrast() {
    return Obx(
      () => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ColorFiltered(
            colorFilter: ColorFilter.matrix(
              _contrastMatrix(editController.contrast.value),
            ),
          ),
          SizedBox(
            height: 80,
            child: Theme(
              data: ThemeData(
                sliderTheme: const SliderThemeData(
                  showValueIndicator: ShowValueIndicator.always,
                ),
              ),
              child: Slider(
                activeColor: kPrimeryColor,
                value: editController.contrast.value,
                min: 0.0,
                max: 2.0,
                label: editController.contrast.value.toStringAsFixed(2),
                onChanged: (value) {
                  editController.contrast.value = value;
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<double> _contrastMatrix(double contrast) {
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

  Widget imageRotate() {
    return Obx(
      () => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Transform.rotate(
            angle: editController.angle.value,
          ),
          SizedBox(
            height: 80,
            child: Theme(
              data: ThemeData(
                sliderTheme: const SliderThemeData(
                  showValueIndicator: ShowValueIndicator.always,
                ),
              ),
              child: Slider(
                activeColor: kPrimeryColor,
                value: editController.angle.value,
                min: -6.283,
                max: 6.283,
                // label: "1",
                label:
                    "${(editController.angle.value * (180 / pi)).toStringAsFixed(1)}°",

                onChanged: (value) {
                  editController.angle.value = value;
                },
              ),
            ),
          ),
          // Text(
          //   '${(editController.angle.value * (180 / pi)).toStringAsFixed(1)}°',
          //   style: TextStyle(fontSize: 15), // Adjust the style as needed
          // ),
        ],
      ),
    );
  }

  Widget imageSizeBoxFit() {
    var h = MediaQuery.of(context).size.height;
    return Container(
      height: 95,
      color: kPrimeryColor,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        scrollDirection: Axis.horizontal,
        itemCount: editController.sizeList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(12),
            child: GestureDetector(
              onTap: () {
                editController.sizeTap.value = index;
                editController.imageHeight.value = index == 0
                    ? double.infinity
                    : index == 1
                        ? 0.65 * h
                        : index == 2
                            ? 0.6 * h
                            : index == 3
                                ? 0.65 * h
                                : index == 4
                                    ? 0.62 * h
                                    : 0.5 * h;
              },
              child: Obx(
                () => Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: editController.sizeTap.value == index
                            ? kEditFetureBlueColor
                            : whiteColor,
                      ),
                      height: 40,
                      width: 40,
                      child: Image.asset(
                        editController.sizeList[index]["image"]!,
                        scale: 5,
                        color: editController.sizeTap.value == index
                            ? whiteColor
                            : blackColor,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      editController.sizeList[index]["size"]!,
                      style: GoogleFonts.poppins(
                        color: whiteColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // Logo Image Add
  Widget logoImageAdd() {
    return Container(
      height: 100,
      width: double.infinity,
      decoration: BoxDecoration(
        color: logoAddContainerColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListView.builder(
        padding: const EdgeInsets.only(right: 0, left: 15, bottom: 0),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: editController.logotypeList.length,
        itemBuilder: (context, index) {
          return index != 0
              ? Obx(() {
                  if (editController.pickLogos.isNotEmpty) {
                    if (selectedImageIndex.value! <
                        editController.pickLogos.length) {
                      return GestureDetector(
                        onTap: () {
                          editController.pickLogos[selectedImageIndex.value!] =
                              {
                            "image": editController
                                .pickLogos[selectedImageIndex.value!]["image"],
                            "shapeIndex": index.obs,
                          };
                          print(
                              "---------- Shape Index ----------- ${selectedImageIndex.value}");
                          print(
                              "---------- Pick Logo List ----------- ${editController.pickLogos}");
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 15),
                          height: 20,
                          width: 70,
                          child: Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: Image.asset(
                              editController.logotypeList[index],
                              scale: 3,
                              color: editController
                                          .pickLogos[selectedImageIndex.value!]
                                              ["shapeIndex"]
                                          .value ==
                                      index
                                  ? kPrimeryColor
                                  : null,
                            ),
                          ),
                        ),
                      );
                    }
                  } else {
                    return Container();
                  }
                  return Container();
                })
              : Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  height: 100,
                  width: 100,
                  child: GestureDetector(
                    onTap: () async {
                      // editController.logoIndex.value = 1;
                      editController.isImageShow.value = true;
                      await pickLogoDialog(context);
                      selectedImageIndex.value = 1;
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: kPrimeryColor),
                        shape: BoxShape.circle,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.add,
                            color: kPrimeryColor,
                            size: 20,
                          ),
                          Text(
                            "Add Logo",
                            style: GoogleFonts.poppins(
                              // fontSize: 16,
                              fontSize: 10,
                              color: kPrimeryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
        },
      ),
    );
  }

  Future<void> _saveImageToGallery(GlobalKey key) async {
    try {
      editController.show.value = false;
      editController.isImageShow.value = false;
      editController.isImageSaveLoader.value = true;

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

      String fileName = "${DateTime.now()}_$templateName.jpg";
      final File imageFile = File("${directory.path}/$fileName");
      await imageFile.writeAsBytes(bytes!);

      print("-------- image File ------ ${imageFile.path}");
      await GallerySaver.saveImage(imageFile.path,
          albumName: "Festival Poster");
      editController.isImageSaveLoader.value = false;
      imageSaveSuccessDialog(
        context,
        () {
          shareImage(bytes!, fileName);
          Navigator.of(context).pop();
        },
      );
    } catch (e) {
      print("-------- Save Image Error ------- $e");
      editController.isImageSaveLoader.value = false;
    }
  }

  // Image Share
  Future<void> shareImage(Uint8List bytes, String filename) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/$filename');
      await file.writeAsBytes(bytes);
      await ShareExtend.share(file.path, 'image');
    } catch (e) {
      print("------------- Image Share Error ----------- $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    GlobalKey globalKey = GlobalKey();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: kPrimeryColor,
        centerTitle: true,
        title: Text(
          "Preview",
          style: GoogleFonts.poppins(
            color: whiteColor,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: Obx(
          () => editController.isFilterTap.value == true ||
                  editController.isTextTap.value == true ||
                  editController.isCropTap.value == true ||
                  editController.isContrastTap.value == true ||
                  editController.isRotateTap.value == true ||
                  editController.isSizeBoxTap.value == true ||
                  editController.isLogoImageTap.value == true ||
                  editController.isImageShow.value == true
              ? GestureDetector(
                  onTap: () {
                    editController.isFilterTap.value == true
                        ? {
                            editController.isFilterTap.value = false,
                            editController.filterContainerColor.value =
                                transparentColor,
                          }
                        : null;

                    editController.isTextTap.value == true
                        ? {
                            editController.textController.value.text = "",
                            editController.isTextTap.value = false,
                            editController.textBlackColor.value = blackColor,
                          }
                        : null;

                    editController.isCropTap.value == true
                        ? {
                            editController.isCropTap.value = false,
                          }
                        : null;

                    editController.isContrastTap.value == true
                        ? {
                            editController.isContrastTap.value = false,
                            editController.contrast.value = 1.0,
                          }
                        : null;

                    editController.isRotateTap.value == true
                        ? {
                            editController.isRotateTap.value = false,
                            editController.angle.value = 0.0,
                          }
                        : null;

                    editController.isSizeBoxTap.value == true
                        ? {
                            editController.isSizeBoxTap.value = false,
                            editController.sizeTap.value = 0,
                            editController.imageFit.value = BoxFit.fill,
                            editController.imageHeight.value = double.infinity,
                          }
                        : editController.isLogoImageTap.value == true
                            ? {
                                editController.isLogoImageTap.value = false,
                                editController.isImageShow.value = false,
                                editController.pickLogos.removeLast(),
                              }
                            : null;
                  },
                  child: const Icon(
                    Icons.close,
                    color: whiteColor,
                  ),
                )
              : GestureDetector(
                  onTap: () {
                    isPatrioticImageTap = false;
                    isFestivalImageTap = false;
                    isSpecialImageTap = false;
                    editController.functionTap.value = -1;
                    editController.isFilterTap.value = false;
                    editController.textController.value.text = "";
                    editController.isTextTap.value = false;
                    editController.isCropImageDone.value = false;
                    image = null;
                    editController.isCropTap.value = false;
                    editController.filterContainerColor.value =
                        transparentColor;
                    editController.isContrastTap.value = false;
                    editController.contrast.value = 1.0;
                    editController.isRotateTap.value = false;
                    editController.angle.value = 0.0;
                    editController.isSizeBoxTap.value = false;
                    editController.sizeTap.value = 0;
                    editController.imageFit.value = BoxFit.fill;
                    editController.imageHeight.value = double.infinity;
                    editController.isLogoImageTap.value = false;
                    editController.logoIndex.value = 1;
                    editController.textBlackColor.value = blackColor;
                    editController.isColorIconTap.value = false;
                    editController.isMoreIconTap.value = false;
                    editController.selectedFontSize.value = 16.0;
                    editController.selectedTitle.value = "Title";
                    editController.isBoldIconTap.value = false;
                    editController.fontWeight.value = FontWeight.normal;
                    editController.isTextItalicIconTap.value = false;
                    editController.fontStyle.value = FontStyle.normal;
                    editController.isTextUnderLineIconTap.value = false;
                    editController.textDecoration.value = TextDecoration.none;
                    editController.selectedFontFamily.value = "Poppins";
                    selectedIndexPost.value = null;
                    selectedItem = null;
                    editController.isImageSaveLoader.value = false;
                    editController.isShareImage.value = false;
                    editController.frontImage.value = null;
                    editController.backImage.value = null;
                    editController.items.clear();
                    editController.pickLogos.clear();
                    editController.pickLogosCardFrontSide.clear();
                    editController.pickLogosCardBackSide.clear();
                    isSliderImageTap = false;
                    editController.checkBoxValue.value = false;
                    Get.offAll(
                      transition: Transition.rightToLeftWithFade,
                      () => const BottomNavBarBar(),
                    );

                    setState(() {});
                  },
                  child: const Icon(
                    Icons.arrow_back_rounded,
                    color: whiteColor,
                  ),
                ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Obx(
              () => editController.isShareImage.value == false
                  ? GestureDetector(
                      onTap: () async {
                        await _saveImageToGallery(globalKey);
                        editController.pickLogos.clear();

                        editController.isShareImage.value = true;
                      },
                      child: editController.isFilterTap.value == true ||
                              editController.isTextTap.value == true ||
                              editController.isContrastTap.value == true ||
                              editController.isRotateTap.value == true ||
                              editController.isSizeBoxTap.value == true ||
                              editController.isLogoImageTap.value == true ||
                              editController.isImageShow.value == true
                          ? IconButton(
                              onPressed: () async {
                                editController.isFilterTap.value == true
                                    ? {
                                        editController.isFilterTap.value =
                                            false,
                                      }
                                    : null;

                                editController.isTextTap.value == true
                                    ? {
                                        editController.isTextTap.value = false,
                                        text = editController
                                            .textController.value.text,
                                        editController.isEditIconTap.value ==
                                                true
                                            ? editController.items[
                                                    selectedIndexPost.value!] =
                                                Item(
                                                parentKey:
                                                    selectedItem!.parentKey,
                                                size: selectedItem!.size,
                                                offset: selectedItem!.offset,
                                                rotation:
                                                    selectedItem!.rotation,
                                                text: text,
                                                textColor: editController
                                                    .textBlackColor.value,
                                                fontSize: editController
                                                    .selectedFontSize.value,
                                                fontWeight: editController
                                                    .fontWeight.value,
                                                textDecoration: editController
                                                    .textDecoration.value,
                                                fontStyle: editController
                                                    .fontStyle.value,
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
                                                    .backgroundStrokeColor
                                                    .value,
                                              )
                                            : editController.items.add(
                                                Item(
                                                  parentKey: GlobalKey(),
                                                  size: const Size(100, 100),
                                                  offset:
                                                      const Offset(100, 100),
                                                  rotation: 0,
                                                  text: text,
                                                  textColor: editController
                                                      .textBlackColor.value,
                                                  fontSize: editController
                                                      .selectedFontSize.value,
                                                  fontWeight: editController
                                                      .fontWeight.value,
                                                  textDecoration: editController
                                                      .textDecoration.value,
                                                  fontStyle: editController
                                                      .fontStyle.value,
                                                  selectTitle: editController
                                                      .selectedTitle.value,
                                                  fontFamily: editController
                                                      .selectedFontFamily.value,
                                                  isStrokeCheck: editController
                                                      .checkBoxValue.value,
                                                  strokeWidth: editController
                                                      .selectedStrokeWidth
                                                      .value,
                                                  forgroundColor: editController
                                                      .forgroundStrokeColor
                                                      .value,
                                                  backgroundColor:
                                                      editController
                                                          .backgroundStrokeColor
                                                          .value,
                                                ),
                                              ),
                                        editController
                                            .textController.value.text = "",
                                        editController.isEditIconTap.value =
                                            false,
                                      }
                                    : null;

                                editController.isCropTap.value == true
                                    ? {
                                        editController.isCropTap.value = false,
                                      }
                                    : null;

                                editController.isContrastTap.value == true
                                    ? {
                                        editController.isContrastTap.value =
                                            false,
                                      }
                                    : null;

                                editController.isRotateTap.value == true
                                    ? {
                                        editController.isRotateTap.value =
                                            false,
                                      }
                                    : null;

                                editController.isSizeBoxTap.value == true
                                    ? {
                                        editController.isSizeBoxTap.value =
                                            false,
                                      }
                                    : editController.isLogoImageTap.value ==
                                            true
                                        ? {
                                            editController
                                                .isLogoImageTap.value = false,
                                            editController.isImageShow.value =
                                                false,
                                          }
                                        : null;
                              },
                              icon: const Icon(
                                Icons.done,
                                color: whiteColor,
                              ),
                            )
                          : editController.isCropTap.value == true
                              ? Container()
                              : Image.asset(
                                  "assets/images/printIcon.png",
                                  scale: 5,
                                ),
                    )
                  : GestureDetector(
                      onTap: () {
                        editController.isShareImage.value = true;
                        shareImage(bytes!,
                            "${DateTime.now().millisecondsSinceEpoch}.png");
                        setState(() {});
                      },
                      child: const Icon(
                        Icons.share,
                        color: whiteColor,
                      ),
                    ),
            ),
          ),
        ],
      ),
      body: Obx(
        () => WillPopScope(
          onWillPop: editController.isShareImage.value
              ? () async {
                  print("------- After Image Save ---------");
                  isPatrioticImageTap = false;
                  isFestivalImageTap = false;
                  isSpecialImageTap = false;
                  editController.functionTap.value = -1;
                  editController.isFilterTap.value = false;
                  editController.textController.value.text = "";
                  editController.isTextTap.value = false;
                  editController.isCropImageDone.value = false;
                  image = null;
                  editController.isCropTap.value = false;
                  editController.filterContainerColor.value = transparentColor;
                  editController.isContrastTap.value = false;
                  editController.contrast.value = 1.0;
                  editController.isRotateTap.value = false;
                  editController.angle.value = 0.0;
                  editController.isSizeBoxTap.value = false;
                  editController.sizeTap.value = 0;
                  editController.imageFit.value = BoxFit.fill;
                  editController.imageHeight.value = double.infinity;
                  editController.isLogoImageTap.value = false;
                  isSliderImageTap = false;
                  editController.logoIndex.value = 1;
                  editController.textBlackColor.value = blackColor;
                  editController.isColorIconTap.value = false;
                  editController.isMoreIconTap.value = false;
                  editController.selectedFontSize.value = 16.0;
                  editController.selectedTitle.value = "Title";
                  editController.isBoldIconTap.value = false;
                  editController.fontWeight.value = FontWeight.normal;
                  editController.isTextItalicIconTap.value = false;
                  editController.fontStyle.value = FontStyle.normal;
                  editController.isTextUnderLineIconTap.value = false;
                  editController.textDecoration.value = TextDecoration.none;
                  editController.selectedFontFamily.value = "Poppins";
                  selectedIndexPost.value = null;
                  selectedItem = null;
                  editController.isImageSaveLoader.value = false;
                  editController.isShareImage.value = false;
                  editController.frontImage.value = null;
                  editController.backImage.value = null;
                  editController.items.clear();
                  editController.pickLogos.clear();
                  editController.pickLogosCardFrontSide.clear();
                  editController.pickLogosCardBackSide.clear();
                  editController.checkBoxValue.value = false;
                  Get.offAll(
                    transition: Transition.rightToLeftWithFade,
                    () => const BottomNavBarBar(),
                  );
                  drawerContainer = 0;
                  isSliderImageTap = false;
                  setState(() {});
                  return true;
                }
              : () async {
                  print("------- Before Image Save ---------");
                  // setState(() {});
                  return false;
                },
          child: GestureDetector(
            onTap: () {
              editController.isTextTap.value = false;
              editController.show.value = false;
              editController.isImageShow.value = false;
              editController.isLogoImageTap.value = false;
            },
            child: Obx(
              () => Stack(
                children: [
                  Column(
                    children: [
                      Expanded(
                        child: Stack(
                          children: [
                            editController.isShareImage.value == true
                                ? SizedBox(
                                    height: double.infinity,
                                    width: double.infinity,
                                    child: Image.memory(
                                      bytes!,
                                      fit: BoxFit.fill,
                                    ),
                                  )
                                : Container(
                                    color:
                                        editController.isCropTap.value == true
                                            ? blackColor
                                            : whiteColor,
                                    padding: EdgeInsets.symmetric(
                                      vertical: editController
                                                  .imageHeight.value ==
                                              double.infinity
                                          // ? 0.025 * h
                                          ? 0.005 * h
                                          : editController.imageHeight.value ==
                                                  0.65 * h
                                              // ? 0.085 * h
                                              ? 0.095 * h
                                              : editController
                                                          .imageHeight.value ==
                                                      0.6 * h
                                                  // ? 0.11 * h
                                                  ? 0.121 * h
                                                  : editController.imageHeight
                                                              .value ==
                                                          0.65 * h
                                                      // ? 0.056 * h
                                                      ? 0.054 * h
                                                      : editController
                                                                  .imageHeight
                                                                  .value ==
                                                              0.62 * h
                                                          // ? 0.1 * h
                                                          ? 0.08 * h
                                                          // : 0.165 * h,
                                                          : 0.125 * h,
                                      horizontal: editController
                                                  .imageHeight.value ==
                                              double.infinity
                                          // ? 0.04 * w
                                          ? 0.015 * w
                                          : editController.imageHeight.value ==
                                                  0.65 * h
                                              ? 0.055 * w
                                              : editController
                                                          .imageHeight.value ==
                                                      0.6 * h
                                                  ? 0.06 * w
                                                  : editController.imageHeight
                                                              .value ==
                                                          0.65 * h
                                                      ? 0.06 * w
                                                      : editController
                                                                  .imageHeight
                                                                  .value ==
                                                              0.62 * h
                                                          ? 0.1 * w
                                                          : 0.13 * w,
                                    ),
                                    child: RepaintBoundary(
                                      key: globalKey,
                                      child: Transform.rotate(
                                        angle: editController.angle.value,
                                        child: ColorFiltered(
                                          colorFilter: editController
                                                      .filterContainerColor
                                                      .value ==
                                                  Colors.black.withOpacity(0.05)
                                              ? const ColorFilter.matrix([
                                                  0.2126, 0.7152, 0.0722, 0,
                                                  0, // Red
                                                  0.2126, 0.7152, 0.0722, 0,
                                                  0, // Green
                                                  0.2126, 0.7152, 0.0722, 0,
                                                  0, // Blue
                                                  0, 0, 0, 1, 0, // Alpha
                                                ])
                                              : const ColorFilter.mode(
                                                  Colors.transparent,
                                                  BlendMode.color,
                                                ),
                                          child: Stack(
                                            children: [
                                              Center(
                                                child: ColorFiltered(
                                                  colorFilter:
                                                      ColorFilter.matrix(
                                                    _contrastMatrix(
                                                        editController
                                                            .contrast.value),
                                                  ),
                                                  child: PhotoView(
                                                    backgroundDecoration:
                                                        const BoxDecoration(
                                                      color: blackColor,
                                                    ),
                                                    // minScale: 0.2,
                                                    // maxScale: 3.0,
                                                    imageProvider: FileImage(
                                                        widget.cropImage),
                                                    disableGestures: false,
                                                    enableRotation: true,
                                                    enablePanAlways: true,
                                                    wantKeepAlive: true,
                                                    gaplessPlayback: true,
                                                  ),

                                                  // child: Container(
                                                  //   height: editController
                                                  //       .imageHeight.value,
                                                  //   width: w,
                                                  //   color: blackColor,
                                                  //   child: GestureDetector(
                                                  //     onScaleStart: (details) {
                                                  //       _lastRotation =
                                                  //           _rotationAngle;
                                                  //     },
                                                  //     onScaleUpdate: (details) {
                                                  //       // Calculate the updated rotation based on the initial rotation
                                                  //       setState(() {
                                                  //         _rotationAngle =
                                                  //             _lastRotation +
                                                  //                 details
                                                  //                     .rotation;
                                                  //       });
                                                  //     },
                                                  //     child: InteractiveViewer(
                                                  //       transformationController:
                                                  //           transformationController,
                                                  //       trackpadScrollCausesScale:
                                                  //           true,
                                                  //       // onInteractionUpdate:
                                                  //       //     (details) {
                                                  //       //   _onRotationUpdate(
                                                  //       //       details.rotation);
                                                  //       //   setState(() {});
                                                  //       // },
                                                  //       minScale: 0.1,
                                                  //       maxScale: 4.0,
                                                  //       boundaryMargin:
                                                  //           const EdgeInsets
                                                  //               .all(double
                                                  //                   .infinity),
                                                  //       child: Transform.rotate(
                                                  //         angle: _rotation,
                                                  //         child: AspectRatio(
                                                  //           aspectRatio: 1.0,
                                                  //           child: widget
                                                  //                       .cropImage !=
                                                  //                   null
                                                  //               ? Image.file(
                                                  //                   File(widget
                                                  //                       .cropImage
                                                  //                       .path),
                                                  //                   fit: BoxFit
                                                  //                       .contain,
                                                  //                 )
                                                  //               : Container(),
                                                  //         ),
                                                  //       ),
                                                  //     ),
                                                  //   ),
                                                  // ),
                                                ),
                                              ),
                                              editController.isCropTap.value ==
                                                      true
                                                  ? cropImage()
                                                  : ColorFiltered(
                                                      colorFilter:
                                                          ColorFilter.matrix(
                                                        _contrastMatrix(
                                                            editController
                                                                .contrast
                                                                .value),
                                                      ),
                                                      child: IgnorePointer(
                                                        child: SizedBox(
                                                          child: editController
                                                                          .isCropImageDone
                                                                          .value ==
                                                                      true &&
                                                                  image != null
                                                              ? Center(
                                                                  child: Image(
                                                                    image: image!
                                                                        .image,
                                                                    height: editController
                                                                        .imageHeight
                                                                        .value,
                                                                    width: w,
                                                                    fit: BoxFit
                                                                        .fill,
                                                                  ),
                                                                )
                                                              : Center(
                                                                  child: Image
                                                                      .asset(
                                                                    widget
                                                                        .wallPaper,
                                                                    height: editController
                                                                        .imageHeight
                                                                        .value,
                                                                    width: w,
                                                                    fit: BoxFit
                                                                        .fill,
                                                                  ),
                                                                ),
                                                        ),
                                                      ),
                                                    ),
                                              Obx(
                                                () => Stack(
                                                  children: List.generate(
                                                    editController
                                                        .pickLogos.length,
                                                    (index) {
                                                      return ImageWidget(
                                                        image: editController
                                                                .pickLogos[
                                                            index]["image"],
                                                        onRemove: () {
                                                          editController
                                                              .pickLogos
                                                              .removeAt(index);
                                                          editController
                                                              .isImageShow
                                                              .value = false;
                                                          editController
                                                              .isLogoImageTap
                                                              .value = false;
                                                        },
                                                        index: index,
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ),
                                              Stack(
                                                children: editController.items
                                                    .asMap()
                                                    .entries
                                                    .map((entry) {
                                                  final item = entry.value;
                                                  final index = entry.key;
                                                  return TextWidget(
                                                    key: item.parentKey,
                                                    item: item,
                                                    onRemove: () {
                                                      editController
                                                          .removeItem(index);
                                                      editController
                                                          .show.value = false;
                                                    },
                                                    onEdit: () {
                                                      selectedItem = item;
                                                      selectedIndexPost.value =
                                                          index;
                                                      editController
                                                          .textController
                                                          .value
                                                          .text = item.text;
                                                      editController
                                                          .isEditIconTap
                                                          .value = true;
                                                      editController
                                                              .textBlackColor
                                                              .value =
                                                          item.textColor;
                                                      editController
                                                              .selectedFontSize
                                                              .value =
                                                          item.fontSize;
                                                      editController.fontWeight
                                                              .value =
                                                          item.fontWeight;
                                                      editController.fontWeight
                                                                  .value ==
                                                              ui.FontWeight.bold
                                                          ? editController
                                                              .isBoldIconTap
                                                              .value = true
                                                          : editController
                                                              .isBoldIconTap
                                                              .value = false;
                                                      editController
                                                              .textDecoration
                                                              .value =
                                                          item.textDecoration;
                                                      editController
                                                                  .textDecoration
                                                                  .value ==
                                                              TextDecoration
                                                                  .underline
                                                          ? editController
                                                              .isTextUnderLineIconTap
                                                              .value = true
                                                          : editController
                                                              .isTextUnderLineIconTap
                                                              .value = false;
                                                      editController
                                                              .fontStyle.value =
                                                          item.fontStyle;
                                                      editController.fontStyle
                                                                  .value ==
                                                              ui.FontStyle
                                                                  .italic
                                                          ? editController
                                                              .isTextItalicIconTap
                                                              .value = true
                                                          : editController
                                                              .isTextItalicIconTap
                                                              .value = false;
                                                      editController
                                                              .selectedTitle
                                                              .value =
                                                          item.selectTitle;
                                                      editController
                                                              .selectedFontFamily
                                                              .value =
                                                          item.fontFamily;
                                                      editController
                                                              .selectedStrokeWidth
                                                              .value =
                                                          item.strokeWidth;
                                                      editController
                                                              .forgroundStrokeColor
                                                              .value =
                                                          item.forgroundColor;
                                                      editController
                                                              .backgroundStrokeColor
                                                              .value =
                                                          item.backgroundColor;
                                                      editController
                                                              .checkBoxValue
                                                              .value =
                                                          item.isStrokeCheck;
                                                    },
                                                    index: index,
                                                  );
                                                }).toList(),
                                              ),
                                              IgnorePointer(
                                                child: ColorFiltered(
                                                  colorFilter:
                                                      ColorFilter.matrix(
                                                    _contrastMatrix(
                                                        editController
                                                            .contrast.value),
                                                  ),
                                                ),
                                              ),
                                              IgnorePointer(
                                                child: Container(
                                                  color: editController
                                                      .filterContainerColor
                                                      .value,
                                                ),
                                              ),
                                            ].toList(),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                            Container(
                              height: editController.isShareImage.value == true
                                  ? 0
                                  : editController.imageHeight.value ==
                                          double.infinity
                                      ? 0.065 * w
                                      : editController.imageHeight.value ==
                                              0.65 * h
                                          ? 0.21 * w
                                          : editController.imageHeight.value ==
                                                  0.6 * h
                                              ? 0.267 * w
                                              : editController
                                                          .imageHeight.value ==
                                                      0.65 * h
                                                  ? 0.164 * w
                                                  : editController.imageHeight
                                                              .value ==
                                                          0.62 * h
                                                      ? 0.25 * w
                                                      : 0.37 * w,
                              width: w,
                              color: editController.isCropTap.value == true
                                  ? blackColor
                                  : whiteColor,
                            ),
                            editController.isShareImage.value == true
                                ? Container()
                                : Positioned(
                                    left: 0,
                                    child: Container(
                                      height: h,
                                      width: editController.imageHeight.value ==
                                              double.infinity
                                          ? 0.04 * w
                                          : editController.imageHeight.value ==
                                                  0.65 * h
                                              ? 0.056 * w
                                              : editController
                                                          .imageHeight.value ==
                                                      0.6 * h
                                                  ? 0.06 * w
                                                  : editController.imageHeight
                                                              .value ==
                                                          0.65 * h
                                                      ? 0.056 * w
                                                      : editController
                                                                  .imageHeight
                                                                  .value ==
                                                              0.62 * h
                                                          ? 0.1 * w
                                                          : 0.135 * w,
                                      color:
                                          editController.isCropTap.value == true
                                              ? blackColor
                                              : whiteColor,
                                    ),
                                  ),
                            editController.isShareImage.value == true
                                ? Container()
                                : Positioned(
                                    right: 0,
                                    child: Container(
                                      height: h,
                                      width: editController.imageHeight.value ==
                                              double.infinity
                                          // ? 0.04 * w
                                          ? 0.015 * w
                                          : editController.imageHeight.value ==
                                                  0.65 * h
                                              ? 0.056 * w
                                              : editController
                                                          .imageHeight.value ==
                                                      0.6 * h
                                                  ? 0.06 * w
                                                  : editController.imageHeight
                                                              .value ==
                                                          0.65 * h
                                                      ? 0.056 * w
                                                      : editController
                                                                  .imageHeight
                                                                  .value ==
                                                              0.62 * h
                                                          ? 0.1 * w
                                                          : 0.135 * w,
                                      color:
                                          editController.isCropTap.value == true
                                              ? blackColor
                                              : whiteColor,
                                    ),
                                  ),
                            // ),
                            editController.isShareImage.value == true
                                ? Container()
                                : Positioned(
                                    bottom: 0,
                                    child: Container(
                                      height: editController
                                                  .imageHeight.value ==
                                              double.infinity
                                          ? 0.056 * w
                                          : editController.imageHeight.value ==
                                                  0.65 * h
                                              ? 0.21 * w
                                              : editController
                                                          .imageHeight.value ==
                                                      0.6 * h
                                                  ? 0.267 * w
                                                  : editController.imageHeight
                                                              .value ==
                                                          0.65 * h
                                                      ? 0.164 * w
                                                      : editController
                                                                  .imageHeight
                                                                  .value ==
                                                              0.62 * h
                                                          ? 0.25 * w
                                                          : 0.37 * w,
                                      width: w,
                                      color:
                                          editController.isCropTap.value == true
                                              ? blackColor
                                              : whiteColor,
                                    ),
                                  ),
                            editController.isImageSaveLoader.value == true
                                ? const Center(
                                    child: CircularProgressIndicator(
                                      color: kPrimeryColor,
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                      editController.isTextTap.value == true ||
                              editController.isCropTap.value == true ||
                              editController.isFilterTap.value == true ||
                              editController.isContrastTap.value == true ||
                              editController.isRotateTap.value == true ||
                              editController.isSizeBoxTap.value == true ||
                              editController.isLogoImageTap.value == true ||
                              editController.isImageShow.value == true
                          ? Container()
                          : SizedBox(
                              width: w,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  editController.isShareImage.value == true
                                      ? Container()
                                      : Container(
                                          height: 75,
                                          color: kPrimeryColor,
                                          child: Obx(
                                            () => ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount: editController
                                                  .functionList.length,
                                              itemBuilder: (context, index) {
                                                return GestureDetector(
                                                  onTap: () {
                                                    editController.isShareImage
                                                        .value = false;
                                                    editController
                                                        .updateTap(index);
                                                    editController.functionTap
                                                        .value = index;
                                                  },
                                                  child: Center(
                                                    child: Container(
                                                      margin: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 5),
                                                      decoration: BoxDecoration(
                                                        color: editController
                                                                    .functionTap
                                                                    .value ==
                                                                index
                                                            ? whiteColor
                                                            : transparentColor,
                                                      ),
                                                      width: 70,
                                                      child: Container(
                                                        margin: const EdgeInsets
                                                            .only(top: 5),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Image.asset(
                                                              editController
                                                                      .functionList[
                                                                  index]["image"]!,
                                                              scale: index ==
                                                                          4 ||
                                                                      index ==
                                                                          5 ||
                                                                      index == 6
                                                                  ? 7.5
                                                                  : index == 0 ||
                                                                          index ==
                                                                              1
                                                                      ? 7.5
                                                                      : 6.5,
                                                              color: editController
                                                                          .functionTap
                                                                          .value ==
                                                                      index
                                                                  ? kEditFetureColor
                                                                  : whiteColor,
                                                            ),
                                                            const SizedBox(
                                                              height: 10,
                                                            ),
                                                            Text(
                                                              editController
                                                                      .functionList[
                                                                  index]["size"]!,
                                                              style: GoogleFonts
                                                                  .poppins(
                                                                color: editController
                                                                            .functionTap
                                                                            .value ==
                                                                        index
                                                                    ? kEditFetureColor
                                                                    : whiteColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: index == 3 ||
                                                                        index ==
                                                                            4 ||
                                                                        index ==
                                                                            5 ||
                                                                        index ==
                                                                            6
                                                                    ? 14
                                                                    : 15,
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
                            ),
                      Obx(
                        () => Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            child: editController.isCropTap.value == true
                                ? cropButton()
                                : editController.isFilterTap.value == true
                                    ? filterContainer()
                                    : editController.isContrastTap.value == true
                                        ? imageContrast()
                                        : editController.isRotateTap.value ==
                                                true
                                            ? imageRotate()
                                            : editController
                                                        .isSizeBoxTap.value ==
                                                    true
                                                ? imageSizeBoxFit()
                                                : editController.isLogoImageTap
                                                            .value ==
                                                        true
                                                    ? logoImageAdd()
                                                    : null,
                          ),
                        ),
                      ),
                    ],
                  ),
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
                      ? Column(
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
                                          borderRadius:
                                              BorderRadius.circular(10),
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
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child:
                                              editController.isTextFieldTextAdd
                                                          .value ==
                                                      true
                                                  ? Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                        left: 20,
                                                        right: 20,
                                                        bottom: 10,
                                                      ),
                                                      child: Stack(
                                                        children: [
                                                          SingleChildScrollView(
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      bottom:
                                                                          15.0),
                                                              child: editController
                                                                      .checkBoxValue
                                                                      .value
                                                                  ? Stack(
                                                                      children: [
                                                                        TextField(
                                                                          style:
                                                                              GoogleFonts.getFont(
                                                                            editController.selectedFontFamily.value,
                                                                            fontSize:
                                                                                editController.selectedFontSize.value,
                                                                            // color:
                                                                            //     editController.textBlackColor.value,
                                                                            fontWeight:
                                                                                editController.fontWeight.value,
                                                                            decoration:
                                                                                editController.textDecoration.value,
                                                                            fontStyle:
                                                                                editController.fontStyle.value,
                                                                            foreground: Paint()
                                                                              ..style = PaintingStyle.stroke
                                                                              ..strokeWidth = editController.selectedStrokeWidth.value
                                                                              ..color = editController.forgroundStrokeColor.value,
                                                                          ),
                                                                          decoration:
                                                                              const InputDecoration(
                                                                            border:
                                                                                InputBorder.none,
                                                                          ),
                                                                          focusNode:
                                                                              editController.focusNode,
                                                                          maxLines:
                                                                              null,
                                                                          cursorColor:
                                                                              kPrimeryColor,
                                                                          controller: editController
                                                                              .textController
                                                                              .value,
                                                                        ),
                                                                        TextField(
                                                                          style:
                                                                              GoogleFonts.getFont(
                                                                            editController.selectedFontFamily.value,
                                                                            fontSize:
                                                                                editController.selectedFontSize.value,
                                                                            color:
                                                                                editController.backgroundStrokeColor.value,
                                                                            fontWeight:
                                                                                editController.fontWeight.value,
                                                                            decoration:
                                                                                editController.textDecoration.value,
                                                                            fontStyle:
                                                                                editController.fontStyle.value,
                                                                          ),
                                                                          decoration:
                                                                              const InputDecoration(
                                                                            border:
                                                                                InputBorder.none,
                                                                          ),
                                                                          focusNode:
                                                                              editController.focusNode,
                                                                          maxLines:
                                                                              null,
                                                                          cursorColor:
                                                                              kPrimeryColor,
                                                                          controller: editController
                                                                              .textController
                                                                              .value,
                                                                        ),
                                                                      ],
                                                                    )
                                                                  : TextField(
                                                                      style: GoogleFonts
                                                                          .getFont(
                                                                        editController
                                                                            .selectedFontFamily
                                                                            .value,
                                                                        fontSize: editController
                                                                            .selectedFontSize
                                                                            .value,
                                                                        color: editController
                                                                            .textBlackColor
                                                                            .value,
                                                                        fontWeight: editController
                                                                            .fontWeight
                                                                            .value,
                                                                        decoration: editController
                                                                            .textDecoration
                                                                            .value,
                                                                        fontStyle: editController
                                                                            .fontStyle
                                                                            .value,
                                                                      ),
                                                                      decoration:
                                                                          const InputDecoration(
                                                                        border:
                                                                            InputBorder.none,
                                                                      ),
                                                                      focusNode:
                                                                          editController
                                                                              .focusNode,
                                                                      maxLines:
                                                                          null,
                                                                      cursorColor:
                                                                          kPrimeryColor,
                                                                      controller: editController
                                                                          .textController
                                                                          .value,
                                                                    ),
                                                            ),
                                                          ),
                                                          Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            children: [
                                                              SizedBox(
                                                                height: 20,
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .end,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Text(
                                                                      "Stroke",
                                                                      style: GoogleFonts
                                                                          .poppins(
                                                                        fontSize:
                                                                            13,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                      ),
                                                                    ),
                                                                    Transform
                                                                        .scale(
                                                                      scale:
                                                                          0.8,
                                                                      child:
                                                                          Checkbox(
                                                                        activeColor:
                                                                            kPrimeryColor,
                                                                        value: editController
                                                                            .checkBoxValue
                                                                            .value,
                                                                        onChanged:
                                                                            (value) {
                                                                          editController
                                                                              .checkBoxValue
                                                                              .value = value!;
                                                                          editController
                                                                              .focusNode
                                                                              .requestFocus();
                                                                        },
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  : Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                        top: 20,
                                                        left: 20,
                                                        right: 20,
                                                        bottom: 20,
                                                      ),
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          editController
                                                              .isTextFieldTextAdd
                                                              .value = true;
                                                        },
                                                        child: Text(
                                                          "Write A Text",
                                                          style: GoogleFonts
                                                              .poppins(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w600,
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
                                            editController.isTextTap.value =
                                                false;
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
                                  editController.isTextFieldTextAdd.value ==
                                          true
                                      ? GestureDetector(
                                          onTap: () {
                                            editController.isTextTap.value =
                                                true;
                                          },
                                          child: Container(
                                            child: textFeture(
                                                context,
                                                setState,
                                                editController
                                                    .textController.value),
                                          ),
                                        )
                                      : Container(),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  editController.checkBoxValue.value
                                      ? GestureDetector(
                                          onTap: () {
                                            editController.isTextTap.value =
                                                true;
                                          },
                                          child: Container(
                                            child: strokeTextFeture(context),
                                          ),
                                        )
                                      : Container(),
                                ],
                              ),
                            ),
                          ],
                        )
                      : Container(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(size.width / 2, 0); // Top point of the triangle
    path.lineTo(size.width, size.height); // Bottom right point
    path.lineTo(0, size.height); // Bottom left point
    path.close(); // Close the path to form a triangle
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class PolygonClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    const numberOfSides = 7;
    final radius = size.width / 2;
    const angle = (2 * pi) / numberOfSides;

    for (int i = 0; i < numberOfSides; i++) {
      final x = radius + radius * cos(i * angle);
      final y = radius + radius * sin(i * angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
