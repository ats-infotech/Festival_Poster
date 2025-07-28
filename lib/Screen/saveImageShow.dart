// import 'dart:developer';
// import 'dart:io';
// import 'dart:typed_data';
// import 'package:device_info_plus/device_info_plus.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:page_transition/page_transition.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:photo_frame/Contstant/AppColor.dart';
// import 'package:photo_frame/Contstant/CommonMethod.dart';
// import 'package:photo_frame/Contstant/Strings.dart';
// import 'package:photo_frame/Screen/BottomNavBar.dart';
// import 'package:photo_frame/Screen/EditImageScreen.dart';
// import 'package:photo_frame/Screen/PreviewImage.dart';
// import 'package:photo_frame/Screen/VideoPreviewScreen.dart';
// import 'package:photo_manager/photo_manager.dart';
// import 'package:video_thumbnail/video_thumbnail.dart';

// class SaveImageShow extends StatefulWidget {
//   const SaveImageShow({super.key});

//   @override
//   State<SaveImageShow> createState() => _SaveImageShowState();
// }

// class _SaveImageShowState extends State<SaveImageShow> {
//   List<File> images = [];
//   List<File> videos = [];
//   List<Uint8List?> videoThumbnails = [];

//   bool showLoader = false;

//   // For selection and delete
//   bool isSelectionMode = false;
//   Set<String> selectedPaths = {};
//   Future<bool> requestMediaPermissions() async {
//     if (Platform.isAndroid) {
//       final androidInfo = await DeviceInfoPlugin().androidInfo;
//       final sdkInt = androidInfo.version.sdkInt;

//       if (sdkInt >= 33) {
//         final images = await Permission.photos.request(); // READ_MEDIA_IMAGES
//         final videos = await Permission.videos.request(); // READ_MEDIA_VIDEO
//         return images.isGranted || videos.isGranted;
//       } else {
//         final storage =
//             await Permission.storage.request(); // READ_EXTERNAL_STORAGE
//         return storage.isGranted;
//       }
//     } else if (Platform.isIOS) {
//       final photos = await Permission.photos.request();
//       return photos.isGranted;
//     }
//     return false;
//   }

//   Future<void> loadImages() async {
//     try {
//       final PermissionState permission =
//           await PhotoManager.requestPermissionExtend();
//       if (!permission.isAuth) {
//         PhotoManager.openSetting();
//         return;
//       }

//       List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
//         type: RequestType.image,
//         onlyAll: false,
//         filterOption: FilterOptionGroup(
//           imageOption: const FilterOption(
//               sizeConstraint: SizeConstraint(ignoreSize: true)),
//         ),
//       );

//       if (albums.isEmpty) {
//         if (!mounted) return;
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('No images found in gallery')),
//         );
//         return;
//       }

//       final AssetPathEntity album = albums.first;

//       List<AssetEntity> media =
//           await album.getAssetListPaged(page: 0, size: 300);
//       media.sort((a, b) => b.createDateTime.compareTo(a.createDateTime));

//       // Filter images by folder name faster
//       List<AssetEntity> festivalAssets = media.where((asset) {
//         return (asset.relativePath?.contains('Festival Poster') ?? false);
//       }).toList();

//       // Load all files in parallel (faster)
//       List<File?> files = await Future.wait(festivalAssets.map((a) => a.file));
//       List<File> folderImages = files.whereType<File>().toList();

//       if (!mounted) return;

//       setState(() {
//         images = folderImages;
//       });
//     } catch (e) {
//       log('Error loading images: $e');
//     }
//   }

//   Future<void> loadVideos() async {
//     try {
//       final PermissionState permission =
//           await PhotoManager.requestPermissionExtend();
//       if (!permission.isAuth) {
//         PhotoManager.openSetting();
//         return;
//       }

//       List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
//         type: RequestType.video,
//         onlyAll: false,
//         filterOption: FilterOptionGroup(
//           videoOption:
//               FilterOption(sizeConstraint: SizeConstraint(ignoreSize: true)),
//         ),
//       );

//       if (albums.isEmpty) {
//         if (!mounted) return;
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('No videos found in gallery')),
//         );
//         return;
//       }

//       final AssetPathEntity album = albums.first;

//       List<AssetEntity> media =
//           await album.getAssetListPaged(page: 0, size: 100);

//       List<File> folderVideos = [];
//       List<Uint8List?> thumbnails = [];

//       for (var asset in media) {
//         final file = await asset.file;
//         if (file != null &&
//             (asset.relativePath?.contains('Festival Poster') ?? false)) {
//           folderVideos.add(file);
//           try {
//             final thumb = await VideoThumbnail.thumbnailData(
//               video: file.path,
//               imageFormat: ImageFormat.JPEG,
//               maxWidth: 200,
//               quality: 80,
//             );
//             thumbnails.add(thumb);
//           } catch (_) {
//             thumbnails.add(null);
//           }
//         }
//       }

