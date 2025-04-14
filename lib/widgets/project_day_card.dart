import 'package:flutter/material.dart';
import 'money_badge.dart'; // Import MoneyBadge

class ProjectDayCard extends StatelessWidget {
  final String text;
  final String prayer;
  final String story; // New field for the story
  final DateTime day;
  final bool hasDonated; // New property to indicate donation status

  const ProjectDayCard({
    Key? key,
    required this.text,
    required this.prayer,
    required this.story, // Required parameter for the story
    required this.day,
    required this.hasDonated, // Required parameter for donation status
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DateTime today = DateTime.now();
    final bool isPast = day.isBefore(today);
    final bool isFuture = day.isAfter(today);

    Color cardColor;
    if (hasDonated) {
      cardColor = Colors.green.shade100; // Green-ish for donated days
    } else if (isPast) {
      cardColor = Colors.blue.shade100; // Blue-ish for past days
    } else if (isFuture) {
      cardColor = Colors.grey.shade200; // Grey-ish for future days
    } else {
      cardColor = Colors.white; // Default color
    }

    return Card(
      margin: const EdgeInsets.all(8.0),
      color: cardColor, // Set the card's background color
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  text,
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
              story, // Display the story
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
                prayer,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontStyle: FontStyle.italic),
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              "Date: ${day.toLocal().toString().split(' ')[0]}",
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
