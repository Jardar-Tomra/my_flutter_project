import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/project_bloc.dart';
import 'bloc/user_bloc.dart';
import 'home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ProjectBloc.initialize()..add(LoadProjects())),
        BlocProvider(create: (_) => UserBloc()..add(LoadUsers())),
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
