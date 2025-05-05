import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PersonalInfoController extends GetxController {
  final TextEditingController txtTitle = TextEditingController();
  final TextEditingController txtSubTitle = TextEditingController();
  final TextEditingController txtLocation = TextEditingController();
  final TextEditingController txtNumber = TextEditingController();
  final TextEditingController txtWebsite = TextEditingController();
  final TextEditingController txtEmail = TextEditingController();
  final TextEditingController txtName = TextEditingController();
  final TextEditingController txtRole = TextEditingController();

  Future<void> saveData() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();

    await preferences.setString('company_title', txtTitle.text.trim());
    await preferences.setString('company_sub_title', txtSubTitle.text.trim());
    await preferences.setString('location', txtLocation.text.trim());
    await preferences.setString('number', txtNumber.text.trim());
    await preferences.setString('website', txtWebsite.text.trim());
    await preferences.setString('email', txtEmail.text.trim());
    await preferences.setString('name', txtName.text.trim());
    await preferences.setString('role', txtRole.text.trim());
  }

  Future<void> readData() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    txtTitle.text = preferences.getString('company_title') ?? "";
    txtSubTitle.text = preferences.getString('company_sub_title') ?? "";
    txtLocation.text = preferences.getString('location') ?? "";
    txtNumber.text = preferences.getString('number') ?? "";
    txtWebsite.text = preferences.getString('website') ?? "";
    txtEmail.text = preferences.getString('email') ?? "";
    txtName.text = preferences.getString('name') ?? "";
    txtRole.text = preferences.getString('role') ?? "";
  }
}
