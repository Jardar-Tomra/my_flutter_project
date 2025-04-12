import 'package:flutter/material.dart';
import 'package:my_flutter_project/bloc/project.dart';
import '../bloc/project_bloc.dart';

class DonationButton extends StatelessWidget {
  final Project project;
  final double amount; // Default donation amount

  const DonationButton({
    super.key,
    required this.project,
    this.amount = 10.0,
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
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0), // Rounded corners
        ),
        backgroundColor: Colors.blueAccent, // Button background color
        elevation: 5.0, // Shadow effect
      ),
      onPressed: () {
        context.donate(project.id, 10.0);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Thank you for your donation!'),
          ),
        );
      },
      child: const Text(
        'Donate Now',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white, // Text color
        ),
      ),
    );
  }
}
