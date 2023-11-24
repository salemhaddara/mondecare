// ignore_for_file: camel_case_types

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mondecare/authrepository.dart';
import 'package:mondecare/feature/admins/adminsStates/adminsevent.dart';
import 'package:mondecare/feature/admins/adminsStates/adminsstate.dart';

class adminsbloc extends Bloc<adminsevent, adminsstate> {
  authrepository repo;

  adminsbloc(this.repo) : super(adminsstate(users: [])) {
    on<requestUsers>(
      (event, emit) async {
        emit(adminsstate(
          users: await repo.getAllUsersFromCustomersCollection(),
        ));
      },
    );
  }
}
