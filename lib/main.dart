import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:my_flutter_project/bloc/bloc_factory.dart';
import 'package:my_flutter_project/datamodel/user_entity.dart';
import 'bloc/project_bloc.dart';
import 'bloc/user_bloc.dart';
import 'home_page.dart';
import 'datamodel/repository.dart' as repository_entity;

final getIt = GetIt.instance;

void setupDependencies() {
  final repository = repository_entity.Repository.initial();

  final blocFactory = BlocFactory(repository);

  getIt.registerSingleton<repository_entity.Repository>(repository);
  getIt.registerSingleton<BlocFactory>(blocFactory);

  // Register the current user ID
  const currentUserId = '1'; // Replace with dynamic user ID if needed
  getIt.registerSingleton<String>(currentUserId, instanceName: 'currentUserId');

  // Register the current user object
  final currentUser = repository.getUserById(currentUserId);
  getIt.registerSingleton<UserEntity>(currentUser, instanceName: 'currentUser');
}

void main() {
  setupDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) {
            final projectBloc = GetIt.instance<BlocFactory>().createProjectBloc();
            projectBloc.add(LoadProjects());
            return projectBloc;
          },
        ),
        BlocProvider(create: (_) => GetIt.instance<BlocFactory>().createUserBloc()..add(LoadUsers())),
      ],
      child: MaterialApp(
        title: 'My Flutter Project',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomePage(title: 'Home'),
      ),
    );
  }
}
