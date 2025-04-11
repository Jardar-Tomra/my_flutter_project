import 'package:my_flutter_project/datamodel/repository.dart';
import 'project_bloc.dart';
import 'user_bloc.dart';

class BlocFactory {
  final Repository repository;

  BlocFactory(this.repository);

  ProjectBloc createProjectBloc() {
    return ProjectBloc(repository);
  }

  UserBloc createUserBloc() {
    return UserBloc(repository);
  }

  // Add methods to create other BLoCs as needed
}