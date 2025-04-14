import '../datamodel/user_entity.dart';
import '../datamodel/repository.dart';
import 'project.dart';

class User {
  final UserEntity entity;
  final Repository repository;

  User({
    required this.entity,
    required this.repository,
  });

  factory User.fromEntity(Repository repository, UserEntity userEntity) {
    return User(
      entity: userEntity,
      repository: repository,
    );
  }

  String get id => entity.id;

  String get name => entity.name;

  List<Project> getAssignedProjects() {
    return repository.getAssignedProjectsForUser(id).map((projectEntity) {
      return Project.fromEntity(repository, projectEntity, entity.id);
    }).toList();
  }

  List<Project> getUnassignedProjects() {
    return repository.getUnassignedProjectsForUser(id).map((projectEntity) {
      return Project.fromEntity(repository, projectEntity, entity.id);
    }).toList();
  }

  double getTotalDonationsForProject(String projectId) {
    return repository.getDonationsByUserForProject(id, projectId).fold(0.0, (sum, donation) => sum + donation.amount);
  }

  Map<String, double> get totalDonationsPerProject {
    final donations = repository.getDonationsByUser(id);
    final Map<String, double> totals = {};

    for (var donation in donations) {
      totals[donation.projectId] = (totals[donation.projectId] ?? 0.0) + donation.amount;
    }

    return totals;
  }

  bool isActiveInProject(String projectId) {
    return getAssignedProjects().any((project) => project.id == projectId);
  }
}

