import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'datamodel/project.dart';
import 'project_tracker.dart'; // Import the ProjectTracker widget
import '../bloc/project_bloc.dart';
import '../widgets/donation_button.dart';

class ProjectOverviewPage extends StatelessWidget {
  final Project project;

  const ProjectOverviewPage({
    super.key,
    required this.project,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProjectBloc([project]),
      child: BlocBuilder<ProjectBloc, ProjectState>(
        builder: (context, state) {
          final currentProject = state is ProjectUpdatedState ? state.project : project;

          final totalDonations = currentProject.donations.length.toDouble();

          return Scaffold(
            appBar: AppBar(
              title: Text(currentProject.title),
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Display the image at the top
                  Image.network(
                    currentProject.imageUrl,
                    width: double.infinity,
                    height: 300,
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        Icon(currentProject.icon, size: 48, color: Theme.of(context).primaryColor),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            currentProject.title,
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
                      currentProject.description,
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
                        Text('Start Date: ${currentProject.startDate}'),
                        Text('End Date: ${currentProject.endDate}'),
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
                        BlocBuilder<ProjectBloc, ProjectState>(
                          builder: (context, state) {
                            final updatedProject = state is ProjectUpdatedState ? state.project : currentProject;

                            if (updatedProject.donations.isEmpty) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'No donations have been made yet.',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  DonationButton(
                                    projectId: updatedProject.id,
                                    amount: 50.0, // Example amount
                                    donations: updatedProject.donations,
                                  ),
                                ],
                              );
                            }

                            return ProjectTracker.fromProject(updatedProject);
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: DonationButton(
                      projectId: currentProject.id,
                      amount: 50.0, // Example amount
                      donations: currentProject.donations,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}