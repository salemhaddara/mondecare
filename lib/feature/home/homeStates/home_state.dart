import 'package:mondecare/config/Models/Customer.dart';

class home_state {
  List<Customer> customers = List.empty(growable: true);
  home_state({required this.customers});
}
