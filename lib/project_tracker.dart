import 'package:flutter/material.dart';

class ProjectTracker extends StatelessWidget {
  final List<DateTime> allDays;
  final List<DateTime> donationDays;

  const ProjectTracker({
    super.key,
    required this.allDays,
    required this.donationDays,
  });

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
