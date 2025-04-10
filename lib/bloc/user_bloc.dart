import 'package:flutter_bloc/flutter_bloc.dart';
import '../datamodel/user.dart';
import '../data/user_data.dart'; // Import the user data

abstract class UserEvent {}

class LoadUsers extends UserEvent {}

class UpdateActiveUser extends UserEvent {
  final User activeUser;

  UpdateActiveUser(this.activeUser);
}

abstract class UserState {}

class UserInitial extends UserState {}

class UserLoaded extends UserState {
  final User activeUser;

  UserLoaded(this.activeUser);
}

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserInitial()) {
    on<LoadUsers>((event, emit) {
      // Load initial users from user_data.dart
      emit(UserLoaded(users[0])); // Assuming the first user is the active one
    });

    on<UpdateActiveUser>((event, emit) {
      emit(UserLoaded(event.activeUser));
    });
  }
}
