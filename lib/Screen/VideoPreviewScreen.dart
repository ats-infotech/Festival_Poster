import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:photo_frame/Contstant/AppColor.dart';
import 'package:photo_frame/Contstant/CommonMethod.dart';
import 'package:video_player/video_player.dart';

import 'package:get/get.dart';
import 'package:photo_frame/Screen/BottomNavBar.dart';
import 'package:photo_frame/Screen/EditImageScreen.dart';
import 'package:share_plus/share_plus.dart';

class VideoPreviewScreen extends StatefulWidget {
  final File file;
  final bool fromEdit;

  const VideoPreviewScreen(
      {super.key, required this.file, required this.fromEdit});

  @override
  State<VideoPreviewScreen> createState() => _VideoPreviewScreenState();
}

class _VideoPreviewScreenState extends State<VideoPreviewScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    initializePlayer();
  }

  void initializePlayer() async {
    _controller = VideoPlayerController.file(widget.file);
    await _controller.initialize();
    _controller.setLooping(true);
    _controller.play();

    _controller.addListener(() {
      if (mounted) setState(() {});
    });

    setState(() {});
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  void handleExit() {
    Get.offAll(
      transition: Transition.rightToLeftWithFade,
      () => const BottomNavBarBar(),
    );
  }

  Future<void> shareVideo(String videoPath) async {
    try {
      XFile xfile = XFile(videoPath);
      await Share.shareXFiles([xfile], text: 'video');
    } catch (e) {
      print("------------- Video Share Error ----------- $e");
    }
  }

  @override
  void dispose() {
    if (_controller.value.isInitialized) {
      _controller.pause();
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentPosition = _controller.value.isInitialized
        ? _controller.value.position
        : Duration.zero;

    final totalDuration = _controller.value.isInitialized
        ? _controller.value.duration
        : Duration.zero;

    return WillPopScope(
      onWillPop: () async {
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
        _controller.pause();
        setState(() {});
        if (widget.fromEdit == true) {
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
              _controller.pause();
              setState(() {});
              if (widget.fromEdit == true) {
                handleExit();
              } else {
                Get.back();
              }
            },
            icon: commonBackArrow(),
          ),
          backgroundColor: kPrimeryColor,
          title: Text(
            'Video Preview',
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
                onPressed: () {
                  shareVideo(widget.file.path);
                },
                icon: const Icon(Icons.share),
              ),
            ),
          ],
        ),
        body: _controller.value.isInitialized
            ? Stack(
                alignment: Alignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _controller.value.isPlaying
                                    ? _controller.pause()
                                    : _controller.play();
                              });
                            },
                            child: VideoPlayer(_controller),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      VideoProgressIndicator(
                        _controller,
                        allowScrubbing: true,
                        colors: VideoProgressColors(
                          playedColor: kPrimeryColor,
                          bufferedColor: Colors.grey.shade300,
                          backgroundColor: Colors.grey.shade100,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              formatDuration(currentPosition),
                              style: GoogleFonts.poppins(
                                color: kPrimeryColor,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              formatDuration(totalDuration),
                              style: GoogleFonts.poppins(
                                color: kPrimeryColor,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // Center play/pause overlay
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _controller.value.isPlaying
                            ? _controller.pause()
                            : _controller.play();
                      });
                    },
                    child: AnimatedOpacity(
                      opacity: _controller.value.isPlaying ? 0.0 : 1.0,
                      duration: const Duration(milliseconds: 300),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(10),
                        child: Icon(
                          _controller.value.isPlaying
                              ? Icons.pause
                              : Icons.play_arrow,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : commonLoader(),
      ),
    );
  }
}