//       if (!mounted) return;

//       setState(() {
//         videos = folderVideos;
//         videoThumbnails = thumbnails;
//       });
//     } catch (e) {
//       log('Error loading videos: $e');
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     showLoader = true;
//     loadImages().then((value) {
//       if (!mounted) return;
//       setState(() {
//         selectedPaths.clear();
//         showLoader = false;
//       });
//     });
//   }

//   Future<void> showDeleteConfirmation() async {
//     final confirm = await showDialog<bool>(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text("Delete Selected Items?"),
//         content: const Text(
//             "Are you sure you want to delete the selected items permanently?"),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(false),
//             child: const Text(
//               "Cancel",
//               style: TextStyle(color: kPrimeryColor),
//             ),
//           ),
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(backgroundColor: kPrimeryColor),
//             onPressed: () => Navigator.of(context).pop(true),
//             child: const Text("Delete"),
//           ),
//         ],
//       ),
//     );

//     if (confirm == true) {
//       deleteSelectedFiles();
//     }
//   }

//   void deleteSelectedFiles() async {
//     for (var path in selectedPaths) {
//       try {
//         final file = File(path);
//         if (await file.exists()) {
//           await file.delete();
//         }
//       } catch (e) {
//         print("Error deleting $path : $e");
//       }
//     }

//     setState(() {
//       isSelectionMode = false;
//       selectedPaths.clear();
//       showLoader = true;
//     });

//     if (editController.selectedSaveTab.value == 0) {
//       loadImages().then((_) {
//         setState(() => showLoader = false);
//       });
//     } else {
//       loadVideos().then((_) {
//         setState(() => showLoader = false);
//       });
//     }
//   }

//   void onLongPressFile(String path) {
//     setState(() {
//       isSelectionMode = true;
//       selectedPaths.add(path);
//     });
//   }

//   void onTapFile(String path, File file, bool isVideo, int index) {
//     if (isSelectionMode) {
//       setState(() {
//         if (selectedPaths.contains(path)) {
//           selectedPaths.remove(path);
//           if (selectedPaths.isEmpty) {
//             isSelectionMode = false;
//           }
//         } else {
//           selectedPaths.add(path);
//         }
//       });
//     } else {
//       if (isVideo) {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (_) => VideoPreviewScreen(
//               file: videos[index],
//               fromEdit: false,
//             ),
//           ),
//         );
//       } else {
//         Navigator.push(
//           context,
//           PageTransition(
//             type: PageTransitionType.rightToLeftWithFade,
//             child: PreviewImage(
//               image: images,
//               index: index,
//               fromEdit: false,
//             ),
//           ),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         if (isSelectionMode) {
//           setState(() {
//             isSelectionMode = false;
//             selectedPaths.clear();
//           });
//           return false;
//         }
//         editController.selectedSaveTab.value = 0;
//         images.clear();
//         videos.clear();
//         videoThumbnails.clear();
//         return true;
//       },
//       child: Scaffold(
//         backgroundColor: kscaffoldBgColor,
//         appBar: AppBar(
//           backgroundColor: kPrimeryColor,
//           leading: IconButton(
//             onPressed: () {
//               Get.offAll(
//                 transition: Transition.rightToLeftWithFade,
//                 () => const BottomNavBarBar(),
//               );
//             },
//             icon: commonBackArrow(),
//           ),
//           title: Text(
//             isSelectionMode ? "${selectedPaths.length} Selected" : savedImages,
//             style: GoogleFonts.poppins(
//               color: whiteColor,
//               fontSize: 15,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           actions: [
//             if (isSelectionMode)
//               IconButton(
//                 icon: const Icon(Icons.delete),
//                 onPressed: () => showDeleteConfirmation(),
//               ),
//           ],
//         ),
//         body: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: greyColor.withOpacity(0.3),
//                   borderRadius: BorderRadius.circular(30),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(7.0),
//                   child: Row(
//                     children: [
//                       Obx(() => buildTab(
//                             title: "Images",
//                             index: 0,
//                             isSelected:
//                                 editController.selectedSaveTab.value == 0,
//                             onTap: () {
//                               editController.selectedSaveTab.value = 0;
//                               setState(() => showLoader = true);
//                               loadImages().then((_) {
//                                 setState(() {
//                                   selectedPaths.clear();
//                                   showLoader = false;
//                                   isSelectionMode = false;
//                                 });
//                               });
//                             },
//                           )),
//                       const SizedBox(width: 10),
//                       Obx(() => buildTab(
//                             title: "Videos",
//                             index: 1,
//                             isSelected:
//                                 editController.selectedSaveTab.value == 1,
//                             onTap: () {
//                               editController.selectedSaveTab.value = 1;
//                               setState(() => showLoader = true);
//                               loadVideos().then((_) {
//                                 setState(() {
//                                   selectedPaths.clear();
//                                   showLoader = false;
//                                   isSelectionMode = false;
//                                 });
//                               });
//                             },
//                           )),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             Obx(() => editController.selectedSaveTab.value == 0
//                 ? Expanded(child: templatesView())
//                 : Expanded(child: videoView())),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget videoView() {
//     if (showLoader) return commonLoader();

