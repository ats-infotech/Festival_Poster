import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:photo_frame/Contstant/AppColor.dart';
import 'package:photo_frame/Contstant/CommonMethod.dart';
import 'package:photo_frame/Contstant/Strings.dart';
import 'package:photo_frame/Screen/BottomNavBar.dart';
import 'package:photo_frame/Screen/EditImageScreen.dart';
import 'package:photo_frame/Screen/saveImageShow.dart';
import 'package:photo_view/photo_view.dart';
// import 'package:share_extend/share_extend.dart';
import 'package:share_plus/share_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class PreviewImage extends StatefulWidget {
  final List<File> image;
  final int index;
  final bool fromEdit;
  const PreviewImage(
      {super.key,
      required this.image,
      required this.index,
      required this.fromEdit});

  @override
  State<PreviewImage> createState() => _PreviewImageState();
}

class _PreviewImageState extends State<PreviewImage> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.index);
  }

  Future<void> shareImage() async {
    try {
      if (Platform.isAndroid) {
        var storageStatus = await Permission.storage.request();
        if (storageStatus.isGranted) {
          // ShareExtend.share(widget.image[_pageController.page!.toInt()].path,
          //     "${DateTime.now().millisecondsSinceEpoch}.png");
          XFile file =
              XFile(widget.image[_pageController.page?.toInt() ?? 0].path);
          Share.shareXFiles([file],
              text: "${DateTime.now().millisecondsSinceEpoch}.png");
        }

        // Request permission for Android 13+
        var photoStatus = await Permission.photos.request();
        if (photoStatus.isGranted) {
          XFile file =
              XFile(widget.image[_pageController.page?.toInt() ?? 0].path);
          await Share.shareXFiles([file],
              text: "${DateTime.now().millisecondsSinceEpoch}.png");
        }
      }
    } catch (e) {
      print("------ Image Share Error ---------- $e");
    }
  }

  void handleExit() {
    Get.offAll(
      transition: Transition.rightToLeftWithFade,
      () => const BottomNavBarBar(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.fromEdit == true) {
          editController.functionTap.value = -1;
          editController.isFilterTap.value = false;
          editController.textController.value.text = "";
          editController.isTextTap.value = false;
          editController.isCropImageDone.value = false;

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

          editController.isImageSaveLoader.value = false;
          editController.isShareImage.value = false;
          editController.frontImage.value = null;
          editController.backImage.value = null;
          editController.items.clear();
          editController.pickLogos.clear();
          editController.pickLogosCardFrontSide.clear();
          editController.pickLogosCardBackSide.clear();
          editController.checkBoxValue.value = false;
          editController.isPickAudioIconTap.value = false;
          editController.selectedAudioPath.value = "";

          setState(() {});

          handleExit();
        } else {
          Get.back();
        }
        return false;
      },
      child: Scaffold(
        backgroundColor: whiteColor,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              if (widget.fromEdit == true) {
                editController.functionTap.value = -1;
                editController.isFilterTap.value = false;
                editController.textController.value.text = "";
                editController.isTextTap.value = false;
                editController.isCropImageDone.value = false;

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

                editController.isImageSaveLoader.value = false;
                editController.isShareImage.value = false;
                editController.frontImage.value = null;
                editController.backImage.value = null;
                editController.items.clear();
                editController.pickLogos.clear();
                editController.pickLogosCardFrontSide.clear();
                editController.pickLogosCardBackSide.clear();
                editController.checkBoxValue.value = false;
                editController.isPickAudioIconTap.value = false;
                editController.selectedAudioPath.value = "";

                setState(() {});

                handleExit();
              } else {
                Get.back();
              }
            },
            icon: commonBackArrow(),
          ),
          backgroundColor: blackColor,
          title: Text(
            preview,
            style: GoogleFonts.poppins(
              color: whiteColor,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 5.0),
              child: IconButton(
                onPressed: shareImage,
                icon: const Icon(Icons.share),
              ),
            ),
          ],
        ),
        body: PageView.builder(
          controller: _pageController,
          itemCount: widget.image.length,
          itemBuilder: (context, index) {
            return PhotoView(
              imageProvider: FileImage(
                widget.image[index],
              ),
              maxScale: 1.0,
              minScale: 0.1,
            );
          },
        ),
      ),
    );
  }
}
