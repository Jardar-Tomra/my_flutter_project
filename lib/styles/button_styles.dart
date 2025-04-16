import 'package:flutter/material.dart';

class ButtonStyles {
  static final ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(25.0), // Rounded corners
    ),
    backgroundColor: Colors.blueAccent, // Button background color
    elevation: 5.0, // Shadow effect
  );

  static var secondaryButtonStyle =ElevatedButton.styleFrom(
    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(25.0), // Rounded corners
    ),
    backgroundColor: Colors.redAccent, // Button background color
    elevation: 5.0, // Shadow effect
  );
}
