import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:clipboard/clipboard.dart';
import 'package:crop_image/crop_image.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:photo_frame/Contstant/AppColor.dart';
import 'package:photo_frame/Contstant/getXController.dart';
import 'package:photo_frame/Contstant/imageItemModel.dart';
import 'package:photo_frame/Contstant/itemModel.dart';
import 'package:photo_frame/Contstant/CommonMethod.dart';
import 'package:photo_frame/Screen/HomeScreen.dart';
import 'package:photo_view/photo_view.dart';
import 'package:share_extend/share_extend.dart';

EditController editController = Get.put(EditController());
List<Item> items = [];

class EditImageScreen extends StatefulWidget {
  final cropImage;
  final wallPaper;
  final image;
  const EditImageScreen(
      {super.key,
      required this.cropImage,
      required this.wallPaper,
      required this.image});

  @override
  State<EditImageScreen> createState() => _EditImageScreenState();
}

class _EditImageScreenState extends State<EditImageScreen> {
  Image? image;
  bool isShareImage = false;
  Uint8List? bytes;
  bool isImageSaveLoader = false;
  String text = "";
  Item? selectedItem;
  int? selectedIndex;
  String duplicate = "";

  List<String> titleList = [
    "Title",
    "Sub-Title",
    "Body Text",
    "Caption",
  ];
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

