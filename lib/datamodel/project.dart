import 'package:flutter/material.dart';

class Project {
  final String id; // Added id field
  final String title;
  final String description;
  final IconData icon;
  final String imageUrl;
  final DateTime startDate;
  final DateTime endDate;
  final List<Donation> donations;

  Project({
    required this.id, // Added id to constructor
    required this.title,
    required this.description,
    required this.icon,
    required this.imageUrl,
    required this.startDate,
    required this.endDate,
    required this.donations,
  });
}

class Donation {
  final String id; // Added id field
  final DateTime day; // Changed type from String to DateTime
  final double amount;
  final String text;
  final String prayer;

  Donation({
    required this.id, // Added id to constructor
    required this.day, // Updated type to DateTime
    required this.amount,
    required this.text,
    required this.prayer,
  });
}