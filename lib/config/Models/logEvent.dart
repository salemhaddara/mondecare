// ignore_for_file: file_names, camel_case_types

class logEvent {
  String user, type, admin;
  DateTime time;
  logEvent({
    required this.user,
    required this.admin,
    required this.time,
    required this.type,
  });
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
      user: map['user'] as String,
      admin: map['admin'] as String,
      time: DateTime.parse(map['time'] as String).toLocal(),
      type: map['type'] as String,
    );
  }
  Map<String, dynamic> toMapWithType() {
    return {
      "fields": {
        'user': {'stringValue': user},
        'type': {'stringValue': type},
        'admin': {'stringValue': admin},
        'time': {'stringValue': time.toUtc().toIso8601String()},
      }
    };
  }
}
