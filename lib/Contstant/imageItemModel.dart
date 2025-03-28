import 'dart:ui';

class ImageItem {
  var parentKey;
  Size size;
  Offset offset;
  double imageRotation;
  String image;
  double imageSize;
  ImageItem({
    required this.parentKey,
    required this.size,
    required this.offset,
    required this.imageRotation,
    required this.image,
    required this.imageSize,
  });
}
