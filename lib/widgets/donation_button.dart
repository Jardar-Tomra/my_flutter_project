import 'package:flutter/material.dart';
import 'package:caritas_donation_app/bloc/project.dart';
import '../bloc/project_bloc.dart';
import '../styles/button_styles.dart'; // Import the reusable button styles

class DonationButton extends StatelessWidget {
  final Project project;
  final double amount; // Default donation amount
  final String participantName; // Name of the participant donating

  const DonationButton({
    super.key,
    required this.project,
    required this.amount,
    required this.participantName, // Add participantName
  });

  @override
  Widget build(BuildContext context) {
    final hasDonatedToday = project.hasDonatedToday();

    if (hasDonatedToday) {
      return Text(
        '$participantName has already donated today. Thank you!',
        style: const TextStyle(
          fontSize: 14,
          fontStyle: FontStyle.italic,
          color: Colors.grey,
        ),
      );
    }

    return ElevatedButton(
      style: ButtonStyles.primaryButtonStyle, // Use the reusable button style
      onPressed: () {
        context.donate(project.id, amount, participantName); // Pass the participant name to the donate method

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Thank you, $participantName, for your donation!'),
          ),
        );
      },
      child: Text(
        'Donate \$${amount.toStringAsFixed(0)} - $participantName',
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white, // Text color
        ),
      ),
    );
  }
}
