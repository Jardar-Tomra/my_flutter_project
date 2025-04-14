import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ColoredWormEffect extends CustomizableEffect {


  final Color Function(int index) getColor;

  ColoredWormEffect.ColoredWormEffect({
    required this.getColor,
    double offset = 16.0,
    double dotWidth = 16.0,
    double dotHeight = 16.0,
    double spacing = 8.0,
    double radius = 16,
    Color dotColor = Colors.grey,
    Color activeDotColor = Colors.indigo,
    double strokeWidth = 1.0,
    PaintingStyle paintStyle = PaintingStyle.fill
  }) : super(
      activeDotDecoration: DotDecoration(height: dotHeight, width: dotWidth, color: activeDotColor, borderRadius: BorderRadius.all(Radius.circular(radius)),),
      dotDecoration: DotDecoration(height: dotHeight, width: dotWidth, color: dotColor, borderRadius: BorderRadius.all(Radius.circular(radius)),),  
      inActiveColorOverride: (index) => getColor(index),
      spacing: spacing
    );
}