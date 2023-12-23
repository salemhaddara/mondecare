// ignore_for_file: camel_case_types

abstract class deleteevent {}

class searchUser extends deleteevent {
  String searchedNumber;
  searchUser({required this.searchedNumber});
}

class deleteUser extends deleteevent {
  Map<String, dynamic> userData;
  deleteUser(this.userData);
}
