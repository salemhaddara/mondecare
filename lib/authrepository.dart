// ignore_for_file: camel_case_types, invalid_return_type_for_catch_error

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mondecare/config/Models/MyUser.dart';
import 'package:mondecare/core/utils/Backend/Backend.dart';
import 'package:mondecare/core/utils/Backend/UsertoMap.dart';
import 'package:mondecare/core/utils/Preferences/Preferences.dart';

class authrepository {
  late FirebaseFirestore db;

  authrepository() {
    db = FirebaseFirestore.instance;
  }
  login(
    String email,
    String password,
    Function(dynamic success) onSuccess,
    Function(dynamic error) onFailed,
  ) async {
    try {
      final credentialinfo = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      await db
          .collection(Backend.customers)
          .where(Backend.idField, isEqualTo: credentialinfo.user!.uid)
          .get()
          .then((value) async {
        await Preferences.saveEmail(await value.docs[0][Backend.emailField]);
        await Preferences.saveName(await value.docs[0][Backend.nameField]);
        await Preferences.saveUserId(await value.docs[0][Backend.idField]);
      });
      await onSuccess(credentialinfo);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        await onFailed('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        await onFailed('Wrong password provided for that user.');
      } else if (e.code == 'INVALID_LOGIN_CREDENTIALS') {
        await onFailed('Invalid Credentials');
      } else {
        await onFailed('Invalid Credentials');
      }
    }
  }

  Future<bool> signUpUser({
    required String name,
    required String email,
    required String password,
    required Function(dynamic success) onSuccess,
    required Function(dynamic error) onFailed,
  }) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      QuerySnapshot documents = await db
          .collection(Backend.customers)
          .where(Backend.emailField, isEqualTo: email)
          .get();
      if (documents.docs.isEmpty) {
        await db.collection(Backend.customers).add(
              UsertoMap.convert(MyUser(
                id: userCredential.user!.uid,
                name: name,
                email: email,
              )),
            );
        onSuccess({'success': true, 'message': 'User Registered Successfully'});
        return true;
      } else {
        onFailed({'success': false, 'message': 'User Already Exists'});
        return false;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        onFailed({'success': false, 'message': 'Weak password'});
      } else if (e.code == 'email-already-in-use') {
        onFailed({'success': false, 'message': 'Email already in use'});
      } else {
        onFailed({'success': false, 'message': e.toString()});
      }
      return false;
    } catch (e) {
      onFailed({'success': false, 'message': e.toString()});
      return false;
    }
  }
}
