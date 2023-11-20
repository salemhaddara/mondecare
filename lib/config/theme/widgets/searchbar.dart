// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mondecare/config/theme/colors.dart';

class searchbar extends StatelessWidget {
  final String hint;
  final bool? autofocus;
  final Function(String?) onChanged;
  final Function onSearchTapped;
  const searchbar({
    Key? key,
    required this.hint,
    required this.onChanged,
    this.autofocus,
    required this.onSearchTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      height: 54,
      alignment: Alignment.center,
      constraints: const BoxConstraints(maxWidth: 500),
      width: MediaQuery.of(context).size.width,
      child: Row(children: [
        Expanded(
          flex: 3,
          child: TextFormField(
            onChanged: (text) {
              onChanged(text);
            },
            cursorColor: darkgrey,
            autofocus: autofocus ?? false,
            style: GoogleFonts.nunitoSans(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,
                color: darkgrey),
            decoration: InputDecoration(
                fillColor: white,
                filled: true,
                hintText: hint,
                contentPadding: const EdgeInsets.all(15),
                hintStyle: GoogleFonts.nunitoSans(
                    color: grey, fontWeight: FontWeight.w400, fontSize: 16),
                enabledBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(13)),
                    borderSide: BorderSide(color: darkgrey, width: 1)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(13)),
                    borderSide: BorderSide(color: darkgrey, width: 1))),
          ),
        ),
        Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Container(
                  height: double.infinity,
                  decoration: BoxDecoration(
                      color: darkgrey,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(14))),
                  child: InkWell(
                    borderRadius: const BorderRadius.all(Radius.circular(14)),
                    onTap: () {
                      onSearchTapped();
                    },
                    child: const Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                  )),
            ))
      ]),
    );
  }
}
