// ignore_for_file: camel_case_types, avoid_print

import 'dart:convert';

import 'package:mondecare/config/Models/Customer.dart';
import 'package:http/http.dart' as http;
import 'package:mondecare/config/Models/logEvent.dart';
import 'package:mondecare/core/utils/Backend/Backend.dart';
import 'package:mondecare/core/utils/Preferences/Preferences.dart';
import 'package:mondecare/feature/searchUser/searchbloc/Repository/searchRepository.dart';

class usercontrolrepository {
  Future<bool> createCustomer({
    required Customer customer,
    required Function(dynamic success) onSuccess,
    required Function(dynamic error) onFailed,
  }) async {
    searchRepository repo = searchRepository();
    try {
      if (await repo.searchUser(customer.CardNumber, (failed) {}) == null) {
        final response = await http.post(
          Uri.parse('$firestoreURL/${Backend.users}'),
          body: json.encode(customer.toMapWithType()),
          headers: {'Content-Type': 'application/json'},
        );
        await saveloginLog(
            user: customer.CustomerName,
            admin: await Preferences.getUserName() ?? 'N/A',
            type: 'add');
        if (response.statusCode == 200) {
          onSuccess(
              {'success': true, 'message': 'Customer Registered Successfully'});

          return true;
        } else {
          print(json.decode(response.body));
          onFailed(json.decode(response.body));
          return false;
        }
      } else {
        onFailed('Customer Already Exists');
        return false;
      }
    } catch (e) {
      print(e.toString());
      onFailed({'success': false, 'message': e.toString()});
      return false;
    }
  }

  Future<void> saveloginLog({String? admin, String? user, String? type}) async {
    await http.post(
      Uri.parse('$firestoreURL/logs'),
      body: json.encode(
        logEvent(
          user: user ?? 'N/A',
          admin: admin ?? 'N/A',
          type: type ?? 'N/A',
          time: DateTime.now(),
        ).toMapWithType(),
      ),
      headers: {'Content-Type': 'application/json'},
    );
  }

  Future<List<Customer>> getAllCustomersFromFirestore() async {
    try {
      final response = await http.get(Uri.parse('$firestoreURL/customers'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<Customer> users = [];

        if (data.containsKey('documents')) {
          final List<dynamic> documents = data['documents'];

          for (final doc in documents) {
            final fields = doc['fields'] as Map<String, dynamic>?;

            if (fields != null) {
              users.add(Customer(
                AdminName: fields['AdminName']['stringValue'],
                CustomerName: fields['CustomerName']['stringValue'],
                CardNumber: fields['CardNumber']['stringValue'],
                IdentityNumber: fields['IdentityNumber']['stringValue'],
                PhoneNumber: fields['PhoneNumber']['stringValue'],
                Country: fields['Country']['stringValue'],
                CardType: fields['CardType']['stringValue'],
                MemberShipDate:
                    DateTime.parse(fields['MemberShipDate']['stringValue']),
                Birthday: DateTime.parse(fields['Birthday']['stringValue']),
              ));
            }
          }
        }

        return users;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }
}
