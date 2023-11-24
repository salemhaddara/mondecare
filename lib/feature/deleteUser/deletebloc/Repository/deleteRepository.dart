// ignore_for_file: camel_case_types,file_names

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mondecare/core/utils/Backend/Backend.dart';

class deleteRepository {
  late FirebaseFirestore db;
  deleteRepository() {
    db = FirebaseFirestore.instance;
  }
  Future<bool> deleteUser(
    String cardNumber,
    Function(String) onfailed,
  ) async {
    try {
      QuerySnapshot result = await db
          .collection(Backend.users)
          .where(Backend.CardNumber, isEqualTo: cardNumber)
          .get();
      if (result.docs.isNotEmpty) {
        var documentReference = result.docs.first.reference;
        try {
          await documentReference.delete();
          return true;
        } catch (e) {
          onfailed('Something Went Wrong');

          return false;
        }
      } else {
        onfailed('No Users Found With This Card Number ');
        return false;
      }
    } catch (e) {
      onfailed(e.toString());
      return false;
    }
  }
}
