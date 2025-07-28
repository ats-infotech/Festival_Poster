import 'package:google_fonts/google_fonts.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:zoom_widget/zoom_widget.dart';
// import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_frame/Controller/CardEditController.dart';

class CardPreview extends StatefulWidget {
  const CardPreview({super.key});

  @override
  State<CardPreview> createState() => _CardPreviewState();
}

class _CardPreviewState extends State<CardPreview> {
  CardEditController cardEditController = Get.put(CardEditController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff1E3360),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: double.infinity,
                color: const Color(0xffE8E8E8),
                child: Zoom(
                    initScale: 2,
                    initPosition: const Offset(0.0, 0.0),
                    backgroundColor: Colors.transparent,
                    scrollWeight: 0,
                    maxZoomWidth: 1800,
                    maxZoomHeight: 1800,
                    initTotalZoomOut: true,
                    canvasColor: Colors.transparent,
                    child: Column(
                      children: [
                        Image.file(File(
                            cardEditController.processBackCardPath.value ??
                                "")),
                        const SizedBox(
                          height: 22,
                        ),
                        Image.file(File(
                            cardEditController.processFrontCardPath.value ??
                                "")),
                      ],
                    )),
                // child: GestureDetector(
                //   onScaleStart: (ScaleStartDetails details) {
                //     _previousScale = _scale;
                //   },
                //   onScaleUpdate: (ScaleUpdateDetails details) {
                //     setState(() {
                //       _scale = _previousScale * details.scale;
                //     });
                //   },
                //   onScaleEnd: (ScaleEndDetails details) {
                //     _previousScale = _scale;
                //   },
                //   child: Transform.scale(
                //     scale: _scale,
                //     child: Container(
                //       width: 200,
                //       height: 200,
                //       color: Colors.blue,
                //       child: Center(
                //         child: Text(
                //           "Zoom Me",
                //           style: TextStyle(
                //               color: Colors.white,
                //               fontSize: 20), // Fixed text size
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff1E3360)),
            onPressed: () async {
              final result = await ImageGallerySaverPlus.saveFile(
                  cardEditController.processBackCardPath.value!);
              await ImageGallerySaverPlus.saveFile(
                  cardEditController.processFrontCardPath.value!);
              print("Image saved to gallery: $result");
            },
            child: Text(
              'Download Card',
              style: GoogleFonts.poppins(
                color: Colors.white,
              ),
            ),
          ),
          Container(
            height: 150,
            color: const Color(0xff1E3360),
          ),
        ],
      ),
    );
  }
}
