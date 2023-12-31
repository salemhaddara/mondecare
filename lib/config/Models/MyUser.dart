// ignore_for_file: file_names

class MyUser {
  String firstName,
      lastName,
      id,
      userName,
      password,
      phoneNumber,
      country,
      question,
      questionAnswer;
  MyUser({
    required this.firstName,
    required this.lastName,
    required this.id,
    required this.userName,
    required this.password,
    required this.country,
    required this.phoneNumber,
    required this.question,
    required this.questionAnswer,
  });
  factory MyUser.fromJson(Map<String, dynamic> json) {
    return MyUser(
        firstName: json['firstName'],
        lastName: json['lastName'],
        id: json['id'],
        country: json['country'],
        phoneNumber: json['phoneNumber'],
        userName: json['userName'],
        password: json['password'],
        question: json['question'],
        questionAnswer: json['questionAnswer']);
  }
}
