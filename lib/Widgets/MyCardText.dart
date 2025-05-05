import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:photo_frame/model/card_model.dart';

class MyCardText extends StatelessWidget {
  final Property data;
  final String text;
  const MyCardText({super.key, required this.data, required this.text});

  Offset getOffset({required MyOffset offset}) {
    return Offset(offset.dx, offset.dy);
  }

  Alignment getAlignment({required String alignment}) {
    switch (alignment) {
      case 'center':
        return Alignment.center;
      case 'centerLeft':
        return Alignment.centerLeft;
      case 'centerRight':
        return Alignment.centerRight;
      case 'topCenter':
        return Alignment.topCenter;
      case 'topLeft':
        return Alignment.topLeft;
      case 'topRight':
        return Alignment.topRight;
      case 'bottomCenter':
        return Alignment.bottomCenter;
      case 'bottomLeft':
        return Alignment.bottomLeft;
      case 'bottomRight':
        return Alignment.bottomRight;
      default:
        return Alignment.centerLeft;
    }
  }

  TextStyle getTextStyle(
      {required double fontSize,
      required String fontStyle,
      required String? fontWeight,
      required int color}) {
    log('text style ••••••••••••••••  $fontStyle');
    return GoogleFonts.getFont(
      fontStyle,
      fontSize: fontSize,
      color: Color(color),
      fontWeight: getFontWeight(fontWeight: fontWeight),
    );
  }

  FontWeight? getFontWeight({required String? fontWeight}) {
    switch (fontWeight) {
      case null:
        return null;
      case 'w100':
        return FontWeight.w100;
      case 'w200':
        return FontWeight.w200;
      case 'w300':
        return FontWeight.w300;
      case 'w400':
        return FontWeight.w400;
      case 'w500':
        return FontWeight.w500;
      case 'w600':
        return FontWeight.w600;
      case 'w700':
        return FontWeight.w700;
      case 'w800':
        return FontWeight.w800;
      case 'w900':
        return FontWeight.w900;
      case 'normal':
        return FontWeight.normal;
      case 'bold':
        return FontWeight.bold;
      default:
    }
    return FontWeight.bold;
  }

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: getOffset(offset: data.offset),
      child: SizedBox(
        width: data.containerProperty.width,
        height: data.containerProperty.height,
        child: Align(
          alignment: getAlignment(alignment: data.containerProperty.alignment),
          child: Text(
            text,
            overflow: TextOverflow.ellipsis,
            style: getTextStyle(
                color: data.textProperty.color,
                fontSize: data.textProperty.fontSize,
                fontStyle: data.textProperty.textStyle,
                fontWeight: data.textProperty.fontWeight),
          ),
        ),
      ),
    );
  }
}
