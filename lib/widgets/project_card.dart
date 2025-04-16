import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:caritas_donation_app/bloc/aggregated_project_bloc.dart';
import 'package:caritas_donation_app/bloc/bloc_factory.dart';
import 'package:caritas_donation_app/bloc/project.dart';
import 'package:caritas_donation_app/styles/button_styles.dart';
import 'package:caritas_donation_app/widgets/date_badge.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:caritas_donation_app/bloc/project_bloc.dart';
import 'package:caritas_donation_app/styles/app_text_styles.dart';
import 'package:caritas_donation_app/widgets/money_badge.dart'; // Import MoneyBadge
import 'package:caritas_donation_app/pages/setup_participation_page.dart';

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
                                    style: ButtonStyles.primaryButtonStyle,
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