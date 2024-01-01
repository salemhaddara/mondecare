// ignore_for_file: camel_case_types,file_names

import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:mondecare/config/Models/MyUser.dart';
import 'package:mondecare/core/utils/Backend/Backend.dart';

class forgetPassRepo {
  Future<Map<String, dynamic>?> getUserByUserName(
      String searchedUsername) async {
    try {
      final response = await http.get(
        Uri.parse('$firestoreURL/users'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> users = data['documents'];
        for (var user in users) {
          final username = user['fields']['userName']['stringValue'];
          if (username == searchedUsername) {
            return {
              'user': MyUser(
                firstName: user['fields']['firstName']['stringValue'],
                lastName: user['fields']['lastName']['stringValue'],
                country: user['fields']['country']['stringValue'],
                phoneNumber: user['fields']['phoneNumber']['stringValue'],
                id: user['fields']['id']['stringValue'],
                userName: username,
                question: user['fields']['question']['stringValue'],
                questionAnswer: user['fields']['questionAnswer']['stringValue'],
                password: user['fields']['password']['stringValue'],
              ),
              'documentName': user['name'],
            };
          }
        }
      }
    } catch (e) {}
    return null;
  }

  Future<Map<String, dynamic>> updatePass(
      String question, answer, newPass, username) async {
    try {
      Map<String, dynamic>? userData = await getUserByUserName(username);

      if (userData != null) {
        MyUser user = userData['user'] as MyUser;
        String documentName = userData['documentName'] as String;
        if (user.question == question && user.questionAnswer == answer) {
          final Map<String, dynamic> updatedData = {
            'password': {
              'stringValue': md5.convert(utf8.encode(newPass)).toString()
            }
          };
          final updateResponse = await http.patch(
            Uri.parse(
                '$domainName$documentName?updateMask.fieldPaths=password'),
            body: json.encode({'fields': updatedData}),
            headers: {
              'Content-Type': 'application/json',
            },
          );

          if (updateResponse.statusCode == 200) {
            return {'status': 'success', 'message': 'Password updated'};
          } else {
            return {'status': 'error', 'message': 'Failed to update password'};
          }
        } else {
          return {
            'status': 'error',
            'message': 'Question And Answer are not accurate'
          };
        }
      } else {
        return {'status': 'error', 'message': 'User Not Found'};
      }
    } on SocketException {
      return {'status': 'error', 'message': 'Check Your Internet Connection'};
    } catch (e) {
      return {'status': 'error', 'message': 'Unknown Server Error'};
    }
  }
}
