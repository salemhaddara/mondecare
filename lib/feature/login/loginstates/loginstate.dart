// ignore_for_file: camel_case_types

import 'package:mondecare/feature/login/submission/submissionevent.dart';

class loginstate {
  final submissionstatus formstatus;

  loginstate({
    this.formstatus = const initialformstatus(),
  });

  loginstate copyWith({
    required submissionstatus formstatus,
  }) {
    return loginstate(
      formstatus: formstatus,
    );
  }
}
