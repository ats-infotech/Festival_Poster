import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:photo_frame/Controller/PersonalInfoController.dart';
import 'package:photo_frame/Contstant/AppColor.dart';
import 'package:photo_frame/Contstant/Strings.dart';
import 'package:photo_frame/Widgets/MyTextField.dart';
import 'package:photo_frame/Widgets/show_messages.dart';

class PersonalInfo extends StatefulWidget {
  const PersonalInfo({super.key});

  @override
  State<PersonalInfo> createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<PersonalInfo> {
  final PersonalInfoController personalInfoController =
      Get.put(PersonalInfoController());

  @override
  void initState() {
    super.initState();
    personalInfoController.readData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimeryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Text(
                fillYourCardDetails,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 14,
              ),
              MyTextField(
                controller: personalInfoController.txtTitle,
                hint: companyTitle,
              ),
              const SizedBox(
                height: 14,
              ),
              MyTextField(
                controller: personalInfoController.txtSubTitle,
                hint: companySubTitle,
              ),
              const SizedBox(
                height: 14,
              ),
              MyTextField(
                controller: personalInfoController.txtLocation,
                hint: companyLocation,
              ),
              const SizedBox(
                height: 14,
              ),
              MyTextField(
                controller: personalInfoController.txtNumber,
                hint: contactNumber,
              ),
              const SizedBox(
                height: 14,
              ),
              MyTextField(
                controller: personalInfoController.txtWebsite,
                hint: websiteUrl,
              ),
              const SizedBox(
                height: 14,
              ),
              MyTextField(
                controller: personalInfoController.txtEmail,
                hint: email,
              ),
              const SizedBox(
                height: 14,
              ),
              MyTextField(
                controller: personalInfoController.txtName,
                hint: yourName,
              ),
              const SizedBox(
                height: 14,
              ),
              MyTextField(
                controller: personalInfoController.txtRole,
                hint: yourRole,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0, top: 30),
                child: ElevatedButton(
                  onPressed: () async {
                    if (personalInfoController.txtTitle.text.trim().isEmpty) {
                      ShowMessages()
                          .showSnackBar("Please enter your company title");

                      return;
                    }
                    if (personalInfoController.txtSubTitle.text
                        .trim()
                        .isEmpty) {
                      ShowMessages()
                          .showSnackBar("Please enter your company sub-title");
                      return;
                    }
                    if (personalInfoController.txtLocation.text
                        .trim()
                        .isEmpty) {
                      ShowMessages()
                          .showSnackBar("Please enter your company location");
                      return;
                    }
                    if (personalInfoController.txtNumber.text.trim().isEmpty) {
                      ShowMessages()
                          .showSnackBar("Please enter your contact number");
                      return;
                    }
                    if (personalInfoController.txtWebsite.text.trim().isEmpty) {
                      ShowMessages()
                          .showSnackBar("Please enter your website url");
                      return;
                    }
                    if (personalInfoController.txtEmail.text.trim().isEmpty) {
                      ShowMessages().showSnackBar("Please enter your email");
                      return;
                    }
                    if (personalInfoController.txtName.text.trim().isEmpty) {
                      ShowMessages().showSnackBar("Please enter your name");
                      return;
                    }
                    if (personalInfoController.txtRole.text.trim().isEmpty) {
                      ShowMessages().showSnackBar("Please enter your role");
                      return;
                    }
                    await personalInfoController.saveData();
                    Navigator.pop(context, true);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimeryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    saveDetails,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
