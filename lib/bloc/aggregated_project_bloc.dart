import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:caritas_donation_app/datamodel/repository.dart';
import 'package:caritas_donation_app/utils/donation_simulator.dart';

class AggregatedProjectState {
  final int totalParticipants;
  final double totalDonations;

  AggregatedProjectState(this.totalParticipants, this.totalDonations);
}

class AggregatedProjectBloc extends Cubit<AggregatedProjectState> {
  final Repository repository;
  
  final DonationSimulator simulator;

  AggregatedProjectBloc(this.repository, this.simulator)
      : super(AggregatedProjectState(simulator.currentUsers, simulator.currentTotalDonations)) {
      simulator.subscribe(onData);
  }

  void onData(double donations, int participants) {
      emit(AggregatedProjectState(participants, donations));
    }

  @override
  Future<void> close() {
    simulator.unsubscribe(onData);
    return super.close();
  }
}
