// ignore_for_file: camel_case_types

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mondecare/feature/addUser/adduserstates/adduser_event.dart';
import 'package:mondecare/feature/addUser/adduserstates/adduser_state.dart';
import 'package:mondecare/feature/addUser/userAdditionStatus/userAdditionStatus.dart';
import 'package:mondecare/usercontrolrepository.dart';

class adduser_bloc extends Bloc<adduser_event, adduser_state> {
  final usercontrolrepository repo;
  adduser_bloc(this.repo)
      : super(adduser_state(requestStatus: waitingrequest())) {
    on<SaveUser>((event, emit) async {
      emit(state.copyWith(requestStatus: loadingrequest()));
      try {
        await repo.createCustomer(
          customer: event.customer,
          onSuccess: (success) async {},
          onFailed: (error) {
            throw Exception();
          },
        );
        emit(state.copyWith(requestStatus: successInsertion()));
      } catch (e) {
        emit(state.copyWith(requestStatus: failedInsertion(e.toString())));
      }
    });
    on<returnInitial>(
      (event, emit) {
        emit(state.copyWith(requestStatus: waitingrequest()));
      },
    );
  }
}
