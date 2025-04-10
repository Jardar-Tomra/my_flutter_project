import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/project_bloc.dart';
import 'bloc/user_bloc.dart';
import 'datamodel/project.dart';
import 'project_overview_page.dart'; // Import the project overview page
import 'project_tracker.dart'; // Import the ProjectTracker widget

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => ProjectBloc()..add(LoadProjects())),
          BlocProvider(create: (_) => UserBloc()..add(LoadUsers())),
        ],
        child: BlocBuilder<UserBloc, UserState>(
          builder: (context, userState) {
            if (userState is UserLoaded) {
              final activeUser = userState.activeUser;

              return BlocBuilder<ProjectBloc, ProjectState>(
                builder: (context, projectState) {
                  if (projectState is ProjectLoaded) {
                    final sortedProjects = [
                      ...projectState.projects.where((project) => activeUser.activeProjects.contains(project.title)),
                      ...projectState.projects.where((project) => !activeUser.activeProjects.contains(project.title)),
                    ];

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            'Welcome, ${activeUser.name}!',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Divider(),
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
                                        project: project,
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
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