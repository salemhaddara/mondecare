import 'package:flutter/material.dart';
import 'package:mondecare/config/theme/colors.dart';
import 'package:mondecare/config/theme/widgets/text400normal.dart';

SnackBar showSnackbar(String text, Size size) {
  return SnackBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Container(
        constraints:
            const BoxConstraints(maxHeight: 100, minHeight: 50, maxWidth: 500),
        decoration: BoxDecoration(
            color: grey,
            borderRadius: const BorderRadius.all(Radius.circular(25))),
        alignment: Alignment.center,
        child: Column(children: [
          const SizedBox(
            height: 10,
          ),
          Expanded(
              child: text400normal(
            data: text,
            align: TextAlign.center,
            textColor: darkgrey,
            fontsize: 16,
          )),
          const SizedBox(
            height: 10,
          ),
          Container(
            width: 150,
            height: 5,
            margin: const EdgeInsets.symmetric(vertical: 10),
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(50)),
                color: Colors.white),
          )
        ]),
      ));
}
