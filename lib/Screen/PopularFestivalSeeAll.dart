import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:photo_frame/Contstant/AppColor.dart';
import 'package:photo_frame/Screen/HomePage.dart';
import 'package:photo_frame/Screen/HomeSearchPage.dart';
import 'package:photo_frame/Screen/SpecificPoster.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class PopularFestivalSeeAll extends StatefulWidget {
  const PopularFestivalSeeAll({super.key});

  @override
  State<PopularFestivalSeeAll> createState() => _PopularFestivalSeeAllState();
}

class _PopularFestivalSeeAllState extends State<PopularFestivalSeeAll> {
  TextEditingController searchController = TextEditingController();
  List searchList = [];
  SpeechToText speechToText = SpeechToText();
  bool isSpeechEnable = false;
  String lastWords = "";
  bool isDialogShow = false;

  Future<void> initSpeech() async {
    isSpeechEnable = await speechToText.initialize();
    print("--------- isSpeechEnable ----------- $isSpeechEnable");
    setState(() {});
  }

  Future<void> startListening() async {
    await speechToText.listen(onResult: onSpeechResult);
    setState(() {});
  }

  Future<void> stopListening() async {
    await speechToText.stop();
    isDialogShow = false;
    setState(() {});
  }

  void onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      lastWords = result.recognizedWords;
      searchController.text = lastWords;
      print("---------- Recognize Words ------- $lastWords");
    });
    searchData(lastWords);
    if (speechToText.isNotListening) {
      Future.delayed(
        const Duration(seconds: 1),
        () {
          setState(() {
            isDialogShow = false;
          });
        },
      );
    }
  }

  void searchData(String search) {
    searchList.clear();
    if (search.isEmpty) {
      searchList = List.from(popularFetivalList);
    } else {
      for (var searchText in popularFetivalList) {
        if (searchText["name"].toLowerCase().contains(search.toLowerCase())) {
          searchList.add(searchText);
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    searchData("");
    initSpeech();
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: kPrimeryColor,
        title: Text(
          "Popular Festival",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Material(
                  elevation: 5,
                  borderRadius: BorderRadius.circular(10),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: const Icon(
                        Icons.search,
                        color: greyColor,
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          print("--------- Mic Icon Tap --------");
                          setState(() {
                            lastWords = "";
                            isDialogShow = true;
                            speechToText.isNotListening
                                ? startListening()
                                : stopListening();
                            if (speechToText.isNotListening) {
                              Future.delayed(
                                const Duration(seconds: 4),
                                () {
                                  if (lastWords == "") {
                                    setState(() {
                                      isDialogShow = false;
                                    });
                                  }
                                },
                              );
                            }
                          });
                        },
                        icon: const Icon(Icons.keyboard_voice_outlined),
                        color: greyColor,
                      ),
                      hintText: "Search Your Poster",
                      hintStyle: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    cursorColor: blackColor,
                    onChanged: (value) {
                      setState(() {
                        searchData(value);
                      });
                    },
                  ),
                ),
              ),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.only(bottom: 20),
                  itemCount: searchList.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisExtent: 125,
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 5,
                  ),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        selectedName = searchList[index]["name"];
                        Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.rightToLeftWithFade,
                            child: const SpecificPoster(),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(top: 20),
                        width: w / 3 - 20,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Material(
                              elevation: 5,
                              borderRadius: BorderRadius.circular(70),
                              child: Container(
                                height: 70,
                                width: 70,
                                decoration: const BoxDecoration(
                                  color: whiteColor,
                                  shape: BoxShape.circle,
                                ),
                                child: Image.asset(
                                  searchList[index]["icon"],
                                  scale: 5,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Text(
                              searchList[index]["name"],
                              style: GoogleFonts.poppins(
                                fontSize: 0.03 * w,
                                color: kPrimeryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          isDialogShow == true
              ? GestureDetector(
                  onTap: () {
                    setState(() {
                      isDialogShow = false;
                    });
                  },
                  child: Container(
                    height: double.infinity,
                    width: double.infinity,
                    color: blackColor.withOpacity(0.5),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          isDialogShow = true;
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: whiteColor,
                              boxShadow: [
                                BoxShadow(
                                  color: kPrimeryColor.withOpacity(0.5),
                                  offset: const Offset(0, 3),
                                  blurRadius: 4,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(30.0),
                              child: Image.asset(
                                "assets/images/voice.png",
                                scale: 5,
                              ),
                            ),
                          ),
                          Text(
                            speechToText.isListening ? lastWords : "",
                            style: GoogleFonts.poppins(
                              color: whiteColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
