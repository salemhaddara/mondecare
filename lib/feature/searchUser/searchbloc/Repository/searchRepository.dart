import 'dart:convert';

import 'package:mondecare/config/Models/Customer.dart';
import 'package:http/http.dart' as http;

class searchRepository {
  static const String firebaseApiKey =
      'AIzaSyCOv1iqZLuMtoOlPnehDbonzipB0izq9Ro';
  static const String firebaseAuthURL =
      'https://identitytoolkit.googleapis.com/v1/accounts';
  static const String firestoreURL =
      'https://firestore.googleapis.com/v1/projects/mondecare-3b42f/databases/(default)/documents';

  Future<Customer?> searchUser(
      String cardNumber, Function(String) onfailed) async {
    try {
      final response = await http.get(
        Uri.parse('$firestoreURL/customers'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> documents = data['documents'];

        final user = documents.firstWhere(
          (doc) =>
              doc['fields'] != null &&
              doc['fields']['CardNumber']['stringValue'] == cardNumber,
          orElse: () => null,
        );

        if (user != null) {
          final userData = user['fields'];
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
            Birthday: DateTime.parse(userData['Birthday']['stringValue']),
          );
        } else {
          onfailed('No Users Found With This Card Number');
        }
      } else {
        onfailed('Failed to fetch data');
      }
    } catch (e) {
      onfailed(e.toString());
    }

    return null;
  }
}
