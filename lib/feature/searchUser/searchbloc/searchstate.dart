import 'package:mondecare/config/Models/Customer.dart';
import 'package:mondecare/feature/searchUser/searchbloc/searchStateTracker/searchStatusTracker.dart';

class searchstate {
  Customer? customer;
  String searchedNumber;
  String message;
  searchStatusTracker statusTracker;
  searchstate(
      {this.customer,
      this.searchedNumber = '',
      required this.message,
      required this.statusTracker});
}
