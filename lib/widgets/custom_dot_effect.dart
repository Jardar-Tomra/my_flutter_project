import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class CustomDotEffect extends WormEffect {
  final Color Function(int index) getColor;

  CustomDotEffect({
    required this.getColor,
    double dotHeight = 8.0,
    double dotWidth = 8.0,
    double spacing = 8.0,
  }) : super(
          dotHeight: dotHeight,
          dotWidth: dotWidth,
          spacing: spacing,
        );

  @override
  void paint(Canvas canvas, Size size, int count, double offset, Paint paint) {
    for (int i = 0; i < count; i++) {
      paint.color = getColor(i); // Set color based on the card
      final double xPos = i * (dotWidth + spacing);
      final double yPos = size.height / 2;
      canvas.drawCircle(Offset(xPos, yPos), dotWidth / 2, paint);
    }
  }
}
