import 'package:flutter/material.dart';
import 'package:mondecare/feature/addUser/userAdditionStatus/userAdditionStatus.dart';

class adduser_state {
  //Get Request Status In it
  userAdditionStatus requestStatus;

  adduser_state({Key? key, required this.requestStatus});
  //make copyWith Function for copying values from last object if we need to change only one
  adduser_state copyWith({required userAdditionStatus requestStatus}) {
    return adduser_state(requestStatus: requestStatus);
  }
}
