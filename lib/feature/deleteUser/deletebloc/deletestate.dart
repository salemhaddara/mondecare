// ignore_for_file: camel_case_types

import 'package:mondecare/feature/deleteUser/deletebloc/searchStateTracker/deleteStatusTracker.dart';

class deletestate {
  String searchedNumber;
  deleteStatusTracker statusTracker;
  deletestate({
    this.searchedNumber = '',
    required this.statusTracker,
  });
}
