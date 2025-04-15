import 'package:my_flutter_project/datamodel/repository.dart';
import 'package:my_flutter_project/utils/donation_simulator.dart';
import 'project_bloc.dart';
import 'user_bloc.dart';
import 'aggregated_project_bloc.dart';

class BlocFactory {

  Map<String, DonationSimulator> simulators = {};

  final Repository repository;

  BlocFactory(this.repository);

  ProjectBloc createProjectBloc() {
    return ProjectBloc(repository);
  }

  UserBloc createUserBloc() {
    return UserBloc(repository);
  }

  AggregatedProjectBloc createAggregatedProjectBloc(String projectId) {
    return AggregatedProjectBloc(repository, createDonationSimulator(projectId));
  }

  DonationSimulator createDonationSimulator(String projectId) {
    if (!simulators.containsKey(projectId)) {
      simulators[projectId] = DonationSimulator(
    initialUsers: 300,
    growthRate: 0.03, // 3% daily growth
    speedMultiplier: 10.0, // Run 10x faster than normal);
      );
    }
    simulators[projectId]!.start();
    return simulators[projectId]!;
  }

  // Add methods to create other BLoCs as needed
}