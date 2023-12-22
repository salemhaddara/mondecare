class MyUser {
  String name, id, email, username;
  MyUser(
      {required this.name,
      required this.id,
      required this.email,
      required this.username});
  factory MyUser.fromJson(Map<String, dynamic> json) {
    return MyUser(
        name: json['name'],
        id: json['id'],
        email: json['email'],
        username: json['username']);
  }
}
