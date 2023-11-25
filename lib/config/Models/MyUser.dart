class MyUser {
  String name, id, email;
  MyUser({
    required this.name,
    required this.id,
    required this.email,
  });
  factory MyUser.fromJson(Map<String, dynamic> json) {
    return MyUser(
      name: json['name'],
      id: json['id'],
      email: json['email'],
    );
  }
}
