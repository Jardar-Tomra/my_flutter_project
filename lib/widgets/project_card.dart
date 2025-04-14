import 'package:flutter/material.dart';
import 'package:my_flutter_project/bloc/project.dart';
import 'package:my_flutter_project/bloc/user_bloc.dart';
import 'package:my_flutter_project/widgets/date_badge.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_flutter_project/bloc/project_bloc.dart';
import 'package:my_flutter_project/styles/app_text_styles.dart';
import 'package:my_flutter_project/widgets/money_badge.dart'; // Import MoneyBadge

class ProjectCard extends StatelessWidget {
  final Project project;
  final VoidCallback onTap;

  const ProjectCard({
    super.key,
    required this.project,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Ensure the ProjectBloc is available in the widget tree
    return BlocProvider.value(
      value: BlocProvider.of<ProjectBloc>(context),
      child: BlocBuilder<ProjectBloc, ProjectState>(
        buildWhen: (previous, current) {
          // Rebuild only if the project with the same ID is updated
          return current is ProjectUpdatedState && current.project.id == project.id;
        },
        builder: (context, state) {
          final updatedProject = state is ProjectUpdatedState && state.project.id == project.id
              ? state.project
              : project;

          return Card(
            margin: const EdgeInsets.all(8.0),
            color: project.isAssigned() ? Colors.green.shade100 : Colors.blue.shade50, // Green for active projects
            child: InkWell(
              onTap: project.isAssigned()
                  ? onTap // Allow navigation only if the project is assigned
                  : null,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                updatedProject.title,
                                style: AppTextStyles.titleMedium,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                updatedProject.description,
                                style: AppTextStyles.bodyMedium,
                              ),
                              const SizedBox(height: 16),
                              if (!project.isAssigned()) // Show "Participate" button for inactive projects
                                ElevatedButton(
                                  onPressed: () {
                                    // Logic to start participating in the project
                                    context.activate(updatedProject.id);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blueAccent, // Match Donate button color
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10.0,
                                      horizontal: 20.0,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                  child: const Text(
                                    'Participate',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white, // Text color
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              DateBadge(
                                startDate: updatedProject.startDate,
                                endDate: updatedProject.endDate,
                                size: BadgeSize.small,
                              ),
                              const SizedBox(height: 16),
                              MoneyBadge(
                                amount: updatedProject.totalDonations(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}