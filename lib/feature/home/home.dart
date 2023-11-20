// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mondecare/config/theme/colors.dart';
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
        drawer: Drawer(
          backgroundColor: darkgrey,
          child: ListView(physics: const BouncingScrollPhysics(), children: [
            _drawerhead(context),
            _drawerlist(size),
          ]),
        ),
        body: SafeArea(
          child: LayoutBuilder(builder: (context, constraints) {
            return SizedBox(
                height: constraints.maxHeight,
                width: constraints.maxWidth,
                child: Stack(
                  children: [
                    _homelist(),
                  ],
                ));
          }),
        ));
  }

  _drawerlist(Size size) {
    return Expanded(
      child: SingleChildScrollView(
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
            _drawerlistItem(size, 'Dashboard', 'home', () {}, true),
            _drawerlistItem(
                size, 'Search User', 'searchuserwhite', () {}, false),
            _drawerlistItem(size, 'Add User', 'adduserwhite', () {}, false),
            _drawerlistItem(size, 'Insights', 'insightswhite', () {}, false),
            _drawerlistItem(size, 'Admins', 'adminwhite', () {}, false),
            _drawerlistItem(
                size, 'Delete User', 'deleteuserwhite', () {}, false),
            _drawerlistItem(size, 'Logs', 'logswhite', () {}, false),
          ],
        ),
      ),
    );
  }

  _drawerlistItem(
    Size size,
    String title,
    String imagePath,
    Function onClick,
    bool choosed,
  ) {
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
          onTap: () {},
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
        _homelistItem(size, 'insights', 'Insights', addUserRoute),
        _homelistItem(size, 'admin', 'Admins', addUserRoute),
        _homelistItem(size, 'deleteuser', 'Delete User', addUserRoute),
        _homelistItem(size, 'logs', 'Logs', addUserRoute),
      ],
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

  _drawerhead(BuildContext context) {
    return SvgPicture.asset(
      'assets/images/iconwhite.svg',
      height: MediaQuery.of(context).size.height * 0.2,
      width: MediaQuery.of(context).size.height * 0.2,
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
