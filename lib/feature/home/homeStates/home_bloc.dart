import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mondecare/feature/home/homeStates/home_event.dart';
import 'package:mondecare/feature/home/homeStates/home_state.dart';
import 'package:mondecare/usercontrolrepository.dart';

class home_bloc extends Bloc<home_event, home_state> {
  usercontrolrepository repo;
  home_bloc(this.repo)
      : super(home_state(customers: List.empty(growable: true))) {
    on<fetchData>((event, emit) async {
      emit(home_state(customers: await repo.getAllCustomersFromFirestore()));
    });
    on<saveLog>(
      (event, emit) async {},
    );
  }
}
