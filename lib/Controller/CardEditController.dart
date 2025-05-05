import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CardEditController extends GetxController {
  final bool kIsDevMode = false;

  Rxn<String> processBackCardPath = Rxn();
  Rxn<String> processFrontCardPath = Rxn();

  Rxn<String> title = Rxn();
  Rxn<String> subTitle = Rxn();
  Rxn<String> location = Rxn();
  Rxn<String> number = Rxn();
  Rxn<String> website = Rxn();
  Rxn<String> email = Rxn();
  Rxn<String> name = Rxn();
  Rxn<String> role = Rxn();

  Future<void> getData() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    title.value = preferences.getString('company_title') ?? "";
    subTitle.value = preferences.getString('company_sub_title') ?? "";
    location.value = preferences.getString('location') ?? "";
    number.value = preferences.getString('number') ?? "";
    website.value = preferences.getString('website') ?? "";
    email.value = preferences.getString('email') ?? "";
    name.value = preferences.getString('name') ?? "";
    role.value = preferences.getString('role') ?? "";
  }

  // void showEditBottomSheet(BuildContext context, {required CardModel data}) {
  //   Get.bottomSheet(
  //     SizedBox(
  //       height: Get.height * .85,
  //       child: Column(
  //         children: [
  //           Container(
  //             height: 4,
  //             width: 100,
  //             decoration: BoxDecoration(
  //                 color: kPrimeryColor, borderRadius: BorderRadius.circular(2)),
  //           ),
  //           const SizedBox(
  //             height: 10,
  //           ),
  //           Expanded(
  //             child: Container(
  //               width: double.infinity,
  //               decoration: BoxDecoration(
  //                 color: Colors.white,
  //                 borderRadius: const BorderRadius.only(
  //                   topLeft: Radius.circular(40),
  //                   topRight: Radius.circular(40),
  //                 ),
  //                 boxShadow: [
  //                   BoxShadow(
  //                     color: Colors.black.withAlpha(20),
  //                     spreadRadius: 2,
  //                     blurRadius: 7,
  //                     offset: const Offset(0, -7),
  //                   ),
  //                 ],
  //               ),
  //               child: SingleChildScrollView(
  //                 child: Padding(
  //                   padding: const EdgeInsets.all(20),
  //                   child: Column(
  //                     children: [
  //                       const SizedBox(
  //                         height: 10,
  //                       ),
  //                       Text(
  //                         'Fill Your Card Details',
  //                         style: GoogleFonts.poppins(
  //                           fontSize: 18,
  //                           fontWeight: FontWeight.w600,
  //                         ),
  //                       ),
  //                       const SizedBox(
  //                         height: 14,
  //                       ),
  //                       MyTextField(
  //                         controller: txtTitle,
  //                         hint: 'Company Title',
  //                       ),
  //                       const SizedBox(
  //                         height: 14,
  //                       ),
  //                       MyTextField(
  //                         controller: txtSubTitle,
  //                         hint: 'Company Sub-Title',
  //                       ),
  //                       const SizedBox(
  //                         height: 14,
  //                       ),
  //                       MyTextField(
  //                         controller: txtLocation,
  //                         hint: 'Company Location',
  //                       ),
  //                       const SizedBox(
  //                         height: 14,
  //                       ),
  //                       MyTextField(
  //                         controller: txtNumber,
  //                         hint: 'Contact Number',
  //                       ),
  //                       const SizedBox(
  //                         height: 14,
  //                       ),
  //                       MyTextField(
  //                         controller: txtWebsite,
  //                         hint: 'Website Url',
  //                       ),
  //                       const SizedBox(
  //                         height: 14,
  //                       ),
  //                       MyTextField(
  //                         controller: txtEmail,
  //                         hint: 'Email',
  //                       ),
  //                       const SizedBox(
  //                         height: 14,
  //                       ),
  //                       MyTextField(
  //                         controller: txtName,
  //                         hint: 'Your name',
  //                       ),
  //                       const SizedBox(
  //                         height: 14,
  //                       ),
  //                       MyTextField(
  //                         controller: txtRole,
  //                         hint: 'Your Role',
  //                       ),
  //                       Padding(
  //                         padding: const EdgeInsets.only(bottom: 20.0, top: 30),
  //                         child: ElevatedButton(
  //                           onPressed: () {
  //                             Get.close(0);
  //                             Navigator.push(
  //                                 context,
  //                                 MaterialPageRoute(
  //                                   builder: (context) => CardCreate(
  //                                     data: data,
  //                                   ),
  //                                 ));
  //                           },
  //                           style: ElevatedButton.styleFrom(
  //                             backgroundColor: kPrimeryColor,
  //                             shape: RoundedRectangleBorder(
  //                               borderRadius: BorderRadius.circular(12),
  //                             ),
  //                           ),
  //                           child: Text(
  //                             'Save Details',
  //                             style: GoogleFonts.poppins(
  //                               fontSize: 16,
  //                               fontWeight: FontWeight.w600,
  //                               color: Colors.white,
  //                             ),
  //                           ),
  //                         ),
  //                       )
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //     elevation: 0,
  //     barrierColor: Colors.transparent,
  //     isScrollControlled: true,
  //   );
  // }

  final List newCardList = [
    {
      "searchText": "Visiting Card",
      "title": "Visiting Card",
      "type": "Visiting Card",
      "coverImage": "assets/images/visitingCardPreview_3.png",
      "frontImage": "assets/images/visitingCardFrontSide_3.png",
      "backImage": "assets/images/visitingCardBackSide_3.png",

      // front
      "frontTitleProperty": {
        "offset": {
          "dx": 160,
          "dy": 82,
        },
        "containerProperty": {
          "height": 20,
          "width": 180,
          "alignment": "centerLeft",
        },
        "textProperty": {
          "textStyle": "Roboto Serif",
          "fontSize": 15,
          "fontWeight": "w700",
          "color": 0XffE4C993,
        },
      },
      "frontSubTitleProperty": {
        "offset": {
          "dx": 160,
          "dy": 100,
        },
        "containerProperty": {
          "height": 20,
          "width": 180,
          "alignment": "centerLeft",
        },
        "textProperty": {
          "textStyle": "Montserrat",
          "fontSize": 12,
          "fontWeight": "w500",
          "color": 0XffE4C993,
        },
      },

      // back

      "nameProperty": {
        "offset": {
          "dx": 50,
          "dy": 31,
        },
        "containerProperty": {
          "height": 15,
          "width": 150,
          "alignment": "centerLeft",
        },
        "textProperty": {
          "textStyle": "Roboto Serif",
          "fontSize": 13,
          "fontWeight": "w700",
          "color": 0XffE4C993,
        },
      },
      "roleProperty": {
        "offset": {
          "dx": 220,
          "dy": 32,
        },
        "containerProperty": {
          "height": 15,
          "width": 120,
          "alignment": "centerLeft",
        },
        "textProperty": {
          "textStyle": "Montserrat",
          "fontSize": 10,
          "fontWeight": "w500",
          "color": 0XffE4C993,
        },
      },
      "titleProperty": {
        "offset": {
          "dx": -15,
          "dy": 50,
        },
        "containerProperty": {
          "height": 20,
          "width": 140,
          "alignment": "center",
        },
        "textProperty": {
          "textStyle": "Montserrat",
          "fontSize": 0,
          "fontWeight": null,
          "color": 0,
        },
      },
      "subTitleProperty": {
        "offset": {
          "dx": 0,
          "dy": 0,
        },
        "containerProperty": {
          "height": 20,
          "width": 140,
          "alignment": "center",
        },
        "textProperty": {
          "textStyle": "Montserrat",
          "fontSize": 0,
          "fontWeight": null,
          "color": 0,
        },
      },
      "locationProperty": {
        "offset": {
          "dx": 155,
          "dy": 166,
        },
        "containerProperty": {
          "height": 10,
          "width": 140,
          "alignment": "centerRight",
        },
        "textProperty": {
          "textStyle": "Roboto Flex",
          "fontSize": 8,
          "fontWeight": "w500",
          "color": 0XffE4C993,
        },
      },
      "contactProperty": {
        "offset": {
          "dx": 155,
          "dy": 118,
        },
        "containerProperty": {
          "height": 10,
          "width": 140,
          "alignment": "centerRight",
        },
        "textProperty": {
          "textStyle": "Roboto Flex",
          "fontSize": 8,
          "fontWeight": "w500",
          "color": 0XffE4C993,
        },
      },
      "emailProperty": {
        "offset": {
          "dx": 155,
          "dy": 134,
        },
        "containerProperty": {
          "height": 10,
          "width": 140,
          "alignment": "centerRight",
        },
        "textProperty": {
          "textStyle": "Roboto Flex",
          "fontSize": 8,
          "fontWeight": "w500",
          "color": 0XffE4C993,
        },
      },
      "websiteProperty": {
        "offset": {
          "dx": 155,
          "dy": 150,
        },
        "containerProperty": {
          "height": 10,
          "width": 140,
          "alignment": "centerRight",
        },
        "textProperty": {
          "textStyle": "Roboto Flex",
          "fontSize": 8,
          "fontWeight": "w500",
          "color": 0XffE4C993,
        },
      },
    },
    {
      "searchText": "Visiting Card",
      "title": "Visiting Card",
      "type": "Visiting Card",
      "coverImage": "assets/images/visitingCardPreview_2.png",
      "frontImage": "assets/images/visitingCardFrontSide_2.png",
      "backImage": "assets/images/visitingCardBackSide_2.png",

      // front
      "frontTitleProperty": {
        "offset": {
          "dx": 0,
          "dy": 82,
        },
        "containerProperty": {
          "height": 20,
          "width": 350,
          "alignment": "center",
        },
        "textProperty": {
          "textStyle": "Anton",
          "fontSize": 15,
          "fontWeight": "w400",
          "color": 0xfffffffff,
        },
      },
      "frontSubTitleProperty": {
        "offset": {
          "dx": 0,
          "dy": 102,
        },
        "containerProperty": {
          "height": 20,
          "width": 350,
          "alignment": "center",
        },
        "textProperty": {
          "textStyle": "Rubik",
          "fontSize": 12,
          "fontWeight": "w400",
          "color": 0xfffffffff,
        },
      },

      // back

      "nameProperty": {
        "offset": {
          "dx": 0,
          "dy": 23,
        },
        "containerProperty": {
          "height": 20,
          "width": 324,
          "alignment": "centerRight",
        },
        "textProperty": {
          "textStyle": "Anton",
          "fontSize": 16,
          "fontWeight": "w400",
          "color": 0XffB5802B,
        },
      },
      "roleProperty": {
        "offset": {
          "dx": 0,
          "dy": 45,
        },
        "containerProperty": {
          "height": 15,
          "width": 324,
          "alignment": "centerRight",
        },
        "textProperty": {
          "textStyle": "Montserrat",
          "fontSize": 10,
          "fontWeight": "w500",
          "color": 0Xfffffffff,
        },
      },
      "titleProperty": {
        "offset": {
          "dx": -15,
          "dy": 50,
        },
        "containerProperty": {
          "height": 20,
          "width": 140,
          "alignment": "center",
        },
        "textProperty": {
          "textStyle": "Righteous",
          "fontSize": 0,
          "fontWeight": "w400",
          "color": 0Xfffffffff,
        },
      },
      "subTitleProperty": {
        "offset": {
          "dx": -15,
          "dy": 60,
        },
        "containerProperty": {
          "height": 20,
          "width": 140,
          "alignment": "center",
        },
        "textProperty": {
          "textStyle": "Righteous",
          "fontSize": 0,
          "fontWeight": "w400",
          "color": 0Xfffffffff,
        },
      },
      "locationProperty": {
        "offset": {
          "dx": 67,
          "dy": 151,
        },
        "containerProperty": {
          "height": 10,
          "width": 120,
          "alignment": "centerLeft",
        },
        "textProperty": {
          "textStyle": "Montserrat",
          "fontSize": 8,
          "fontWeight": "w600",
          "color": 0Xff0E2D32,
        },
      },
      "contactProperty": {
        "offset": {
          "dx": 209,
          "dy": 151,
        },
        "containerProperty": {
          "height": 10,
          "width": 120,
          "alignment": "centerLeft",
        },
        "textProperty": {
          "textStyle": "Montserrat",
          "fontSize": 8,
          "fontWeight": "w600",
          "color": 0Xff0E2D32,
        },
      },
      "emailProperty": {
        "offset": {
          "dx": 67,
          "dy": 166,
        },
        "containerProperty": {
          "height": 10,
          "width": 120,
          "alignment": "centerLeft",
        },
        "textProperty": {
          "textStyle": "Montserrat",
          "fontSize": 8,
          "fontWeight": "w600",
          "color": 0Xff0E2D32,
        },
      },
      "websiteProperty": {
        "offset": {
          "dx": 209,
          "dy": 167,
        },
        "containerProperty": {
          "height": 10,
          "width": 120,
          "alignment": "centerLeft",
        },
        "textProperty": {
          "textStyle": "Montserrat",
          "fontSize": 8,
          "fontWeight": "w600",
          "color": 0Xff0E2D32,
        },
      },
    },
    {
      "searchText": "Visiting Card",
      "title": "Visiting Card",
      "type": "Visiting Card",
      "coverImage": "assets/images/visitingCardPreview_1.png",
      "frontImage": "assets/images/visitingCardFrontSide_1.png",
      "backImage": "assets/images/visitingCardBackSide_1.png",

      // front
      "frontTitleProperty": {
        "offset": {
          "dx": 0,
          "dy": 110,
        },
        "containerProperty": {
          "height": 20,
          "width": 350,
          "alignment": "center",
        },
        "textProperty": {
          "textStyle": "Staatliches",
          "fontSize": 15,
          "fontWeight": "w400",
          "color": 0xffEA8D2A,
        },
      },
      "frontSubTitleProperty": {
        "offset": {
          "dx": 0,
          "dy": 125,
        },
        "containerProperty": {
          "height": 20,
          "width": 350,
          "alignment": "center",
        },
        "textProperty": {
          "textStyle": "Roboto",
          "fontSize": 10,
          "fontWeight": "w800",
          "color": 0xffEA8D2A,
        },
      },

      // back

      "nameProperty": {
        "offset": {
          "dx": 190,
          "dy": 80,
        },
        "containerProperty": {
          "height": 20,
          "width": 140,
          "alignment": "center",
        },
        "textProperty": {
          "textStyle": "Staatliches",
          "fontSize": 16,
          "fontWeight": "w400",
          "color": 0Xff002838,
        },
      },
      "roleProperty": {
        "offset": {
          "dx": 190,
          "dy": 102,
        },
        "containerProperty": {
          "height": 20,
          "width": 140,
          "alignment": "center",
        },
        "textProperty": {
          "textStyle": "Roboto",
          "fontSize": 10,
          "fontWeight": "w600",
          "color": 0Xff002838,
        },
      },
      "titleProperty": {
        "offset": {
          "dx": -15,
          "dy": 50,
        },
        "containerProperty": {
          "height": 20,
          "width": 140,
          "alignment": "center",
        },
        "textProperty": {
          "textStyle": "Montserrat",
          "fontSize": 0,
          "fontWeight": null,
          "color": 0,
        },
      },
      "subTitleProperty": {
        "offset": {
          "dx": 0,
          "dy": 0,
        },
        "containerProperty": {
          "height": 20,
          "width": 140,
          "alignment": "center",
        },
        "textProperty": {
          "textStyle": "Montserrat",
          "fontSize": 0,
          "fontWeight": null,
          "color": 0,
        },
      },
      "locationProperty": {
        "offset": {
          "dx": 35,
          "dy": 65,
        },
        "containerProperty": {
          "height": 10,
          "width": 120,
          "alignment": "centerRight",
        },
        "textProperty": {
          "textStyle": "Roboto",
          "fontSize": 8,
          "fontWeight": "w500",
          "color": 0Xff002838,
        },
      },
      "contactProperty": {
        "offset": {
          "dx": 35,
          "dy": 85,
        },
        "containerProperty": {
          "height": 10,
          "width": 120,
          "alignment": "centerRight",
        },
        "textProperty": {
          "textStyle": "Roboto",
          "fontSize": 8,
          "fontWeight": "w500",
          "color": 0Xff002838,
        },
      },
      "emailProperty": {
        "offset": {
          "dx": 35,
          "dy": 105,
        },
        "containerProperty": {
          "height": 10,
          "width": 120,
          "alignment": "centerRight",
        },
        "textProperty": {
          "textStyle": "Roboto",
          "fontSize": 8,
          "fontWeight": "w500",
          "color": 0Xff002838,
        },
      },
      "websiteProperty": {
        "offset": {
          "dx": 35,
          "dy": 125,
        },
        "containerProperty": {
          "height": 10,
          "width": 120,
          "alignment": "centerRight",
        },
        "textProperty": {
          "textStyle": "Roboto",
          "fontSize": 8,
          "fontWeight": "w500",
          "color": 0Xff002838,
        },
      },
    },
  ];
}
