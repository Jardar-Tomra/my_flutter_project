import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_flutter_project/bloc/project.dart';
import 'package:my_flutter_project/datamodel/donation_entity.dart';
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
      onPressed: () {
        context.donate(project.id, 10.0);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Thank you for your donation!'),
          ),
        );
      },
      child: const Text('Donate Now'),
    );
  }
}
