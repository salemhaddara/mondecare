// ignore_for_file: camel_case_types

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mondecare/config/Models/logEvent.dart';
import 'package:mondecare/feature/logs/logsStates/Repo/logsrepository.dart';
import 'package:mondecare/feature/logs/logsStates/logsStatus/logsStatus.dart';
import 'package:mondecare/feature/logs/logsStates/logs_event.dart';
import 'package:mondecare/feature/logs/logsStates/logs_state.dart';

class logs_bloc extends Bloc<logs_event, logs_state> {
  logsrepository repo;
  logs_bloc(this.repo) : super(logs_state(status: initialLogsState())) {
    on<requestLogs>((event, emit) async {
      List<logEvent> events = List.empty(growable: true);
      emit(logs_state(status: fetchingLogsData()));
      try {
        events = await repo.fetchLogsFromFirestore();
        if (events.isEmpty) {
          emit(logs_state(status: nodataLogs()));
        } else {
          emit(logs_state(status: dataLogsGetted(logsevents: events)));
        }
      } catch (e) {
        emit(logs_state(status: fetchingLogsdataFailed(exception: 'error')));
      }
    });
  }
}
