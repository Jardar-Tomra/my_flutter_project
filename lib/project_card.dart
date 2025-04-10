import 'package:flutter/material.dart';
import 'package:my_flutter_project/datamodel/project.dart';
import 'package:my_flutter_project/project_tracker.dart';

class ProjectCard extends StatelessWidget {
  final Project project;
  final bool isActive;
  final double totalDonations;
  final VoidCallback onTap;

  const ProjectCard({
    super.key,
    required this.project,
    required this.isActive,
    required this.totalDonations,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Generate a list of donation days with their statuses
    final donationDays = project.donations.map((donation) => donation.day).toList();
    final allDays = List.generate(7, (index) {
      // Example: Generate 7 days starting from the project's start date
      final startDate = project.startDate;
      return startDate.add(Duration(days: index));
    });

    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: Icon(
          project.icon,
          color: isActive ? Colors.green : null, // Green icon for active projects
        ),
        title: Text(project.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total Donations: \$${totalDonations.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blue, // Highlighted in blue
              ),
            ),
            Text(
              'Start Date: ${project.startDate}',
            ),
            Text(
              'End Date: ${project.endDate}',
            ),
            if (isActive) ...[
              const SizedBox(height: 8),
              const Text(
                'Donation Tracker:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              ProjectTracker(
                allDays: allDays,
                donationDays: donationDays,
              ),
            ],
          ],
        ),
        trailing: isActive
            ? const Icon(Icons.check_circle, color: Colors.green) // Green check mark
            : null,
        onTap: onTap,
      ),
    );
  }
}