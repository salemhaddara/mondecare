// ignore_for_file: camel_case_types,file_names

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class deleteRepository {
  static const String firebaseApiKey =
      'AIzaSyCOv1iqZLuMtoOlPnehDbonzipB0izq9Ro';
  static const String firebaseAuthURL =
      'https://identitytoolkit.googleapis.com/v1/accounts';
  static const String firestoreURL =
      'https://firestore.googleapis.com/v1/projects/mondecare-3b42f/databases/(default)/documents';

  Future<bool> deleteUser(String cardNumber, Function(String) onFailed) async {
    try {
      final response = await http.get(Uri.parse('$firestoreURL/customers'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final List<dynamic>? documents = data['documents'] as List<dynamic>?;

        if (documents != null && documents.isNotEmpty) {
          final userEntry = documents.firstWhere(
            (entry) =>
                entry is Map<String, dynamic> &&
                entry['fields'] != null &&
                entry['fields']['CardNumber']?['stringValue'] == cardNumber,
            orElse: () => null,
          );

          if (userEntry != null) {
            final documentId = userEntry['name'].split('/').last;
            final deleteResponse = await http
                .delete(Uri.parse('$firestoreURL/customers/$documentId'));

            if (deleteResponse.statusCode == 200) {
              print('Deleted user successfully');
              return true;
            } else {
              onFailed('Failed to delete user');
              return false;
            }
          } else {
            onFailed('No Users Found With This Card Number');
            return false;
          }
        } else {
          onFailed('No documents found');
          return false;
        }
      } else {
        onFailed('Failed to fetch data');
        return false;
      }
    } catch (e) {
      onFailed(e.toString());
      return false;
    }
  }
}
