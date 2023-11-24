// ignore_for_file: camel_case_types

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mondecare/feature/deleteUser/deletebloc/Repository/deleteRepository.dart';
import 'package:mondecare/feature/deleteUser/deletebloc/deleteevent.dart';
import 'package:mondecare/feature/deleteUser/deletebloc/deletestate.dart';
import 'package:mondecare/feature/deleteUser/deletebloc/searchStateTracker/deleteStatusTracker.dart';

class deletebloc extends Bloc<deleteevent, deletestate> {
  deleteRepository repo;

  deletebloc(this.repo)
      : super(deletestate(statusTracker: WaitingTheFirstDelete())) {
    on<deleteUser>(
      (event, emit) async {
        emit(deletestate(statusTracker: Searching()));

        if (await repo.deleteUser(event.searchedNumber, (onfailed) {
          emit(deletestate(
            statusTracker: NotFoundSearchedNUmber(onfailed),
          ));
        })) {
          emit(deletestate(
            searchedNumber: event.searchedNumber,
            statusTracker: SearchedNumberDeleted(
                'User Deleted with Card Number : \n ${event.searchedNumber},'),
          ));
        }
      },
    );
  }
}
