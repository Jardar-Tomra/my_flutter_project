import 'package:flutter/material.dart';
import 'package:caritas_donation_app/bloc/project.dart';

class ProjectDonationTracker extends StatelessWidget {
  final List<DateTime> allDays;
  final List<DateTime> donationDays;

  const ProjectDonationTracker({
    super.key,
    required this.allDays,
    required this.donationDays,
  });

  factory ProjectDonationTracker.fromProject(Project project) {
    final allDays = List.generate(7, (index) {
      final startDate = project.startDate;
      return startDate.add(Duration(days: index));
    });

    final donationDays = project.donations().map((donation) => donation.date).toList();

    return ProjectDonationTracker(
      allDays: allDays,
      donationDays: donationDays,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: allDays.map((day) {
        final isDonated = donationDays.contains(day);
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: CircleAvatar(
            radius: 6, // Small dot size
            backgroundColor: isDonated ? Colors.green : Colors.grey,
          ),
        );
      }).toList(),
    );
  }
}
