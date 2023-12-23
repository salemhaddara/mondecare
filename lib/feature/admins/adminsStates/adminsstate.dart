// ignore_for_file: camel_case_types

import 'package:mondecare/config/Models/MyUser.dart';
import 'package:mondecare/feature/admins/deleteAdminTracker/deleteTracker.dart';

class adminsstate {
  List<MyUser> users = List.empty(growable: true);
  deleteTracker? tracker = initialdeleteState();
  adminsstate({required this.users, this.tracker});
  adminsstate copyWith({List<MyUser>? users, deleteTracker? tracker}) {
    return adminsstate(
        users: users ?? this.users, tracker: tracker ?? this.tracker);
  }
}
