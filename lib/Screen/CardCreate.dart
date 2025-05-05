import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:ui' as ui;

import 'package:photo_frame/Controller/CardEditController.dart';
import 'package:photo_frame/Contstant/AppColor.dart';
import 'package:photo_frame/Screen/CardPreview.dart';
import 'package:photo_frame/Widgets/MyCardText.dart';
import 'package:photo_frame/model/card_model.dart';

class CardCreate extends StatefulWidget {
  final CardModel data;
  const CardCreate({super.key, required this.data});

  @override
  State<CardCreate> createState() => _CardCreateState();
}

class _CardCreateState extends State<CardCreate> {
  CardEditController cardEditController = Get.put(CardEditController());

  final GlobalKey frontCardKey = GlobalKey();
  final GlobalKey backCardKey = GlobalKey();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        // await Future.delayed(const Duration(milliseconds: 700));
        // await captureAndSave();
        // Navigator.pushReplacement(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => const CardPreview(),
        //     ));
        if (!cardEditController.kIsDevMode) {
          await Future.delayed(const Duration(milliseconds: 700));
          await captureAndSave();
          Get.back();
        }
      },
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Stack(
        children: [
          Column(
            children: [
              // for new add
              cardEditController.kIsDevMode
                  ? SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const ScrollPhysics(),
                      child: SizedBox(
                        height: 200,
                        width: 350,
                        child: RepaintBoundary(
                          key: backCardKey,
                          child: Stack(
                            children: [
                              SizedBox(
                                height: 200,
                                width: 350,
                                child: Image.asset(
                                  'assets/images/visitingCardBackSide_1.png',
                                  fit: BoxFit.fill,
                                ),
                              ),
                              // title
                              Transform.translate(
                                offset: const Offset(-15, 50),
                                child: SizedBox(
                                  width: 140,
                                  height: 20,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      cardEditController.title.value ?? "",
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.righteous(
                                          color: Colors.black,
                                          fontSize: 0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                              // sub title
                              Transform.translate(
                                offset: const Offset(-15, 60),
                                child: SizedBox(
                                  width: 140,
                                  height: 20,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      cardEditController.subTitle.value ?? "",
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.righteous(
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black,
                                          fontSize: 0),
                                    ),
                                  ),
                                ),
                              ),
                              // Phone Number
                              Transform.translate(
                                offset: const Offset(35, 85),
                                child: SizedBox(
                                  width: 120,
                                  height: 10,
                                  // color: Colors.teal,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      cardEditController.number.value ?? "",
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.roboto(
                                          fontSize: 8,
                                          fontWeight: FontWeight.w500,
                                          color: const Color(0Xff002838)),
                                    ),
                                  ),
                                ),
                              ),
                              // Email
                              Transform.translate(
                                offset: const Offset(35, 105),
                                child: SizedBox(
                                  width: 120,
                                  height: 10,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      cardEditController.email.value ?? "",
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.roboto(
                                          fontSize: 8,
                                          fontWeight: FontWeight.w500,
                                          color: const Color(0Xff002838)),
                                    ),
                                  ),
                                ),
                              ),
                              // Website
                              Transform.translate(
                                offset: const Offset(35, 125),
                                child: SizedBox(
                                  width: 120,
                                  height: 10,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      cardEditController.website.value ?? "",
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.roboto(
                                          fontSize: 8,
                                          fontWeight: FontWeight.w500,
                                          color: const Color(0Xff002838)),
                                    ),
                                  ),
                                ),
                              ),
                              // Location
                              Transform.translate(
                                offset: const Offset(35, 65),
                                child: SizedBox(
                                  width: 120,
                                  height: 10,
                                  // color: Colors.green,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      cardEditController.location.value ?? "",
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.roboto(
                                          fontSize: 8,
                                          fontWeight: FontWeight.w500,
                                          color: const Color(0Xff002838)),
                                    ),
                                  ),
                                ),
                              ),
                              // Name
                              Transform.translate(
                                offset: const Offset(190, 80),
                                child: SizedBox(
                                  width: 140,
                                  height: 20,
                                  // color: Colors.amber,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      cardEditController.name.value ?? "",
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.staatliches(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 16,
                                          color: const Color(0Xff002838)),
                                    ),
                                  ),
                                ),
                              ),
                              // // Role
                              Transform.translate(
                                offset: const Offset(190, 102),
                                child: SizedBox(
                                  width: 140,
                                  height: 20,
                                  // color: Colors.amber,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      cardEditController.role.value ?? "",
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.roboto(
                                          fontSize: 10,
                                          color: const Color(0Xff002838),
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  :

                  // main
                  SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const ScrollPhysics(),
                      child: SizedBox(
                        height: 200,
                        width: 350,
                        child: RepaintBoundary(
                          key: backCardKey,
                          child: Stack(
                            children: [
                              SizedBox(
                                height: 200,
                                width: 350,
                                child: Image.asset(
                                  widget.data.backImage,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              // title
                              MyCardText(
                                  data: widget.data.titleProperty,
                                  text: cardEditController.title.value ??
                                      "".trim()),
                              // sub title
                              MyCardText(
                                  data: widget.data.subTitleProperty,
                                  text: cardEditController.subTitle.value ??
                                      "".trim()),
                              // Name
                              MyCardText(
                                  data: widget.data.nameProperty,
                                  text: cardEditController.name.value ??
                                      "".trim()),
                              // Role
                              MyCardText(
                                  data: widget.data.roleProperty,
                                  text: cardEditController.role.value ??
                                      "".trim()),
                              // Phone Number
                              MyCardText(
                                  data: widget.data.contactProperty,
                                  text: cardEditController.number.value ??
                                      "".trim()),
                              // Email
                              MyCardText(
                                  data: widget.data.emailProperty,
                                  text: cardEditController.email.value ??
                                      "".trim()),
                              // Location
                              MyCardText(
                                  data: widget.data.locationProperty,
                                  text: cardEditController.location.value ??
                                      "".trim()),
                              // Website
                              MyCardText(
                                  data: widget.data.websiteProperty,
                                  text: cardEditController.website.value ??
                                      "".trim()),
                            ],
                          ),
                        ),
                      ),
                    ),

              const SizedBox(
                height: 20,
              ),

              // for new add
              cardEditController.kIsDevMode
                  ? SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const ScrollPhysics(),
                      child: SizedBox(
                        height: 200,
                        width: 350,
                        child: RepaintBoundary(
                          key: frontCardKey,
                          child: Stack(
                            children: [
                              SizedBox(
                                height: 200,
                                width: 350,
                                child: Image.asset(
                                  'assets/images/visitingCardFrontSide_1.png',
                                  fit: BoxFit.fill,
                                ),
                              ),
                              // title
                              Transform.translate(
                                offset: const Offset(0, 110),
                                child: SizedBox(
                                  width: 350,
                                  height: 20,
                                  // color: Colors.amber,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      cardEditController.title.value ?? "",
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.staatliches(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 15,
                                        color: const Color(0xffEA8D2A),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              // sub title
                              Transform.translate(
                                offset: const Offset(0, 125),
                                child: SizedBox(
                                  width: 350,
                                  height: 20,
                                  // color: Colors.amber,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      cardEditController.subTitle.value ?? "",
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.roboto(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 10,
                                          color: const Color(0xffEA8D2A)),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  :

                  // main
                  SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const ScrollPhysics(),
                      child: SizedBox(
                        height: 200,
                        width: 350,
                        child: RepaintBoundary(
                          key: frontCardKey,
                          child: Stack(
                            children: [
                              SizedBox(
                                height: 200,
                                width: 350,
                                child: Image.asset(
                                  widget.data.frontImage,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              // title
                              MyCardText(
                                data: widget.data.frontTitleProperty,
                                text: cardEditController.title.value ?? "",
                              ),
                              // sub title
                              MyCardText(
                                data: widget.data.frontSubTitleProperty,
                                text: cardEditController.subTitle.value ?? "",
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff1E3360)),
                onPressed: () async {
                  await captureAndSave();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CardPreview(),
                      ));
                  // Get.toNamed(Routes.editCard);
                },
                child: Text(
                  'Go To Preview',
                  style: GoogleFonts.poppins(),
                ),
              ),
            ],
          ),
          cardEditController.kIsDevMode
              ? Container()
              : Container(
                  color: Colors.white,
                  height: Get.height,
                  width: Get.width,
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        color: kPrimeryColor,
                      ),
                    ],
                  ),
                )
        ],
      ),
    ));
  }

  Future<void> captureAndSave() async {
    try {
      RenderRepaintBoundary boundary = backCardKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();
      final directory = await getApplicationDocumentsDirectory();
      final imagePath = File(
          '${directory.path}/${DateTime.now().millisecondsSinceEpoch}captured_image_back.png');
      await imagePath.writeAsBytes(pngBytes);

      cardEditController.processBackCardPath.value = imagePath.path;

      // Front
      RenderRepaintBoundary boundaryfront = frontCardKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      ui.Image imageFront = await boundaryfront.toImage(pixelRatio: 3.0);
      ByteData? byteDataFront =
          await imageFront.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytesFront = byteDataFront!.buffer.asUint8List();
      final directoryFront = await getApplicationDocumentsDirectory();
      final imagePathFront = File(
          '${directoryFront.path}/${DateTime.now().millisecondsSinceEpoch}captured_image_front.png');
      await imagePathFront.writeAsBytes(pngBytesFront);

      cardEditController.processFrontCardPath.value = imagePathFront.path;
    } catch (e) {
      print(e);
    }
  }
}
