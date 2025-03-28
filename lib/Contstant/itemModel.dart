import 'dart:ui';

class Item {
  Size size;
  Offset offset;
  double rotation;
  var parentKey;
  String text;
  Color textColor;
  double fontSize;
  FontWeight fontWeight;
  TextDecoration textDecoration;
  FontStyle fontStyle;
  String selectTitle;

  Item({
    required this.parentKey,
    required this.size,
    required this.offset,
    required this.rotation,
    required this.text,
    required this.textColor,
    required this.fontSize,
    required this.fontWeight,
    required this.textDecoration,
    required this.fontStyle,
    required this.selectTitle,
  });
}
