// ignore_for_file: file_names, camel_case_types

class logEvent {
  String user, type, admin;
  DateTime time;
  logEvent(this.user, this.admin, this.time, this.type);
  Map<String, dynamic> toMap() {
    return {
      'user': user,
      'type': type,
      'admin': admin,
      'time': time.toUtc().toIso8601String(),
    };
  }

  factory logEvent.fromMap(Map<String, dynamic> map) {
    return logEvent(
      map['user'] as String,
      map['admin'] as String,
      DateTime.parse(map['time'] as String).toLocal(),
      map['type'] as String,
    );
  }
}
