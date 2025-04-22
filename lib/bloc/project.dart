import 'package:caritas_donation_app/datamodel/donation_entity.dart';
import 'package:caritas_donation_app/datamodel/project_day_entity.dart';
import 'package:caritas_donation_app/datamodel/project_entity.dart';
import 'package:caritas_donation_app/datamodel/repository.dart';
import 'package:caritas_donation_app/datamodel/user_project_assignment_entity.dart';
import 'package:caritas_donation_app/extensions/date_time_formatting.dart';
import 'package:flutter/widgets.dart';

class Project {
  final ProjectEntity entity;
  final Repository repository;
  final String userId;

  IconData get icon => entity.icon; // Assuming ProjectEntity has an icon of type IconData

  Project({
    required this.entity,
    required this.repository,
    required this.userId,
  });

  String get id => entity.id;

  String get title => entity.title;

  String get description => entity.description;

  DateTime get startDate => entity.startDate;

  DateTime get endDate => entity.endDate;

  String get imageUrl => entity.imageUrl; // Assuming ProjectEntity has an imageUrl field

  factory Project.fromRepository(Repository repository, String projectId, String userId) {
    final projectEntity = repository.getProjectById(projectId);
    return Project(
      entity: projectEntity,
      repository: repository,
      userId: userId,
    );
  }

  factory Project.fromEntity(Repository repository, ProjectEntity projectEntity, String userId) {
    return Project(
      entity: projectEntity,
      repository: repository,
      userId: userId,
    );
  }

  bool isAssigned() {
    return repository.getAssignedProjectsForUser(userId).any((project) => project.id == id);
  }

  List<DonationEntity> donations() {
    return repository.getDonationsByUserForProject(userId, id);
  }

  double totalDonations() {
    return donations().fold(0, (sum, donation) => sum + donation.amount);
  }

  bool isCompleted() {
    return DateTime.now().isAfter(endDate);
  }

  void donate(double amount, String donator) {
    if (amount <= 0) {
      throw ArgumentError('Donation amount must be greater than zero.');
    }
    repository.addDonationForToday(userId, id, amount, donator);
  }

  bool hasDonatedToday() {
    final today = DateTime.now();
    return donations().any((donation) => donation.date.isSameDay(today) );
  }


  List<ProjectDayEntity> getProjectDays() {
    return repository.getProjectDaysByProjectId(id);
  }

  bool hasDonatedForDay(ProjectDayEntity day) {
    return donations().any((donation) => donation.projectDayId == day.id);
  }

  bool hasDonatedForDayBy(ProjectDayEntity day, String donator) {
    return donations().any((donation) => donation.projectDayId == day.id && donation.donator == donator);
  }

  List<String> getDonators() {
    return getUserProjectEntity().participants;
  }

  double get dailyDonationAmount {
    // Retrieve the user's chosen daily donation amount for this project
    UserProjectAssignmentEntity assignment = getUserProjectEntity();
    return assignment.dailyDonationAmount; // Assuming `dailyDonationAmount` exists in the assignment entity
  }

  UserProjectAssignmentEntity getUserProjectEntity() {
    final assignment = repository.getUserProjectAssignment(userId, id);
    return assignment;
  }

}