import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_flutter_project/project_card.dart';
import 'bloc/project_bloc.dart';
import 'bloc/user_bloc.dart';
import 'project_overview_page.dart'; // Import the project overview page

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
      body: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => ProjectBloc.initialize()..add(LoadProjects())),
          BlocProvider(create: (_) => UserBloc()..add(LoadUsers())),
        ],
        child: BlocBuilder<UserBloc, UserState>(
          builder: (context, userState) {
            if (userState is UserLoaded) {
              final activeUser = userState.activeUser;

              return BlocBuilder<ProjectBloc, ProjectState>(
                builder: (context, projectState) {
                  if (projectState is ProjectLoaded) {
                    final sortedProjects = [
                      ...projectState.projects.where((project) => activeUser.activeProjects.contains(project.title)),
                      ...projectState.projects.where((project) => !activeUser.activeProjects.contains(project.title)),
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
                              final isActive = activeUser.activeProjects.contains(project.title);
                              final totalDonations = activeUser.totalDonationsPerProject[project.title] ?? 0.0;

                              return ProjectCard(
                                project: project,
                                isActive: isActive,
                                totalDonations: totalDonations,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProjectOverviewPage(
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
    );
  }
}