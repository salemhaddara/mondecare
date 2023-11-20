import 'package:mondecare/config/Models/Customer.dart';

abstract class adduser_event {}

class SaveUser extends adduser_event {
  Customer customer;
  SaveUser({required this.customer});
}

class returnInitial extends adduser_event {}
