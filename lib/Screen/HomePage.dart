// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:image_cropper/image_cropper.dart';
// import 'package:package_info_plus/package_info_plus.dart';
// import 'package:page_transition/page_transition.dart';
// import 'package:photo_frame/Controller/CardEditController.dart';
// import 'package:photo_frame/Contstant/AppColor.dart';
// import 'package:photo_frame/Contstant/CommonMethod.dart';
// import 'package:photo_frame/Contstant/Strings.dart';
// import 'package:photo_frame/Screen/CardEdit.dart';
// import 'package:photo_frame/Screen/EditImageScreen.dart';
// import 'package:photo_frame/Screen/EditVisitingCard.dart';
// import 'package:photo_frame/Screen/HomeSearchPage.dart';
// import 'package:photo_frame/Screen/SpecificPoster.dart';
// import 'package:photo_frame/Screen/Templates.dart';
// import 'package:photo_frame/model/card_model.dart';
// import 'package:photo_frame/service/firebase_analytics_service.dart';
// import 'package:photo_frame/service/firebase_push_notification_service.dart';
// import 'package:shimmer/shimmer.dart';

// int drawerContainer = 0;
// bool isSliderImageTap = false;
// // bool isLoading = false;
// bool isPatrioticImageTap = false;
// bool isFestivalImageTap = false;
// bool isSpecialImageTap = false;
// List versionList = [];
// ScrollController tabScrollController = ScrollController();
// String templateName = "";
// String templateSearchName = "";
// bool isSeeAllTap = true;

// List popularFetivalList = [
//   {
//     "icon": "assets/images/diwaliIcon.png",
//     "name": "Diwali",
//     "tabTap": 2,
//   },
//   {
//     "icon": "assets/images/rakshaBadhanIcon.png",
//     "name": "Raksha Bandhan",
//     "tabTap": 2,
//   },
//   {
//     "icon": "assets/images/independeceIcon.png",
//     "name": "Independence",
//     "tabTap": 1,
//   },
//   {
//     "icon": "assets/images/motherDayIcon.png",
//     "name": "Mother Day",
//     "tabTap": 3,
//   },
//   {
//     "icon": "assets/images/ganeshChaturthiIcon.png",
//     "name": "Ganesh Chaturthi",
//     "tabTap": 2,
//   },
//   {
//     "icon": "assets/images/holiIcon.png",
//     "name": "Holi",
//     "tabTap": 2,
//   },
//   {
//     "icon": "assets/images/fatherDayIcon.png",
//     "name": "Father Day",
//     "tabTap": 3,
//   },
//   {
//     "icon": "assets/images/environmentDayIcon.png",
//     "name": "Environment Day",
//     "tabTap": 3,
//   },
//   {
//     "icon": "assets/images/valentinesIcon.png",
//     "name": "Valentines",
//     "tabTap": 3,
//   },
//   {
//     "icon": "assets/images/republicIcon.png",
//     "name": "Republic Day",
//     "tabTap": 1,
//   },
//   {
//     "icon": "assets/images/rathYatraIcon.png",
//     "name": "Rath Yatra",
//     "tabTap": 2,
//   },
// ];

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   // GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
//   String? version = '';
//   // ImagePicker picker = ImagePicker();
//   final CardEditController cardEditController = Get.put(CardEditController());

//   // Pick Image Crop From Home Page
//   Future<void> cropImage(index) async {
//     try {
//       if (image != null) {
//         print("----------- image Crop ----------- $image");
//         var croppedFile = await ImageCropper().cropImage(
//           sourcePath: image!.path,
//           compressFormat: ImageCompressFormat.jpg,
//           compressQuality: 100,
//           aspectRatioPresets: [
//             CropAspectRatioPreset.square,
//             CropAspectRatioPreset.ratio4x3,
//             CropAspectRatioPreset.original,
//             CropAspectRatioPreset.ratio3x2,
//             CropAspectRatioPreset.ratio16x9,
//           ],
//           androidUiSettings: AndroidUiSettings(
//             toolbarTitle: 'Edit',
//             toolbarColor: grey800Color,
//             toolbarWidgetColor: whiteColor,
//             initAspectRatio: CropAspectRatioPreset.original,
//             lockAspectRatio: false,
//           ),
//           iosUiSettings: const IOSUiSettings(
//             title: 'Edit',
//           ),
//         );
//         if (croppedFile != null) {
//           setState(() {
//             File cropImage = File(croppedFile!.path);
//             Navigator.of(context).push(
//               MaterialPageRoute(
//                 builder: (context) => EditImageScreen(
//                   cropImage: cropImage,
//                   image: isPatrioticImageTap == true
//                       ? patrioticDayList[index]["image"]
//                       : isFestivalImageTap == true
//                           ? festivalsEventList[index]["image"]
//                           : isSpecialImageTap == true
//                               ? specialDaysList[index]["image"]
//                               : templateWithImageList[index]["image"],
//                   wallPaper: isPatrioticImageTap == true
//                       ? patrioticDayList[index]["image_2"]
//                       : isFestivalImageTap == true
//                           ? festivalsEventList[index]["image_2"]
//                           : isSpecialImageTap == true
//                               ? specialDaysList[index]["image_2"]
//                               : templateWithImageList[index]["image_2"],
//                 ),
//               ),
//             );
//           });
//           setState(() {});
//         } else {
//           image = null;
//           isLoader = false;
//           croppedFile = null;
//           setState(() {});
//         }
//       }
//     } catch (e) {
//       print("-------------- Image Crop Error ----------- $e");
//     }
//   }

//   // Get Json File Data
//   Future<void> getImages() async {
//     try {
//       var imageResponse = await rootBundle.loadString('assets/images.json');
//       templateWithImageList = jsonDecode(imageResponse).toList();
//       setState(() {});
//     } catch (e) {
//       print("-------------- Json Get Data Error -------------- $e");
//     }
//   }

//   // Get Version
//   Future<void> getVersion() async {
//     try {
//       var versionResponse = await rootBundle.loadString('assets/version.json');
//       versionList = jsonDecode(versionResponse).toList();
//       setState(() {});
//     } catch (e) {
//       print("-------------- Json Get version Error -------------- $e");
//     }
//   }

//   // Check Version
//   Future<void> checkVersion() async {
//     PackageInfo packageInfo = await PackageInfo.fromPlatform();
//     version = packageInfo.version;
//     int currentVersion = getVersionNumber(version!);
//     int latestVersion = getVersionNumber(versionList[0]["appVersion"]);
//     print("---------- Current Version ----------- $version");
//     print("---------- v1 ----------- $currentVersion");
//     print("---------- v2 ----------- $latestVersion");
//     // if (version[0]["appVersion"] != currentVersion) {
//     if (latestVersion > currentVersion) {
//       print("---------- Dialog Show ------------");
//       showUpdateDialog(context);
//     } else {
//       print("----------- Dialog Not Show -------------");
//     }
//   }

