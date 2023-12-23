import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:mondecare/config/Models/MyUser.dart';

class AuthRepository {
  static const String firebaseApiKey =
      'AIzaSyCOv1iqZLuMtoOlPnehDbonzipB0izq9Ro';
  static const String firebaseAuthURL =
      'https://identitytoolkit.googleapis.com/v1/accounts';
  static const String firestoreURL =
      'https://firestore.googleapis.com/v1/projects/mondecare-3b42f/databases/(default)/documents';
  static const String domainName = 'https://firestore.googleapis.com/v1/';
  Future<void> login(
    String email,
    String password,
    Function(MyUser success) onSuccess,
    Function(dynamic error) onFailed,
  ) async {
    bool isUsername = email.length < 8;
    String emailofUserName = '';
    try {
      if (isUsername) {
        MyUser? user = await getUserByUserName(email);
        if (user != null) {
          emailofUserName = user.email;
        } else {
          await onFailed('User Not Found');
        }
      }
      final response = await http.post(
        Uri.parse('$firebaseAuthURL:signInWithPassword?key=$firebaseApiKey'),
        body: json.encode({
          'email': isUsername ? emailofUserName : email,
          'password': password,
          'returnSecureToken': true,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        MyUser? user =
            await getUserByEmail(isUsername ? emailofUserName : email);
        if (user != null) {
          await onSuccess(user);
        } else {
          await onFailed('User Data Not Found');
        }
      } else {
        await onFailed(json.decode(response.body)['error']['message']);
      }
    } on SocketException {
      await onFailed('Check Your internet Connection');
    } catch (e) {
      print(e.toString());
      await onFailed('Error: $e');
    }
  }

  Future<MyUser?> getUserByEmail(String email) async {
    try {
      final response = await http.get(
        Uri.parse('$firestoreURL/users'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        print(response.body);
        final List<dynamic> users = data['documents'];
        for (var user in users) {
          final userEmail = user['fields']['email']['stringValue'];
          if (userEmail == email) {
            return MyUser(
                name: user['fields']['name']['stringValue'],
                id: user['name'],
                email: userEmail,
                username: user['fields']['username']['stringValue']);
          }
        }
      }
    } catch (e) {}
    return null;
  }

  Future<Map<String, dynamic>?> getUserByUserNameMapReturn(
      String SearchedUsername) async {
    try {
      final response = await http.get(
        Uri.parse('$firestoreURL/users'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> users = data['documents'];
        for (var user in users) {
          final username = user['fields']['username']['stringValue'];
          if (username == SearchedUsername) {
            return {
              'user': MyUser(
                  name: user['fields']['name']['stringValue'],
                  id: user['fields']['id']['stringValue'],
                  email: user['fields']['email']['stringValue'],
                  username: username),
              'ref': user['name']
            };
          }
        }
      }
    } catch (e) {}
    return null;
  }

  Future<MyUser?> getUserByUserName(String SearchedUsername) async {
    try {
      final response = await http.get(
        Uri.parse('$firestoreURL/users'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> users = data['documents'];
        for (var user in users) {
          final username = user['fields']['username']['stringValue'];
          if (username == SearchedUsername) {
            return MyUser(
                name: user['fields']['name']['stringValue'],
                id: user['name'],
                email: user['fields']['email']['stringValue'],
                username: username);
          }
        }
      }
    } catch (e) {}
    return null;
  }

  Future<void> signUpUser({
    required String name,
    required String email,
    required String password,
    required String username,
    required Function(dynamic success) onSuccess,
    required Function(dynamic error) onFailed,
  }) async {
    try {
      MyUser? existingUser = await getUserByEmail(email);
      if (existingUser != null) {
        onFailed('Email already exists');
        return;
      }
      existingUser = await getUserByUserName(username);
      if (existingUser != null) {
        onFailed('Username already exists');
        return;
      }

      final response = await http.post(
        Uri.parse('$firebaseAuthURL:signUp?key=$firebaseApiKey'),
        body: json.encode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final userId = responseData['localId'];

        await http.post(
          Uri.parse('$firestoreURL/users'),
          body: json.encode({
            'fields': {
              'id': {'stringValue': userId},
              'name': {'stringValue': name},
              'email': {'stringValue': email},
              'username': {'stringValue': username}
            },
          }),
          headers: {'Content-Type': 'application/json'},
        );

        onSuccess({'success': true, 'message': 'User Registered Successfully'});
      } else {
        onFailed(json.decode(response.body)['error']['message']);
      }
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

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<MyUser> users = [];

        if (data.containsKey('documents')) {
          final List<dynamic> documents = data['documents'];

          for (final doc in documents) {
            final fields = doc['fields'] as Map<String, dynamic>?;

            if (fields != null) {
              final name = fields['name']?['stringValue'] ?? '';
              final username = fields['username']?['stringValue'] ?? '';
              final id = fields['id']?['stringValue'] ?? '';
              final email = fields['email']?['stringValue'] ?? '';

              final user = MyUser.fromJson({
                'name': name,
                'id': id,
                'email': email,
                'username': username
              });
              users.add(user);
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

  Future<bool> deleteUser(String username) async {
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
        print(Uri.parse('$domainName$documentReference'));
        print(firestoreDeleteResponse.body);

        if (firestoreDeleteResponse.statusCode == 200) {
          return true;
        }
      }
    } on SocketException {
      print('Internet Connection Error');
    } catch (e) {
      print('Error deleting user: $e');
    }
    return false;
  }
}
