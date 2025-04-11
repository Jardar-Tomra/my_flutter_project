import 'user_entity.dart';
import 'project_entity.dart' as project_entity;
import 'donation_entity.dart' as donation_entity;
import 'project_day_entity.dart' as project_day_entity;
import 'dart:convert';
import 'dart:io';
import 'user_project_assignment_entity.dart' as user_project_assignment_entity;

class Repository {
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
    return donations.where((donation) => donation.userId == userId).toList();
  }

  List<donation_entity.DonationEntity> getDonationsForProject(String projectId) {
    return donations.where((donation) => donation.projectId == projectId).toList();
  }

  List<donation_entity.DonationEntity> getDonationsForProjectDay(String projectDayId) {
    return donations.where((donation) => donation.projectDayId == projectDayId).toList();
  }

  UserEntity getUserById(String userId) {
    return users.firstWhere((user) => user.id == userId, orElse: () => throw ArgumentError('User not found'));
  }

  project_entity.ProjectEntity getProjectById(String projectId) {
    return projects.firstWhere((project) => project.id == projectId, orElse: () => throw ArgumentError('Project not found'));
  }

  project_day_entity.ProjectDayEntity getProjectDayById(String projectDayId) {
    return projectDays.firstWhere((day) => day.id == projectDayId, orElse: () => throw ArgumentError('ProjectDay not found'));
  }

  void addDonationForToday(String projectDayId, String userId, double amount) {
    final today = DateTime.now();
    final day = DateTime(today.year, today.month, today.day);
    final donation = donation_entity.DonationEntity(
      id: '',
      userId: userId,
      projectId: getProjectDayById(projectDayId).projectId,
      projectDayId: projectDayId,
      date: day,
      amount: amount,
    );
    donations.add(donation);
  }

  double getTotalDonationsForProject(String projectId) {
    return projectDays
        .where((day) => day.projectId == projectId)
        .fold(0, (sum, day) => getTotalDonationsForProjectDay(day.id));
  }

  double getTotalDonationsForProjectDay(String projectDayId) {
    return donations
        .where((donation) => donation.projectDayId == projectDayId)
        .fold(0, (sum, donation) => sum + donation.amount);
  }

  List<donation_entity.DonationEntity> getDonationsByUserForProject(String userId, String projectId) {
    return donations
        .where((donation) =>
            donation.userId == userId && donation.projectId == projectId)
        .toList();
  }

  List<donation_entity.DonationEntity> getDonationsByUserForProjectDay(
      String userId, String projectDayId) {
    return donations
        .where((donation) =>
            donation.userId == userId && donation.projectDayId == projectDayId)
        .toList();
  }

  List<project_entity.ProjectEntity> getAssignedProjectsForUser(String userId) {
    final assignedProjectIds = userProjectAssignments
        .where((assignment) => assignment.userId == userId)
        .map((assignment) => assignment.projectId)
        .toSet();

    return projects.where((project) => assignedProjectIds.contains(project.id)).toList();
  }

  List<project_entity.ProjectEntity> getUnassignedProjectsForUser(String userId) {
    final assignedProjectIds = userProjectAssignments
        .where((assignment) => assignment.userId == userId)
        .map((assignment) => assignment.projectId)
        .toSet();

    return projects.where((project) => !assignedProjectIds.contains(project.id)).toList();
  }

  Future<void> loadData() async {
    final projectJson = File('lib/data/projects.json').readAsStringSync();
    final projectDayJson = File('lib/data/project_days.json').readAsStringSync();
    final donationJson = File('lib/data/donations.json').readAsStringSync();
    final userJson = File('lib/data/users.json').readAsStringSync();
    final assignmentJson = File('lib/data/user_project_assignments.json').readAsStringSync();

    projects.addAll((jsonDecode(projectJson) as List)
        .map((data) => project_entity.ProjectEntity.fromJson(data)));
    projectDays.addAll((jsonDecode(projectDayJson) as List)
        .map((data) => project_day_entity.ProjectDayEntity.fromJson(data)));
    donations.addAll((jsonDecode(donationJson) as List)
        .map((data) => donation_entity.DonationEntity.fromJson(data)));
    users.addAll((jsonDecode(userJson) as List)
        .map((data) => UserEntity.fromJson(data)));
    userProjectAssignments.addAll((jsonDecode(assignmentJson) as List)
        .map((data) => user_project_assignment_entity.UserProjectAssignmentEntity.fromJson(data)));
  }

  // Future<void> saveData() async {
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