import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mondecare/config/theme/colors.dart';

class signuprichtext extends StatelessWidget {
  final String startText;
  final String clickableText;
  final VoidCallback onClick;
  final double fontsize;
  const signuprichtext({
    super.key,
    required this.startText,
    required this.clickableText,
    required this.onClick,
    required this.fontsize,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: startText,
            style: GoogleFonts.montserrat(
                color: darkgrey,
                fontWeight: FontWeight.w400,
                fontSize: fontsize),
          ),
          TextSpan(
            text: clickableText,
            style: GoogleFonts.montserrat(
              color: gold,
              fontWeight: FontWeight.w400,
              fontSize: fontsize,
            ),
            recognizer: TapGestureRecognizer()..onTap = onClick,
          ),
        ],
      ),
    );
  }
}