//   // String to Int Convert Version
//   int getVersionNumber(String version) {
//     List versionCells = version.split(".");
//     versionCells = versionCells.map((e) => int.parse(e)).toList();
//     return versionCells[0] * 100000 + versionCells[1] * 1000 + versionCells[2];
//   }

//   @override
//   void initState() {
//     super.initState();
//     getImages();
//     getVersion();
//     checkVersion();
//     reviewCount(context);
//     allScreenSkeleton(setState);
//     getPatrioticImage();
//     getFestivalImage();
//     getSpecialImage();
//     getVisitingCard();
//     FirebaseService.requestPermission();
//     FirebaseService.configureForegroundMessaging();
//   }

//   @override
//   Widget build(BuildContext context) {
//     var w = MediaQuery.of(context).size.width;
//     var h = MediaQuery.of(context).size.height;
//     return Expanded(
//       child: SingleChildScrollView(
//         child: Container(
//           margin: const EdgeInsets.only(top: 20),
//           child: Column(
//             children: [
//               Container(
//                 margin: const EdgeInsets.only(right: 20, left: 20),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Row(
//                       children: [
//                         isLoadingSkeleton
//                             ? Shimmer.fromColors(
//                                 baseColor: skeletonBaseColor,
//                                 highlightColor: skeletonhighlightColor,
//                                 child: Container(
//                                   height: 30,
//                                   width: 3,
//                                   decoration: BoxDecoration(
//                                     color: skeletonBaseColor,
//                                     borderRadius: BorderRadius.circular(5),
//                                   ),
//                                 ),
//                               )
//                             : Container(
//                                 height: 30,
//                                 width: 3,
//                                 decoration: BoxDecoration(
//                                   color: kPrimeryColor,
//                                   borderRadius: BorderRadius.circular(5),
//                                 ),
//                               ),
//                         const SizedBox(
//                           width: 20,
//                         ),
//                         isLoadingSkeleton
//                             ? Shimmer.fromColors(
//                                 baseColor: skeletonBaseColor,
//                                 highlightColor: skeletonhighlightColor,
//                                 child: Container(
//                                   width: 150,
//                                   height: 20,
//                                   decoration: BoxDecoration(
//                                     color: skeletonBaseColor,
//                                     borderRadius: BorderRadius.circular(5),
//                                   ),
//                                 ),
//                               )
//                             : Text(
//                                 popularPoster,
//                                 style: GoogleFonts.poppins(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w600,
//                                   color: kPrimeryColor,
//                                 ),
//                               ),
//                       ],
//                     ),
//                     GestureDetector(
//                       onTap: () {
//                         setState(() {
//                           isSeeAllTap = !isSeeAllTap;
//                         });
//                         // tabTap = 0;
//                         // Navigator.push(
//                         //   context,
//                         //   PageTransition(
//                         //     type: PageTransitionType.rightToLeftWithFade,
//                         //     child: const Templates(
//                         //       scrollPosition: 0,
//                         //     ),
//                         //   ),
//                         // );
//                       },
//                       child: isLoadingSkeleton
//                           ? Shimmer.fromColors(
//                               baseColor: skeletonBaseColor,
//                               highlightColor: skeletonhighlightColor,
//                               child: Container(
//                                 width: 50,
//                                 height: 20,
//                                 decoration: BoxDecoration(
//                                   color: skeletonBaseColor,
//                                   borderRadius: BorderRadius.circular(5),
//                                 ),
//                               ),
//                             )
//                           : Text(
//                               isSeeAllTap ? seeAll : seeLess,
//                               style: GoogleFonts.poppins(
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.w500,
//                                 color: const Color(0xff747474),
//                               ),
//                             ),
//                     ),
//                   ],
//                 ),
//               ),
//               // Container(
//               //   height: 135,
//               //   child: ListView.builder(
//               //     padding: const EdgeInsets.only(right: 20, left: 20),
//               //     scrollDirection: Axis.horizontal,
//               //     shrinkWrap: true,
//               //     itemCount: popularFetivalList.length,
//               //     itemBuilder: (context, index) {
//               //       return GestureDetector(
//               //         onTap: () {
//               //           selectedName = popularFetivalList[index]["name"];
//               //           Navigator.push(
//               //             context,
//               //             PageTransition(
//               //               type: PageTransitionType.rightToLeftWithFade,
//               //               child: const SpecificPoster(),
//               //             ),
//               //           );
//               //           setState(() {});
//               //         },
//               //         child: Container(
//               //           margin: const EdgeInsets.only(top: 30),
//               //           width: w / 3 - 20,
//               //           child: Column(
//               //             mainAxisAlignment: MainAxisAlignment.spaceAround,
//               //             children: [
//               //               isLoadingSkeleton
//               //                   ? Shimmer.fromColors(
//               //                       baseColor: skeletonBaseColor,
//               //                       highlightColor: skeletonhighlightColor,
//               //                       child: Container(
//               //                         height: 70,
//               //                         width: 70,
//               //                         decoration: const BoxDecoration(
//               //                           color: skeletonBaseColor,
//               //                           shape: BoxShape.circle,
//               //                         ),
//               //                       ),
//               //                     )
//               //                   : Material(
//               //                       elevation: 5,
//               //                       borderRadius: BorderRadius.circular(70),
//               //                       child: Container(
//               //                         height: 70,
//               //                         width: 70,
//               //                         decoration: const BoxDecoration(
//               //                           color: whiteColor,
//               //                           shape: BoxShape.circle,
//               //                         ),
//               //                         child: Image.asset(
//               //                           popularFetivalList[index]["icon"],
//               //                           scale: 5,
//               //                         ),
//               //                       ),
//               //                     ),
//               //               const SizedBox(
//               //                 height: 12,
//               //               ),
//               //               isLoadingSkeleton
//               //                   ? Shimmer.fromColors(
//               //                       baseColor: skeletonBaseColor,
//               //                       highlightColor: skeletonhighlightColor,
//               //                       child: Container(
//               //                         width: 150,
//               //                         height: 20,
//               //                         decoration: BoxDecoration(
//               //                           color: skeletonBaseColor,
//               //                           borderRadius: BorderRadius.circular(5),
//               //                         ),
//               //                       ),
//               //                     )
//               //                   : Text(
//               //                       popularFetivalList[index]["name"],
//               //                       overflow: TextOverflow.ellipsis,
//               //                       style: GoogleFonts.poppins(
//               //                         fontSize: 12,
//               //                         color: kPrimeryColor,
//               //                         fontWeight: FontWeight.w600,
//               //                       ),
//               //                     ),
//               //             ],
//               //           ),
//               //         ),
//               //       );
//               //     },
//               //   ),
//               // ),
//               const SizedBox(
//                 height: 30,
//               ),
//               GridView.builder(
//                 padding: const EdgeInsets.symmetric(horizontal: 10),
//                 itemCount: isSeeAllTap ? 8 : popularFetivalList.length,
//                 physics: const NeverScrollableScrollPhysics(),
//                 shrinkWrap: true,
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 4,
//                   childAspectRatio: 0.75,
//                   // childAspectRatio: 0.0007 * h,
//                 ),
//                 itemBuilder: (context, index) {
//                   return GestureDetector(
//                     onTap: () {
//                       selectedName = popularFetivalList[index]["name"];
//                       Navigator.push(
//                         context,
//                         PageTransition(
//                           type: PageTransitionType.rightToLeftWithFade,
//                           child: const SpecificPoster(),
//                         ),
//                       );
//                       setState(() {});
//                     },
//                     child: Container(
//                       // margin: const EdgeInsets.only(top: 30),
//                       // margin: EdgeInsets.only(top: 0.03 * h),
//                       // color: Colors.amber,
//                       // width: w / 3 - 20,
//                       alignment: Alignment.center,
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           isLoadingSkeleton
//                               ? Shimmer.fromColors(
//                                   baseColor: skeletonBaseColor,
//                                   highlightColor: skeletonhighlightColor,
//                                   child: Container(
//                                     height: 70,
//                                     width: 70,
//                                     decoration: const BoxDecoration(
//                                       color: skeletonBaseColor,
//                                       shape: BoxShape.circle,
//                                     ),
//                                   ),
//                                 )
//                               : Container(
//                                   // height: 70,
//                                   // width: 70,
//                                   height: 0.075 * h,
//                                   width: 0.15 * w,
//                                   decoration: BoxDecoration(
//                                     color: whiteColor,
//                                     border: Border.all(
//                                       color: kPrimeryColor,
//                                       width: 1.2,
//                                     ),
//                                     shape: BoxShape.circle,
//                                   ),
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(0.0),
//                                     child: Image.asset(
//                                       popularFetivalList[index]["icon"],
//                                       scale: 4,
//                                     ),
//                                   ),
//                                 ),
//                           const SizedBox(
//                             height: 15,
//                           ),
//                           isLoadingSkeleton
//                               ? Shimmer.fromColors(
//                                   baseColor: skeletonBaseColor,
//                                   highlightColor: skeletonhighlightColor,
//                                   child: Container(
//                                     width: 150,
//                                     height: 20,
//                                     decoration: BoxDecoration(
//                                       color: skeletonBaseColor,
//                                       borderRadius: BorderRadius.circular(5),
//                                     ),
//                                   ),
//                                 )
//                               : SizedBox(
//                                   // width: 100,
//                                   width: 0.23 * w,
//                                   // color: Colors.amber,
//                                   child: Text(
//                                     popularFetivalList[index]["name"] + "\n ",
//                                     overflow: TextOverflow.ellipsis,
//                                     textAlign: TextAlign.center,
//                                     maxLines: 2,
//                                     style: GoogleFonts.poppins(
//                                       // fontSize: 12,
//                                       fontSize: 0.028 * w,
//                                       color: kPrimeryColor,
//                                       fontWeight: FontWeight.w600,
//                                     ),
//                                   ),
//                                 ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//               // GestureDetector(
//               //   onTap: () {
//               //     setState(() {
//               //       isSeeAllTap = !isSeeAllTap;
//               //     });
//               //   },
//               //   child: Row(
//               //     mainAxisAlignment: MainAxisAlignment.center,
//               //     mainAxisSize: MainAxisSize.min,
//               //     children: [
//               //       isLoadingSkeleton
//               //           ? Shimmer.fromColors(
//               //               baseColor: skeletonBaseColor,
//               //               highlightColor: skeletonhighlightColor,
//               //               child: Container(
//               //                 width: 60,
//               //                 height: 20,
//               //                 decoration: BoxDecoration(
//               //                   color: skeletonBaseColor,
//               //                   borderRadius: BorderRadius.circular(5),
//               //                 ),
//               //               ),
//               //             )
//               //           : Text(
//               //               isSeeAllTap ? "See All" : "See Less",
//               //               style: GoogleFonts.poppins(
//               //                 fontSize: 14,
//               //                 fontWeight: FontWeight.w500,
//               //                 color: const Color(0xff747474),
//               //               ),
//               //             ),
//               //       const SizedBox(
//               //         width: 5,
//               //       ),
//               //       isLoadingSkeleton
//               //           ? Shimmer.fromColors(
//               //               baseColor: skeletonBaseColor,
//               //               highlightColor: skeletonhighlightColor,
//               //               child: Container(
//               //                 width: 50,
//               //                 height: 20,
//               //                 decoration: BoxDecoration(
//               //                   color: skeletonBaseColor,
//               //                   borderRadius: BorderRadius.circular(5),
//               //                 ),
//               //               ),
//               //             )
//               //           : Icon(
//               //               isSeeAllTap
//               //                   ? Icons.keyboard_arrow_down_outlined
//               //                   : Icons.keyboard_arrow_up,
//               //               color: const Color(0xff747474),
//               //             )
//               //     ],
//               //   ),
//               // ),
//               const SizedBox(
//                 // height: 50,
//                 height: 25,
//               ),
//               Container(
//                 margin: const EdgeInsets.only(right: 20, left: 20),
//                 child: rowText(
//                   "Customized Festival Poster",
//                   viewAll,
//                   () {
//                     tabTap = 0;
//                     Navigator.push(
//                       context,
//                       PageTransition(
//                         type: PageTransitionType.rightToLeftWithFade,
//                         child: const Templates(scrollPosition: 0),
//                       ),
//                     );
//                     FirebaseAnalyticsService.instance.logEvent(
//                         name: 'view_all',
//                         parameters: {'name': 'Customized Festival Poster'});
//                   },
//                   isLoading: isLoadingSkeleton,
//                 ),
//               ),
//               const SizedBox(
//                 height: 30,
//               ),
//               SizedBox(
//                 height: w / 3 - 20,
//                 child: ListView.builder(
//                   padding: const EdgeInsets.only(left: 10, right: 20),
//                   shrinkWrap: true,
//                   scrollDirection: Axis.horizontal,
//                   itemCount: templateWithImageList.length,
//                   itemBuilder: (context, index) {
//                     return isLoadingSkeleton
//                         ? Shimmer.fromColors(
//                             baseColor: skeletonBaseColor,
//                             highlightColor: skeletonhighlightColor,
//                             child: Container(
//                               width: w / 3 - 20,
//                               height: w / 3 - 20,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(15),
//                                 color: skeletonBaseColor,
//                               ),
//                             ),
//                           )
//                         : GestureDetector(
//                             onTap: () async {
//                               templateName =
//                                   templateWithImageList[index]["title"];
//                               templateSearchName =
//                                   templateWithImageList[index]["searchText"];
//                               print(
//                                   "--------- Template Name --------- ${templateWithImageList[index]["image"]}");
//                               isPatrioticImageTap = false;
//                               isFestivalImageTap = false;
//                               isSpecialImageTap = false;
//                               await imageDialog(context, index,
//                                   templateName: templateWithImageList[index]
//                                       ["searchText"]);
//                               cropImage(index);
//                               reviewCount(context);
//                               setState(() {});
//                             },
//                             child: Container(
//                               margin: const EdgeInsets.only(left: 10),
//                               width: w / 3 - 20,
//                               height: w / 3 - 20,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(15),
//                               ),
//                               child: Image.asset(
//                                 templateWithImageList[index]["image"],
//                                 fit: BoxFit.fill,
//                               ),
//                             ),
//                           );
//                   },
//                 ),
//               ),
//               const SizedBox(
//                 height: 30,
//               ),
//               Container(
//                 margin: const EdgeInsets.only(right: 20, left: 20),
//                 child: rowText(
//                   customizedBusinessCards,
//                   viewAll,
//                   () {
//                     tabTap = 4;
//                     Navigator.push(
//                       context,
//                       PageTransition(
//                         type: PageTransitionType.rightToLeftWithFade,
//                         child: const Templates(scrollPosition: 320),
//                       ),
//                     );
//                     FirebaseAnalyticsService.instance.logEvent(
//                         name: 'view_all',
//                         parameters: {'name': 'Customized Business cards'});
//                   },
//                   isLoading: isLoadingSkeleton,
//                 ),
//               ),
//               const SizedBox(
//                 height: 30,
//               ),
//               SizedBox(
//                 height: w / 3 - 20,
//                 child: ListView.builder(
//                   padding: const EdgeInsets.only(left: 10, right: 20),
//                   shrinkWrap: true,
//                   scrollDirection: Axis.horizontal,
//                   itemCount: cardEditController.newCardList.length,
//                   itemBuilder: (context, index) {
//                     final cardData = cardEditController.newCardList[index];
//                     return isLoadingSkeleton
//                         ? Shimmer.fromColors(
//                             baseColor: skeletonBaseColor,
//                             highlightColor: skeletonhighlightColor,
//                             child: Container(
//                               width: w / 3 - 20,
//                               height: w / 3 - 20,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(15),
//                                 color: skeletonBaseColor,
//                               ),
//                             ),
//                           )
//                         : GestureDetector(
//                             onTap: () async {
//                               templateName = cardData["title"];
//                               templateSearchName = cardData["searchText"];
//                               print(
//                                   "--------- Template Name --------- ${cardData["searchText"]}");
//                               reviewCount(context);
//                               Navigator.push(
//                                 context,
//                                 PageTransition(
//                                   type: PageTransitionType.rightToLeftWithFade,
//                                   child: CardEdit(
//                                     data: CardModel.fromJson(cardData),
//                                   ),
//                                 ),
//                               );
//                               setState(() {});
//                             },
//                             child: Container(
//                               margin: const EdgeInsets.only(left: 10),
//                               width: w / 3 - 20,
//                               height: w / 3 - 20,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(15),
//                               ),
//                               child: Image.asset(
//                                 cardData["coverImage"],
//                                 fit: BoxFit.fill,
//                               ),
//                             ),
//                           );
//                   },
//                 ),
//               ),
//               const SizedBox(
//                 height: 30,
//               ),
//               Container(
//                 margin: const EdgeInsets.only(right: 20, left: 20),
//                 child: rowText(
//                   patrioticDay,
//                   viewAll,
//                   () {
//                     tabTap = 1;
//                     Navigator.push(
//                       context,
//                       PageTransition(
//                         type: PageTransitionType.rightToLeftWithFade,
//                         child: const Templates(scrollPosition: 0),
//                       ),
//                     );
//                     FirebaseAnalyticsService.instance.logEvent(
//                         name: 'view_all',
//                         parameters: {'name': 'Patriotic Day'});
//                   },
//                   isLoading: isLoadingSkeleton,
//                 ),
//               ),
//               const SizedBox(
//                 height: 30,
//               ),
//               SizedBox(
//                 height: w / 3 - 20,
//                 child: ListView.builder(
//                   padding: const EdgeInsets.only(left: 10, right: 20),
//                   shrinkWrap: true,
//                   scrollDirection: Axis.horizontal,
//                   itemCount: patrioticDayList.length,
//                   itemBuilder: (context, index) {
//                     return isLoadingSkeleton
//                         ? Shimmer.fromColors(
//                             baseColor: skeletonBaseColor,
//                             highlightColor: skeletonhighlightColor,
//                             child: Container(
//                               width: w / 3 - 20,
//                               height: w / 3 - 20,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(15),
//                                 color: skeletonBaseColor,
//                               ),
//                             ),
//                           )
//                         : GestureDetector(
//                             onTap: () async {
//                               templateName = patrioticDayList[index]["title"];
//                               templateSearchName =
//                                   patrioticDayList[index]["searchText"];
//                               print(
//                                   "--------- Template Name --------- ${patrioticDayList[index]["searchText"]}");
//                               isPatrioticImageTap = true;
//                               isFestivalImageTap = false;
//                               isSpecialImageTap = false;
//                               await imageDialog(context, index,
//                                   templateName: patrioticDayList[index]
//                                       ["searchText"]);
//                               cropImage(index);
//                               reviewCount(context);
//                               setState(() {});
//                             },
//                             child: Container(
//                               margin: const EdgeInsets.only(left: 10),
//                               width: w / 3 - 20,
//                               height: w / 3 - 20,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(15),
//                               ),
//                               child: Image.asset(
//                                 patrioticDayList[index]["image"],
//                                 fit: BoxFit.fill,
//                               ),
//                             ),
//                           );
//                   },
//                 ),
//               ),
//               const SizedBox(
//                 height: 30,
//               ),
//               Container(
//                 margin: const EdgeInsets.symmetric(horizontal: 20),
//                 child: rowText(
//                   businessCards,
//                   viewAll,
//                   () {
//                     tabTap = 4;
//                     Navigator.push(
//                       context,
//                       PageTransition(
//                         type: PageTransitionType.rightToLeftWithFade,
//                         child: const Templates(scrollPosition: 320),
//                       ),
//                     );
//                     FirebaseAnalyticsService.instance.logEvent(
//                         name: 'view_all',
//                         parameters: {'name': 'Business Cards'});
//                   },
//                   isLoading: isLoadingSkeleton,
//                 ),
//               ),
//               const SizedBox(
//                 height: 30,
//               ),
//               SizedBox(
//                 height: w / 3 - 20,
//                 child: ListView.builder(
//                   padding: const EdgeInsets.only(left: 10, right: 20),
//                   shrinkWrap: true,
//                   scrollDirection: Axis.horizontal,
//                   itemCount: visitingCardList.length,
//                   itemBuilder: (context, index) {
//                     return isLoadingSkeleton
//                         ? Shimmer.fromColors(
//                             baseColor: skeletonBaseColor,
//                             highlightColor: skeletonhighlightColor,
//                             child: Container(
//                               width: w / 3 - 20,
//                               height: w / 3 - 20,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(15),
//                                 color: skeletonBaseColor,
//                               ),
//                             ),
//                           )
//                         : GestureDetector(
//                             onTap: () {
//                               templateName = visitingCardList[index]["title"];
//                               templateSearchName =
//                                   visitingCardList[index]["searchText"];
//                               print(
//                                   "--------- Template Name --------- ${visitingCardList[index]["title"]}");
//                               reviewCount(context);
//                               Navigator.push(
//                                 context,
//                                 PageTransition(
//                                   type: PageTransitionType.rightToLeftWithFade,
//                                   child: EditVisitingCard(
//                                     frontSide: visitingCardList[index]
//                                         ["image_2"],
//                                     backSide: visitingCardList[index]
//                                         ["image_3"],
//                                   ),
//                                 ),
//                               );
//                             },
//                             child: Container(
//                               margin: const EdgeInsets.only(left: 10),
//                               width: w / 3 - 20,
//                               height: w / 3 - 20,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(15),
//                               ),
//                               child: Image.asset(
//                                 visitingCardList[index]["image"],
//                                 fit: BoxFit.fill,
//                               ),
//                             ),
//                           );
//                   },
//                 ),
//               ),
//               const SizedBox(
//                 height: 30,
//               ),
//               Container(
//                 margin: const EdgeInsets.symmetric(horizontal: 20),
//                 child: rowText(
//                   festivalDay,
//                   viewAll,
//                   () {
//                     tabTap = 2;
//                     Navigator.push(
//                       context,
//                       PageTransition(
//                         type: PageTransitionType.rightToLeftWithFade,
//                         child: const Templates(scrollPosition: 100),
//                       ),
//                     );
//                     FirebaseAnalyticsService.instance.logEvent(
//                         name: 'view_all', parameters: {'name': 'Festival Day'});
//                   },
//                   isLoading: isLoadingSkeleton,
//                 ),
//               ),
//               const SizedBox(
//                 height: 30,
//               ),
//               SizedBox(
//                 height: w / 3 - 20,
//                 child: ListView.builder(
//                   padding: const EdgeInsets.only(left: 10, right: 20),
//                   shrinkWrap: true,
//                   scrollDirection: Axis.horizontal,
//                   itemCount: festivalsEventList.length,
//                   itemBuilder: (context, index) {
//                     return isLoadingSkeleton
//                         ? Shimmer.fromColors(
//                             baseColor: skeletonBaseColor,
//                             highlightColor: skeletonhighlightColor,
//                             child: Container(
//                               width: w / 3 - 20,
//                               height: w / 3 - 20,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(15),
//                                 color: skeletonBaseColor,
//                               ),
//                             ),
//                           )
//                         : GestureDetector(
//                             onTap: () async {
//                               templateName = festivalsEventList[index]["title"];
//                               templateSearchName =
//                                   festivalsEventList[index]["searchText"];
//                               print(
//                                   "--------- Template Name --------- ${festivalsEventList[index]["title"]}");
//                               isFestivalImageTap = true;
//                               isPatrioticImageTap = false;
//                               isSpecialImageTap = false;
//                               await imageDialog(context, index,
//                                   templateName: festivalsEventList[index]
//                                       ["searchText"]);
//                               cropImage(index);
//                               reviewCount(context);
//                               setState(() {});
//                             },
//                             child: Container(
//                               margin: const EdgeInsets.only(left: 10),
//                               width: w / 3 - 20,
//                               height: w / 3 - 20,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(15),
//                               ),
//                               child: Image.asset(
//                                 festivalsEventList[index]["image"],
//                                 fit: BoxFit.fill,
//                               ),
//                             ),
//                           );
//                   },
//                 ),
//               ),
//               const SizedBox(
//                 height: 30,
//               ),
//               Container(
//                 margin: const EdgeInsets.symmetric(horizontal: 20),
//                 child: rowText(
//                   specialDay,
//                   viewAll,
//                   () {
//                     tabTap = 3;
//                     Navigator.push(
//                       context,
//                       PageTransition(
//                         type: PageTransitionType.rightToLeftWithFade,
//                         child: const Templates(scrollPosition: 250),
//                       ),
//                     );
//                     FirebaseAnalyticsService.instance.logEvent(
//                         name: 'view_all', parameters: {'name': 'Special Day'});
//                   },
//                   isLoading: isLoadingSkeleton,
//                 ),
//               ),
//               const SizedBox(
//                 height: 30,
//               ),
//               SizedBox(
//                 height: w / 3 - 20,
//                 child: ListView.builder(
//                   padding: const EdgeInsets.only(left: 10, right: 20),
//                   shrinkWrap: true,
//                   scrollDirection: Axis.horizontal,
//                   itemCount: specialDaysList.length,
//                   itemBuilder: (context, index) {
//                     return isLoadingSkeleton
//                         ? Shimmer.fromColors(
//                             baseColor: skeletonBaseColor,
//                             highlightColor: skeletonhighlightColor,
//                             child: Container(
//                               width: w / 3 - 20,
//                               height: w / 3 - 20,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(15),
//                                 color: skeletonBaseColor,
//                               ),
//                             ),
//                           )
//                         : GestureDetector(
//                             onTap: () async {
//                               templateName = specialDaysList[index]["title"];
//                               templateSearchName =
//                                   specialDaysList[index]["searchText"];
//                               print(
//                                   "--------- Template Name --------- ${specialDaysList[index]["title"]}");
//                               isSpecialImageTap = true;
//                               isPatrioticImageTap = false;
//                               isFestivalImageTap = false;
//                               await imageDialog(context, index,
//                                   templateName: specialDaysList[index]
//                                       ["searchText"]);
//                               cropImage(index);
//                               reviewCount(context);
//                               setState(() {});
//                             },
//                             child: Container(
//                               margin: const EdgeInsets.only(left: 10),
//                               width: w / 3 - 20,
//                               height: w / 3 - 20,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(15),
//                               ),
//                               child: Image.asset(
//                                 specialDaysList[index]["image"],
//                                 fit: BoxFit.fill,
//                               ),
//                             ),
//                           );
//                   },
//                 ),
//               ),
//               const SizedBox(
//                 height: 50,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:page_transition/page_transition.dart';
import 'package:photo_frame/Controller/CardEditController.dart';
import 'package:photo_frame/Contstant/AppColor.dart';
import 'package:photo_frame/Contstant/CommonMethod.dart';
import 'package:photo_frame/Contstant/Strings.dart';
import 'package:photo_frame/Screen/CardEdit.dart';
import 'package:photo_frame/Screen/EditImageScreen.dart';
import 'package:photo_frame/Screen/EditVisitingCard.dart';
import 'package:photo_frame/Screen/HomeSearchPage.dart';
import 'package:photo_frame/Screen/SpecificPoster.dart';
import 'package:photo_frame/Screen/Templates.dart';
import 'package:photo_frame/model/card_model.dart';
import 'package:photo_frame/service/firebase_analytics_service.dart';
import 'package:photo_frame/service/firebase_push_notification_service.dart';
import 'package:shimmer/shimmer.dart';

