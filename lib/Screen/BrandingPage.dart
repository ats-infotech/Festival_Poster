import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:photo_frame/Contstant/AppColor.dart';
import 'package:photo_frame/Contstant/CommonMethod.dart';
import 'package:photo_frame/Screen/EditVisitingCard.dart';
import 'package:photo_frame/Screen/HomePage.dart';
import 'package:photo_frame/Screen/Templates.dart';
import 'package:photo_frame/service/firebase_analytics_service.dart';
import 'package:shimmer/shimmer.dart';

class BrandingPage extends StatefulWidget {
  const BrandingPage({super.key});

  @override
  State<BrandingPage> createState() => _BrandingPageState();
}

class _BrandingPageState extends State<BrandingPage> {
  @override
  void initState() {
    super.initState();
    allScreenSkeleton(setState);
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return Expanded(
      child: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(top: 20),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: rowText(
                  "All",
                  "View All",
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
                            name: 'view_all', parameters: {'name': 'All'});
                  },
                  isLoading: isLoadingSkeleton,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                height: w / 3 - 20,
                child: ListView.builder(
                  padding: const EdgeInsets.only(left: 10, right: 20),
                  shrinkWrap: true,
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
                                  " ---------- Template Name -------- ${templateName}");
                              reviewCount(context);
                              Navigator.push(
                                context,
                                PageTransition(
                                  type: PageTransitionType.rightToLeftWithFade,
                                  child: EditVisitingCard(
                                    frontSide: visitingCardList[index]
                                        ["image_2"],
                                    backSide: visitingCardList[index]
                                        ["image_3"],
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
              const SizedBox(
                height: 30,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: rowText(
                  "Transparent Visiting Card",
                  "View All",
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
                            name: 'view_all', parameters: {'name': 'Transparent Visiting Card'});
                  },
                  isLoading: isLoadingSkeleton,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                height: w / 3 - 20,
                child: ListView.builder(
                  padding: const EdgeInsets.only(left: 10, right: 20),
                  shrinkWrap: true,
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
                              templateSearchName = visitingCardList[index]["searchText"];
                              print(
                                  " ---------- Template Name -------- ${templateName}");
                              reviewCount(context);
                              Navigator.push(
                                context,
                                PageTransition(
                                  type: PageTransitionType.rightToLeftWithFade,
                                  child: EditVisitingCard(
                                    frontSide: visitingCardList[index]
                                        ["image_2"],
                                    backSide: visitingCardList[index]
                                        ["image_3"],
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
              const SizedBox(
                height: 30,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: rowText(
                  "Premium Visiting Card",
                  "View All",
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
                            name: 'view_all', parameters: {'name': 'Premium Visiting Card'});
                  },
                  isLoading: isLoadingSkeleton,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                height: w / 3 - 20,
                child: ListView.builder(
                  padding: const EdgeInsets.only(left: 10, right: 20),
                  shrinkWrap: true,
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
templateSearchName = visitingCardList[index]["searchText"];
                              print(
                                  " ---------- Template Name -------- ${templateName}");
                              reviewCount(context);
                              Navigator.push(
                                context,
                                PageTransition(
                                  type: PageTransitionType.rightToLeftWithFade,
                                  child: EditVisitingCard(
                                    frontSide: visitingCardList[index]
                                        ["image_2"],
                                    backSide: visitingCardList[index]
                                        ["image_3"],
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
              const SizedBox(
                height: 30,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: rowText(
                  "Folded Visiting Cards",
                  "View All",
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
                            name: 'view_all', parameters: {'name': 'Folded Visiting Cards'});
                  },
                  isLoading: isLoadingSkeleton,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                height: w / 3 - 20,
                child: ListView.builder(
                  padding: const EdgeInsets.only(left: 10, right: 20),
                  shrinkWrap: true,
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
                              templateSearchName = visitingCardList[index]["searchText"];
                              print(
                                  " ---------- Template Name -------- ${templateName}");
                              reviewCount(context);
                              Navigator.push(
                                context,
                                PageTransition(
                                  type: PageTransitionType.rightToLeftWithFade,
                                  child: EditVisitingCard(
                                    frontSide: visitingCardList[index]
                                        ["image_2"],
                                    backSide: visitingCardList[index]
                                        ["image_3"],
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
              const SizedBox(
                height: 30,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: rowText(
                  "Photographic Visiting Cards",
                  "View All",
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
                            name: 'view_all', parameters: {'name': 'Photographic Visiting Cards'});
                  },
                  isLoading: isLoadingSkeleton,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                height: w / 3 - 20,
                child: ListView.builder(
                  padding: const EdgeInsets.only(left: 10, right: 20),
                  shrinkWrap: true,
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
                              templateSearchName = visitingCardList[index]["searchText"];
                              print(
                                  " ---------- Template Name -------- ${templateName}");
                              reviewCount(context);
                              Navigator.push(
                                context,
                                PageTransition(
                                  type: PageTransitionType.rightToLeftWithFade,
                                  child: EditVisitingCard(
                                    frontSide: visitingCardList[index]
                                        ["image_2"],
                                    backSide: visitingCardList[index]
                                        ["image_3"],
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
              const SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
