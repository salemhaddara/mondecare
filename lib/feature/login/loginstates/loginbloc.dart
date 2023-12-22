// ignore_for_file: camel_case_types

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mondecare/authrepository.dart';
import 'package:mondecare/core/utils/Preferences/Preferences.dart';
import 'package:mondecare/feature/login/loginstates/loginevent.dart';
import 'package:mondecare/feature/login/loginstates/loginstate.dart';
import 'package:mondecare/feature/login/submission/submissionevent.dart';

class loginbloc extends Bloc<loginevent, loginstate> {
  final AuthRepository repo;
  loginbloc(this.repo) : super(loginstate()) {
    on<loginSubmitted>((event, emit) async {
      emit(state.copyWith(formstatus: formsubmitting()));
      try {
        await repo.login(event.email, event.password, (success) async {
          if (await Preferences.saveUserId((success.id))) {
            await Preferences.saveUserName(success.username);
            emit(state.copyWith(formstatus: submissionsuccess()));
          } else {
            emit(state.copyWith(
                formstatus: const submissionfailed('Something went Wrong')));
          }
        }, (failed) {
          emit(state.copyWith(formstatus: submissionfailed(failed.toString())));
        });
      } catch (e) {
        emit(state.copyWith(formstatus: submissionfailed(e.toString())));
      }
    });
    on<returnInitialStatus>((event, emit) {
      emit(state.copyWith(formstatus: const initialformstatus()));
    });
  }
}
