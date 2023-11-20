// ignore_for_file: camel_case_types, must_be_immutable

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mondecare/config/theme/colors.dart';

class text400normal extends StatelessWidget {
  String data;
  double fontsize;
  FontWeight? fontWeight;
  Color? textColor;
  TextAlign? align;
  text400normal(
      {super.key,
      required this.data,
      required this.fontsize,
      this.fontWeight,
      this.textColor,
      this.align});

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      textAlign: align ?? TextAlign.start,
      style: GoogleFonts.montserrat(
          fontSize: fontsize,
          fontWeight: fontWeight ?? FontWeight.w400,
          color: textColor ?? darkgrey),
    );
  }
}
