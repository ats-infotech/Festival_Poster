import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_frame/Contstant/AppColor.dart';
import 'package:photo_frame/Screen/PreviewImage.dart';

class SaveImageShow extends StatefulWidget {
  const SaveImageShow({super.key});

  @override
  State<SaveImageShow> createState() => _SaveImageShowState();
}

class _SaveImageShowState extends State<SaveImageShow> {
  List<File> images = [];

  Future<void> loadImages() async {
    try {
      if (Platform.isAndroid) {
        PermissionStatus storageStatus = await Permission.storage.request();

        if (storageStatus.isDenied || storageStatus.isPermanentlyDenied) {
          await Permission.storage.request();
          print("------ Storage Permission Denied ------------ $storageStatus");
          // return;
        }
        // PermissionStatus photoStatus = await Permission.photos.request();

        // if (photoStatus.isDenied || photoStatus.isPermanentlyDenied) {
        //   await Permission.photos.request();
        //   print("------ Storage Permission Denied ------------ $photoStatus");
        //   // return;
        // }
      }

      String folderPath = "/storage/emulated/0/Pictures/Festival Poster";
      Directory folder = Directory(folderPath);

      // Check if folder exists
      if (!folder.existsSync()) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Folder does not exist')),
        );
        return;
      }

      // Get image files
      List<File> folderImages = folder
          .listSync()
          .where((file) =>
              file is File &&
              (file.path.endsWith('.jpg') ||
                  file.path.endsWith('.png') ||
                  file.path.endsWith('.jpeg')))
          .map((file) => File(file.path))
          .toList();

      setState(() {
        images = folderImages.reversed.toList();
      });
    } catch (e) {
      print('error on get image •••  $e');
    }
  }

  bool showLoader = false;
  @override
  void initState() {
    super.initState();
    showLoader = true;
    loadImages().then(
      (value) {
        setState(() {
          showLoader = false;
        });
      },
    ).onError(
      (error, stackTrace) {
        setState(() {
          showLoader = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kscaffoldBgColor,
      appBar: AppBar(
        backgroundColor: kPrimeryColor,
        title: Text(
          "Saved Images",
          style: GoogleFonts.poppins(
            color: whiteColor,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: showLoader
          ? const Center(
              child: CircularProgressIndicator(
                color: kPrimeryColor,
              ),
            )
          : images.isEmpty
              ? Center(
                  child: Text(
                    'No images found',
                    style: GoogleFonts.poppins(),
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.only(bottom: 20),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemCount: images.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.rightToLeftWithFade,
                            child: PreviewImage(image: images, index: index),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(
                          top: 15,
                          left: 15,
                          right: 15,
                        ),
                        height: 180,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                            image: FileImage(images[index]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