//     if (videos.isEmpty) {
//       return const Center(child: Text('No videos found.'));
//     }

//     return GridView.builder(
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10),
//       itemCount: videos.length,
//       itemBuilder: (context, index) {
//         final video = videos[index];
//         final isSelected = selectedPaths.contains(video.path);

//         return GestureDetector(
//             onLongPress: () => onLongPressFile(video.path),
//             onTap: () => onTapFile(video.path, video, true, index),
//             child: Stack(
//               children: [
//                 Container(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10),
//                     color: Colors.black12,
//                     image: videoThumbnails[index] != null
//                         ? DecorationImage(
//                             image: MemoryImage(videoThumbnails[index]!),
//                             fit: BoxFit.cover,
//                           )
//                         : null,
//                   ),
//                   child: videoThumbnails[index] == null
//                       ? const Center(
//                           child: Icon(Icons.video_library,
//                               size: 40, color: Colors.white),
//                         )
//                       : null,
//                 ),

//                 // Black overlay when selected
//                 if (isSelected)
//                   Container(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10),
//                       color: Colors.black.withOpacity(0.5),
//                     ),
//                   ),

//                 // Play icon always in center
//                 const Center(
//                   child: Icon(Icons.play_circle_fill,
//                       color: Colors.white, size: 30),
//                 ),

//                 // Bottom right check icon when selected
//                 if (isSelected)
//                   Positioned(
//                     bottom: 8,
//                     right: 8,
//                     child: Container(
//                       decoration: BoxDecoration(
//                         color: kPrimeryColor,
//                         shape: BoxShape.circle,
//                         border: Border.all(color: Colors.white, width: 2),
//                       ),
//                       padding: const EdgeInsets.all(4),
//                       child: const Icon(
//                         Icons.check,
//                         size: 20,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//               ],
//             ));
//       },
//     );
//   }

//   Widget templatesView() {
//     if (showLoader) return commonLoader();

//     if (images.isEmpty) {
//       return Center(
//         child: Text(noimagesfound, style: GoogleFonts.poppins()),
//       );
//     }

//     return GridView.builder(
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10),
//       itemCount: images.length,
//       itemBuilder: (context, index) {
//         final img = images[index];
//         final isSelected = selectedPaths.contains(img.path);
//         return GestureDetector(
//             onLongPress: () => onLongPressFile(img.path),
//             onTap: () => onTapFile(img.path, img, false, index),
//             child: Stack(
//               children: [
//                 Container(
//                   height: 180,
//                   decoration: BoxDecoration(
//                     color: Colors.grey.shade300,
//                     borderRadius: BorderRadius.circular(10),
//                     image: DecorationImage(
//                       image: FileImage(img),
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 ),

//                 // Black overlay when selected
//                 if (isSelected)
//                   Container(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10),
//                       color: Colors.black.withOpacity(0.5),
//                     ),
//                   ),

//                 // Bottom right check icon when selected
//                 if (isSelected)
//                   Positioned(
//                     bottom: 8,
//                     right: 8,
//                     child: Container(
//                       decoration: BoxDecoration(
//                         color: kPrimeryColor,
//                         shape: BoxShape.circle,
//                         border: Border.all(color: Colors.white, width: 2),
//                       ),
//                       padding: const EdgeInsets.all(4),
//                       child: const Icon(
//                         Icons.check,
//                         size: 20,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//               ],
//             ));
//       },
//     );
//   }
// }

// Widget buildTab(
//     {required String title,
//     required int index,
//     required void Function()? onTap,
//     required bool isSelected}) {
//   return Expanded(
//     child: GestureDetector(
//       onTap: onTap,
//       child: AnimatedContainer(
//         curve: Curves.easeInOutCubic,
//         // curve: Easing.legacyAccelerate,
//         duration: const Duration(milliseconds: 300),
//         padding: const EdgeInsets.symmetric(vertical: 12),
//         decoration: BoxDecoration(
//           color: isSelected ? kPrimeryColor : Colors.transparent,
//           borderRadius: BorderRadius.circular(30),
//         ),
//         child: Center(
//           child: Text(
//             title,
//             style: GoogleFonts.poppins(
//               color: isSelected ? whiteColor : kPrimeryColor,
//               fontSize: 14,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ),
//       ),
//     ),
//   );
// }
