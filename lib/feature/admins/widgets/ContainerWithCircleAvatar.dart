// ignore_for_file: must_be_immutable,file_names, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:mondecare/config/theme/colors.dart';
import 'package:mondecare/config/theme/widgets/inputfield.dart';
import 'package:mondecare/config/theme/widgets/text400normal.dart';

class ContainerWithCircleAvatar extends StatelessWidget {
  String name, username, country, phoneNumber;
  double fontsize;
  Function(String) OnDeleteClick;
  ContainerWithCircleAvatar(
      {super.key,
      required this.name,
      required this.country,
      required this.username,
      required this.phoneNumber,
      required this.fontsize,
      required this.OnDeleteClick});

  bool isPermitted = false;

  @override
  Widget build(BuildContext context) {
    if (fontsize > 20) {
      fontsize = 20;
    }
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.all(16),
      child: Material(
        borderRadius: BorderRadius.circular(14.0),
        elevation: 4.0,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 800.0),
          margin: const EdgeInsets.all(10.0),
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  alignment: Alignment.center,
                  child: Image.asset('assets/images/user.png'),
                ),
              ),
              const SizedBox(width: 20.0),
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    text400normal(
                      data: name,
                      fontsize: fontsize,
                      fontWeight: FontWeight.w600,
                    ),
                    text400normal(
                      data: 'From : $country',
                      fontsize: fontsize,
                    ),
                    text400normal(
                      data: 'Username : $username',
                      fontsize: fontsize,
                    ),
                    text400normal(
                      data: 'Call me at $phoneNumber',
                      fontsize: fontsize,
                    ),
                    _field(size, 'Enter Your Key To Perform Actions',
                        (text) => {}, false, (text) {
                      if (text == 'mondecarecairo\$#@admin') {
                        isPermitted = true;
                        return null;
                      } else {
                        if (text != null && text.isNotEmpty) {
                          return 'Wrong Key';
                        }
                      }
                      return null;
                    }),
                    Container(
                      height: (MediaQuery.of(context).size.height * 0.05),
                      margin: const EdgeInsets.all(10),
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: () {
                          if (isPermitted) {
                            OnDeleteClick(username);
                          }
                        },
                        borderRadius:
                            const BorderRadius.all(Radius.circular(14)),
                        child: Icon(
                          Icons.delete,
                          color: isPermitted ? darkred : grey,
                          size: (MediaQuery.of(context).size.height * 0.05),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _title(Size size, String title) {
    return Container(
      width: size.width,
      margin: const EdgeInsets.only(bottom: 10),
      constraints: const BoxConstraints(maxWidth: 600),
      child: text400normal(
        data: title,
        textColor: darkgrey,
        fontsize: size.height * 0.017,
        align: TextAlign.start,
      ),
    );
  }

  _field(Size size, String fieldTitle, Function(String?) onChanged,
      bool isNumber, String? Function(String?) validator) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      constraints: const BoxConstraints(maxWidth: 500),
      child: Column(
        children: [
          _title(size, fieldTitle),
          InputField(
              icon: Icons.password_outlined,
              isPassword: false,
              hint: '',
              initialState: false,
              isNumber: isNumber,
              validator: (text) {
                return validator(text);
              },
              onChanged: (text) {
                onChanged(text);
              })
        ],
      ),
    );
  }
}
