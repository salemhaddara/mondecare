import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mondecare/config/Models/Customer.dart';
import 'package:mondecare/feature/searchUser/searchbloc/Repository/searchRepository.dart';
import 'package:mondecare/feature/searchUser/searchbloc/searchStateTracker/searchStatusTracker.dart';
import 'package:mondecare/feature/searchUser/searchbloc/searchevent.dart';
import 'package:mondecare/feature/searchUser/searchbloc/searchstate.dart';

class searchbloc extends Bloc<searchevent, searchstate> {
  searchRepository repo;

  searchbloc(this.repo)
      : super(
            searchstate(message: '', statusTracker: WaitingTheFirstSearch())) {
    on<searchUser>(
      (event, emit) async {
        emit(searchstate(message: 'loading', statusTracker: Searching()));

        Customer? customer =
            await repo.searchUser(event.searchedNumber, (onfailed) {
          emit(searchstate(
            message: onfailed,
            statusTracker: NotFoundSearchedNUmber(),
          ));
        });
        if (customer != null) {
          emit(searchstate(
            customer: customer,
            searchedNumber: event.searchedNumber,
            statusTracker: SearchedNumberFound(),
            message: 'Founded ${customer.CustomerName},',
          ));
        }
      },
    );
  }
}
