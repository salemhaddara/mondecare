import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mondecare/config/Models/MyUser.dart';

class AuthRepository {
  static const String firebaseApiKey =
      'AIzaSyCOv1iqZLuMtoOlPnehDbonzipB0izq9Ro';
  static const String firebaseAuthURL =
      'https://identitytoolkit.googleapis.com/v1/accounts';
  static const String firestoreURL =
      'https://firestore.googleapis.com/v1/projects/mondecare-3b42f/databases/(default)/documents';

  Future<void> login(
    String email,
    String password,
    Function(MyUser success) onSuccess,
    Function(dynamic error) onFailed,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$firebaseAuthURL:signInWithPassword?key=$firebaseApiKey'),
        body: json.encode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        MyUser? user = await getUserByEmail(email);
        if (user != null) {
          await onSuccess(user);
        } else {
          await onFailed('User Data Not Found');
        }
      } else {
        await onFailed(json.decode(response.body)['error']['message']);
      }
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

        // Search for the user by email
        for (var user in users) {
          final userEmail = user['fields']['email']['stringValue'];
          print(userEmail);
          if (userEmail == email) {
            return MyUser(
              name: user['fields']['name']['stringValue'],
              id: user['name'],
              email: userEmail,
            );
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
    required Function(dynamic success) onSuccess,
    required Function(dynamic error) onFailed,
  }) async {
    try {
      MyUser? existingUser = await getUserByEmail(email);
      if (existingUser != null) {
        onFailed('User already exists');
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

        // Example: Add user details to Firestore
        await http.post(
          Uri.parse('$firestoreURL/users'),
          body: json.encode({
            'fields': {
              'userId': {'stringValue': userId},
              'name': {'stringValue': name},
              'email': {'stringValue': email},
            },
          }),
          headers: {'Content-Type': 'application/json'},
        );

        onSuccess({'success': true, 'message': 'User Registered Successfully'});
      } else {
        onFailed(json.decode(response.body));
      }
    } catch (e) {
      onFailed('Error: $e');
    }
  }

  Future<List<MyUser>> getAllUsersFromFirestore() async {
    try {
      final response = await http.get(
        Uri.parse('$firestoreURL/collectionName.json'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<MyUser> users = [];

        data.forEach((key, value) {
          final user = MyUser.fromJson({
            'name': value['name'],
            'id': key,
            'email': value['email'],
          });
          users.add(user);
        });

        return users;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }
}
