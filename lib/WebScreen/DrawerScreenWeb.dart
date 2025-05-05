import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:photo_frame/Contstant/AppColor.dart';
import 'package:photo_frame/Contstant/Strings.dart';
import 'package:photo_frame/Screen/GradientText.dart';
import 'package:photo_frame/WebScreen/SpecificPosterWeb.dart';

List templateList = [
  "Happy Independence Day",
  "Happy Holi Day",
  "Happy Father Day",
  "Happy Environment Day",
  "Happy Janmahastami Day",
  "Happy Raksha Bandhan Day",
  "Happy Rath Yatra",
  "Ganesh Chaturthi",
  "Happy Mother Day",
  "Happy Valentine's Day",
  "Happy New Year",
  "Marry Christmas",
];
List businessCardList = [
  transparentVisitingCard,
  premiumVisitingCard,
  foldedVisitingCards,
  photographicVisitingCards,
];

class DrawerScreenWeb extends StatefulWidget {
  const DrawerScreenWeb({super.key});

  @override
  State<DrawerScreenWeb> createState() => _DrawerScreenWebState();
}

class _DrawerScreenWebState extends State<DrawerScreenWeb> {
  bool isTemplate = false;
  bool isBusinessCard = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: constraints.maxWidth,
              minHeight: constraints.maxHeight,
            ),
            child: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  width: double.infinity,
                  child: Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            "assets/images/AppLogo.png",
                            scale: 5,
                          ),
                          SizedBox(
                            width: constraints.maxWidth > 300 ? 20 : 0,
                          ),
                          constraints.maxWidth > 300
                              ? GradientText(
                                  festivalPoster,
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xff276EB6),
                                      Color(0xff443995),
                                    ],
                                  ),
                                  style: GoogleFonts.reemKufiFun(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 15),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: const Icon(
                            Icons.close,
                            color: kPrimeryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                const Divider(
                  indent: 30,
                  endIndent: 30,
                  thickness: 2,
                ),
                const SizedBox(
                  height: 25,
                ),
                InkWell(
                  splashColor: transparentColor,
                  hoverColor: transparentColor,
                  highlightColor: transparentColor,
                  onTap: () {
                    setState(() {
                      isTemplate = !isTemplate;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 30),
                    width: double.infinity,
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: Wrap(
                            alignment: WrapAlignment.spaceBetween,
                            crossAxisAlignment: WrapCrossAlignment.start,
                            children: [
                              Wrap(
                                children: [
                                  Image.asset(
                                    "assets/images/drawerTemplate.png",
                                    color: isTemplate
                                        ? kPrimeryColor
                                        : const Color(0xff747474),
                                    scale: 4,
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    templates,
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: isTemplate
                                          ? kPrimeryColor
                                          : const Color(0xff747474),
                                    ),
                                  ),
                                ],
                              ),
                              Icon(
                                isTemplate
                                    ? Icons.keyboard_arrow_up_rounded
                                    : Icons.keyboard_arrow_down_rounded,
                                color: isTemplate
                                    ? kPrimeryColor
                                    : const Color(0xff747474),
                              ),
                            ],
                          ),
                        ),
                        isTemplate
                            ? const SizedBox(
                                height: 30,
                              )
                            : Container(),
                        isTemplate
                            ? GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isTemplate = true;
                                  });
                                },
                                child: ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: templateList.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            PageTransition(
                                              type: PageTransitionType
                                                  .rightToLeft,
                                              duration: const Duration(
                                                  milliseconds: 400),
                                              child: SpecificPosterWeb(
                                                selectedName:
                                                    templateList[index],
                                              ),
                                            ),
                                          );
                                        },
                                        child: GradientText(
                                          templateList[index],
                                          gradient: const LinearGradient(
                                            colors: [
                                              kPrimeryColor,
                                              kSecondaryColor
                                            ],
                                          ),
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                InkWell(
                  splashColor: transparentColor,
                  hoverColor: transparentColor,
                  highlightColor: transparentColor,
                  onTap: () {
                    setState(() {
                      isBusinessCard = !isBusinessCard;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 30),
                    width: double.infinity,
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: Wrap(
                            alignment: WrapAlignment.spaceBetween,
                            crossAxisAlignment: WrapCrossAlignment.start,
                            children: [
                              Wrap(
                                children: [
                                  Image.asset(
                                    "assets/webImages/businessCard.png",
                                    color: isBusinessCard
                                        ? kPrimeryColor
                                        : const Color(0xff747474),
                                    scale: 4,
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    "Business card",
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: isBusinessCard
                                          ? kPrimeryColor
                                          : const Color(0xff747474),
                                    ),
                                  ),
                                ],
                              ),
                              Icon(
                                isBusinessCard
                                    ? Icons.keyboard_arrow_up_rounded
                                    : Icons.keyboard_arrow_down_rounded,
                                color: isBusinessCard
                                    ? kPrimeryColor
                                    : const Color(0xff747474),
                              ),
                            ],
                          ),
                        ),
                        isBusinessCard
                            ? const SizedBox(
                                height: 30,
                              )
                            : Container(),
                        isBusinessCard
                            ? GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isBusinessCard = true;
                                  });
                                },
                                child: ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: businessCardList.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            PageTransition(
                                              type: PageTransitionType
                                                  .rightToLeft,
                                              duration: const Duration(
                                                  milliseconds: 400),
                                              child: SpecificPosterWeb(
                                                selectedName:
                                                    businessCardList[index],
                                              ),
                                            ),
                                          );
                                        },
                                        child: GradientText(
                                          businessCardList[index],
                                          gradient: const LinearGradient(
                                            colors: [
                                              kPrimeryColor,
                                              kSecondaryColor
                                            ],
                                          ),
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  width: double.infinity,
                  child: Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.start,
                    children: [
                      Wrap(
                        children: [
                          Image.asset(
                            "assets/webImages/aboutUs.png",
                            color: const Color(0xff747474),
                            scale: 4,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Text(
                            "About Us",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xff747474),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  width: double.infinity,
                  child: Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.start,
                    children: [
                      Wrap(
                        children: [
                          Image.asset(
                            "assets/webImages/contectUs.png",
                            color: const Color(0xff747474),
                            scale: 4,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Text(
                            "Contact Us",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xff747474),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
