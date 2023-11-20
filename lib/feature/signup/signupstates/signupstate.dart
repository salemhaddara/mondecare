import 'package:mondecare/feature/signup/signupsubmission/signupsubmissionevent.dart';

class signupstate {
  final String phonenumber;
  bool get isValidPhoneNumber {
    return phonenumber.length > 3;
  }

  final String password;
  bool get isValidPassword {
    return password.isNotEmpty && password.length > 8;
  }

  final String email;
  bool get isValidEmail {
    RegExp emailRegExp = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');

    return emailRegExp.hasMatch(email);
  }

  final String name;

  final signupsubmissionstatus formstatus;

  signupstate({
    this.phonenumber = '',
    this.password = '',
    this.email = '',
    this.name = '',
    this.formstatus = const initialsignupformstatus(),
  });

  signupstate copyWith({
    String? phonenumber,
    String? password,
    String? email,
    String? name,
    signupsubmissionstatus? formstatus,
  }) {
    return signupstate(
      name: name ?? this.name,
      email: email ?? this.email,
      phonenumber: phonenumber ?? this.phonenumber,
      password: password ?? this.password,
      formstatus: formstatus ?? this.formstatus,
    );
  }
}
