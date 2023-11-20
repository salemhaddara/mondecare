import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mondecare/config/Models/Customer.dart';
import 'package:mondecare/core/utils/Backend/Backend.dart';

class searchRepository {
  late FirebaseFirestore db;
  searchRepository() {
    db = FirebaseFirestore.instance;
  }
  Future<Customer?>? searchUser(
    String cardNumber,
    Function(String) onfailed,
  ) async {
    try {
      QuerySnapshot result = await db
          .collection(Backend.users)
          .where(Backend.CardNumber, isEqualTo: cardNumber)
          .get();
      if (result.docs.isNotEmpty) {
        return Customer(
          AdminName: result.docs.first['AdminName'],
          CustomerName: result.docs.first['CustomerName'],
          CustomerID: result.docs.first['CustomerID'],
          CardNumber: result.docs.first['CardNumber'],
          IdentityNumber: result.docs.first['IdentityNumber'],
          PhoneNumber: result.docs.first['PhoneNumber'],
          Country: result.docs.first['Country'],
          CardType: result.docs.first['CardType'],
          MemberShipDate: DateTime.parse(result.docs.first['MemberShipDate']),
          Birthday: DateTime.parse(result.docs.first['Birthday']),
        );
      } else {
        onfailed('No Users Found With This Card Number ');
      }
    } catch (e) {
      print(e.toString());
      onfailed(e.toString());
    }

    return null;
  }
}
