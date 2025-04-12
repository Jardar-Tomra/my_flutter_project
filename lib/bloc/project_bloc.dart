import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_flutter_project/bloc/project.dart';
import 'package:my_flutter_project/datamodel/repository.dart' as repository_entity;
import 'package:my_flutter_project/datamodel/user_entity.dart';
import 'package:get_it/get_it.dart';

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

class ProjectsLoaded extends ProjectState {
  final List<Project> projects;

  ProjectsLoaded(this.projects);
}

class ProjectUpdatedState extends ProjectState {
  final Project project;

  ProjectUpdatedState(this.project);
}


class ProjectBloc extends Bloc<ProjectEvent, ProjectState> {
  final repository_entity.Repository repo;
  List<Project> projects = [];
  final UserEntity user = GetIt.instance.get<UserEntity>();

  ProjectBloc(this.repo) : super(ProjectInitial()) {
    on<LoadProjects>((event, emit) {
      // Load initial projects from project_data.dart
      emit(ProjectsLoaded(getProjects()));
    });

    on<UpdateProjects>((event, emit) {
      emit(ProjectsLoaded(event.projects));
    });

    on<RefreshProjects>((event, emit) {
      emit(ProjectsLoaded(getProjects()));
    });

    on<UpdateProject>((event, emit) {
      emit(ProjectsLoaded(getProjects()));
    });

    on<AddDonationEvent>((event, emit) {
      var p = projects.firstWhere((project) => project.id == event.projectId);
      p.donate(event.amount);
      emit(ProjectUpdatedState( p ));
    });
  }

  List<Project> getProjects() {
    projects = repo.projects.map((project) => Project.fromEntity(repo, project, user.id)).toList();
    return projects;
  }
}

extension ProjectBlocExtension on BuildContext {
  void donate(String projectId, double amount) {
    read<ProjectBloc>().add(AddDonationEvent(
      projectId: projectId,
      amount: 10.0,
    ));
  }
}