int drawerContainer = 0;
bool isSliderImageTap = false;
bool isPatrioticImageTap = false;
bool isFestivalImageTap = false;
bool isSpecialImageTap = false;
List versionList = [];
ScrollController tabScrollController = ScrollController();
String templateName = "";
String templateSearchName = "";
bool isSeeAllTap = true;

List popularFetivalList = [
  {
    "icon": "assets/images/diwaliIcon.png",
    "name": "Diwali",
    "tabTap": 2,
  },
  {
    "icon": "assets/images/rakshaBadhanIcon.png",
    "name": "Raksha Bandhan",
    "tabTap": 2,
  },
  {
    "icon": "assets/images/independeceIcon.png",
    "name": "Independence",
    "tabTap": 1,
  },
  {
    "icon": "assets/images/motherDayIcon.png",
    "name": "Mother Day",
    "tabTap": 3,
  },
  {
    "icon": "assets/images/ganeshChaturthiIcon.png",
    "name": "Ganesh Chaturthi",
    "tabTap": 2,
  },
  {
    "icon": "assets/images/holiIcon.png",
    "name": "Holi",
    "tabTap": 2,
  },
  {
    "icon": "assets/images/fatherDayIcon.png",
    "name": "Father Day",
    "tabTap": 3,
  },
  {
    "icon": "assets/images/environmentDayIcon.png",
    "name": "Environment Day",
    "tabTap": 3,
  },
  {
    "icon": "assets/images/valentinesIcon.png",
    "name": "Valentines",
    "tabTap": 3,
  },
  {
    "icon": "assets/images/republicIcon.png",
    "name": "Republic Day",
    "tabTap": 1,
  },
  {
    "icon": "assets/images/rathYatraIcon.png",
    "name": "Rath Yatra",
    "tabTap": 2,
  },
];

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? version = '';
  final CardEditController cardEditController = Get.put(CardEditController());

  Future<void> cropImage(index) async {
    try {
      if (image != null) {
        print("----------- image Crop ----------- $image");
        var croppedFile = await ImageCropper().cropImage(
          sourcePath: image!.path,
          compressFormat: ImageCompressFormat.jpg,
          compressQuality: 100,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.ratio16x9,
          ],
          androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Edit',
            toolbarColor: grey800Color,
            toolbarWidgetColor: whiteColor,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
          ),
          iosUiSettings: const IOSUiSettings(
            title: 'Edit',
          ),
        );
        if (croppedFile != null) {
          setState(() {
            File cropImage = File(croppedFile!.path);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => EditImageScreen(
                  cropImage: cropImage,
                  image: isPatrioticImageTap == true
                      ? patrioticDayList[index]["image"]
                      : isFestivalImageTap == true
                          ? festivalsEventList[index]["image"]
                          : isSpecialImageTap == true
                              ? specialDaysList[index]["image"]
                              : templateWithImageList[index]["image"],
                  wallPaper: isPatrioticImageTap == true
                      ? patrioticDayList[index]["image_2"]
                      : isFestivalImageTap == true
                          ? festivalsEventList[index]["image_2"]
                          : isSpecialImageTap == true
                              ? specialDaysList[index]["image_2"]
                              : templateWithImageList[index]["image_2"],
                ),
              ),
            );
          });
          setState(() {});
        } else {
          image = null;
          isLoader = false;
          croppedFile = null;
          setState(() {});
        }
      }
    } catch (e) {
      print("-------------- Image Crop Error ----------- $e");
    }
  }

  Future<void> getImages() async {
    try {
      var imageResponse = await rootBundle.loadString('assets/images.json');
      templateWithImageList = jsonDecode(imageResponse).toList();
      setState(() {});
    } catch (e) {
      print("-------------- Json Get Data Error -------------- $e");
    }
  }

  Future<void> getVersion() async {
    try {
      var versionResponse = await rootBundle.loadString('assets/version.json');
      versionList = jsonDecode(versionResponse).toList();
      setState(() {});
    } catch (e) {
      print("-------------- Json Get version Error -------------- $e");
    }
  }

  Future<void> checkVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version = packageInfo.version;
    int currentVersion = getVersionNumber(version!);
    int latestVersion = getVersionNumber(versionList[0]["appVersion"]);
    print("---------- Current Version ----------- $version");
    print("---------- v1 ----------- $currentVersion");
    print("---------- v2 ----------- $latestVersion");
    if (latestVersion > currentVersion) {
      print("---------- Dialog Show ------------");
      showUpdateDialog(context);
    } else {
      print("----------- Dialog Not Show -------------");
    }
  }

  int getVersionNumber(String version) {
    List versionCells = version.split(".");
    versionCells = versionCells.map((e) => int.parse(e)).toList();
    return versionCells[0] * 100000 + versionCells[1] * 1000 + versionCells[2];
  }

  @override
  void initState() {
    super.initState();
    getImages();
    getVersion();
    checkVersion();
    reviewCount(context);
    allScreenSkeleton(setState);
    getPatrioticImage();
    getFestivalImage();
    getSpecialImage();
    getVisitingCard();
    FirebaseService.requestPermission();
    FirebaseService.configureForegroundMessaging();
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return Expanded(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.only(right: 20, left: 20, bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      isLoadingSkeleton
                          ? Shimmer.fromColors(
                              baseColor: skeletonBaseColor,
                              highlightColor: skeletonhighlightColor,
                              child: Container(
                                height: 30,
                                width: 3,
                                decoration: BoxDecoration(
                                  color: skeletonBaseColor,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            )
                          : Container(
                              height: 30,
                              width: 3,
                              decoration: BoxDecoration(
                                color: kPrimeryColor,
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                      const SizedBox(
                        width: 20,
                      ),
                      isLoadingSkeleton
                          ? Shimmer.fromColors(
                              baseColor: skeletonBaseColor,
                              highlightColor: skeletonhighlightColor,
                              child: Container(
                                width: 150,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: skeletonBaseColor,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            )
                          : Text(
                              popularPoster,
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: kPrimeryColor,
                              ),
                            ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isSeeAllTap = !isSeeAllTap;
                      });
                    },
                    child: isLoadingSkeleton
                        ? Shimmer.fromColors(
                            baseColor: skeletonBaseColor,
                            highlightColor: skeletonhighlightColor,
                            child: Container(
                              width: 50,
                              height: 20,
                              decoration: BoxDecoration(
                                color: skeletonBaseColor,
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          )
                        : Text(
                            isSeeAllTap ? seeAll : seeLess,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xff747474),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 0.75,
              ),
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      selectedName = popularFetivalList[index]["name"];
                      Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.rightToLeftWithFade,
                          child: const SpecificPoster(),
                        ),
                      );
                      setState(() {});
                    },
                    child: Container(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          isLoadingSkeleton
                              ? Shimmer.fromColors(
                                  baseColor: skeletonBaseColor,
                                  highlightColor: skeletonhighlightColor,
                                  child: Container(
                                    height: 70,
                                    width: 70,
                                    decoration: const BoxDecoration(
                                      color: skeletonBaseColor,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                )
                              : Container(
                                  height: 0.075 * h,
                                  width: 0.15 * w,
                                  decoration: BoxDecoration(
                                    color: whiteColor,
                                    border: Border.all(
                                      color: kPrimeryColor,
                                      width: 1.2,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(0.0),
                                    child: Image.asset(
                                      popularFetivalList[index]["icon"],
                                      scale: 4,
                                    ),
                                  ),
                                ),
                          const SizedBox(
                            height: 15,
                          ),
                          isLoadingSkeleton
                              ? Shimmer.fromColors(
                                  baseColor: skeletonBaseColor,
                                  highlightColor: skeletonhighlightColor,
                                  child: Container(
                                    width: 150,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color: skeletonBaseColor,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                )
                              : SizedBox(
                                  width: 0.23 * w,
                                  child: Text(
                                    popularFetivalList[index]["name"] + "\n ",
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    style: GoogleFonts.poppins(
                                      fontSize: 0.028 * w,
                                      color: kPrimeryColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ),
                  );
                },
                childCount: isSeeAllTap ? 8 : popularFetivalList.length,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.only(
                  right: 20, left: 20, bottom: 25, top: 25),
              child: rowText(
                "Customized Festival Poster",
                viewAll,
                () {
                  tabTap = 0;
                  Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.rightToLeftWithFade,
                      child: const Templates(scrollPosition: 0),
                    ),
                  );
                  FirebaseAnalyticsService.instance.logEvent(
                      name: 'view_all',
                      parameters: {'name': 'Customized Festival Poster'});
                },
                isLoading: isLoadingSkeleton,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: w / 3 - 20,
              child: ListView.builder(
                padding: const EdgeInsets.only(left: 10, right: 20),
                scrollDirection: Axis.horizontal,
                itemCount: templateWithImageList.length,
                itemBuilder: (context, index) {
                  return isLoadingSkeleton
                      ? Shimmer.fromColors(
                          baseColor: skeletonBaseColor,
                          highlightColor: skeletonhighlightColor,
                          child: Container(
                            width: w / 3 - 20,
                            height: w / 3 - 20,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: skeletonBaseColor,
                            ),
                          ),
                        )
                      : GestureDetector(
                          onTap: () async {
                            templateName =
                                templateWithImageList[index]["title"];
                            templateSearchName =
                                templateWithImageList[index]["searchText"];
                            print(
                                "--------- Template Name --------- ${templateWithImageList[index]["image"]}");
                            isPatrioticImageTap = false;
                            isFestivalImageTap = false;
                            isSpecialImageTap = false;
                            await imageDialog(context, index,
                                templateName: templateWithImageList[index]
                                    ["searchText"]);
                            cropImage(index);
                            reviewCount(context);
                            setState(() {});
                          },
                          child: Container(
                            margin: const EdgeInsets.only(left: 10),
                            width: w / 3 - 20,
                            height: w / 3 - 20,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Image.asset(
                              templateWithImageList[index]["image"],
                              fit: BoxFit.fill,
                            ),
                          ),
                        );
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.only(
                  right: 20, left: 20, bottom: 25, top: 25),
              child: rowText(
                customizedBusinessCards,
                viewAll,
                () {
                  tabTap = 4;
                  Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.rightToLeftWithFade,
                      child: const Templates(scrollPosition: 320),
                    ),
                  );
                  FirebaseAnalyticsService.instance.logEvent(
                      name: 'view_all',
                      parameters: {'name': 'Customized Business cards'});
                },
                isLoading: isLoadingSkeleton,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: w / 3 - 20,
              child: ListView.builder(
                padding: const EdgeInsets.only(left: 10, right: 20),
                scrollDirection: Axis.horizontal,
                itemCount: cardEditController.newCardList.length,
                itemBuilder: (context, index) {
                  final cardData = cardEditController.newCardList[index];
                  return isLoadingSkeleton
                      ? Shimmer.fromColors(
                          baseColor: skeletonBaseColor,
                          highlightColor: skeletonhighlightColor,
                          child: Container(
                            width: w / 3 - 20,
                            height: w / 3 - 20,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: skeletonBaseColor,
                            ),
                          ),
                        )
                      : GestureDetector(
                          onTap: () async {
                            templateName = cardData["title"];
                            templateSearchName = cardData["searchText"];
                            print(
                                "--------- Template Name --------- ${cardData["searchText"]}");
                            reviewCount(context);
                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.rightToLeftWithFade,
                                child: CardEdit(
                                  data: CardModel.fromJson(cardData),
                                ),
                              ),
                            );
                            setState(() {});
                          },
                          child: Container(
                            margin: const EdgeInsets.only(left: 10),
                            width: w / 3 - 20,
                            height: w / 3 - 20,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Image.asset(
                              cardData["coverImage"],
                              fit: BoxFit.fill,
                            ),
                          ),
                        );
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.only(
                  right: 20, left: 20, bottom: 25, top: 25),
              child: rowText(
                patrioticDay,
                viewAll,
                () {
                  tabTap = 1;
                  Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.rightToLeftWithFade,
                      child: const Templates(scrollPosition: 0),
                    ),
                  );
                  FirebaseAnalyticsService.instance.logEvent(
                      name: 'view_all', parameters: {'name': 'Patriotic Day'});
                },
                isLoading: isLoadingSkeleton,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: w / 3 - 20,
              child: ListView.builder(
                padding: const EdgeInsets.only(left: 10, right: 20),
                scrollDirection: Axis.horizontal,
                itemCount: patrioticDayList.length,
                itemBuilder: (context, index) {
                  return isLoadingSkeleton
                      ? Shimmer.fromColors(
                          baseColor: skeletonBaseColor,
                          highlightColor: skeletonhighlightColor,
                          child: Container(
                            width: w / 3 - 20,
                            height: w / 3 - 20,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: skeletonBaseColor,
                            ),
                          ),
                        )
                      : GestureDetector(
                          onTap: () async {
                            templateName = patrioticDayList[index]["title"];
                            templateSearchName =
                                patrioticDayList[index]["searchText"];
                            print(
                                "--------- Template Name --------- ${patrioticDayList[index]["searchText"]}");
                            isPatrioticImageTap = true;
                            isFestivalImageTap = false;
                            isSpecialImageTap = false;
                            await imageDialog(context, index,
                                templateName: patrioticDayList[index]
                                    ["searchText"]);
                            cropImage(index);
                            reviewCount(context);
                            setState(() {});
                          },
                          child: Container(
                            margin: const EdgeInsets.only(left: 10),
                            width: w / 3 - 20,
                            height: w / 3 - 20,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Image.asset(
                              patrioticDayList[index]["image"],
                              fit: BoxFit.fill,
                            ),
                          ),
                        );
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
              child: rowText(
                businessCards,
                viewAll,
                () {
                  tabTap = 4;
                  Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.rightToLeftWithFade,
                      child: const Templates(scrollPosition: 320),
                    ),
                  );
                  FirebaseAnalyticsService.instance.logEvent(
                      name: 'view_all', parameters: {'name': 'Business Cards'});
                },
                isLoading: isLoadingSkeleton,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: w / 3 - 20,
              child: ListView.builder(
                padding: const EdgeInsets.only(left: 10, right: 20),
                scrollDirection: Axis.horizontal,
                itemCount: visitingCardList.length,
                itemBuilder: (context, index) {
                  return isLoadingSkeleton
                      ? Shimmer.fromColors(
                          baseColor: skeletonBaseColor,
                          highlightColor: skeletonhighlightColor,
                          child: Container(
                            width: w / 3 - 20,
                            height: w / 3 - 20,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: skeletonBaseColor,
                            ),
                          ),
                        )
                      : GestureDetector(
                          onTap: () {
                            templateName = visitingCardList[index]["title"];
                            templateSearchName =
                                visitingCardList[index]["searchText"];
                            print(
                                "--------- Template Name --------- ${visitingCardList[index]["title"]}");
                            reviewCount(context);
                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.rightToLeftWithFade,
                                child: EditVisitingCard(
                                  frontSide: visitingCardList[index]["image_2"],
                                  backSide: visitingCardList[index]["image_3"],
                                ),
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.only(left: 10),
                            width: w / 3 - 20,
                            height: w / 3 - 20,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Image.asset(
                              visitingCardList[index]["image"],
                              fit: BoxFit.fill,
                            ),
                          ),
                        );
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
              child: rowText(
                festivalDay,
                viewAll,
                () {
                  tabTap = 2;
                  Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.rightToLeftWithFade,
                      child: const Templates(scrollPosition: 100),
                    ),
                  );
                  FirebaseAnalyticsService.instance.logEvent(
                      name: 'view_all', parameters: {'name': 'Festival Day'});
                },
                isLoading: isLoadingSkeleton,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: w / 3 - 20,
              child: ListView.builder(
                padding: const EdgeInsets.only(left: 10, right: 20),
                scrollDirection: Axis.horizontal,
                itemCount: festivalsEventList.length,
                itemBuilder: (context, index) {
                  return isLoadingSkeleton
                      ? Shimmer.fromColors(
                          baseColor: skeletonBaseColor,
                          highlightColor: skeletonhighlightColor,
                          child: Container(
                            width: w / 3 - 20,
                            height: w / 3 - 20,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: skeletonBaseColor,
                            ),
                          ),
                        )
                      : GestureDetector(
                          onTap: () async {
                            templateName = festivalsEventList[index]["title"];
                            templateSearchName =
                                festivalsEventList[index]["searchText"];
                            print(
                                "--------- Template Name --------- ${festivalsEventList[index]["title"]}");
                            isFestivalImageTap = true;
                            isPatrioticImageTap = false;
                            isSpecialImageTap = false;
                            await imageDialog(context, index,
                                templateName: festivalsEventList[index]
                                    ["searchText"]);
                            cropImage(index);
                            reviewCount(context);
                            setState(() {});
                          },
                          child: Container(
                            margin: const EdgeInsets.only(left: 10),
                            width: w / 3 - 20,
                            height: w / 3 - 20,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Image.asset(
                              festivalsEventList[index]["image"],
                              fit: BoxFit.fill,
                            ),
                          ),
                        );
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
              child: rowText(
                specialDay,
                viewAll,
                () {
                  tabTap = 3;
                  Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.rightToLeftWithFade,
                      child: const Templates(scrollPosition: 250),
                    ),
                  );
                  FirebaseAnalyticsService.instance.logEvent(
                      name: 'view_all', parameters: {'name': 'Special Day'});
                },
                isLoading: isLoadingSkeleton,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: w / 3 - 20,
              child: ListView.builder(
                padding: const EdgeInsets.only(left: 10, right: 20),
                scrollDirection: Axis.horizontal,
                itemCount: specialDaysList.length,
                itemBuilder: (context, index) {
                  return isLoadingSkeleton
                      ? Shimmer.fromColors(
                          baseColor: skeletonBaseColor,
                          highlightColor: skeletonhighlightColor,
                          child: Container(
                            width: w / 3 - 20,
                            height: w / 3 - 20,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: skeletonBaseColor,
                            ),
                          ),
                        )
                      : GestureDetector(
                          onTap: () async {
                            templateName = specialDaysList[index]["title"];
                            templateSearchName =
                                specialDaysList[index]["searchText"];
                            print(
                                "--------- Template Name --------- ${specialDaysList[index]["title"]}");
                            isSpecialImageTap = true;
                            isPatrioticImageTap = false;
                            isFestivalImageTap = false;
                            await imageDialog(context, index,
                                templateName: specialDaysList[index]
                                    ["searchText"]);
                            cropImage(index);
                            reviewCount(context);
                            setState(() {});
                          },
                          child: Container(
                            margin: const EdgeInsets.only(left: 10),
                            width: w / 3 - 20,
                            height: w / 3 - 20,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Image.asset(
                              specialDaysList[index]["image"],
                              fit: BoxFit.fill,
                            ),
                          ),
                        );
                },
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(
              height: 50,
            ),
          ),
        ],
      ),
    );
  }
}
