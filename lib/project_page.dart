import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_flutter_project/bloc/project.dart';
import 'package:my_flutter_project/extensions/date_time_formatting.dart';
import 'package:my_flutter_project/styles/app_text_styles.dart';
import 'package:my_flutter_project/widgets/project_day_card.dart';
import 'widgets/project_donation_tracker.dart'; // Import the ProjectTracker widget
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
    return BlocBuilder<ProjectBloc, ProjectState>(      
      builder: (context, state) {
        final currentProject = state is ProjectUpdatedState ? state.project : project;

        return WillPopScope(
          onWillPop: () => Future(() {
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
                          'Total Donations: \$${currentProject.totalDonations.toStringAsFixed(2)}',
                          style: AppTextStyles.bodyLarge,
                        ),
                        Text(
                          'Duration: ${currentProject.startDate.toLocal().toShortDateString()} - ${currentProject.endDate.toLocal().toShortDateString()}',
                          style: AppTextStyles.bodySmall,
                        ),
                        const SizedBox(height: 16),
                        DonationButton(
                          project: project,
                          amount: 50.0, // Example amount
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Project Days:',
                          style: AppTextStyles.sectionHeader,
                        ),
                        const SizedBox(height: 8),
                        ...project.getProjectDays().map((day) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: SizedBox(
                              width: double.infinity,
                              child: ProjectDayCard(
                                text: day.text,
                                prayer: day.prayer,
                                day: day.day,
                                hasDonated: currentProject.hasDonatedFor(day), // Provide the required parameter
                              ),
                            ),
                          );
                        }).toList(),
                      ],
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