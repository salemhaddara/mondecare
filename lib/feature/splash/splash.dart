// ignore_for_file: camel_case_types, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mondecare/config/theme/colors.dart';
import 'package:mondecare/core/routes/routes.dart';

class splash extends StatefulWidget {
  const splash({Key? key}) : super(key: key);

  @override
  _splashState createState() => _splashState();
}

class _splashState extends State<splash> {
  bool _isAnimated = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      _startAnimation();
    });
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, loginscreenRoute);
    });
  }

  void _startAnimation() {
    setState(() {
      _isAnimated = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: darkgrey,
        systemNavigationBarColor: darkgrey,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [darkgrey, const Color.fromARGB(255, 60, 68, 77), darkgrey],
          ),
        ),
        child: Center(
          child: AnimatedContainer(
            duration: const Duration(seconds: 2),
            curve: Curves.easeInOut,
            height: _isAnimated ? MediaQuery.of(context).size.height : 0.0,
            width: MediaQuery.of(context).size.width / 2,
            child: AnimatedOpacity(
              opacity: _isAnimated ? 1.0 : 0.0,
              duration: const Duration(seconds: 2),
              curve: Curves.easeInOut,
              child: SvgPicture.asset('assets/images/icon.svg'),
            ),
          ),
        ),
      ),
    );
  }
}
