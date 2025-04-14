import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:my_flutter_project/bloc/user.dart';
import 'package:my_flutter_project/datamodel/repository.dart' as repository_entity;
import 'package:my_flutter_project/datamodel/user_entity.dart';


abstract class UserEvent {}

class LoadUsers extends UserEvent {}

class UpdateActiveUser extends UserEvent {
  final User activeUser;

  UpdateActiveUser(this.activeUser);
}

class ActivateProject extends UserEvent {
  final String projectId;

  ActivateProject(this.projectId);
}

class DeactivateProject extends UserEvent {
  final String projectId;

  DeactivateProject(this.projectId);
}

abstract class UserState {}

class UserInitial extends UserState {}

class UserLoaded extends UserState {
  final User activeUser;

  UserLoaded(this.activeUser);
}

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc(repository_entity.Repository repo) : super(UserInitial()) {
    on<LoadUsers>((event, emit) {
      // Load initial users from user_data.dart
      print("Emitting user");
      emit(UserLoaded(User.fromEntity(repo, GetIt.instance.get<UserEntity>()) )); // Assuming the first user is the active one
    });

    on<UpdateActiveUser>((event, emit) {
      emit(UserLoaded(event.activeUser));
    });

    on<ActivateProject>((event, emit) {
      if (state is UserLoaded) {
        final activeUser = (state as UserLoaded).activeUser;
        repo.activateProjectForUser(activeUser.id, event.projectId);
        emit(UserLoaded(activeUser));
      }
    });

    on<DeactivateProject>((event, emit) {
      if (state is UserLoaded) {
        final activeUser = (state as UserLoaded).activeUser;
        repo.deactivateProjectForUser(activeUser.id, event.projectId);
        emit(UserLoaded(activeUser));
      }
    });
  }
}

extension UserBlocExtension on BuildContext {
  void activate(String projectId) {
    read<UserBloc>().add(ActivateProject(projectId));
  }

    void deactivate(String projectId) {
      read<UserBloc>().add(DeactivateProject(projectId));
  }
}