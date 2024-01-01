// ignore_for_file: file_names, camel_case_types

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mondecare/feature/forgetPassword/Repo/forgetPassRepo.dart';
import 'package:mondecare/feature/forgetPassword/state/forgetPass_event.dart';
import 'package:mondecare/feature/forgetPassword/state/forgetPass_state.dart';
import 'package:mondecare/feature/forgetPassword/tracker/forgetPassTracker.dart';

class forgetPass_bloc extends Bloc<forgetPass_event, forgetPass_state> {
  forgetPassRepo repo;
  forgetPass_bloc(this.repo) : super(forgetPass_state(initialStateTracker())) {
    on<updatePass>(
      (event, emit) async {
        emit(forgetPass_state(loadingStateTracker()));
        var response = await repo.updatePass(
          event.question,
          event.answer,
          event.newPass,
          event.username,
        );
        if (response['status'] == 'success') {
          emit(forgetPass_state(successstateTracker()));
        } else {
          emit(forgetPass_state(failedStateTracker(response['message'])));
        }
      },
    );
  }
}
