// ignore_for_file: camel_case_types, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mondecare/config/theme/colors.dart';
import 'package:mondecare/config/theme/widgets/text400normal.dart';
import 'package:mondecare/core/routes/routes.dart';

class drawer extends StatefulWidget {
  int choosed;
  drawer({super.key, required this.choosed});

  @override
  State<drawer> createState() => _drawerState();
}

class _drawerState extends State<drawer> {
  late Size size;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Drawer(
      backgroundColor: darkgrey,
      child: ListView(physics: const BouncingScrollPhysics(), children: [
        _drawerhead(context),
        _drawerlist(size),
      ]),
    );
  }

  _drawerhead(BuildContext context) {
    return SvgPicture.asset(
      'assets/images/iconwhite.svg',
      height: MediaQuery.of(context).size.height * 0.2,
      width: MediaQuery.of(context).size.height * 0.2,
    );
  }

  _drawerlist(Size size) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          Container(
            height: 1,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(2)),
                color: white),
            margin: EdgeInsets.symmetric(horizontal: size.width * 0.05),
          ),
          _drawerlistItem(
            size,
            'Dashboard',
            'home',
            widget.choosed == 1,
            homescreenRoute,
          ),
          _drawerlistItem(
            size,
            'Search User',
            'searchuserwhite',
            widget.choosed == 2,
            searchUserRoute,
          ),
          _drawerlistItem(
            size,
            'Add User',
            'adduserwhite',
            widget.choosed == 3,
            addUserRoute,
          ),
          _drawerlistItem(
            size,
            'Insights',
            'insightswhite',
            widget.choosed == 4,
            homescreenRoute,
          ),
          _drawerlistItem(
            size,
            'Admins',
            'adminwhite',
            widget.choosed == 5,
            homescreenRoute,
          ),
          _drawerlistItem(
            size,
            'Delete User',
            'deleteuserwhite',
            widget.choosed == 6,
            deleteUserScreenRoute,
          ),
          _drawerlistItem(
            size,
            'Logs',
            'logswhite',
            widget.choosed == 7,
            logsScreenRoute,
          ),
        ],
      ),
    );
  }

  _drawerlistItem(
      Size size, String title, String imagePath, bool choosed, String route) {
    return Column(
      children: [
        Container(
          height: 0.5,
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(2)),
              color: white),
          margin: EdgeInsets.symmetric(horizontal: size.width * 0.05),
        ),
        InkWell(
          onTap: () {
            Navigator.of(context).pushReplacementNamed(route);
          },
          child: Container(
            height: size.height * 0.08,
            padding: const EdgeInsets.all(10),
            width: double.infinity,
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: SvgPicture.asset(
                    'assets/images/$imagePath.svg',
                    height: size.height * 0.03,
                  ),
                ),
                Expanded(
                    flex: 3,
                    child: text400normal(
                      data: title,
                      fontsize: size.height * 0.017,
                      align: TextAlign.start,
                      textColor: white,
                    )),
                Expanded(
                    flex: 1,
                    child: Visibility(
                        visible: choosed,
                        child: SvgPicture.asset('assets/images/choosed.svg')))
              ],
            ),
          ),
        ),
      ],
    );
  }
}
