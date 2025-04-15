import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:my_flutter_project/bloc/aggregated_project_bloc.dart';
import 'package:my_flutter_project/bloc/bloc_factory.dart';
import 'package:my_flutter_project/bloc/project.dart';
import 'package:my_flutter_project/bloc/user_bloc.dart';
import 'package:my_flutter_project/datamodel/repository.dart';
import 'package:my_flutter_project/widgets/date_badge.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_flutter_project/bloc/project_bloc.dart';
import 'package:my_flutter_project/styles/app_text_styles.dart';
import 'package:my_flutter_project/widgets/money_badge.dart'; // Import MoneyBadge
import 'package:my_flutter_project/pages/setup_participation_page.dart';

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

          final isAssigned = project.isAssigned();
          final totalDonations = project.totalDonations();

          return BlocProvider(
            create: (context) {
              print("Creating AggregatedProjectBloc for project ID: ${project.id}");
              return GetIt.instance<BlocFactory>().createAggregatedProjectBloc(project.id);
            },
            child: Card(
              margin: const EdgeInsets.all(8.0),
              color: isAssigned ? Colors.green.shade100 : Colors.blue.shade50, // Green for active projects
              child: InkWell(
                onTap: isAssigned
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
                                if (!isAssigned) // Show "Participate" button for inactive projects
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => SetupParticipationPage(project: updatedProject,),
                                        ),
                                      );
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
                                BlocBuilder<AggregatedProjectBloc, AggregatedProjectState>(
                                  builder: (context, state) {
                                    return MoneyBadge(
                                      amountForAll: state.totalDonations,
                                      amount: totalDonations,
                                    );
                                  },
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
            ),
          );
        },
      ),
    );
  }
}