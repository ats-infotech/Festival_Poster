import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/state_manager.dart';
import 'package:photo_frame/Contstant/AppColor.dart';

class EditController extends GetxController {
  RxInt functionTap = (-1).obs;
  RxBool isBoxTap = false.obs;
  Rx<Color> textBlackColor = blackColor.obs;
  Rx<Color> filterContainerColor = transparentColor.obs;
  Rx<FontWeight> fontWeight = FontWeight.normal.obs;
  Rx<TextDecoration> textDecoration = TextDecoration.none.obs;
  Rx<FontStyle> fontStyle = FontStyle.normal.obs;
  FocusNode focusNode = FocusNode();
  RxInt logoIndex = 1.obs;
  var sides = 7;
  var radius = 100.0;
  var pickLogo = Rx<File?>(null);
  Rx<TextEditingController> textController = TextEditingController().obs;

  RxList sizeList = [
    {
      "image": "assets/images/default.png",
      "size": "Default",
    },
    {
      "image": "assets/images/free.png",
      "size": "Free",
    },
    {
      "image": "assets/images/square.png",
      "size": "Square",
    },
    {
      "image": "assets/images/9:16.png",
      "size": "9:16",
    },
    {
      "image": "assets/images/1:1.png",
      "size": "1:1",
    },
    {
      "image": "assets/images/2:3.png",
      "size": "2:3",
    },
  ].obs;

  RxList functionList = [
    {
      "image": "assets/images/filter.png",
      "size": "Filter",
    },
    {
      "image": "assets/images/text.png",
      "size": "Text",
    },
    {
      "image": "assets/images/crop.png",
      "size": "Crop",
    },
    {
      "image": "assets/images/contrast.png",
      "size": "Contrast",
    },
    {
      "image": "assets/images/rotate.png",
      "size": "Rotate",
    },
    {
      "image": "assets/images/size.png",
      "size": "Size",
    },
    {
      "image": "assets/images/addLogo.png",
      "size": "Images",
    },
  ].obs;

  RxList<String> titleList = [
    "Sub-Title",
    "Body Text",
    "Caption",
  ].obs;

  RxList logotypeList = [
    "assets/images/logoNone.png",
    "assets/images/logoRound.png",
    "assets/images/logoRectangle.png",
    "assets/images/logoTringle.png",
    "assets/images/logoRectangle2.png",
    "assets/images/logoPolygon.png",
  ].obs;

  RxInt sizeTap = 0.obs;

  RxDouble height = 130.0.obs;
  RxDouble width = 130.0.obs;
  RxDouble contrast = 1.0.obs;
  RxDouble angle = 0.0.obs;

  RxBool isTextTap = false.obs;
  RxBool isCropTap = false.obs;
  RxBool isCropImageDone = false.obs;
  RxBool isFilterTap = false.obs;
  RxBool isContrastTap = false.obs;
  RxBool isRotateTap = false.obs;
  RxBool isSizeBoxTap = false.obs;
  RxBool isLogoImageTap = false.obs;

  Rx<BoxFit> imageFit = BoxFit.fill.obs;
  RxDouble imageHeight = double.infinity.obs;

  RxBool isRotate = false.obs;
  RxBool showText = true.obs;
  RxBool show = true.obs;
  RxBool isSizeIconTap = false.obs;
  RxBool isEditIconTap = false.obs;
  RxBool isBoldIconTap = false.obs;
  RxBool isTextUnderLineIconTap = false.obs;
  RxBool isTextItalicIconTap = false.obs;
  RxBool isResizing = false.obs;

  RxBool isTextFieldTextAdd = false.obs;
  RxBool isColorIconTap = false.obs;
  RxBool isMoreIconTap = false.obs;

  RxDouble offsetAngle = 0.0.obs;
  RxDouble top = 70.0.obs;
  RxDouble left = 30.0.obs;

  RxDouble? initX;
  RxDouble? initY;

  RxString selectedTitle = 'Title'.obs;
  RxDouble selectedFontSize = 8.0.obs;

  void updateTap(int index) {
    functionTap.value = index;

    isFilterTap.value = index == 0;
    {
      isTextTap.value = index == 1;
      isEditIconTap.value = false;
      textBlackColor.value = blackColor;
      isBoldIconTap.value = false;
      fontWeight.value = FontWeight.normal;
      textDecoration.value = TextDecoration.none;
      fontStyle.value = FontStyle.normal;
      isTextFieldTextAdd.value = false;
      isColorIconTap.value = false;
      isTextItalicIconTap.value = false;
      isTextUnderLineIconTap.value = false;
      isMoreIconTap.value = false;
      textController.value.text = "";
      selectedTitle.value = "";
      selectedFontSize.value = 8;
      focusNode.requestFocus();
    }

    isCropTap.value = index == 2;
    isContrastTap.value = index == 3;
    isRotateTap.value = index == 4;
    isSizeBoxTap.value = index == 5;
    isLogoImageTap.value = index == 6;
  }
}
