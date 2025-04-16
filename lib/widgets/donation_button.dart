import 'package:flutter/material.dart';
import 'package:caritas_donation_app/bloc/project.dart';
import '../bloc/project_bloc.dart';
import '../styles/button_styles.dart'; // Import the reusable button styles

class DonationButton extends StatelessWidget {
  final Project project;
  final double amount; // Default donation amount

  const DonationButton({
    super.key,
    required this.project,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    final hasDonatedToday = project.hasDonatedToday();

    if (hasDonatedToday) {
      return const Text(
        'You have already donated today. Thank you!',
        style: TextStyle(
          fontSize: 14,
          fontStyle: FontStyle.italic,
          color: Colors.grey,
        ),
      );
    }

    return ElevatedButton(
      style: ButtonStyles.primaryButtonStyle, // Use the reusable button style
      onPressed: () {
        context.donate(project.id, amount);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Thank you for your donation!'),
          ),
        );
      },
      child: Text(
        'Donate \$${amount.toStringAsFixed(0)}',
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white, // Text color
        ),
      ),
    );
  }
}
