import 'package:flutter/material.dart';

class ProjectEntity {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final String imageUrl;
  final DateTime startDate;
  final DateTime endDate;

  ProjectEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.imageUrl,
    required this.startDate,
    required this.endDate,
  });

  factory ProjectEntity.fromJson(Map<String, dynamic> json) {
    return ProjectEntity(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      icon: _mapStringToIcon(json['icon']),
      imageUrl: json['imageUrl'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
    );
  }
  
  static IconData _mapStringToIcon(String iconName) {
    switch (iconName) {
      case 'Icons.clean_hands':
        return Icons.clean_hands;
      case 'Icons.work':
        return Icons.work;
      case 'Icons.health_and_safety':
        return Icons.health_and_safety;
      default:
        return Icons.help; // Default icon
    }
  }

  bool isProjectActive(DateTime currentDate) {
    return currentDate.isAfter(startDate) && currentDate.isBefore(endDate);
  }
}
