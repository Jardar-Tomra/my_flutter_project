import 'package:flutter/material.dart';
import 'package:my_flutter_project/datamodel/project.dart';
import 'package:my_flutter_project/project_tracker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_flutter_project/bloc/project_bloc.dart';
import 'package:my_flutter_project/extensions/date_time_formatting.dart';
import 'package:my_flutter_project/styles/app_text_styles.dart';

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
            child: InkWell(
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          updatedProject.icon,
                          size: 40,
                          color: isActive ? Colors.green : Colors.grey,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            updatedProject.title,
                            style: AppTextStyles.titleMedium,
                          ),
                        ),
                        if (isActive)
                          const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Total Donations: \$${updatedProject.getTotalDonations().toStringAsFixed(2)}',
                      style: AppTextStyles.bodyLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Duration: ${updatedProject.startDate.toLocal().toShortDateString()} - ${updatedProject.endDate.toLocal().toShortDateString()}',
                      style: AppTextStyles.bodySmall,
                    ),
                    if (isActive) ...[
                      const SizedBox(height: 16),
                      const Text(
                        'Donation Tracker:',
                        style: AppTextStyles.sectionHeader,
                      ),
                      const SizedBox(height: 8),
                      ProjectTracker.fromProject(updatedProject),
                    ],
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