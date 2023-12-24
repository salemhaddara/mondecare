import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:mondecare/config/theme/colors.dart';

import 'inputFormater.dart';

// ignore: camel_case_types, must_be_immutable
class phoneinput extends StatefulWidget {
  Function(PhoneNumber) onChanged;
  Color? color;
  phoneinput({super.key, required this.onChanged, this.color});

  @override
  State<phoneinput> createState() => _phoneinputState();
}

class _phoneinputState extends State<phoneinput> {
  bool isEnabled = false;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 54,
          decoration: BoxDecoration(
              color: widget.color ?? white,
              border: Border.all(width: 2, color: darkgrey),
              borderRadius: const BorderRadius.all(Radius.circular(13))),
        ),
        IntlPhoneField(
          keyboardType: TextInputType.number,
          inputFormatters: [NumericTextInputFormatter()],
          onChanged: (text) {
            setState(() {
              if (!isEnabled) isEnabled = true;
            });

            widget.onChanged(text);
          },
          languageCode: 'en',
          pickerDialogStyle: PickerDialogStyle(
              countryCodeStyle: GoogleFonts.montserrat(
                  color: darkgrey, fontWeight: FontWeight.w500),
              countryNameStyle: GoogleFonts.montserrat(
                  color: darkgrey, fontWeight: FontWeight.w500)),
          decoration: InputDecoration(
            fillColor: white,
            filled: false,
            errorBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(13)),
                borderSide: BorderSide(color: Colors.red)),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(13)),
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(13)),
            ),
            focusedErrorBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(13)),
                borderSide: BorderSide(color: Colors.red)),
          ),
          initialCountryCode: 'EG',
          disableLengthCheck: true,
          cursorColor: darkgrey,
          autovalidateMode: isEnabled
              ? AutovalidateMode.always
              : AutovalidateMode.onUserInteraction,
          style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w400, fontSize: 14, color: darkgrey),
          validator: (text) {
            return null;
          },
        ),
      ],
    );
  }
}
