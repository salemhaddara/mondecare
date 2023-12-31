// ignore_for_file: camel_case_types,file_names

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mondecare/config/Models/logEvent.dart';
import 'package:mondecare/core/utils/Backend/Backend.dart';
import 'package:mondecare/core/utils/Preferences/Preferences.dart';

class deleteRepository {
  Future<Map<String, dynamic>> deleteUser(
      Map<String, dynamic> userEntry) async {
    try {
      final documentId = userEntry['name'].split('/').last;
      final deleteResponse =
          await http.delete(Uri.parse('$firestoreURL/customers/$documentId'));
      await saveloginLog(user: userEntry['fields']['userName'], type: 'Delete');
      if (deleteResponse.statusCode == 200) {
        return {'status': 'success', 'message': 'Deleted user successfully'};
      } else {
        return {'status': 'error', 'message': 'Failed to delete user'};
      }
    } catch (e) {
      return {'status': 'error', 'message': 'Failed to delete user'};
    }
  }

  Future<void> saveloginLog({String? user, String? type}) async {
    await http.post(
      Uri.parse('$firestoreURL/logs'),
      body: json.encode(
        logEvent(
          user: user ?? 'N/A',
          admin: (await Preferences.getUserName() ?? ''),
          type: type ?? 'N/A',
          time: DateTime.now(),
        ).toMapWithType(),
      ),
      headers: {'Content-Type': 'application/json'},
    );
  }

  Future<Map<String, dynamic>> searchUsertoDelete(
      String cardNumber, Function(String) onFailed) async {
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
            return {'status': 'success', 'data': userEntry};
          } else {
            onFailed('No Users Found With This Card Number');
            return {'status': 'error'};
          }
        } else {
          onFailed('No documents found');
          return {'status': 'error'};
        }
      } else {
        onFailed('Failed to fetch data');
        return {'status': 'error'};
      }
    } catch (e) {
      onFailed(e.toString());
      return {'status': 'error'};
    }
  }
}
