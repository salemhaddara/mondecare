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
    on<searchUser>(
      (event, emit) async {
        emit(deletestate(statusTracker: Searching()));
        var response =
            (await repo.searchUsertoDelete(event.searchedNumber, (onfailed) {
          emit(deletestate(
            statusTracker: NotFoundSearchedNUmber(onfailed),
          ));
        }));
        if (response['status'] == 'success') {
          emit(deletestate(
            searchedNumber: event.searchedNumber,
            statusTracker: FoundSearchedNumber(),
            searchedNumberData: response['data'],
          ));
        }
      },
    );
    on<deleteUser>(
      (event, emit) async {
        var response = await repo.deleteUser(event.userData);
        print(response);
        if (response['status'] != 'success') {
          emit(deletestate(
              statusTracker: NotFoundSearchedNUmber('Failed Try Again Later')));
        } else {
          emit(deletestate(
              statusTracker: SearchedNumberDeleted(
                  'Delete Success for card with Number : ${event.userData['fields']['CardNumber']['stringValue']}')));
        }
      },
    );
  }
}
