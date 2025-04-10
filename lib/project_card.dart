import 'package:flutter/material.dart';
import 'package:my_flutter_project/datamodel/project.dart';
import 'package:my_flutter_project/project_tracker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_flutter_project/bloc/project_bloc.dart';

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
    return BlocBuilder<ProjectBloc, ProjectState>(
      builder: (context, state) {
      print("updated project card: ${state}");
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
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
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
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Duration: ${updatedProject.startDate.toLocal().toShortDateString()} - ${updatedProject.endDate.toLocal().toShortDateString()}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                  if (isActive) ...[
                    const SizedBox(height: 16),
                    const Text(
                      'Donation Tracker:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
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
    );
  }
}

extension DateTimeFormatting on DateTime {
  String toShortDateString() {
    return '${this.year}-${this.month.toString().padLeft(2, '0')}-${this.day.toString().padLeft(2, '0')}';
  }
}