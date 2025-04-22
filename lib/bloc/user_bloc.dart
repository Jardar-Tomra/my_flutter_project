import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:caritas_donation_app/bloc/user.dart';
import 'package:caritas_donation_app/datamodel/repository.dart' as repository_entity;
import 'package:caritas_donation_app/datamodel/user_entity.dart';


abstract class UserEvent {}

class LoadUsers extends UserEvent {}

class UpdateActiveUser extends UserEvent {
  final User activeUser;

  UpdateActiveUser(this.activeUser);
}

class ActivateProject extends UserEvent {
  final String projectId;
  final double dailyDonationAmount;
  final List<String> participants; // Updated to use participants

  ActivateProject(this.projectId, this.dailyDonationAmount, this.participants);
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
        repo.assignProjectToUser(activeUser.id, event.projectId, event.dailyDonationAmount, event.participants);
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
  void activate(String projectId, double dailyDonationAmount, List<String> participants) {
    read<UserBloc>().add(ActivateProject(projectId, dailyDonationAmount, participants));
  }

    void deactivate(String projectId) {
      read<UserBloc>().add(DeactivateProject(projectId));
  }
}