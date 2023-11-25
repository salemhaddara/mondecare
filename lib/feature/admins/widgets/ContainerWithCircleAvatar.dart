// ignore_for_file: must_be_immutable,file_names

import 'package:flutter/material.dart';
import 'package:mondecare/config/theme/widgets/text400normal.dart';

class ContainerWithCircleAvatar extends StatelessWidget {
  String name, id, email;
  double fontsize;
  ContainerWithCircleAvatar(
      {super.key,
      required this.name,
      required this.email,
      required this.id,
      required this.fontsize});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Material(
        borderRadius: BorderRadius.circular(14.0),
        elevation: 4.0,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600.0),
          margin: const EdgeInsets.all(10.0),
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 30.0,
                backgroundImage: AssetImage('assets/images/person.png'),
              ),
              const SizedBox(width: 20.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  text400normal(
                    data: 'Name : $name',
                    fontsize: fontsize,
                  ),
                  text400normal(
                    data: 'Email : $email',
                    fontsize: fontsize,
                  ),
                  text400normal(
                    data: 'id : $id',
                    fontsize: fontsize,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
