import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:mondecare/config/Models/MyUser.dart';
import 'package:uuid/v1.dart';
import 'package:mondecare/core/utils/Backend/Backend.dart';

class AuthRepository {
  //FUNCTION FINISHED
  Future<void> login(
    String userName,
    String password,
    Function(MyUser success) onSuccess,
    Function(dynamic error) onFailed,
  ) async {
    bool isUsername = userName.length < 8;
    try {
      if (isUsername) {
        MyUser? user = await getUserByUserName(userName);
        if (user != null) {
          if (md5.convert(utf8.encode(password)).toString() == user.password) {
            await onSuccess(user);
          } else {
            await onFailed('Password Is Not Correct');
          }
        } else {
          await onFailed('User Not Found');
        }
      }
    } on SocketException {
      await onFailed('Check Your internet Connection');
    } catch (e) {
      await onFailed('Server Error');
    }
  }

//FINISHED FUNCTION
  Future<Map<String, dynamic>?> getUserByUserNameMapReturn(
      String searchedUserName) async {
    try {
      final response = await http.get(
        Uri.parse('$firestoreURL/users'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> users = data['documents'];
        for (var user in users) {
          final username = user['fields']['username']['stringValue'];
          if (username == searchedUserName) {
            return {
              'user': MyUser(
                  firstName: user['fields']['firstName']['stringValue'],
                  lastName: user['fields']['lastName']['stringValue'],
                  id: user['fields']['id']['stringValue'],
                  country: user['fields']['country']['stringValue'],
                  phoneNumber: user['fields']['phoneNumber']['stringValue'],
                  userName: username,
                  question: user['fields']['question']['stringValue'],
                  questionAnswer: user['fields']['questionAnswer']
                      ['stringValue'],
                  password: user['fields']['password']['stringValue']),
              'ref': user['name']
            };
          }
        }
      }
    } catch (e) {}
    return null;
  }

//FINISHED FUNCTION REVIEW
  Future<MyUser?> getUserByUserName(String searchedUsername) async {
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
            return MyUser(
                firstName: user['fields']['firstName']['stringValue'],
                lastName: user['fields']['lastName']['stringValue'],
                country: user['fields']['country']['stringValue'],
                phoneNumber: user['fields']['phoneNumber']['stringValue'],
                id: user['fields']['id']['stringValue'],
                userName: username,
                question: user['fields']['question']['stringValue'],
                questionAnswer: user['fields']['questionAnswer']['stringValue'],
                password: user['fields']['password']['stringValue']);
          }
        }
      }
    } catch (e) {}
    return null;
  }

//HERE WE CAN SAY THAT IS FINISH (MISSING PASSWORD FIXING)
  Future<void> signUpUser({
    required String firstName,
    required String lastName,
    required String password,
    required String username,
    required String phoneNumber,
    required String country,
    required String question,
    required String questionAnswer,
    required Function(dynamic success) onSuccess,
    required Function(dynamic error) onFailed,
  }) async {
    try {
      MyUser? existingUser = await getUserByUserName(username);
      if (existingUser != null) {
        onFailed('Username already exists');
        return;
      }

      await http.post(
        Uri.parse('$firestoreURL/users'),
        body: json.encode({
          'fields': {
            'id': {'stringValue': const UuidV1().generate()},
            'firstName': {'stringValue': firstName},
            'lastName': {'stringValue': lastName},
            'userName': {'stringValue': username},
            'question': {'stringValue': question},
            'phoneNumber': {'stringValue': phoneNumber},
            'country': {'stringValue': country},
            'questionAnswer': {'stringValue': questionAnswer},
            'password': {
              'stringValue': md5.convert(utf8.encode(password)).toString()
            }
          },
        }),
        headers: {'Content-Type': 'application/json'},
      );

      onSuccess({'success': true, 'message': 'User Registered Successfully'});
    } on SocketException {
      onFailed('Check Your Ineternet Connection');
    } catch (e) {
      onFailed('Error: $e');
    }
  }

  Future<List<MyUser>> getAllUsersFromFirestore() async {
    try {
      final response = await http.get(
        Uri.parse('$firestoreURL/users'),
      );
      final List<MyUser> users = [];
      print(response.body);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data.containsKey('documents')) {
          final List<dynamic> documents = data['documents'];

          for (final doc in documents) {
            final fields = doc['fields'] as Map<String, dynamic>?;

            if (fields != null) {
              final user = MyUser.fromJson({
                'firstName': fields['firstName']['stringValue'],
                'lastName': fields['lastName']['stringValue'],
                'id': fields['id']['stringValue'],
                'phoneNumber': fields['phoneNumber']['stringValue'],
                'userName': fields['userName']['stringValue'],
                'country': fields['country']['stringValue'],
                'question': fields['question']['stringValue'],
                'questionAnswer': fields['questionAnswer']['stringValue'],
                'password': fields['password']['stringValue']
              });
              users.add(user);
            }
          }
        }
      }
      return users;
    } catch (e) {
      return [];
    }
  }

  Future<Map<String, dynamic>> deleteUser(String username) async {
    try {
      // Fetch user details and document reference from Firestore
      Map<String, dynamic>? userResponse =
          await getUserByUserNameMapReturn(username);
      if (userResponse != null) {
        String documentReference = userResponse['ref'];
        final firestoreDeleteResponse = await http.delete(
          Uri.parse('$domainName$documentReference'),
          headers: {'Content-Type': 'application/json'},
        );

        if (firestoreDeleteResponse.statusCode == 200) {
          return {
            'status': 'success',
            'message': 'Delete succesful',
          };
        }
      }
      return {
        'status': 'success',
        'message': 'User Reference Not Reached',
      };
    } on SocketException {
      return {
        'status': 'error',
        'message': 'Check Your Internet Connection',
      };
    } catch (e) {
      return {
        'status': 'success',
        'message': 'Unknown Server error',
      };
    }
  }
}
