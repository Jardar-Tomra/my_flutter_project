import 'package:caritas_donation_app/extensions/date_time_formatting.dart';
import 'package:caritas_donation_app/extensions/list_extensions.dart';
import 'package:logger/logger.dart';

import 'user_entity.dart';
import 'project_entity.dart' as project_entity;
import 'donation_entity.dart' as donation_entity;
import 'project_day_entity.dart' as project_day_entity;
import 'dart:convert';
import 'user_project_assignment_entity.dart' as user_project_assignment_entity;
import 'package:flutter/services.dart';

class Repository {
  final Logger _logger = Logger();

  final List<UserEntity> users;
  final List<project_entity.ProjectEntity> projects;
  final List<project_day_entity.ProjectDayEntity> projectDays;
  final List<donation_entity.DonationEntity> donations;
  final List<user_project_assignment_entity.UserProjectAssignmentEntity> userProjectAssignments;

  Repository({
    required this.users,
    required this.projects,
    required this.projectDays,
    required this.donations,
    required this.userProjectAssignments,
  });

  factory Repository.initial() {
    return Repository(
      users: [],
      projects: [],
      projectDays: [],
      donations: [],
      userProjectAssignments: [],
    );
  }

  List<donation_entity.DonationEntity> getDonationsByUser(String userId) {
    _logger.i('Fetching donations for user: $userId');
    return donations.where((donation) => donation.userId == userId).toList();
  }

  List<donation_entity.DonationEntity> getDonationsForProject(String projectId) {
    _logger.i('Fetching donations for project: $projectId');
    return donations.where((donation) => donation.projectId == projectId).toList();
  }

  List<donation_entity.DonationEntity> getDonationsForProjectDay(String projectDayId) {
    _logger.i('Fetching donations for project day: $projectDayId');
    return donations.where((donation) => donation.projectDayId == projectDayId).toList();
  }

  UserEntity getUserById(String userId) {
    _logger.i('Fetching user by ID: $userId');
    return users.firstWhere((user) => user.id == userId, orElse: () => throw ArgumentError('User not found'));
  }

  project_entity.ProjectEntity getProjectById(String projectId) {
    _logger.i('Fetching project by ID: $projectId');
    return projects.firstWhere((project) => project.id == projectId, orElse: () => throw ArgumentError('Project not found'));
  }

  project_day_entity.ProjectDayEntity getProjectDayById(String projectDayId) {
    _logger.i('Fetching project day by ID: $projectDayId');
    return projectDays.firstWhere((day) => day.id == projectDayId, orElse: () => throw ArgumentError('ProjectDay not found'));
  }

  project_day_entity.ProjectDayEntity getProjectDayByDate(String projectId, DateTime date) {
    _logger.i('Fetching project day for project: $projectId on date: $date');
    _logger.i('Total project days: ${projectDays.length}');
    return projectDays.firstWhere((day) => day.projectId == projectId && day.day.isSameDay(date), orElse: () => throw ArgumentError('ProjectDay not found'));
  }

  void addDonationForToday(String projectId, String userId, double amount, String donator) {
    _logger.i('Adding donation for today. Project: $projectId, User: $userId, Amount: $amount, Donator: $donator'); 
    final today = DateTime.now().dateOnly();

    var d = donations.firstOrNullWhere((donation) =>
        donation.userId == userId &&
        donation.projectId == projectId &&
        donation.donator == donator && // Check for participantName
        donation.date.isSameDay(today));
    if (d != null) {
      throw ArgumentError('Donation already exists for today');
    }
    var pd = getProjectDayByDate(projectId, today);

    final donation = donation_entity.DonationEntity(
      id: '',
      userId: userId,
      projectId: projectId,
      projectDayId: pd.id,
      date: today,
      amount: amount,
      donator: donator, // Add participantName to the donation
    );
    donations.add(donation);
  }

  double getTotalDonationsForProject(String projectId) {
    _logger.i('Calculating total donations for project: $projectId');
    return projectDays
        .where((day) => day.projectId == projectId)
        .fold(0, (sum, day) => getTotalDonationsForProjectDay(day.id));
  }

  double getTotalDonationsForProjectDay(String projectDayId) {
    _logger.i('Calculating total donations for project day: $projectDayId');
    return donations
        .where((donation) => donation.projectDayId == projectDayId)
        .fold(0, (sum, donation) => sum + donation.amount);
  }

  List<donation_entity.DonationEntity> getDonationsByUserForProject(String userId, String projectId) {
    _logger.i('Fetching donations for user: $userId in project: $projectId');
    return donations
        .where((donation) =>
            donation.userId == userId && donation.projectId == projectId)
        .toList();
  }

