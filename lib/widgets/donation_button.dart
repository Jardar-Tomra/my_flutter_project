import 'package:caritas_donation_app/datamodel/project_day_entity.dart';
import 'package:flutter/material.dart';
import 'package:caritas_donation_app/bloc/project.dart';
import '../bloc/project_bloc.dart';
import '../styles/button_styles.dart'; // Import the reusable button styles

class DonationButton extends StatelessWidget {
  final Project project;
  final double amount; // Default donation amount
  final String donator; // Name of the participant donating
  final ProjectDayEntity dayEntity;

  const DonationButton({
    super.key,
    required this.project,
    required this.amount,
    required this.donator, // Add participantName
    required this.dayEntity, 
  });

  @override
  Widget build(BuildContext context) {
    final hasDonatedToday = project.hasDonatedForDayBy(dayEntity, donator); // Check if the participant has donated today

    if (hasDonatedToday) {
      return Row(
        children: [
          const Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 20.0, // Checkmark icon
          ),
          const SizedBox(width: 8.0),
          Text(
            '$donator has donated today.',
            style: const TextStyle(
              fontSize: 14,
            ),
          ),
        ],
      );
    }

    return ElevatedButton(
      style: ButtonStyles.primaryButtonStyle, // Use the reusable button style
      onPressed: () {
        context.donate(project.id, amount, donator); // Pass the participant name to the donate method

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Thank you, $donator, for your donation!'),
          ),
        );
      },
      child: Text(
        'Donate \$${amount.toStringAsFixed(0)} - $donator',
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white, // Text color
        ),
      ),
    );
  }
}
