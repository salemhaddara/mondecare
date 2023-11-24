import 'package:mondecare/config/Models/Customer.dart';

abstract class searchevent {}

class searchUser extends searchevent {
  String searchedNumber;
  searchUser({required this.searchedNumber});
}

class generatePdf extends searchevent {
  Customer customer;
  generatePdf({required this.customer});
}
