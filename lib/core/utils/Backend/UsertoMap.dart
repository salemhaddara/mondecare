import 'package:mondecare/config/Models/MyUser.dart';
import 'package:mondecare/core/utils/Backend/Backend.dart';

class UsertoMap {
  static Map<String, dynamic> convert(MyUser user) {
    Map<String, dynamic> map = {
      Backend.idField: user.id,
      Backend.nameField: user.name,
      Backend.emailField: user.email,
    };
    return map;
  }
}
