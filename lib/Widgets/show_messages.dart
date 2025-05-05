import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class ShowMessages {
  void showSnackBar(message) async {
    if (!Get.isSnackbarOpen) {
      Get.snackbar(
        '',
        message,
        padding: const EdgeInsets.only(left: 20, right: 20, top: 8, bottom: 14),
        backgroundColor: const Color(0xFF525252),
        colorText: Colors.white,
        duration: const Duration(milliseconds: 5000),
        snackPosition: SnackPosition.TOP,
        maxWidth: kIsWeb ? 400 : Get.width,
        titleText: const SizedBox.shrink(),
        margin: const EdgeInsets.all(30),
        borderRadius: 6,
      );
    }
  }
}
