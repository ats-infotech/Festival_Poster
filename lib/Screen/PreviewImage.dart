import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:photo_frame/Contstant/AppColor.dart';
import 'package:photo_frame/Contstant/Strings.dart';
import 'package:photo_view/photo_view.dart';
import 'package:share_extend/share_extend.dart';
import 'package:share_plus/share_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class PreviewImage extends StatefulWidget {
  final List<File> image;
  final int index;
  const PreviewImage({super.key, required this.image, required this.index});

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
          ShareExtend.share(widget.image[_pageController.page!.toInt()].path,
              "${DateTime.now().millisecondsSinceEpoch}.png");
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
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
    );
  }
}
