import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_flutter_project/widgets/project_card.dart';
import '../bloc/project_bloc.dart';
import '../bloc/user_bloc.dart';
import 'project_page.dart'; // Import the project overview page

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: Column(
        children: [
          Stack(
            children: [
              Image.asset(
                'assets/images/top.jpg',
                fit: BoxFit.cover,
                width: double.infinity,
                height: 200.0,
              ),
              Positioned(
                top: 16.0,
                right: 16.0,
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 150.0,
                  height: 150.0,
                ),
              ),
            ],
          ),
          Expanded(
            child: BlocBuilder<UserBloc, UserState>(
              builder: (context, userState) {
                if (userState is UserLoaded) {
                  final activeUser = userState.activeUser;

                  return BlocBuilder<ProjectBloc, ProjectState>(
                    builder: (context, projectState) {
                      if (projectState is ProjectsLoaded) {
                        final sortedProjects = [
                          ...userState.activeUser.getAssignedProjects(),
                          ...userState.activeUser.getUnassignedProjects(),
                        ];

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                'Welcome, ${activeUser.name}!',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const Divider(),
                            Expanded(
                              child: ListView.builder(
                                itemCount: sortedProjects.length,
                                itemBuilder: (context, index) {
                                  
                                  final project = sortedProjects[index];

                                  return ProjectCard(
                                    project: project,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ProjectPage(
                                            project: project,
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      }
                      return const Center(child: CircularProgressIndicator());
                    },
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
      ),
    );
  }
}