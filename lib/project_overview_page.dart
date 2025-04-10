import 'package:flutter/material.dart';
import 'project_tracker.dart'; // Import the ProjectTracker widget

class ProjectOverviewPage extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final String imageUrl; // Add an image URL field
  final double totalDonations = 0.0; // Example: Replace with actual data
  final List<String> donationDays = []; // Example: Replace with actual data
  final List<String> allDays = []; // Example: Replace with actual data

  ProjectOverviewPage({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.imageUrl, // Require the image URL
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display the image at the top
            Image.network(
              imageUrl,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Icon(icon, size: 48, color: Theme.of(context).primaryColor),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      title,
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
                description,
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
                  Text(
                    'Start Date: ${DateTime.now().toIso8601String().split('T').first}', // Replace with actual start date
                  ),
                  Text(
                    'End Date: ${DateTime.now().toIso8601String().split('T').first}', // Replace with actual end date
                  ),
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