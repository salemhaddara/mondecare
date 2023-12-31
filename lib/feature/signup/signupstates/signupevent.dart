// ignore_for_file: camel_case_types

abstract class signupevent {}

class signupPhoneNumberChanged extends signupevent {
  final String? phoneNumnber;
  signupPhoneNumberChanged({required this.phoneNumnber});
}

class signupPasswordrChanged extends signupevent {
  final String? password;
  signupPasswordrChanged({required this.password});
}

class signupNameChanged extends signupevent {
  final String? name;
  signupNameChanged({required this.name});
}

class signupEmailChanged extends signupevent {
  final String? email;
  signupEmailChanged({required this.email});
}

class signupSubmitted extends signupevent {
  String firstname,
      lastName,
      password,
      username,
      country,
      phoneNumber,
      question,
      questionAnswer;
  signupSubmitted({
    required this.firstname,
    required this.lastName,
    required this.username,
    required this.country,
    required this.password,
    required this.question,
    required this.phoneNumber,
    required this.questionAnswer,
  });
}

class returninitial extends signupevent {}
