// ignore_for_file: camel_case_types, file_names

import 'package:mondecare/config/Models/logEvent.dart';

abstract class logsStatus {}

class initialLogsState extends logsStatus {}

class fetchingLogsData extends logsStatus {}

class nodataLogs extends logsStatus {}

class dataLogsGetted extends logsStatus {
  List<logEvent> logsevents;
  dataLogsGetted({required this.logsevents});
}

class fetchingLogsdataFailed extends logsStatus {
  String exception;
  fetchingLogsdataFailed({required this.exception});
}
