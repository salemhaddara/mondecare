// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mondecare/config/theme/colors.dart';
import 'package:mondecare/config/theme/widgets/drawer.dart';
import 'package:mondecare/config/theme/widgets/text400normal.dart';
import 'package:mondecare/core/routes/routes.dart';

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  late Size size;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: white,
          foregroundColor: darkgrey,
          title: text400normal(
            data: 'Home',
            fontsize: MediaQuery.of(context).size.height * 0.025,
            fontWeight: FontWeight.w600,
          ),
          centerTitle: true,
        ),
        drawer: drawer(
          choosed: 1,
        ),
        body: SafeArea(
          child: LayoutBuilder(builder: (context, constraints) {
            return SizedBox(
                height: constraints.maxHeight,
                width: constraints.maxWidth,
                child: Column(
                  children: [
                    _homeTitle(size),
                    Expanded(
                      child: Stack(
                        children: [
                          _homelist(),
                        ],
                      ),
                    ),
                  ],
                ));
          }),
        ));
  }

  _homelist() {
    return GridView(
      physics: const BouncingScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _calculateCrossAxisCount(context),
        crossAxisSpacing: 12.0,
        mainAxisSpacing: 12.0,
      ),
      children: [
        _homelistItem(size, 'searchuser', 'Search User', searchUserRoute),
        _homelistItem(size, 'adduser', 'Add User', addUserRoute),
        _homelistItem(size, 'admin', 'Admins', allUsersScreenRoute),
        _homelistItem(size, 'deleteuser', 'Delete User', deleteUserScreenRoute),
        _homelistItem(size, 'logs', 'Logs', logsScreenRoute),
      ],
    );
  }

  _homeTitle(Size size) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: text400normal(
        data: 'Control Panel',
        fontsize: size.height * 0.03,
        fontWeight: FontWeight.w300,
        align: TextAlign.center,
        textColor: darkgrey,
      ),
    );
  }

  _homelistItem(Size size, String imagePath, String title, String routeName) {
    return Container(
      margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14.0),
      ),
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(14.0),
        color: Colors.white,
        child: InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(14)),
          onTap: () {
            Navigator.pushNamed(context, routeName);
          },
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Column(
              children: [
                Expanded(
                    flex: 2,
                    child: SvgPicture.asset('assets/images/$imagePath.svg')),
                Expanded(child: Container()),
                Expanded(
                    flex: 1,
                    child: text400normal(
                      data: title,
                      fontsize: size.height * 0.02,
                      fontWeight: FontWeight.w500,
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  int _calculateCrossAxisCount(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    int itemCountPerRow = screenWidth ~/ 180;
    if (screenWidth > 600) {
      itemCountPerRow = screenWidth ~/ 250;
    }
    return itemCountPerRow > 0 ? itemCountPerRow : 1;
  }
}