  List<donation_entity.DonationEntity> getDonationsByUserForProjectDay(
      String userId, String projectDayId) {
    _logger.i('Fetching donations for user: $userId in project day: $projectDayId');
    return donations
        .where((donation) =>
            donation.userId == userId && donation.projectDayId == projectDayId)
        .toList();
  }

  List<project_entity.ProjectEntity> getAssignedProjectsForUser(String userId) {
    _logger.i('Fetching assigned projects for user: $userId');
    final assignedProjectIds = userProjectAssignments
        .where((assignment) => assignment.userId == userId)
        .map((assignment) => assignment.projectId)
        .toSet();

    return projects.where((project) => assignedProjectIds.contains(project.id)).toList();
  }

  List<project_entity.ProjectEntity> getUnassignedProjectsForUser(String userId) {
    _logger.i('Fetching unassigned projects for user: $userId');
    final assignedProjectIds = userProjectAssignments
        .where((assignment) => assignment.userId == userId)
        .map((assignment) => assignment.projectId)
        .toSet();

    return projects.where((project) => !assignedProjectIds.contains(project.id)).toList();
  }

  void assignProjectToUser(String userId, String projectId, double dailyDonationAmount, List<String> participants) {
    _logger.i('Activating project $projectId for user $userId with participants: $participants');
    final existingAssignment = userProjectAssignments.firstOrNullWhere(
      (assignment) => assignment.userId == userId && assignment.projectId == projectId,
    );

    if (existingAssignment != null) {
      throw ArgumentError('Project is already active for the user');
    }

    userProjectAssignments.add(
      user_project_assignment_entity.UserProjectAssignmentEntity(
        userId: userId,
        projectId: projectId,
        dailyDonationAmount: dailyDonationAmount,
        participants: participants, // Updated to use participants
      ),
    );
  }

  void deactivateProjectForUser(String userId, String projectId) {
    _logger.i('Deactivating project $projectId for user $userId');
    userProjectAssignments.removeWhere(
      (assignment) => assignment.userId == userId && assignment.projectId == projectId,
    );
  }

  user_project_assignment_entity.UserProjectAssignmentEntity getUserProjectAssignment(String userId, String projectId) {
    return userProjectAssignments.firstWhere(
      (assignment) => assignment.userId == userId && assignment.projectId == projectId,
      orElse: () => throw ArgumentError('User is not assigned to this project'),
    );
  }

  Future<void> loadData() async {
    _logger.i('Loading data from assets');
    final projectJson = await rootBundle.loadString('assets/data/projects.json');
    final projectDayJson = await rootBundle.loadString('assets/data/project_days.json');
    final donationJson = await rootBundle.loadString('assets/data/donations.json');
    final userJson = await rootBundle.loadString('assets/data/users.json');
    final assignmentJson = await rootBundle.loadString('assets/data/user_project_assignments.json');

    projects.addAll((jsonDecode(projectJson) as List)
        .map((data) => project_entity.ProjectEntity.fromJson(data)));
    projectDays.addAll((jsonDecode(projectDayJson) as List)
        .map((data) => project_day_entity.ProjectDayEntity.fromJson(data)));
    // Ensure the `summary` field is correctly loaded from the JSON data.
    donations.addAll((jsonDecode(donationJson) as List)
        .map((data) => donation_entity.DonationEntity.fromJson(data)));
    users.addAll((jsonDecode(userJson) as List)
        .map((data) => UserEntity.fromJson(data)));
    userProjectAssignments.addAll((jsonDecode(assignmentJson) as List)
        .map((data) => user_project_assignment_entity.UserProjectAssignmentEntity.fromJson(data)));
  }

  List<project_day_entity.ProjectDayEntity> getProjectDaysByProjectId(String id) {
    _logger.i('Fetching project days for project ID: $id');
    return projectDays.where((day) => day.projectId == id).toList();
  }

  List<project_entity.ProjectEntity> getProjects() {
    _logger.i('Fetching all projects');
    return projects;
  }

  List<UserEntity> getUsers() {
    _logger.i('Fetching all users');
    return users;
  }

  // Future<void> saveData() async {
  //   _logger.i('Saving data to files');
  //   final projectJson = jsonEncode(projects.map((p) => p.toJson()).toList());
  //   final projectDayJson = jsonEncode(projectDays.map((pd) => pd.toJson()).toList());
  //   final donationJson = jsonEncode(donations.map((d) => d.toJson()).toList());
  //   final userJson = jsonEncode(users.map((u) => u.toJson()).toList());

  //   File('lib/data/projects.json').writeAsStringSync(projectJson);
  //   File('lib/data/project_days.json').writeAsStringSync(projectDayJson);
  //   File('lib/data/donations.json').writeAsStringSync(donationJson);
  //   File('lib/data/users.json').writeAsStringSync(userJson);
  // }
}