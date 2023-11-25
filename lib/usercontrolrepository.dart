// ignore_for_file: camel_case_types, avoid_print

import 'dart:convert';

import 'package:mondecare/config/Models/Customer.dart';
import 'package:http/http.dart' as http;
import 'package:mondecare/core/utils/Backend/Backend.dart';

class usercontrolrepository {
  static const String firebaseApiKey =
      'AIzaSyCOv1iqZLuMtoOlPnehDbonzipB0izq9Ro';
  static const String firebaseAuthURL =
      'https://identitytoolkit.googleapis.com/v1/accounts';
  static const String firestoreURL =
      'https://firestore.googleapis.com/v1/projects/mondecare-3b42f/databases/(default)/documents';

  Future<bool> createCustomer({
    required Customer customer,
    required Function(dynamic success) onSuccess,
    required Function(dynamic error) onFailed,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$firestoreURL/${Backend.users}'),
        body: json.encode(customer.toMapWithType()),
        headers: {'Content-Type': 'application/json'},
      );
      print(response);
      if (response.statusCode == 200) {
        onSuccess(
            {'success': true, 'message': 'Customer Registered Successfully'});
        return true;
      } else {
        print(json.decode(response.body));
        onFailed(json.decode(response.body));
        return false;
      }
    } catch (e) {
      print(e.toString());
      onFailed({'success': false, 'message': e.toString()});
      return false;
    }
  }

  static Future<Customer?> getCustomerByCardNumber(String cardNumber) async {
    try {
      final response = await http.get(
        Uri.parse('$firestoreURL/${Backend.users}?q=cardNumber==$cardNumber'),
      );
      print(response);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> documents = data['documents'] ?? [];

        if (documents.isNotEmpty) {
          final Map<String, dynamic> userData = documents.first['fields'];
          return Customer(
            AdminName: userData['AdminName']['stringValue'],
            CustomerName: userData['CustomerName']['stringValue'],
            CardNumber: userData['CardNumber']['stringValue'],
            IdentityNumber: userData['IdentityNumber']['stringValue'],
            PhoneNumber: userData['PhoneNumber']['stringValue'],
            Country: userData['Country']['stringValue'],
            CardType: userData['CardType']['stringValue'],
            MemberShipDate:
                DateTime.parse(userData['MemberShipDate']['stringValue']),
            Birthday: DateTime.parse(userData['birthday']['stringValue']),
          );
        }
      }
    } catch (e) {
      print(e.toString());
    }
    return null;
  }
}
