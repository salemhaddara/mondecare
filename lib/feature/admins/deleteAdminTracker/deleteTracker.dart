// ignore_for_file: camel_case_types, file_names

abstract class deleteTracker {}

class deleteSuccess extends deleteTracker {}

class deleteLoading extends deleteTracker {}

class deleteFailed extends deleteTracker {
  String exception;
  deleteFailed(this.exception);
}

class initialdeleteState extends deleteTracker {}
