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
  String fontFamily;
  bool isStrokeCheck;
  double strokeWidth;
  Color forgroundColor;
  Color backgroundColor;

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
    required this.fontFamily,
    required this.isStrokeCheck,
    required this.strokeWidth,
    required this.forgroundColor,
    required this.backgroundColor,
  });
}
