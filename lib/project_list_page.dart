import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'datamodel/project.dart';
import 'bloc/project_bloc.dart';
import 'project_card.dart';

class ProjectListPage extends StatelessWidget {
  final List<Project> projects;

  const ProjectListPage({super.key, required this.projects});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectBloc, ProjectState>(
      builder: (context, state) {
        final updatedProjects = state is ProjectUpdatedState
            ? projects.map((project) => project.id == state.project.id ? state.project : project).toList()
            : projects;

        return ListView.builder(
          itemCount: updatedProjects.length,
          itemBuilder: (context, index) {
            final project = updatedProjects[index];
            return ProjectCard(
              project: project,
              isActive: DateTime.now().isBefore(project.endDate),
              totalDonations: project.donations.fold(0, (sum, donation) => sum + donation.amount),
              onTap: () {
                // Navigate to project details or perform another action
              },
            );
          },
        );
      },
    );
  }
}
