import 'dart:convert';

CardModel cardModelFromJson(String str) => CardModel.fromJson(json.decode(str));

String cardModelToJson(CardModel data) => json.encode(data.toJson());

class CardModel {
  final String coverImage;
  final String frontImageDemo;
  final String backImageDemo;
  final String frontImage;
  final String backImage;
  final Property frontTitleProperty;
  final Property frontSubTitleProperty;
  final Property titleProperty;
  final Property subTitleProperty;
  final Property locationProperty;
  final Property contactProperty;
  final Property emailProperty;
  final Property websiteProperty;
  final Property nameProperty;
  final Property roleProperty;

  CardModel({
    required this.frontSubTitleProperty,
    required this.frontTitleProperty,
    required this.coverImage,
    required this.frontImageDemo,
    required this.backImageDemo,
    required this.frontImage,
    required this.backImage,
    required this.titleProperty,
    required this.subTitleProperty,
    required this.locationProperty,
    required this.contactProperty,
    required this.emailProperty,
    required this.websiteProperty,
    required this.nameProperty,
    required this.roleProperty,
  });

  factory CardModel.fromJson(Map json) => CardModel(
        coverImage: json["coverImage"] ?? "",
        frontImageDemo: json["frontImageDemo"] ?? "",
        backImageDemo: json["backImageDemo"] ?? "",
        frontImage: json["frontImage"],
        backImage: json["backImage"],
        frontSubTitleProperty: Property.fromJson(json["frontSubTitleProperty"]),
        frontTitleProperty: Property.fromJson(json["frontTitleProperty"]),
        titleProperty: Property.fromJson(json["titleProperty"]),
        subTitleProperty: Property.fromJson(json["subTitleProperty"]),
        locationProperty: Property.fromJson(json["locationProperty"]),
        contactProperty: Property.fromJson(json["contactProperty"]),
        emailProperty: Property.fromJson(json["emailProperty"]),
        websiteProperty: Property.fromJson(json["websiteProperty"]),
        nameProperty: Property.fromJson(json["nameProperty"]),
        roleProperty: Property.fromJson(json["roleProperty"]),
      );

  Map<String, dynamic> toJson() => {
        "coverImage": coverImage,
        "frontImageDemo": frontImageDemo,
        "backImageDemo": backImageDemo,
        "frontImage": frontImage,
        "backImage": backImage,
        "frontTitleProperty": frontTitleProperty.toJson(),
        "frontSubTitleProperty": frontSubTitleProperty.toJson(),
        "nameProperty": frontTitleProperty.toJson(),
        "roleProperty": frontSubTitleProperty.toJson(),
        "titleProperty": titleProperty.toJson(),
        "subTitleProperty": subTitleProperty.toJson(),
        "locationProperty": locationProperty.toJson(),
        "contactProperty": contactProperty.toJson(),
        "emailProperty": emailProperty.toJson(),
        "websiteProperty": websiteProperty.toJson(),
      };
}

class Property {
  final MyOffset offset;
  final ContainerProperty containerProperty;
  final TextProperty textProperty;

  Property({
    required this.offset,
    required this.containerProperty,
    required this.textProperty,
  });

  factory Property.fromJson(Map<String, dynamic> json) => Property(
        offset: MyOffset.fromJson(json["offset"]),
        containerProperty:
            ContainerProperty.fromJson(json["containerProperty"]),
        textProperty: TextProperty.fromJson(json["textProperty"]),
      );

  Map<String, dynamic> toJson() => {
        "offset": offset.toJson(),
        "containerProperty": containerProperty.toJson(),
        "textProperty": textProperty.toJson(),
      };
}

class ContainerProperty {
  final double height;
  final double width;
  final String alignment;

  ContainerProperty({
    required this.height,
    required this.width,
    required this.alignment,
  });

  factory ContainerProperty.fromJson(Map<String, dynamic> json) =>
      ContainerProperty(
        height: json["height"].toDouble(),
        width: json["width"].toDouble(),
        alignment: json["alignment"],
      );

  Map<String, dynamic> toJson() => {
        "height": height,
        "width": width,
        "alignment": alignment,
      };
}

class MyOffset {
  final double dx;
  final double dy;

  MyOffset({
    required this.dx,
    required this.dy,
  });

  factory MyOffset.fromJson(Map<String, dynamic> json) => MyOffset(
        dx: json["dx"].toDouble(),
        dy: json["dy"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "dx": dx,
        "dy": dy,
      };
}

class TextProperty {
  final String textStyle;
  final double fontSize;
  final String? fontWeight;
  final int color;

  TextProperty({
    required this.textStyle,
    required this.fontSize,
    required this.fontWeight,
    required this.color,
  });

  factory TextProperty.fromJson(Map<String, dynamic> json) => TextProperty(
        color: json["color"],
        textStyle: json["textStyle"],
        fontSize: json["fontSize"].toDouble(),
        fontWeight: json["fontWeight"],
      );

  Map<String, dynamic> toJson() => {
        "textStyle": textStyle,
        "fontSize": fontSize,
        "fontWeight": fontWeight,
        "color": color,
      };
}
