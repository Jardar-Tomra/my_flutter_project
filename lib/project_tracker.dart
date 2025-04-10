import 'dart:math';

import 'package:flutter/material.dart';
import 'datamodel/project.dart';

class ProjectTracker extends StatelessWidget {
  final List<DateTime> allDays;
  final List<DateTime> donationDays;

  const ProjectTracker({
    super.key,
    required this.allDays,
    required this.donationDays,
  });

  factory ProjectTracker.fromProject(Project project) {
    final allDays = List.generate(7, (index) {
      final startDate = project.startDate;
      return startDate.add(Duration(days: index));
    });

    final donationDays = project.donations.map((donation) => donation.day).toList();

    return ProjectTracker(
      allDays: allDays,
      donationDays: donationDays,
    );
  }

  @override
  Widget build(BuildContext context) {
    print("updated project tracker");
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
