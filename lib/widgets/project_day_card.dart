import 'package:flutter/material.dart';
import 'package:my_flutter_project/bloc/project.dart';
import 'package:my_flutter_project/datamodel/project_day_entity.dart';
import 'package:my_flutter_project/extensions/date_time_formatting.dart';
import 'package:my_flutter_project/widgets/donation_button.dart';

class ProjectDayCard extends StatelessWidget {
  final Project project;
  final ProjectDayEntity dayEntity; // Replace redundant fields with ProjectDayEntity
  final int dayIndex; // Add dayIndex field

  const ProjectDayCard({
    Key? key,
    required this.project,
    required this.dayEntity, // Use ProjectDayEntity
    required this.dayIndex, // Initialize dayIndex
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DateTime today = DateTime.now();
    final bool isPast = dayEntity.day.isBefore(today);
    final bool isFuture = dayEntity.day.isAfter(today);
    final bool isToday = dayEntity.day.isSameDay(today);
    final hasDonated = project.hasDonatedFor(dayEntity);
    final dailyDonationAmount = project.dailyDonationAmount;

    Color cardColor;
    if (hasDonated) {
      cardColor = Colors.green.shade100; // Green-ish for donated days
    } else if (isPast) {
      cardColor = Colors.blue.shade100; // Blue-ish for past days
    } else if (isFuture) {
      cardColor = Colors.grey.shade300; // Grey-ish for future days
    } else {
      cardColor = Colors.white; // Default color
    }

    return Card(
      margin: const EdgeInsets.all(8.0),
      color: cardColor, // Set the card's background color
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${dayEntity.title}', // Use dayIndex
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (hasDonated)
                      const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 24.0,
                      ),
                  ],
                ),
                const SizedBox(height: 8.0),
                Text(
                  dayEntity.story, // Use ProjectDayEntity
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 8.0),
                Text(
                  'Prayer:',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text(
                    dayEntity.prayer, // Use ProjectDayEntity
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontStyle: FontStyle.italic),
                  ),
                ),
                const SizedBox(height: 8.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // Align to the right
                  children: [
                                    if (isToday)
                  DonationButton(
                    project: project, // Pass the project object to the button
                    amount: dailyDonationAmount, // Example amount
                  ),
                    Text(
                      dayEntity.day.toLocal().toString().split(' ')[0],
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                )
              ],
            ),
          ),
          Positioned(
            bottom: 16.0,
            right: 16.0,
            child: Text(
              'Day ${dayIndex + 1}', // Display dayIndex
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontSize: 40.0,
                color: Colors.white.withOpacity(0.9), // Lightened color
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
