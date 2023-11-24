// ignore_for_file: camel_case_types

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mondecare/config/Models/logEvent.dart';

class logsrepository {
  Future<List<logEvent>> fetchLogsFromFirestore() async {
    List<logEvent> logEvents = [];
    logEvent logevent;

    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('logs').get();

    for (var doc in querySnapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      logevent = logEvent.fromMap(data);
      logEvents.add(logevent);
    }

    return logEvents;
  }
}
