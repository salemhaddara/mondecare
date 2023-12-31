// ignore_for_file: camel_case_types

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mondecare/authrepository.dart';
import 'package:mondecare/core/utils/Preferences/Preferences.dart';
import 'package:mondecare/feature/admins/adminsStates/adminsevent.dart';
import 'package:mondecare/feature/admins/adminsStates/adminsstate.dart';
import 'package:mondecare/feature/admins/deleteAdminTracker/deleteTracker.dart';

class adminsbloc extends Bloc<adminsevent, adminsstate> {
  AuthRepository repo;

  adminsbloc(this.repo) : super(adminsstate(users: [])) {
    on<requestUsers>(
      (event, emit) async {
        emit(state.copyWith(tracker: initialdeleteState(), users: []));
        emit(adminsstate(
            users: await repo.getAllUsersFromFirestore(),
            tracker: initialdeleteState()));
      },
    );
    on<deleteAdmin>(
      (event, emit) async {
        emit(state.copyWith(tracker: deleteLoading()));
        var response = (await repo.deleteUser(event.username));
        bool deleteState = response['status'] == 'success';
        if (deleteState) {
          if ((await Preferences.getUserName()) == event.username) {
            await Preferences.deleteSavedData();
          }
          emit(state.copyWith(tracker: deleteSuccess(), users: []));
        } else {
          emit(state.copyWith(tracker: deleteFailed(response['message'])));
        }
      },
    );
  }
}
