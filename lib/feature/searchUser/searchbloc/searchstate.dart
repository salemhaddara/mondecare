import 'package:mondecare/config/Models/Customer.dart';

class searchstate {
  Customer? customer;
  String searchedNumber;
  bool working;
  String message;
  searchstate(
      {this.customer,
      this.searchedNumber = '',
      this.working = false,
      required this.message});
}
