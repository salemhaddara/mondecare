// ignore_for_file: camel_case_types

abstract class adminsevent {}

class requestUsers extends adminsevent {
  requestUsers();
}

class deleteAdmin extends adminsevent {
  String username;
  deleteAdmin(this.username);
}
