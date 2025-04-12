import 'package:get_it/get_it.dart';
import 'package:my_flutter_project/datamodel/repository.dart' as repository_entity;
import 'package:my_flutter_project/datamodel/user_entity.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  final repository = repository_entity.Repository.initial();
  getIt.registerSingleton<repository_entity.Repository>(repository);

  await repository.loadData(); // Load initial data into the repository

  const currentUserId = '1';
  final currentUser = repository.getUserById(currentUserId);
  getIt.registerSingleton<UserEntity>(currentUser);
}

void main(List<String> arguments) async {
  await setupDependencies();

  final repository = getIt<repository_entity.Repository>();

  if (arguments.isEmpty) {
    print('Usage: cli_tool <command> [arguments]');
    print('Commands:');
    print('  list-projects       List all projects');
    print('  list-users          List all users');
    return;
  }

  final command = arguments[0];
  switch (command) {
    case 'list-projects':
      final projects = repository.getProjects();
      print('Projects:');
      for (var project in projects) {
        print('- ${project.title}');
      }
      break;

    case 'list-users':
      final users = repository.getUsers();
      print('Users:');
      for (var user in users) {
        print('- ${user.name}');
      }
      break;

    default:
      print('Unknown command: $command');
      print('Use "cli_tool" without arguments to see available commands.');
  }
}
