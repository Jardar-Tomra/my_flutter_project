import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_flutter_project/bloc/project.dart';
import 'package:my_flutter_project/extensions/date_time_formatting.dart';
import 'package:my_flutter_project/styles/app_text_styles.dart';
import 'package:my_flutter_project/widgets/custom_dot_effect.dart';
import 'package:my_flutter_project/widgets/project_day_card.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart'; // Import the package
import '../../bloc/project_bloc.dart';
import '../../widgets/donation_button.dart';
import '../../widgets/date_badge.dart'; // Import the DateBadge widget

class ProjectPage extends StatefulWidget {
  final Project project;

  const ProjectPage({
    super.key,
    required this.project,
  });

  @override
  _ProjectPageState createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    final todayIndex = widget.project.getProjectDays().indexWhere(
      (day) {
        var nowDay = DateTime.now().dateOnly();
        return day.day.isSameDay(nowDay) || day.day.isAfter(nowDay);
      }
    );
    _pageController = PageController(initialPage: todayIndex >= 0 ? todayIndex : 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _save(BuildContext context, Project updatedProject) {
    final bloc = context.read<ProjectBloc>();
    bloc.add(RefreshProjects());
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectBloc, ProjectState>(      
      builder: (context, state) {
        final currentProject = state is ProjectUpdatedState ? state.project : widget.project;

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
                                project: currentProject,
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
                    child: Center(
                      child: SmoothPageIndicator(
                        controller: _pageController, // Bind to the PageController
                        onDotClicked: (d) {
                          debugPrint('Dot clicked: $d');
                          var page = _pageController.page;
                          double durationMs = ((page ?? 0) - d.toDouble()).abs() * 100 + 30;
                          _pageController.animateToPage(
                          d,
                          duration: Duration(milliseconds: durationMs.toInt()),
                          curve: Curves.bounceInOut,
                          );
                        },
                        count: currentProject.getProjectDays().length,
                        effect: CustomDotEffect(
                          getColor: (index) => _getCardColor(currentProject, index), // Custom color logic
                          dotHeight: 10.0,
                          dotWidth: 10.0,
                          spacing: 8.0,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: SizedBox(
                      height: 400, // Set a fixed height for horizontal scrolling
                      child: Listener(
                        onPointerSignal: (pointerSignal) {
                          if (pointerSignal is PointerScrollEvent) {
                            // Convert vertical mouse scroll into horizontal scroll
                            _pageController.position.moveTo(
                              _pageController.position.pixels + pointerSignal.scrollDelta.dy,
                            );
                          }
                        },
                        child: PageView.builder(
                          controller: _pageController, // Use PageController for synchronization
                          scrollDirection: Axis.horizontal, // Enable horizontal scrolling
                          itemCount: currentProject.getProjectDays().length,
                          itemBuilder: (context, index) {
                            final day = currentProject.getProjectDays()[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0), // Add spacing between cards
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.8, // Set width to 80% of screen width
                                child: ProjectDayCard(
                                  text: day.title,
                                  prayer: day.prayer,
                                  story: day.story,
                                  day: day.day,
                                  hasDonated: currentProject.hasDonatedFor(day), // Provide the required parameter
                                ),
                              ),
                            );
                          },
                        ),
                      ),
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

  Color _getCardColor(Project project, int index) {
    final day = project.getProjectDays()[index];
    if (project.hasDonatedFor(day)) {
      return Colors.green.shade100; // Green for donated days
    } else if (day.day.isBefore(DateTime.now())) {
      return Colors.blue.shade100; // Blue for past days
    } else {
      return Colors.grey.shade200; // Grey for future days
    }
  }
}