import 'package:flutter/material.dart';

class EditableTextItem {
  String text;
  Offset position;
  double fontSize;
  double rotation;
  bool isEditing;
  final Color color;
  final FontWeight fontWeight;
  final TextDecoration textDecoration;
  final FontStyle fontStyle;
  final String fontFamily;

  EditableTextItem({
    required this.text,
    required this.position,
    required this.fontSize,
    required this.rotation,
    this.isEditing = false,
    required this.color,
    required this.fontWeight,
    required this.textDecoration,
    required this.fontStyle,
    required this.fontFamily,
  });

  EditableTextItem copyWith({
    String? text,
    Offset? position,
    double? fontSize,
    double? rotation,
    bool? isEditing,
    Color? color,
    FontWeight? fontWeight,
    TextDecoration? textDecoration,
    FontStyle? fontStyle,
    String? fontFamily,
  }) {
    return EditableTextItem(
      text: text ?? this.text,
      position: position ?? this.position,
      fontSize: fontSize ?? this.fontSize,
      rotation: rotation ?? this.rotation,
      isEditing: isEditing ?? this.isEditing,
      color: color ?? this.color,
      fontWeight: fontWeight ?? this.fontWeight,
      textDecoration: textDecoration ?? this.textDecoration,
      fontStyle: fontStyle ?? this.fontStyle,
      fontFamily: fontFamily ?? this.fontFamily,
    );
  }
}