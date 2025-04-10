import 'package:flutter/material.dart';
import 'project_data.dart';
import 'project_overview_page.dart'; // Import the project overview page
import 'user_data.dart'; // Import user data

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    // Assume the first user is the active user
    final activeUser = users.first;

    // Sort projects: active projects first
    final sortedProjects = [
      ...projectData.where((project) => activeUser.activeProjects.contains(project.title)),
      ...projectData.where((project) => !activeUser.activeProjects.contains(project.title)),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Display active user information
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome, ${activeUser.name}!',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          // Display the sorted list of projects
          Expanded(
            child: ListView.builder(
              itemCount: sortedProjects.length,
              itemBuilder: (context, index) {
                final project = sortedProjects[index];
                final isActive = activeUser.activeProjects.contains(project.title);
                final totalDonations = activeUser.totalDonationsPerProject[project.title] ?? 0.0;

                return ProjectCard(
                  project: project,
                  isActive: isActive,
                  totalDonations: totalDonations,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProjectOverviewPage(
                          title: project.title,
                          description: project.description,
                          icon: project.icon,
                          imageUrl: project.imageUrl,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

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
      final startDate = DateTime.parse(project.startDate);
      return startDate.add(Duration(days: index)).toIso8601String().split('T').first;
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
              Row(
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