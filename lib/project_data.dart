import 'package:flutter/material.dart';

class Donation {
  final String day;
  final double amount;
  final String text;
  final String prayer;

  Donation({
    required this.day,
    required this.amount,
    required this.text,
    required this.prayer,
  });
}

class Project {
  final String title;
  final String description;
  final IconData icon;
  final String imageUrl;
  final String startDate;
  final String endDate;
  final List<Donation> donations;

  Project({
    required this.title,
    required this.description,
    required this.icon,
    required this.imageUrl,
    this.startDate = '2025-01-01', // Default start date
    this.endDate = '2025-12-31',   // Default end date
    required this.donations,
  });
}

final List<Project> projectData = [
  Project(
    title: 'Clean Water Initiative',
    description: 'Provide clean water to communities in need.',
    icon: Icons.water_drop,
    imageUrl: 'assets/images/clean_water.png',
    donations: [
      Donation(
        day: '2025-04-01',
        amount: 100.0,
        text: 'Today, we focus on bringing clean water to remote villages.',
        prayer: 'May this water bring health and hope to those in need.',
      ),
      Donation(
        day: '2025-04-02',
        amount: 150.0,
        text: 'Your generosity helps us build sustainable water systems.',
        prayer: 'May these efforts create lasting change for generations.',
      ),
      Donation(
        day: '2025-04-03',
        amount: 200.0,
        text: 'Together, we are making clean water accessible to all.',
        prayer: 'May every drop bring joy and relief to those who receive it.',
      ),
    ],
  ),
  Project(
    title: 'Education for All',
    description: 'Support education for underprivileged children.',
    icon: Icons.school,
    imageUrl: 'assets/images/education.png',
    startDate: '2025-02-01', // Custom start date
    endDate: '2025-11-30',   // Custom end date
    donations: [
      Donation(
        day: '2025-04-01',
        amount: 50.0,
        text: 'Your support provides books and supplies for children.',
        prayer: 'May these tools empower young minds to dream big.',
      ),
      Donation(
        day: '2025-04-02',
        amount: 75.0,
        text: 'Today, we help build classrooms for better learning.',
        prayer: 'May these spaces inspire growth and knowledge.',
      ),
      Donation(
        day: '2025-04-03',
        amount: 120.0,
        text: 'Together, we are creating opportunities for a brighter future.',
        prayer: 'May every child find hope and success through education.',
      ),
    ],
  ),
  Project(
    title: 'Healthcare Access',
    description: 'Improve healthcare facilities in rural areas.',
    icon: Icons.local_hospital,
    imageUrl: 'assets/images/healthcare.png',
    donations: [
      Donation(
        day: '2025-04-01',
        amount: 200.0,
        text: 'Your contributions bring medical supplies to rural clinics.',
        prayer: 'May these supplies save lives and bring healing.',
      ),
      Donation(
        day: '2025-04-02',
        amount: 300.0,
        text: 'Today, we train healthcare workers to serve their communities.',
        prayer: 'May their knowledge and care bring comfort to many.',
      ),
      Donation(
        day: '2025-04-03',
        amount: 400.0,
        text: 'Together, we are building a healthier tomorrow.',
        prayer: 'May every effort bring hope and strength to those in need.',
      ),
    ],
  ),
];