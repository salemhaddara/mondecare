// ignore_for_file: camel_case_types, file_names

abstract class searchStatusTracker {}

class WaitingTheFirstSearch extends searchStatusTracker {}

class Searching extends searchStatusTracker {}

class NotFoundSearchedNUmber extends searchStatusTracker {}

class SearchedNumberFound extends searchStatusTracker {}
