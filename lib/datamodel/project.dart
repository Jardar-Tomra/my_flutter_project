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

  void addDonation(double amount) {
    // Get today without time.
    final today = DateTime.now();
    final day = DateTime(today.year, today.month, today.day);
    donations.add(Donation(id: '', amount: amount, day: day, text: '', prayer: ''));
  }

  double getTotalDonations() {
    return donations.fold(0, (sum, donation) => sum + donation.amount);
  }
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