// ignore_for_file: camel_case_types

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mondecare/authrepository.dart';
import 'package:mondecare/feature/signup/signupstates/signupevent.dart';
import 'package:mondecare/feature/signup/signupstates/signupstate.dart';
import 'package:mondecare/feature/signup/signupsubmission/signupsubmissionevent.dart';

class signupbloc extends Bloc<signupevent, signupstate> {
  final AuthRepository repo;
  signupbloc(this.repo) : super(signupstate()) {
    on<signupSubmitted>((event, emit) async {
      emit(state.copyWith(formstatus: signupformsubmitting()));

      await repo.signUpUser(
          name: event.name,
          email: event.email,
          password: event.password,
          username: event.username,
          onFailed: (message) {
            emit(state.copyWith(formstatus: signupsubmissionfailed(message)));
          },
          onSuccess: (json) {
            emit(state.copyWith(formstatus: signupsubmissionsuccess()));
          });
    });
    on<returninitial>(
      (event, emit) {
        emit(state.copyWith(formstatus: const initialsignupformstatus()));
      },
    );
  }
}
