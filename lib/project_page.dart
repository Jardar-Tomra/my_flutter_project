import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_flutter_project/extensions/date_time_formatting.dart';
import 'package:my_flutter_project/styles/app_text_styles.dart';
import 'datamodel/project.dart';
import 'project_tracker.dart'; // Import the ProjectTracker widget
import '../bloc/project_bloc.dart';
import '../widgets/donation_button.dart';

class ProjectPage extends StatelessWidget {
  final Project project;

  const ProjectPage({
    super.key,
    required this.project,
  });

  void _save(BuildContext context, Project updatedProject) {
    final bloc = context.read<ProjectBloc>();
    bloc.add(RefreshProjects());
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectBloc, ProjectState>(      builder: (context, state) {
        final currentProject = state is ProjectUpdatedState ? state.project : project;

        return WillPopScope(
          onWillPop: () => Future(() {
            print("Is popping back");
            _save(context, currentProject);
            return true;
          }),
          child: Scaffold(
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
                            style: AppTextStyles.titleLarge,
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
                      style: AppTextStyles.bodyMedium,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Donations: \$${currentProject.getTotalDonations().toStringAsFixed(2)}',
                          style: AppTextStyles.bodyLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Duration: ${currentProject.startDate.toLocal().toShortDateString()} - ${currentProject.endDate.toLocal().toShortDateString()}',
                          style: AppTextStyles.bodySmall,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Donation Tracker:',
                          style: AppTextStyles.sectionHeader,
                        ),
                        const SizedBox(height: 8),
                        BlocBuilder<ProjectBloc, ProjectState>(
                          builder: (context, state) {
                            final updatedProject = state is ProjectUpdatedState ? state.project : currentProject;
                
                            if (updatedProject.donations.isEmpty) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'No donations have been made yet.',
                                    style: AppTextStyles.italicGrey,
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
          ),
        );
      },
    );
  }
}