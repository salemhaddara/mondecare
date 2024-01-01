// ignore_for_file: camel_case_types, file_names

abstract class forgetPass_event {}

class updatePass extends forgetPass_event {
  String newPass, question, answer, username;
  updatePass(
      {required this.newPass,
      required this.question,
      required this.answer,
      required this.username});
}

class returnInitial extends forgetPass_event {}
