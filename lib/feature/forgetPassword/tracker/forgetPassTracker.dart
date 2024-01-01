// ignore_for_file: file_names, camel_case_types

abstract class forgetPassTracker {}

class initialStateTracker extends forgetPassTracker {}

class loadingStateTracker extends forgetPassTracker {}

class failedStateTracker extends forgetPassTracker {
  String exception;
  failedStateTracker(this.exception);
}

class successstateTracker extends forgetPassTracker {}
