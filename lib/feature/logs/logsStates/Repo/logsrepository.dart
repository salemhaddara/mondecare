// ignore_for_file: camel_case_types

import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:mondecare/config/Models/logEvent.dart';

class logsrepository {
  static const String firebaseApiKey =
      'AIzaSyCOv1iqZLuMtoOlPnehDbonzipB0izq9Ro';
  static const String firebaseAuthURL =
      'https://identitytoolkit.googleapis.com/v1/accounts';
  static const String firestoreURL =
      'https://firestore.googleapis.com/v1/projects/mondecare-3b42f/databases/(default)/documents';

  Future<List<logEvent>> fetchLogsFromFirestore() async {
    try {
      final response = await http.get(
        Uri.parse('$firestoreURL/logs'),
      );

      if (response.statusCode == 200) {
        print(response.body);

        final List<logEvent> logEvents = [];
        final List<dynamic> data = json.decode(response.body)['documents'];
        for (var doc in data) {
          final Map<String, dynamic> fields = doc['fields'];
          logEvents.add(logEvent.fromMap({
            'user': fields['user']['stringValue'],
            'admin': fields['admin']['stringValue'],
            'time': fields['time']['stringValue'],
            'type': fields['type']['stringValue'],
          }));
        }
        logEvents.sort((a, b) => b.time.compareTo(a.time));

        return logEvents;
      } else {
        print('Error: ${response.body}');
        return [];
      }
    } catch (e) {
      print('Exception: $e');
      return [];
    }
  }
}
