import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:caritas_donation_app/bloc/aggregated_project_bloc.dart';
import 'package:caritas_donation_app/bloc/bloc_factory.dart';
import 'package:caritas_donation_app/bloc/project.dart';
import 'package:caritas_donation_app/datamodel/project_day_entity.dart';
import 'package:caritas_donation_app/extensions/date_time_formatting.dart';
import 'package:caritas_donation_app/styles/app_text_styles.dart';
import 'package:caritas_donation_app/widgets/colored_worm_effect.dart';
import 'package:caritas_donation_app/widgets/project_day_card.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart'; // Import the package
import '../../bloc/project_bloc.dart';
import '../../widgets/date_badge.dart'; // Import the DateBadge widget
import '../../widgets/money_badge.dart'; // Import MoneyBadge

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
          final projectDays = currentProject.getProjectDays();
          final donationForDays = projectDays.map((m) => currentProject.hasDonatedForDay(m)).toList();

          return WillPopScope(
            onWillPop: () => Future(() {
              _save(context, currentProject);
              return true;
            }),
            child: BlocProvider(
              create: (context) => GetIt.instance<BlocFactory>().createAggregatedProjectBloc(currentProject.id),
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
                                  const SizedBox(height: 16)
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
                                  BlocBuilder<AggregatedProjectBloc, AggregatedProjectState>(
                                    builder: (context, state) {
                                      return MoneyBadge(
                                        amountForAll: state.totalDonations,
                                        amount: currentProject.totalDonations(),
                                      );
                                    },
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
                            effect: ColoredWormEffect.ColoredWormEffect(
                              getColor: (index) => _getIndicatorColor(projectDays, donationForDays, index), // Custom color logic
                              dotHeight: 12.0,
                              dotWidth: 12.0,
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
                              itemCount: projectDays.length,
                              itemBuilder: (context, index) {
                                final day = projectDays[index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0), // Add spacing between cards
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.8, // Set width to 80% of screen width
                                    child: ProjectDayCard(
                                      project: currentProject,
                                      dayEntity: day, // Pass
                                      dayIndex: index,
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
            ),
          );
        }
      );
    } 
  }

  Color _getIndicatorColor(List<ProjectDayEntity> days, List<bool> donationsForDays, int index) {
    final day = days[index];
    if (donationsForDays[index]) { 
      return Colors.green.shade300; // Green for donated days
    } else if (day.day.isBefore(DateTime.now())) {
      return Colors.blue.shade300; // Blue for past days
    } else {
      return Colors.grey.shade500; // Grey for future days
  }

}