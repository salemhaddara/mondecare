abstract class searchevent {}

class searchUser extends searchevent {
  String searchedNumber;
  searchUser({required this.searchedNumber});
}
