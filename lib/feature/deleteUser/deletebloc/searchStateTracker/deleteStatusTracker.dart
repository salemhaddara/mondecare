// ignore_for_file: camel_case_types, file_names

abstract class deleteStatusTracker {}

class WaitingTheFirstDelete extends deleteStatusTracker {}

class Searching extends deleteStatusTracker {}

class NotFoundSearchedNUmber extends deleteStatusTracker {
  String exception;
  NotFoundSearchedNUmber(this.exception);
}

class FoundSearchedNumber extends deleteStatusTracker {}

class SearchedNumberDeleted extends deleteStatusTracker {
  String message;
  SearchedNumberDeleted(this.message);
}
