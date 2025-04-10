import 'package:flutter/material.dart';
import 'datamodel/project.dart';
import 'project_tracker.dart'; // Import the ProjectTracker widget

class ProjectOverviewPage extends StatelessWidget {
  final Project project;

  const ProjectOverviewPage({
    super.key,
    required this.project,
  });

  @override
  Widget build(BuildContext context) {
    final totalDonations = project.donations.length.toDouble(); // Example: Replace with actual logic
    final donationDays = project.donations.map((donation) => donation.day).toList();
    final allDays = List.generate(7, (index) {
      final startDate = project.startDate;
      return startDate.add(Duration(days: index)).toIso8601String().split('T').first;
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(project.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display the image at the top
            Image.network(
              project.imageUrl,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Icon(project.icon, size: 48, color: Theme.of(context).primaryColor),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      project.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                project.description,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Project Summary:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('Start Date: ${project.startDate}'),
                  Text('End Date: ${project.endDate}'),
                  Text(
                    'Total Donations: \$${totalDonations.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
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
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  // Add donation functionality here
                },
                child: const Text('Donate Now'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}