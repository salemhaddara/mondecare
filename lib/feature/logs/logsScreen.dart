// ignore_for_file: camel_case_types, file_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mondecare/config/Models/logEvent.dart';
import 'package:mondecare/config/theme/colors.dart';
import 'package:mondecare/config/theme/widgets/drawer.dart';
import 'package:mondecare/config/theme/widgets/text400normal.dart';
import 'package:mondecare/feature/logs/logsStates/Repo/logsrepository.dart';
import 'package:mondecare/feature/logs/logsStates/logsStatus/logsStatus.dart';
import 'package:mondecare/feature/logs/logsStates/logs_bloc.dart';
import 'package:mondecare/feature/logs/logsStates/logs_event.dart';
import 'package:mondecare/feature/logs/logsStates/logs_state.dart';

class logsScreen extends StatefulWidget {
  const logsScreen({super.key});

  @override
  State<logsScreen> createState() => _logsScreenState();
}

class _logsScreenState extends State<logsScreen> {
  late Size size;
  List<logEvent> logs = List.empty(growable: true);
  bool addedData = false;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      drawer: drawer(choosed: 7),
      appBar: AppBar(
        backgroundColor: white,
        foregroundColor: darkgrey,
        title: text400normal(
          data: 'Logs',
          fontsize: MediaQuery.of(context).size.height * 0.025,
          fontWeight: FontWeight.w600,
        ),
        centerTitle: true,
      ),
      body: BlocProvider(
        create: (context) =>
            logs_bloc(context.read<logsrepository>())..add(requestLogs()),
        child: _listview(size),
      ),
    );
  }

  _listview(Size size) {
    return BlocBuilder<logs_bloc, logs_state>(builder: ((context, state) {
      print(state.status.toString());
      if (state.status is fetchingLogsdataFailed) {
        print((state.status as fetchingLogsdataFailed).exception);
      }
      if (state.status is dataLogsGetted && !addedData) {
        logs.addAll((state.status as dataLogsGetted).logsevents);
        addedData = true;
        print(logs);
      }
      return Center(
        child: Container(
          alignment: Alignment.center,
          constraints: const BoxConstraints(maxWidth: 600),
          child: ListView.builder(
              padding: const EdgeInsets.all(0),
              physics: const BouncingScrollPhysics(),
              itemCount: state.status is dataLogsGetted
                  ? (state.status as dataLogsGetted).logsevents.length + 3
                  : 3,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return _logsTitle(size);
                } else if (index == 1) {
                  return _logsHeader(
                      size, 'Admin', 'Type', 'User Modified', 'Time', true);
                } else if (index == 2) {
                  if (state.status is fetchingLogsData) {
                    return Container(
                        alignment: Alignment.center,
                        child: text400normal(
                          data: 'fetching logs...',
                          textColor: darkgrey,
                          fontsize: size.height * 0.017,
                        ));
                  } else {
                    return Container();
                  }
                }
                return _logsHeader(
                    size,
                    logs[index - 3].admin,
                    logs[index - 3].type,
                    logs[index - 3].user,
                    dateTimeToTimeStringPlusDate(logs[index - 3].time),
                    false);
              }),
        ),
      );
    }));
  }

  _logsTitle(Size size) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: text400normal(
        data: 'Logs Table',
        fontsize: size.height * 0.04,
        fontWeight: FontWeight.w300,
        align: TextAlign.center,
        textColor: darkgrey,
      ),
    );
  }
}

_logsHeader(Size size, String admin, String type, String user, String date,
    bool isTitle) {
  return Container(
    padding: const EdgeInsets.all(0),
    margin: const EdgeInsets.all(0),
    width: size.width,
    height: size.height * 0.07,
    constraints: const BoxConstraints(maxWidth: 600),
    child: Column(
      children: [
        _logsRow(size, admin, type, user, date, isTitle),
        if (isTitle) _devider(size),
        _devider(size),
      ],
    ),
  );
}

_logsRow(Size size, String admin, String type, String user, String date,
    bool isTitle) {
  return Expanded(
      child: Row(
    children: [
      _rowItem(2, size, admin, isTitle),
      _rowItem(2, size, type, isTitle),
      _rowItem(2, size, user, isTitle),
      _rowItem(2, size, date, isTitle),
    ],
  ));
}

_rowItem(int flex, Size size, String title, bool isTitle) {
  return Expanded(
    flex: flex,
    child: text400normal(
      data: title,
      fontsize: size.height * 0.015,
      align: TextAlign.center,
      fontWeight: isTitle ? FontWeight.w700 : FontWeight.w400,
    ),
  );
}

_devider(Size size) {
  return Container(
    height: 1,
    width: size.width,
    color: darkgrey,
    padding: const EdgeInsets.all(0),
    margin: const EdgeInsets.all(0),
  );
}

String dateTimeToTimeStringPlusDate(DateTime dateTime) {
  String twoDigits(int n) {
    if (n >= 10) {
      return '$n';
    }
    return '0$n';
  }

  String amPm = dateTime.hour < 12 ? 'AM' : 'PM';
  int hour = dateTime.hour % 12;
  hour = hour == 0 ? 12 : hour;

  String formattedTime =
      '${twoDigits(hour)}:${twoDigits(dateTime.minute)} $amPm';
  String formattedDate =
      '${twoDigits(dateTime.day)}/${twoDigits(dateTime.month)}/${dateTime.year}';

  return '$formattedTime - $formattedDate';
}
