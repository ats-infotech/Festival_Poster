import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:photo_frame/Controller/CardEditController.dart';
import 'package:photo_frame/Contstant/AppColor.dart';
import 'package:photo_frame/Contstant/Strings.dart';
import 'package:photo_frame/Screen/CardCreate.dart';
import 'package:photo_frame/Screen/PersonalInfo.dart';
import 'package:photo_frame/model/card_model.dart';
import 'package:zoom_widget/zoom_widget.dart';

class CardEdit extends StatefulWidget {
  final CardModel data;
  const CardEdit({super.key, required this.data});

  @override
  State<CardEdit> createState() => _CardEditState();
}

class _CardEditState extends State<CardEdit> {
  final CardEditController cardEditController = Get.put(CardEditController());
  @override
  void initState() {
    super.initState();
    cardEditController.processBackCardPath.value = null;
    cardEditController.processFrontCardPath.value = null;
    cardEditController.getData().then(
      (value) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CardCreate(
                data: widget.data,
              ),
            ));
      },
    );
  }

  imageSaveSuccessDialog(
    BuildContext context,
    onTap,
  ) {
    var w = MediaQuery.of(context).size.width / 100;
    showDialog(
      context: context,
      builder: (context) {
        return Scaffold(
          backgroundColor: transparentColor,
          body: Center(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              width: double.infinity,
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      "assets/images/success.png",
                      scale: 5,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      width: double.infinity,
                      child: Text(
                        imageSaveDescription,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        style: GoogleFonts.poppins(
                          fontSize: 3.2 * w,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      checkGallery,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: greyColor,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: kPrimeryColor,
                              ),
                              height: 45,
                              width: 37 * w,
                              child: Center(
                                child: Text(
                                  ok,
                                  style: GoogleFonts.poppins(
                                    color: whiteColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
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
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: kPrimeryColor,
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // IconButton(
            //   onPressed: () {},
            //   icon: const Icon(
            //     Icons.undo,
            //   ),
            // ),
            // IconButton(
            //   onPressed: () {},
            //   icon: const Icon(
            //     Icons.redo,
            //   ),
            // ),
          ],
        ),
        centerTitle: true,
        actions: [
          // IconButton(
          //   onPressed: () {},
          //   icon: const Icon(
          //     Icons.add,
          //   ),
          // ),
          Obx(
            () => cardEditController.processBackCardPath.value == null
                ? Container()
                : IconButton(
                    iconSize: 20,
                    onPressed: () async {
                      // await ImageGallerySaver.saveFile(
                      //     cardEditController.processBackCardPath.value!);
                      // await ImageGallerySaver.saveFile(
                      //     cardEditController.processFrontCardPath.value!);
                      imageSaveSuccessDialog(
                        context,
                        () {
                          Navigator.of(context).pop();
                        },
                      );
                    },
                    icon: const ImageIcon(
                      AssetImage('assets/images/drawerSaveImage.png'),
                    ),
                  ),
          ),
          // IconButton(
          //   iconSize: 20,
          //   onPressed: () {},
          //   icon: const ImageIcon(
          //     AssetImage('assets/images/gallery.png'),
          //   ),
          // ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  Obx(
                    () => cardEditController.processBackCardPath.value ==
                                null ||
                            cardEditController.processFrontCardPath.value ==
                                null
                        ? Padding(
                            padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * .02),
                            child: Container(
                              height: MediaQuery.of(context).size.height * .5,
                              decoration: BoxDecoration(
                                  color: const Color(0xffF8F8F8),
                                  borderRadius: BorderRadius.circular(5)),
                              alignment: Alignment.center,
                              child: Image.asset(widget.data.coverImage),
                            ),
                          )
                        : Expanded(
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
                                        Image.file(File(cardEditController
                                                .processBackCardPath.value ??
                                            "")),
                                        const SizedBox(
                                          height: 22,
                                        ),
                                        Image.file(File(cardEditController
                                                .processFrontCardPath.value ??
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
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: ElevatedButton(
                onPressed: () {
                  // cardEditController.showEditBottomSheet(context,
                  //     data: widget.data);

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PersonalInfo(),
                      )).then(
                    (value) {
                      if (value ?? false) {
                        cardEditController.getData().then(
                          (value) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CardCreate(
                                    data: widget.data,
                                  ),
                                ));
                          },
                        );
                      }
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimeryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.edit,
                      size: 20,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Edit',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
