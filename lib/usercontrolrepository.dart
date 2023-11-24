import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mondecare/config/Models/Customer.dart';
import 'package:mondecare/config/Models/logEvent.dart';
import 'package:mondecare/core/utils/Backend/Backend.dart';

class usercontrolrepository {
  late FirebaseFirestore db;
  usercontrolrepository() {
    db = FirebaseFirestore.instance;
  }
  Future<bool> createCustomer({
    required Customer customer,
    required Function(dynamic success) onSuccess,
    required Function(dynamic error) onFailed,
  }) async {
    try {
      QuerySnapshot documents = await db
          .collection(Backend.users)
          .where(Backend.CardNumber, isEqualTo: customer.CardNumber)
          .get();
      if (documents.docs.isEmpty) {
        await db.collection(Backend.users).add(customer.toMap()).then((value) {
          db.collection(Backend.users).doc(value.id).update({
            'CustomerID': value.id,
          }).then((value) async {
            await db.collection('logs').add(logEvent(customer.CardNumber,
                    customer.AdminName, DateTime.now(), 'add')
                .toMap());
            onSuccess({
              'success': true,
              'message': 'Customer Registered Successfully'
            });
          }).catchError((onError) {
            onFailed({'success': false, 'message': onError.toString()});
          });
          return true;
        }).catchError((e) {
          onFailed({'success': false, 'message': e.toString()});
          return false;
        });
        return true;
      } else {
        onFailed({'success': false, 'message': 'Customer Already Exists'});
        return false;
      }
    } catch (e) {
      onFailed({'success': false, 'message': e.toString()});
      return false;
    }
  }
}
