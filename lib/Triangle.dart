import 'dart:ui';

import 'package:flutter_drawing_board/paint_contents.dart';

class Triangle extends PaintContent {
  Triangle();

  Triangle.data({
    required this.startPoint,
    required this.A,
    required this.B,
    required this.C,
    required Paint paint,
  }) : super.paint(paint);

  Offset startPoint = Offset.zero;
  Offset A = Offset.zero;
  Offset B = Offset.zero;
  Offset C = Offset.zero;

  String get contentType => 'Triangle';

  @override
  void draw(Canvas canvas, Size size, bool deeper) {
    final Path path = Path()
      ..moveTo(A.dx, A.dy)
      ..lineTo(B.dx, B.dy)
      ..lineTo(C.dx, C.dy)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'startPoint': startPoint.toJson(),
      'A': A.toJson(),
      'B': B.toJson(),
      'C': C.toJson(),
      'paint': paint.toJson(),
    };
  }

  static Triangle fromJson(Map<String, dynamic> json) {
    return Triangle.data(
      startPoint: OffsetJson.fromJson(json['startPoint']),
      A: OffsetJson.fromJson(json['A']),
      B: OffsetJson.fromJson(json['B']),
      C: OffsetJson.fromJson(json['C']),
      paint: Paint()..color = Color(json['paint']['color']),
    );
  }

  @override
  PaintContent copy() {
    return Triangle.data(
      startPoint: startPoint,
      A: A,
      B: B,
      C: C,
      paint: paint,
    );
  }

  @override
  void startDraw(Offset startPoint) {
    this.startPoint = startPoint;
    double height = 100;
    A = startPoint;
    B = Offset(startPoint.dx + 50, startPoint.dy + height);
    C = Offset(startPoint.dx - 50, startPoint.dy + height);
  }

  @override
  void drawing(Offset nowPoint) {
    double height = nowPoint.dy - startPoint.dy;
    B = Offset(startPoint.dx + 50, startPoint.dy + height);
    C = Offset(startPoint.dx - 50, startPoint.dy + height);
  }

  @override
  Map<String, dynamic> toContentJson() {
    return {
      'startPoint': startPoint.toJson(),
      'A': A.toJson(),
      'B': B.toJson(),
      'C': C.toJson(),
      'paint': paint.toJson(),
    };
  }
}

extension OffsetJson on Offset {
  Map<String, double> toJson() {
    return {
      'dx': dx,
      'dy': dy,
    };
  }

  static Offset fromJson(Map<String, double> json) {
    return Offset(json['dx']!, json['dy']!);
  }
}

extension PaintJson on Paint {
  Map<String, dynamic> toJson() {
    return {
      'color': color.value,
    };
  }
}
