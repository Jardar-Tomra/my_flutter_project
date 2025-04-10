import 'package:flutter/material.dart';
import 'package:my_flutter_project/datamodel/project.dart';

final List<Project> projectData = [
  Project(
    id: '1',
    title: 'Clean Water Initiative',
    description: 'Providing clean water to communities in need.',
    icon: Icons.water, // Added icon
    imageUrl: 'assets/images/clean_water.jpg', // Added imageUrl
    startDate: DateTime(2025, 1, 1),
    endDate: DateTime(2025, 12, 31),
    donations: [ // Added donations
      Donation(
        id: 'd1',
        day: '2025-01-15',
        amount: 100.0,
        text: 'Donation for clean water.',
        prayer: 'May this help those in need.',
      ),
    ],
  ),
  Project(
    id: '2',
    title: 'Education for All',
    description: 'Ensuring access to education for children in underprivileged areas.',
    icon: Icons.school, // Added icon
    imageUrl: 'assets/images/education.jpg', // Added imageUrl
    startDate: DateTime(2025, 2, 1),
    endDate: DateTime(2025, 11, 30),
    donations: [ // Added donations
      Donation(
        id: 'd2',
        day: '2025-02-20',
        amount: 200.0,
        text: 'Donation for education.',
        prayer: 'May this bring knowledge to many.',
      ),
    ],
  ),
  Project(
    id: '3',
    title: 'Healthcare Access',
    description: 'Providing healthcare services to remote areas.',
    icon: Icons.local_hospital, // Added icon
    imageUrl: 'assets/images/healthcare.jpg', // Added imageUrl
    startDate: DateTime(2025, 3, 1),
    endDate: DateTime(2025, 10, 31),
    donations: [ // Added donations
      Donation(
        id: 'd3',
        day: '2025-03-10',
        amount: 150.0,
        text: 'Donation for healthcare.',
        prayer: 'May this heal the sick.',
      ),
    ],
  ),
];