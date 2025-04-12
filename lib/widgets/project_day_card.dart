import 'package:flutter/material.dart';

class ProjectDayCard extends StatelessWidget {
  final String text;
  final String prayer;
  final DateTime day;
  final bool hasDonated; // New property to indicate donation status

  const ProjectDayCard({
    Key? key,
    required this.text,
    required this.prayer,
    required this.day,
    required this.hasDonated, // Required parameter for donation status
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
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
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                if (hasDonated)
                  Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 24.0,
                  ),
              ],
            ),
            const SizedBox(height: 8.0),
            Text(
              'Prayer: $prayer',
              style: Theme.of(context).textTheme.bodyMedium,
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