  Widget filterWidget(color, text) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
      child: GestureDetector(
        onTap: () {
          editController.filterContainerColor.value = color;
        },
        child: Column(
          children: [
            SizedBox(
              height: 110,
              width: 100,
              child: Stack(
                children: [
                  Container(
                    height: 90,
                    width: 110,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(widget.image),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Container(
                    height: 90,
                    width: 110,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  Positioned(
                    bottom: 5,
                    right: 5,
                    child: Container(
                      decoration: BoxDecoration(
                        color: kfilterContainerColor,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      height: 30,
                      width: 90,
                      child: Center(
                        child: Text(
                          text,
                          style: GoogleFonts.montserrat(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
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
    );
  }

  Widget filterContainer() {
    var h = MediaQuery.of(context).size.height;
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
              filterWidget(Colors.transparent, "Normal"),
              filterWidget(blackColor.withOpacity(0.4), "Lo-fi"),
              filterWidget(const Color(0xffEDEDED).withOpacity(0.2), "Inkwell"),
              filterWidget(const Color(0xffFED914).withOpacity(0.18), "Warm"),
              filterWidget(const Color(0xff9F2860).withOpacity(0.42), "Pop"),
              filterWidget(const Color(0xff5DE147).withOpacity(0.2), "Nature"),
              filterWidget(blackColor.withOpacity(0.58), "B&W"),
              filterWidget(const Color(0xff00A3FF).withOpacity(0.5), "Icy"),
              filterWidget(const Color(0xffD49029).withOpacity(0.2), "Ludwig"),
              filterWidget(const Color(0xff0066FF).withOpacity(0.2), "Ocean"),
            ],
          ),
        ),
      ],
    );
  }

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

  colorPicker(context) {
    return Obx(
      () => ColorIndicator(
          width: 40,
          height: 40,
          borderRadius: 0,
          color: editController.textBlackColor.value,
          elevation: 1,
          onSelectFocus: false,
          onSelect: () async {
            print("------tap-----");
            final Color newColor = await showColorPickerDialog(
              context,
              editController.textBlackColor.value,
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
                  minHeight: 450, minWidth: 320, maxWidth: 320),
            );
            editController.textBlackColor.value = newColor;
          }),
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
              print("--------------- image Path --------- ${image}");
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
            child: Slider(
              activeColor: kPrimeryColor,
              value: editController.contrast.value,
              min: 0.0,
              max: 2.0,
              onChanged: (value) {
                editController.contrast.value = value;
              },
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
            child: Slider(
              activeColor: kPrimeryColor,
              value: editController.angle.value,
              min: -6.283,
              max: 6.283,
              onChanged: (value) {
                editController.angle.value = value;
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget imageSizeBoxFit() {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Container(
      height: 95,
      color: kEditFetureColor.withOpacity(0.9),
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
          return Obx(
            () => GestureDetector(
              onTap: () {
                editController.logoIndex.value = index;
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
                    color: editController.logoIndex.value == index
                        ? kPrimeryColor
                        : null,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _saveImage(key) async {
    try {
      isImageSaveLoader = true;
      RenderRepaintBoundary boundary =
          key.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      bytes = byteData!.buffer.asUint8List();
      var result = await ImageGallerySaver.saveImage(bytes!);
      isImageSaveLoader = true;
      setState(() {});
      if (result != null) {
        imageSaveSuccessDialog(
          context,
          () {
            shareImage(bytes!, "${DateTime.now().millisecondsSinceEpoch}.png");
            Navigator.of(context).pop();
          },
        );
        isImageSaveLoader = false;
        setState(() {});
      }

      setState(() {});
    } catch (e) {
      print("-------- Save Image Error ------- $e");
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
        backgroundColor: kDrwerSelectColor,
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
                  editController.isLogoImageTap.value == true
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
                                editController.pickLogo.value = null,
                                editController.logoIndex.value = 1,
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
                    editController.pickLogo.value = null;
                    editController.logoIndex.value = 1;
                    items.clear();
                    isSliderImageTap = false;
                    Get.offAll(
                      transition: Transition.rightToLeftWithFade,
                      () => const HomeScreen(),
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
              () => isShareImage == false
                  ? GestureDetector(
                      onTap: () async {
                        await _saveImage(globalKey);
                        isShareImage = true;
                      },
                      child: editController.isFilterTap.value == true ||
                              editController.isTextTap.value == true ||
                              editController.isContrastTap.value == true ||
                              editController.isRotateTap.value == true ||
                              editController.isSizeBoxTap.value == true ||
                              editController.isLogoImageTap.value == true
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
                                            ? items[selectedIndex!] = Item(
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
                                              )
                                            : items.add(
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
                        isShareImage = true;
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
          Obx(
            () => editController.isLogoImageTap.value == true
                ? IconButton(
                    onPressed: () {
                      pickLogoDialog(context, setState);
                    },
                    icon: const Icon(
                      Icons.add,
                    ),
                  )
                : Container(),
          ),
        ],
      ),
      body: WillPopScope(
        onWillPop: () async {
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
          editController.pickLogo.value = null;
          editController.logoIndex.value = 1;
          items.clear();
          Get.offAll(
            transition: Transition.rightToLeftWithFade,
            () => const HomeScreen(),
          );
          drawerContainer = 0;
          isSliderImageTap = false;
          setState(() {});
          return true;
        },
        child: GestureDetector(
          onTap: () {
            editController.isTextTap.value = false;
          },
          child: Obx(
            () => Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      child: Stack(
                        children: [
                          isShareImage == true
                              ? SizedBox(
                                  height: double.infinity,
                                  width: double.infinity,
                                  child: Image.memory(
                                    bytes!,
                                    fit: BoxFit.fill,
                                  ),
                                )
                              : Container(
                                  color: editController.isCropTap.value == true
                                      ? blackColor
                                      : whiteColor,
                                  padding: EdgeInsets.symmetric(
                                    vertical: editController
                                                .imageHeight.value ==
                                            double.infinity
                                        ? 0.025 * h
                                        : editController.imageHeight.value ==
                                                0.65 * h
                                            ? 0.085 * h
                                            : editController
                                                        .imageHeight.value ==
                                                    0.6 * h
                                                ? 0.11 * h
                                                : editController.imageHeight
                                                            .value ==
                                                        0.65 * h
                                                    ? 0.056 * h
                                                    : editController.imageHeight
                                                                .value ==
                                                            0.62 * h
                                                        ? 0.1 * h
                                                        : 0.165 * h,
                                    horizontal: editController
                                                .imageHeight.value ==
                                            double.infinity
                                        ? 0.04 * w
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
                                                    : editController.imageHeight
                                                                .value ==
                                                            0.62 * h
                                                        ? 0.1 * w
                                                        : 0.13 * w,
                                  ),
                                  child: RepaintBoundary(
                                    key: globalKey,
                                    child: Obx(
                                      () => Transform.rotate(
                                        angle: editController.angle.value,
                                        child: Stack(
                                          children: [
                                            ColorFiltered(
                                              colorFilter: ColorFilter.matrix(
                                                _contrastMatrix(editController
                                                    .contrast.value),
                                              ),
                                              child: Center(
                                                child: PhotoView(
                                                  backgroundDecoration:
                                                      const BoxDecoration(
                                                    color: blackColor,
                                                  ),
                                                  imageProvider: FileImage(
                                                      widget.cropImage),
                                                  disableGestures: false,
                                                  enableRotation: true,
                                                  enablePanAlways: true,
                                                  wantKeepAlive: true,
                                                  gaplessPlayback: true,
                                                ),
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
                                                              .contrast.value),
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
                                                                child:
                                                                    Image.asset(
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
                                            Stack(
                                              children: items
                                                  .asMap()
                                                  .entries
                                                  .map((entry) {
                                                final item = entry.value;
                                                final index = entry.key;
                                                return TextWidget(
                                                  key: item.parentKey,
                                                  item: item,
                                                  onRemove: () {
                                                    setState(() {
                                                      items.removeAt(index);
                                                    });
                                                  },
                                                  onEdit: () {
                                                    selectedItem = item;
                                                    selectedIndex = index;
                                                    editController
                                                        .textController
                                                        .value
                                                        .text = item.text;
                                                    editController.isEditIconTap
                                                        .value = true;
                                                    editController
                                                        .textBlackColor
                                                        .value = item.textColor;
                                                    editController
                                                        .selectedFontSize
                                                        .value = item.fontSize;
                                                    editController
                                                            .fontWeight.value =
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

                                                    editController.fontStyle
                                                        .value = item.fontStyle;

                                                    editController.fontStyle
                                                                .value ==
                                                            ui.FontStyle.italic
                                                        ? editController
                                                            .isTextItalicIconTap
                                                            .value = true
                                                        : editController
                                                            .isTextItalicIconTap
                                                            .value = false;
                                                    editController.selectedTitle
                                                            .value =
                                                        item.selectTitle;
                                                  },
                                                  selectedFontSize:
                                                      editController
                                                          .selectedFontSize
                                                          .value,
                                                );
                                              }).toList(),
                                            ),
                                            IgnorePointer(
                                              child: Container(
                                                color: editController
                                                    .filterContainerColor.value,
                                              ),
                                            ),
                                            Obx(
                                              () => editController
                                                          .pickLogo.value !=
                                                      null
                                                  ? ImageWidget(
                                                      key: GlobalKey(),
                                                      imageItem: ImageItem(
                                                        parentKey: GlobalKey(),
                                                        size: const Size(
                                                            100, 100),
                                                        offset: const Offset(
                                                            100, 100),
                                                        imageRotation: 0,
                                                        image: editController
                                                            .pickLogo
                                                            .value!
                                                            .path,
                                                        imageSize:
                                                            editController
                                                                .width.value,
                                                      ),
                                                      onRemove: () {
                                                        editController.pickLogo
                                                            .value = null;
                                                        setState(() {});
                                                      },
                                                    )
                                                  : Container(),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                          Container(
                            height: isShareImage == true
                                ? 0
                                : editController.imageHeight.value ==
                                        double.infinity
                                    ? 0.065 * w
                                    : editController.imageHeight.value ==
                                            0.65 * h
                                        ? 0.19 * w
                                        : editController.imageHeight.value ==
                                                0.6 * h
                                            ? 0.25 * w
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
                          isShareImage == true
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
                                                    : editController.imageHeight
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
                          isShareImage == true
                              ? Container()
                              : Positioned(
                                  right: 0,
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
                                                    : editController.imageHeight
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
                          isShareImage == true
                              ? Container()
                              : Positioned(
                                  bottom: 0,
                                  child: Container(
                                    height: editController.imageHeight.value ==
                                            double.infinity
                                        ? 0.056 * w
                                        : editController.imageHeight.value ==
                                                0.65 * h
                                            ? 0.19 * w
                                            : editController
                                                        .imageHeight.value ==
                                                    0.6 * h
                                                ? 0.25 * w
                                                : editController.imageHeight
                                                            .value ==
                                                        0.65 * h
                                                    ? 0.164 * w
                                                    : editController.imageHeight
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
                        ],
                      ),
                    ),
                    editController.isTextTap.value == true ||
                            editController.isCropTap.value == true ||
                            editController.isFilterTap.value == true ||
                            editController.isContrastTap.value == true ||
                            editController.isRotateTap.value == true ||
                            editController.isSizeBoxTap.value == true ||
                            editController.isLogoImageTap.value == true
                        ? Container()
                        : SizedBox(
                            height: isShareImage == true ? 0 : 80,
                            width: w,
                            child: Column(
                              children: [
                                isShareImage == true
                                    ? Container()
                                    : Container(
                                        height: 80,
                                        color: kEditFetureColor,
                                        child: Obx(
                                          () => ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: editController
                                                .functionList.length,
                                            itemBuilder: (context, index) {
                                              return GestureDetector(
                                                onTap: () {
                                                  isShareImage = false;
                                                  editController
                                                      .updateTap(index);
                                                },
                                                child: Container(
                                                  margin: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 10),
                                                  decoration: BoxDecoration(
                                                    color: editController
                                                                .functionTap
                                                                .value ==
                                                            index
                                                        ? whiteColor
                                                        : transparentColor,
                                                  ),
                                                  width: 80,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Image.asset(
                                                        editController
                                                                .functionList[
                                                            index]["image"]!,
                                                        scale: 6,
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
                                                        style:
                                                            GoogleFonts.poppins(
                                                          color: editController
                                                                      .functionTap
                                                                      .value ==
                                                                  index
                                                              ? kEditFetureColor
                                                              : whiteColor,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 15,
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
                                      : editController.isRotateTap.value == true
                                          ? imageRotate()
                                          : editController.isSizeBoxTap.value ==
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
                    ? Container(
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
                                          child: editController
                                                      .isTextFieldTextAdd
                                                      .value ==
                                                  true
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    left: 20,
                                                    right: 20,
                                                    bottom: 20,
                                                  ),
                                                  child: TextField(
                                                    style: GoogleFonts.poppins(
                                                      fontSize: editController
                                                                  .selectedTitle
                                                                  .value ==
                                                              "Sub-Title"
                                                          ? editController
                                                                  .selectedFontSize
                                                                  .value +
                                                              10
                                                          : editController
                                                                      .selectedTitle
                                                                      .value ==
                                                                  "Body Text"
                                                              ? editController
                                                                      .selectedFontSize
                                                                      .value +
                                                                  7
                                                              : editController
                                                                          .selectedTitle
                                                                          .value ==
                                                                      "Caption"
                                                                  ? editController
                                                                          .selectedFontSize
                                                                          .value +
                                                                      4
                                                                  : editController
                                                                          .selectedFontSize
                                                                          .value +
                                                                      16,
                                                      color: editController
                                                          .textBlackColor.value,
                                                      fontWeight: editController
                                                          .fontWeight.value,
                                                      decoration: editController
                                                          .textDecoration.value,
                                                      fontStyle: editController
                                                          .fontStyle.value,
                                                    ),
                                                    decoration:
                                                        const InputDecoration(
                                                      border: InputBorder.none,
                                                    ),
                                                    focusNode: editController
                                                        .focusNode,
                                                    maxLines: null,
                                                    cursorColor: kPrimeryColor,
                                                    controller: editController
                                                        .textController.value,
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
                                                      style:
                                                          GoogleFonts.poppins(
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
                                          child: Image.asset(
                                            "assets/images/cross.png",
                                            scale: 6,
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
                                            margin: const EdgeInsets.only(
                                                left: 20, right: 20),
                                            height: 40,
                                            decoration: BoxDecoration(
                                              color: whiteColor,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Row(
                                              children: [
                                                Obx(
                                                  () => Expanded(
                                                    child:
                                                        DropdownButtonHideUnderline(
                                                      child: Container(
                                                        margin: const EdgeInsets
                                                            .only(left: 20),
                                                        child: DropdownButton2(
                                                          value: editController
                                                                  .selectedTitle
                                                                  .value
                                                                  .isEmpty
                                                              ? null
                                                              : editController
                                                                  .selectedTitle
                                                                  .value,
                                                          isExpanded: true,
                                                          isDense: false,
                                                          items: titleList
                                                              .map((e) {
                                                            return DropdownMenuItem<
                                                                String>(
                                                              value: e,
                                                              child: Container(
                                                                child: Text(
                                                                  e,
                                                                  style: GoogleFonts
                                                                      .poppins(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color:
                                                                        blackColor,
                                                                    fontSize:
                                                                        13,
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          }).toList(),
                                                          hint: Text(
                                                            "Title",
                                                            style: GoogleFonts
                                                                .poppins(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: blackColor,
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                          onChanged: (value) {
                                                            editController
                                                                .selectedTitle
                                                                .value = value!;

                                                            print(
                                                                "--------- change title --------- ${editController.selectedTitle.value}");
                                                          },
                                                          dropdownStyleData:
                                                              DropdownStyleData(
                                                            width: 120,
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    vertical:
                                                                        6),
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          4),
                                                              color: whiteColor,
                                                            ),
                                                            offset:
                                                                const Offset(
                                                                    -20, -4),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                // Font Size
                                                Obx(
                                                  () => Expanded(
                                                    child:
                                                        DropdownButtonHideUnderline(
                                                      child: Container(
                                                        margin: const EdgeInsets
                                                            .only(left: 20),
                                                        child: DropdownButton2<
                                                            double>(
                                                          value: fontSizeList.contains(
                                                                  editController
                                                                      .selectedFontSize
                                                                      .value)
                                                              ? editController
                                                                  .selectedFontSize
                                                                  .value
                                                              : null,
                                                          isExpanded: true,
                                                          isDense: false,
                                                          items: fontSizeList
                                                              .map((e) {
                                                            return DropdownMenuItem<
                                                                double>(
                                                              value: e,
                                                              child: Text.rich(
                                                                TextSpan(
                                                                  children: [
                                                                    TextSpan(
                                                                      text:
                                                                          "${e.toInt()}",
                                                                      style: GoogleFonts
                                                                          .poppins(
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        color:
                                                                            blackColor,
                                                                        fontSize:
                                                                            14,
                                                                      ),
                                                                    ),
                                                                    TextSpan(
                                                                      text:
                                                                          "  PX",
                                                                      style: GoogleFonts
                                                                          .poppins(
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        color:
                                                                            blackColor,
                                                                        fontSize:
                                                                            10,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            );
                                                          }).toList(),
                                                          hint: Container(
                                                            child: Text.rich(
                                                              TextSpan(
                                                                children: [
                                                                  TextSpan(
                                                                    text: "8",
                                                                    style: GoogleFonts
                                                                        .poppins(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color:
                                                                          blackColor,
                                                                      fontSize:
                                                                          13,
                                                                    ),
                                                                  ),
                                                                  TextSpan(
                                                                    text:
                                                                        "  PX",
                                                                    style: GoogleFonts
                                                                        .poppins(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color:
                                                                          blackColor,
                                                                      fontSize:
                                                                          10,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          onChanged: (value) {
                                                            editController
                                                                .selectedFontSize
                                                                .value = value!;
                                                          },
                                                          dropdownStyleData:
                                                              DropdownStyleData(
                                                            width: 80,
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    vertical:
                                                                        6),
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          4),
                                                              color: whiteColor,
                                                            ),
                                                            offset:
                                                                const Offset(
                                                                    -20, -4),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                // Color
                                                Obx(
                                                  () => GestureDetector(
                                                    onTap: () {
                                                      editController
                                                              .isColorIconTap
                                                              .value =
                                                          !editController
                                                              .isColorIconTap
                                                              .value;
                                                    },
                                                    child: Container(
                                                      height: 30,
                                                      width: 30,
                                                      decoration: BoxDecoration(
                                                        color: editController
                                                            .textBlackColor
                                                            .value,
                                                        shape: BoxShape.circle,
                                                      ),
                                                    ),
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

                                                GestureDetector(
                                                  onTap: () {
                                                    editController.isBoldIconTap
                                                            .value =
                                                        !editController
                                                            .isBoldIconTap
                                                            .value;
                                                    editController
                                                            .isBoldIconTap.value
                                                        ? editController
                                                                .fontWeight
                                                                .value =
                                                            ui.FontWeight.bold
                                                        : editController
                                                                .fontWeight
                                                                .value =
                                                            ui.FontWeight
                                                                .normal;
                                                  },
                                                  child: Container(
                                                    color: editController
                                                            .isBoldIconTap.value
                                                        ? blackColor
                                                        : transparentColor,
                                                    child: Icon(
                                                      Icons.format_bold,
                                                      size: 18,
                                                      color: editController
                                                              .isBoldIconTap
                                                              .value
                                                          ? whiteColor
                                                          : blackColor,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    editController
                                                            .isTextItalicIconTap
                                                            .value =
                                                        !editController
                                                            .isTextItalicIconTap
                                                            .value;

                                                    editController
                                                            .isTextItalicIconTap
                                                            .value
                                                        ? editController
                                                                .fontStyle
                                                                .value =
                                                            ui.FontStyle.italic
                                                        : editController
                                                                .fontStyle
                                                                .value =
                                                            ui.FontStyle.normal;
                                                  },
                                                  child: Container(
                                                    color: editController
                                                            .isTextItalicIconTap
                                                            .value
                                                        ? blackColor
                                                        : transparentColor,
                                                    child: Icon(
                                                      Icons.format_italic,
                                                      size: 18,
                                                      color: editController
                                                              .isTextItalicIconTap
                                                              .value
                                                          ? whiteColor
                                                          : blackColor,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    editController
                                                            .isTextUnderLineIconTap
                                                            .value =
                                                        !editController
                                                            .isTextUnderLineIconTap
                                                            .value;
                                                    editController
                                                            .isTextUnderLineIconTap
                                                            .value
                                                        ? editController
                                                                .textDecoration
                                                                .value =
                                                            TextDecoration
                                                                .underline
                                                        : editController
                                                                .textDecoration
                                                                .value =
                                                            TextDecoration.none;
                                                  },
                                                  child: Container(
                                                    color: editController
                                                            .isTextUnderLineIconTap
                                                            .value
                                                        ? blackColor
                                                        : transparentColor,
                                                    child: Icon(
                                                      Icons.format_underline,
                                                      size: 18,
                                                      color: editController
                                                              .isTextUnderLineIconTap
                                                              .value
                                                          ? whiteColor
                                                          : blackColor,
                                                    ),
                                                  ),
                                                ),
                                                const VerticalDivider(
                                                  color: blackColor,
                                                  indent: 10,
                                                  endIndent: 10,
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    editController
                                                        .isColorIconTap
                                                        .value = false;
                                                    editController.isMoreIconTap
                                                            .value =
                                                        !editController
                                                            .isMoreIconTap
                                                            .value;
                                                  },
                                                  child: const Icon(
                                                    Icons.more_horiz,
                                                    size: 20,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 15,
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      : Container(),
                                  editController.isColorIconTap.value == true
                                      ? GestureDetector(
                                          onTap: () {
                                            editController.isTextTap.value =
                                                true;
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.only(
                                                top: 5, left: 50, right: 50),
                                            decoration: BoxDecoration(
                                              color: whiteColor,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Container(
                                              margin: const EdgeInsets.only(
                                                top: 20,
                                                bottom: 20,
                                                left: 20,
                                                right: 20,
                                              ),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Color",
                                                    style: GoogleFonts.poppins(
                                                      fontWeight:
                                                          ui.FontWeight.bold,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 20,
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                        children: [
                                                          color(
                                                              color:
                                                                  Colors.red),
                                                          color(
                                                              color: Colors
                                                                  .indigo
                                                                  .shade900),
                                                          color(
                                                              color: Colors
                                                                  .purple
                                                                  .shade800),
                                                          color(
                                                              color: Colors.grey
                                                                  .shade700),
                                                          color(
                                                              color: Colors
                                                                  .green
                                                                  .shade800),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 15,
                                                      ),
                                                      Row(
                                                        children: [
                                                          color(
                                                              color: Colors
                                                                  .lightBlue
                                                                  .shade200),
                                                          color(
                                                              color:
                                                                  Colors.green),
                                                          color(
                                                              color: Colors
                                                                  .deepOrange
                                                                  .shade300),
                                                          color(
                                                              color: Colors
                                                                  .indigo
                                                                  .shade400),
                                                          color(
                                                              color: Colors.teal
                                                                  .shade300),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 15,
                                                      ),
                                                      Row(
                                                        children: [
                                                          color(
                                                              color:
                                                                  Colors.black),
                                                          color(
                                                              color:
                                                                  kPrimeryColor),
                                                          color(
                                                              color:
                                                                  Colors.amber),
                                                          Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .only(
                                                                    left: 7),
                                                            height: 20,
                                                            width: 20,
                                                            child: Stack(
                                                              children: [
                                                                ClipOval(
                                                                  child: colorPicker(
                                                                      context),
                                                                ),
                                                                const IgnorePointer(
                                                                  child: Center(
                                                                    child: Icon(
                                                                      Icons.add,
                                                                      color:
                                                                          whiteColor,
                                                                      size: 15,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                      : Container(),
                                  editController.isMoreIconTap.value == true
                                      ? Align(
                                          alignment: Alignment.centerRight,
                                          child: GestureDetector(
                                            onTap: () {
                                              editController.isTextTap.value =
                                                  true;
                                            },
                                            child: Container(
                                              margin: const EdgeInsets.only(
                                                  top: 5, right: 20),
                                              width: 150,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: whiteColor,
                                              ),
                                              child: ListView.builder(
                                                padding: const EdgeInsets.only(
                                                  top: 10,
                                                  bottom: 10,
                                                  left: 5,
                                                ),
                                                shrinkWrap: true,
                                                itemCount: moreList.length,
                                                itemBuilder: (context, index) {
                                                  return GestureDetector(
                                                    onTap: () {
                                                      index == 0
                                                          ? FlutterClipboard.copy(
                                                              editController
                                                                  .textController
                                                                  .value
                                                                  .text)
                                                          : index == 1
                                                              ? {
                                                                  duplicate =
                                                                      "${editController.textController.value.text}\n${editController.textController.value.text}",
                                                                  editController
                                                                          .textController
                                                                          .value
                                                                          .text =
                                                                      duplicate,
                                                                }
                                                              : index == 2
                                                                  ? {
                                                                      FlutterClipboard.copy(editController
                                                                          .textController
                                                                          .value
                                                                          .text),
                                                                      editController
                                                                          .textController
                                                                          .value
                                                                          .text = ""
                                                                    }
                                                                  : index == 3
                                                                      ? editController
                                                                          .textController
                                                                          .value
                                                                          .text = ""
                                                                      : null;
                                                      editController
                                                          .isMoreIconTap
                                                          .value = false;
                                                    },
                                                    child: Row(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: ImageIcon(
                                                            AssetImage(
                                                              moreList[index]
                                                                  ["image"],
                                                            ),
                                                            size: 20,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        Text(
                                                          moreList[index]
                                                              ["title"],
                                                          style: GoogleFonts
                                                              .poppins(
                                                            fontSize: 15,
                                                            fontWeight: ui
                                                                .FontWeight
                                                                .w500,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
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
            ),
          ),
        ),
      ),
    );
  }
}

class TextWidget extends StatefulWidget {
  var item;
  final VoidCallback onRemove;
  final VoidCallback onEdit;
  double selectedFontSize;
  TextWidget({
    super.key,
    required this.item,
    required this.onRemove,
    required this.onEdit,
    required this.selectedFontSize,
  });

  @override
  State<TextWidget> createState() => _TextWidgetState();
}

class _TextWidgetState extends State<TextWidget> {
  @override
  Widget build(BuildContext context) {
    return item();
  }

  item() {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Positioned(
      left: widget.item.offset.dx,
      top: widget.item.offset.dy,
      child: widget.item.text == ""
          ? Container()
          : Transform.rotate(
              angle: widget.item.rotation,
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: 0.87 * w,
                  minWidth: 0.2 * w,
                  maxHeight: 0.2 * h,
                ),
                child: Stack(
                  children: [
                    GestureDetector(
                      onPanStart: onPanStart,
                      onPanUpdate: onPanUpdate,
                      onPanEnd: (details) {
                        editController.isRotate.value = false;
                        editController.show.value = false;
                        setState(() {});
                      },
                      onPanCancel: () {
                        editController.isRotate.value = false;
                        editController.show.value = false;
                      },
                      child: Container(
                        margin: const EdgeInsets.all(15),
                        height: widget.item.fontSize +
                            widget.selectedFontSize +
                            100,
                        width: widget.item.fontSize +
                            widget.selectedFontSize *
                                widget.item.text.length *
                                1.5 +
                            100,
                        constraints: BoxConstraints(
                          maxHeight: 0.2 * h,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: editController.show.value
                                ? kEditFetureColor
                                : transparentColor,
                            width: 2,
                          ),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            editController.show.value =
                                !editController.show.value;
                            editController.isRotate.value = false;
                            setState(() {});
                          },
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Text(
                                widget.item.text,
                                textAlign: TextAlign.center,
                                maxLines: null,
                                style: GoogleFonts.poppins(
                                  fontSize: widget.item.selectTitle ==
                                          "Sub-Title"
                                      ? widget.selectedFontSize + 10
                                      : widget.item.selectTitle == "Body Text"
                                          ? widget.selectedFontSize + 7
                                          : widget.item.selectTitle == "Caption"
                                              ? widget.selectedFontSize + 4
                                              : widget.selectedFontSize + 16,
                                  color: widget.item.textColor,
                                  fontWeight: widget.item.fontWeight,
                                  decoration: widget.item.textDecoration,
                                  fontStyle: widget.item.fontStyle,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // top right
                    Positioned(
                      top: 0,
                      right: 0,
                      child: IgnorePointer(
                        child: Align(
                          alignment: Alignment.center,
                          child: editController.show.value
                              ? Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color.fromARGB(255, 65, 64, 64),
                                  ),
                                  child: const Icon(
                                    Icons.flip_camera_android,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                )
                              : Container(),
                        ),
                      ),
                    ),
                    // top left
                    Positioned(
                      top: 0,
                      left: 0,
                      child: editController.show.value
                          ? GestureDetector(
                              onTap: widget.onRemove,
                              child: Container(
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color.fromARGB(255, 65, 64, 64),
                                ),
                                height: 40,
                                width: 40,
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            )
                          : Container(),
                    ),

                    // bottom right
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: editController.show.value
                          ? Container(
                              decoration: const BoxDecoration(
                                color: Color.fromARGB(255, 65, 64, 64),
                                shape: BoxShape.circle,
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(9.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        editController.isSizeIconTap.value =
                                            true;
                                        setState(() {});
                                      },
                                      child: const Icon(
                                        Icons.open_in_full_outlined,
                                        size: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  ManipulatingBall(
                                    width: 30.0,
                                    height: 30.0,
                                    onDrag: (dx, dy) {
                                      var mid = (dx + dy) / 2;

                                      var newHeight =
                                          (widget.selectedFontSize + 2 * mid)
                                              .clamp(1.0, double.infinity);
                                      var newWidth =
                                          (widget.selectedFontSize + 2 * mid)
                                              .clamp(1.0, double.infinity);

                                      setState(() {
                                        widget.selectedFontSize = newHeight;
                                        widget.selectedFontSize = newWidth;
                                        editController.top.value =
                                            editController.top.value - mid;
                                        editController.left.value =
                                            editController.left.value - mid;
                                      });
                                    },
                                    onEnd: (p0) {
                                      editController.show.value = false;
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                            )
                          : Container(),
                    ),

                    // bottom Left
                    Positioned(
                      bottom: 0,
                      left: 0,
                      child: editController.show.value
                          ? Container(
                              decoration: const BoxDecoration(
                                color: Color.fromARGB(255, 65, 64, 64),
                                shape: BoxShape.circle,
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(9.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        editController.isEditIconTap.value =
                                            true;
                                        editController.isTextTap.value = true;
                                        editController
                                            .isTextFieldTextAdd.value = true;
                                        widget.onEdit();
                                      },
                                      child: const Icon(
                                        Icons.edit,
                                        size: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
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

  var touchPosition = Offset.zero;
  onPanStart(DragStartDetails details) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    Offset centerOfGestureDetector =
        Offset(editController.width.value / 2, editController.height.value / 2);

    final touchPositionFromCenter =
        details.localPosition - centerOfGestureDetector;
    editController.offsetAngle.value =
        touchPositionFromCenter.direction - widget.item.rotation;

    final RenderBox referenceBox =
        widget.item.parentKey.currentContext.findRenderObject();
    var x = referenceBox.globalToLocal(details.globalPosition);

    touchPosition = editController.imageHeight.value == double.infinity
        ? Offset(x.dx, x.dy + 100)
        : editController.imageHeight.value == 0.65 * h
            ? Offset(x.dx, x.dy + 155)
            : editController.imageHeight.value == 0.6 * h
                ? Offset(x.dx, x.dy + 170)
                : editController.imageHeight.value == 0.65 * h
                    ? Offset(x.dx, x.dy + 155)
                    : editController.imageHeight.value == 0.62 * h
                        ? Offset(x.dx + 30, x.dy + 180)
                        : Offset(x.dx + 30, x.dy + 200);
    if (details.localPosition.dx > editController.width.value - 40 &&
        details.localPosition.dy < 40) {
      editController.isRotate.value = true;
    }
  }

  onPanUpdate(DragUpdateDetails details) {
    if (editController.isRotate.value) {
      Offset centerOfGestureDetector = Offset(
          editController.width.value / 2, editController.height.value / 2);

      final touchPositionFromCenter =
          details.localPosition - centerOfGestureDetector;

      widget.item.rotation = (touchPositionFromCenter.direction -
          editController.offsetAngle.value);
    } else {
      var positionG = widget.item.offset + details.globalPosition;
      var positiong2 = positionG - touchPosition;
      widget.item.offset = (positiong2 - widget.item.offset);
    }
    setState(() {});
  }
}

class ImageWidget extends StatefulWidget {
  var imageItem;
  final VoidCallback onRemove;

  ImageWidget({
    super.key,
    required this.imageItem,
    required this.onRemove,
  });

  @override
  State<ImageWidget> createState() => _ImageWidgetState();
}

class _ImageWidgetState extends State<ImageWidget> {
  @override
  Widget build(BuildContext context) {
    return item();
  }

  Widget item() {
    return Positioned(
      left: widget.imageItem.offset.dx,
      top: widget.imageItem.offset.dy,
      child: widget.imageItem.image == null
          ? Container()
          : Obx(
              () => Transform.rotate(
                angle: widget.imageItem.imageRotation,
                child: SizedBox(
                  child: Stack(
                    children: [
                      GestureDetector(
                        onPanStart: onPanStart,
                        onPanUpdate: onPanUpdate,
                        onPanEnd: (details) {
                          editController.isRotate.value = false;
                          editController.show.value = false;
                        },
                        onPanCancel: () {
                          editController.isRotate.value = false;
                        },
                        child: Container(
                          margin: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: editController.show.value
                                  ? kEditFetureColor
                                  : transparentColor,
                              width: 1,
                            ),
                          ),
                          child: GestureDetector(
                            onTap: () {
                              editController.show.value =
                                  !editController.show.value;
                            },
                            child: editController.logoIndex.value == 0
                                ? GestureDetector(
                                    onTap: () {
                                      editController.show.value = true;
                                    },
                                    child: Container(
                                      height: widget.imageItem.imageSize,
                                      width: widget.imageItem.imageSize,
                                    ),
                                  )
                                : editController.logoIndex.value == 1
                                    ? Container(
                                        height: widget.imageItem.imageSize,
                                        width: widget.imageItem.imageSize,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                            image: FileImage(
                                              File(widget.imageItem.image),
                                            ),
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      )
                                    : editController.logoIndex.value == 2
                                        ? Container(
                                            height: widget.imageItem.imageSize,
                                            width: widget.imageItem.imageSize,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: FileImage(
                                                  File(widget.imageItem.image),
                                                ),
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          )
                                        : editController.logoIndex.value == 3
                                            ? ClipPath(
                                                clipper: TriangleClipper(),
                                                child: Image.file(
                                                  File(widget.imageItem.image),
                                                  fit: BoxFit.fill,
                                                  width: widget
                                                      .imageItem.imageSize,
                                                  height: widget
                                                      .imageItem.imageSize,
                                                ),
                                              )
                                            : editController.logoIndex.value ==
                                                    4
                                                ? Container(
                                                    height: widget.imageItem
                                                            .imageSize /
                                                        2,
                                                    width: widget
                                                        .imageItem.imageSize,
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                        image: FileImage(
                                                          File(widget
                                                              .imageItem.image),
                                                        ),
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  )
                                                : editController
                                                            .logoIndex.value ==
                                                        5
                                                    ? ClipPath(
                                                        clipper:
                                                            PolygonClipper(),
                                                        child: Image.file(
                                                          File(widget
                                                              .imageItem.image),
                                                          fit: BoxFit.fill,
                                                          width: widget
                                                              .imageItem
                                                              .imageSize,
                                                          height: widget
                                                              .imageItem
                                                              .imageSize,
                                                        ),
                                                      )
                                                    : null,
                          ),
                        ),
                      ),

                      // top right
                      Positioned(
                        top: 2,
                        right: 2,
                        child: IgnorePointer(
                          child: Align(
                            alignment: Alignment.topRight,
                            child: editController.show.value
                                ? Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: whiteColor,
                                    ),
                                    child: const Icon(
                                      Icons.flip_camera_android,
                                      color: kPrimeryColor,
                                      size: 20,
                                    ),
                                  )
                                : Container(),
                          ),
                        ),
                      ),

                      // top left
                      Positioned(
                        top: 2,
                        left: 2,
                        child: editController.show.value
                            ? Container(
                                padding: const EdgeInsets.all(5),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: whiteColor,
                                ),
                                child: GestureDetector(
                                  onTap: widget.onRemove,
                                  child: const Icon(
                                    Icons.delete,
                                    color: kPrimeryColor,
                                    size: 20,
                                  ),
                                ),
                              )
                            : Container(),
                      ),

                      // bottom right
                      Positioned(
                        bottom: 2,
                        right: 2,
                        child: editController.show.value
                            ? Container(
                                decoration: const BoxDecoration(
                                  color: whiteColor,
                                  shape: BoxShape.circle,
                                ),
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
                                          color: kPrimeryColor,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                    ManipulatingBall(
                                      width: 30.0,
                                      height: 30.0,
                                      onDrag: (dx, dy) {
                                        var mid = (dx + dy) / 2;
                                        var newHeight =
                                            (widget.imageItem.imageSize +
                                                    2 * mid)
                                                .clamp(1.0, double.infinity);

                                        setState(() {
                                          widget.imageItem.imageSize =
                                              newHeight;
                                          editController.top.value =
                                              editController.top.value - mid;
                                          editController.left.value =
                                              editController.left.value - mid;
                                        });
                                      },
                                      onEnd: (p0) {
                                        editController.show.value = false;
                                      },
                                    ),
                                  ],
                                ),
                              )
                            : Container(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Offset touchPosition = Offset.zero;

  onPanStart(DragStartDetails details) {
    Offset centerOfGestureDetector =
        Offset(editController.width.value / 2, editController.height.value / 2);

    final touchPositionFromCenter =
        details.localPosition - centerOfGestureDetector;
    editController.offsetAngle.value =
        touchPositionFromCenter.direction - widget.imageItem.imageRotation;

    if (details.localPosition.dx > (editController.width.value - 40) &&
        details.localPosition.dy <= 40) {
      editController.isRotate.value = true;
    } else {
      editController.isRotate.value = false;
    }

    touchPosition = details.localPosition;
  }

  onPanUpdate(DragUpdateDetails details) {
    if (editController.isRotate.value) {
      Offset centerOfGestureDetector = Offset(
          editController.width.value / 2, editController.height.value / 2);
      final touchPositionFromCenter =
          details.localPosition - centerOfGestureDetector;
      widget.imageItem.imageRotation =
          touchPositionFromCenter.direction - editController.offsetAngle.value;
    } else {
      final rotatedDelta = Offset(
        details.delta.dx * cos(widget.imageItem.imageRotation) -
            details.delta.dy * sin(widget.imageItem.imageRotation),
        details.delta.dx * sin(widget.imageItem.imageRotation) +
            details.delta.dy * cos(widget.imageItem.imageRotation),
      );

      widget.imageItem.offset += rotatedDelta;
    }

    setState(() {});
  }
}

class ManipulatingBall extends StatefulWidget {
  ManipulatingBall(
      {Key? key,
      this.onEnd,
      required this.onDrag,
      required this.height,
      required this.width});

  final Function onDrag;
  Function(DragEndDetails)? onEnd;
  double height;
  double width;

  @override
  _ManipulatingBallState createState() => _ManipulatingBallState();
}

class _ManipulatingBallState extends State<ManipulatingBall> {
  double? initX;
  double? initY;

  _handleDrag(details) {
    setState(() {
      initX = details.localPosition.dx;
      initY = details.localPosition.dy;
    });
  }

  _handleUpdate(details) {
    var dx = details.localPosition.dx - initX;
    var dy = details.localPosition.dy - initY;
    initX = details.localPosition.dx;
    initY = details.localPosition.dy;
    widget.onDrag(dx, dy);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: _handleDrag,
      onPanUpdate: _handleUpdate,
      onPanEnd: widget.onEnd,
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: const BoxDecoration(),
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
