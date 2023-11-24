abstract class deleteevent {}

class deleteUser extends deleteevent {
  String searchedNumber;
  deleteUser({required this.searchedNumber});
}
