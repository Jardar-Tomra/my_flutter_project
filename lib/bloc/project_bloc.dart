import 'package:flutter_bloc/flutter_bloc.dart';
import '../datamodel/project.dart';
import '../data/project_data.dart'; // Import the project data

abstract class ProjectEvent {}

class LoadProjects extends ProjectEvent {}

class UpdateProjects extends ProjectEvent {
  final List<Project> projects;

  UpdateProjects(this.projects);
}

abstract class ProjectState {}

class ProjectInitial extends ProjectState {}

class ProjectLoaded extends ProjectState {
  final List<Project> projects;

  ProjectLoaded(this.projects);
}

class ProjectBloc extends Bloc<ProjectEvent, ProjectState> {
  ProjectBloc() : super(ProjectInitial()) {
    on<LoadProjects>((event, emit) {
      // Load initial projects from project_data.dart
      emit(ProjectLoaded(projectData));
    });

    on<UpdateProjects>((event, emit) {
      emit(ProjectLoaded(event.projects));
    });
  }
}
