import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_flutter_project/bloc/project.dart';
import 'package:my_flutter_project/styles/app_text_styles.dart';
import 'package:my_flutter_project/widgets/project_day_card.dart';
import '../../bloc/project_bloc.dart';
import '../../widgets/donation_button.dart';
import '../../widgets/date_badge.dart'; // Import the DateBadge widget

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
                  Image.asset(
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                currentProject.description,
                                style: AppTextStyles.bodyMedium,
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Text(
                                'Total: \$${currentProject.totalDonations.toStringAsFixed(2)}',
                                style: AppTextStyles.bodyLarge,
                              ),
                              const SizedBox(width: 16),
                                DonationButton(
                                project: project,
                                amount: 50.0, // Example amount
                              ),
                              ]),
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
                                startDate: currentProject.startDate,
                                endDate: currentProject.endDate,
                                size: BadgeSize.small,
                              ),
                              const SizedBox(height: 16),

                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...project.getProjectDays().map((day) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: SizedBox(
                              width: double.infinity,
                              child: ProjectDayCard(
                                text: day.title,
                                prayer: day.prayer,
                                story: day.story,
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