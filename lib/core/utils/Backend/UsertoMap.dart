// ignore_for_file: file_names

import 'package:mondecare/config/Models/MyUser.dart';
import 'package:mondecare/core/utils/Backend/Backend.dart';

class UsertoMap {
  static Map<String, dynamic> convert(MyUser user) {
    Map<String, dynamic> map = {
      Backend.idField: user.id,
      'userName': user.userName,
      'firstName': user.firstName,
      'lastName': user.lastName,
      'question': user.question,
      'country': user.country,
      'phoneNumber': user.phoneNumber,
      'questionAnswer': user.questionAnswer,
      'password': user.password,
    };
    return map;
  }
}
