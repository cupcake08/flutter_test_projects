import 'package:flutter/material.dart';

class ImageClipper extends CustomClipper<RRect> {
  @override
  RRect getClip(Size size) {
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTRB(0, 0, size.width, size.height * .7),
      const Radius.circular(30),
    );
    return rrect;
  }

  @override
  bool shouldReclip(covariant CustomClipper<RRect> oldClipper) {
    return true;
  }
}
