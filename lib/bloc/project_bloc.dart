import 'package:flutter_bloc/flutter_bloc.dart';
import '../datamodel/project.dart';
import '../data/project_data.dart'; // Import the project data

abstract class ProjectEvent {}

class LoadProjects extends ProjectEvent {}

class UpdateProjects extends ProjectEvent {
  final List<Project> projects;

  UpdateProjects(this.projects);
}

class UpdateProject extends ProjectEvent {
  final Project project;

  UpdateProject(this.project);
}

class RefreshProjects extends ProjectEvent {}

class AddDonationEvent extends ProjectEvent {
  final String projectId;
  final double amount;

  AddDonationEvent({required this.projectId, required this.amount});
}

abstract class ProjectState {}

class ProjectInitial extends ProjectState {}

class ProjectLoaded extends ProjectState {
  final List<Project> projects;

  ProjectLoaded(this.projects);
}

class ProjectUpdatedState extends ProjectState {
  final Project project;

  ProjectUpdatedState(this.project);
}


class ProjectBloc extends Bloc<ProjectEvent, ProjectState> {
  final List<Project> projects;

  ProjectBloc(this.projects) : super(ProjectInitial()) {
    on<LoadProjects>((event, emit) {
      // Load initial projects from project_data.dart
      emit(ProjectLoaded(projectData));
    });

    on<UpdateProjects>((event, emit) {
      emit(ProjectLoaded(event.projects));
    });

    on<RefreshProjects>((event, emit) {
      emit(ProjectLoaded(projects));
    });

    on<UpdateProject>((event, emit) {
      emit(ProjectLoaded(projects));
    });

    on<AddDonationEvent>((event, emit) {
      final project = projects.firstWhere((p) => p.id == event.projectId);
      project.addDonation(event.amount);
      emit(ProjectUpdatedState(project));
    });
  }
  factory ProjectBloc.initialize() {
    return ProjectBloc(List<Project>.from(projectData));
  }
}

