import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_flutter_project/datamodel/donation_entity.dart';
import '../bloc/project_bloc.dart';

class DonationButton extends StatelessWidget {
  final String projectId;
  final double amount;
  final List<DonationEntity> donations;

  const DonationButton({
    super.key,
    required this.projectId,
    required this.amount,
    required this.donations,
  });

  bool _hasDonatedToday() {
    final today = DateTime.now();
    return donations.any((donation) =>
        donation.date.year == today.year &&
        donation.date.month == today.month &&
        donation.date.day == today.day);
  }

  @override
  Widget build(BuildContext context) {
    final hasDonatedToday = _hasDonatedToday();

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
        context.read<ProjectBloc>().add(
              AddDonationEvent(
                projectId: projectId,
                amount: amount,
              ),
            );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Thank you for your donation!'),
          ),
        );

        // Trigger a state update to refresh the UI
        context.read<ProjectBloc>().add(
              AddDonationEvent(
                projectId: projectId,
                amount: amount,
              ),
            );
      },
      child: const Text('Donate Now'),
    );
  }
}
