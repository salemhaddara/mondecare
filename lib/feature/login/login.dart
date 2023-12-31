// ignore_for_file: non_constant_identifier_names, camel_case_types

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mondecare/authrepository.dart';
import 'package:mondecare/config/theme/colors.dart';
import 'package:mondecare/config/theme/widgets/Snackbar.dart';
import 'package:mondecare/config/theme/widgets/inputfield.dart';
import 'package:mondecare/config/theme/widgets/text400normal.dart';
import 'package:mondecare/core/routes/routes.dart';
import 'package:mondecare/feature/login/loginComponents/signuprichtext.dart';
import 'package:mondecare/feature/login/loginstates/loginbloc.dart';
import 'package:mondecare/feature/login/loginstates/loginevent.dart';
import 'package:mondecare/feature/login/loginstates/loginstate.dart';
import 'package:mondecare/feature/login/submission/submissionevent.dart';

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  final formKey = GlobalKey<FormState>();
  String emailcheck = '', passwordcheck = '';

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: white,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarIconBrightness: Brightness.dark));
    var size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: white,
      body: BlocProvider(
        create: (context) => loginbloc(context.read<AuthRepository>()),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  height: (size.height),
                  width: size.width,
                  child: Stack(
                    children: [
                      SizedBox(
                        height: size.height,
                        width: size.width,
                        child: Image.asset(
                          'assets/images/backstar.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  margin: EdgeInsets.only(
                    top: size.height * 0.1,
                    bottom: size.height * 0.1,
                  ),
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                    Radius.circular(18),
                  )),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(18)),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        height: size.height,
                        margin: const EdgeInsets.all(6),
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(
                          Radius.circular(18),
                        )),
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                _SignInTitle(size),
                                _form(size),
                                _signinButton(size, context),
                                _donthaveaccount(size)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: SvgPicture.asset(
                  'assets/images/iconwhite.svg',
                  height: size.height * 0.2,
                  width: size.height * 0.2,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _form(Size size) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          _emailTitle(size),
          _emailField(size),
          _passwordTitle(size),
          _passwordField(size),
        ],
      ),
    );
  }

  Widget _SignInTitle(Size size) {
    return Container(
        width: size.width,
        height: 50,
        alignment: Alignment.center,
        margin: const EdgeInsets.all(10),
        child: text400normal(
          data: 'Sign In',
          fontsize: size.height * 0.035,
          fontWeight: FontWeight.w600,
          textColor: darkgrey,
        ));
  }

  Widget _emailTitle(Size size) {
    return Container(
      width: size.width,
      margin: const EdgeInsets.only(top: 26, bottom: 10),
      constraints: const BoxConstraints(maxWidth: 600),
      child: text400normal(
        data: 'UserName',
        textColor: darkgrey,
        fontsize: size.height * 0.017,
        align: TextAlign.start,
      ),
    );
  }

  Widget _emailField(Size size) {
    return BlocBuilder<loginbloc, loginstate>(
      builder: (context, state) {
        return InputField(
          hint: '',
          isPassword: false,
          icon: Icons.person,
          validator: (email) {
            if (email!.isEmpty) {
              return null;
            }
            if (email.isNotEmpty && email.length < 3) {
              return 'UserName Must be more than 3 characters';
            }
            if (email.length > 8 && !isValidEmail(email)) {
              return 'Enter A Valid Email';
            }
            return null;
          },
          initialState: false,
          onChanged: (text) {
            emailcheck = text!;
          },
        );
      },
    );
  }

  Widget _passwordTitle(Size size) {
    return Container(
      width: size.width,
      constraints: const BoxConstraints(maxWidth: 600),
      margin: const EdgeInsets.only(top: 10, bottom: 10),
      child: text400normal(
        data: 'Password',
        textColor: darkgrey,
        fontsize: size.height * 0.017,
      ),
    );
  }

  Widget _passwordField(Size size) {
    return BlocBuilder<loginbloc, loginstate>(
      builder: (context, state) {
        return InputField(
          hint: '',
          isPassword: true,
          icon: Icons.password_outlined,
          validator: (password) {
            if (password == null || password.isEmpty) {
              return null;
            }
            if (password.length < 8) {
              return 'Please Enter A Valid Password';
            }
            return null;
          },
          initialState: true,
          onChanged: (text) {
            passwordcheck = text!;
          },
        );
      },
    );
  }

  Widget _signinButton(Size size, BuildContext pagecontext) {
    bool Navigated = false;
    bool isError = false;
    return BlocBuilder<loginbloc, loginstate>(builder: (context, state) {
      if (state.formstatus is submissionsuccess && !Navigated) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.of(pagecontext).pushReplacementNamed(homescreenRoute);
        });
        Navigated = true;
        return Container();
      }
      if (state.formstatus is submissionfailed && !isError) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          ScaffoldMessenger.of(pagecontext).showSnackBar(showSnackbar(
              (state.formstatus as submissionfailed).exception.toString(),
              size));
          context.read<loginbloc>().add(returnInitialStatus());
        });
        isError = true;
        return Container();
      }
      return state.formstatus is formsubmitting
          ? Container(
              margin: const EdgeInsets.only(top: 26),
              child: CircularProgressIndicator(
                color: darkgrey,
                strokeWidth: 6,
              ),
            )
          : Container(
              margin: const EdgeInsets.only(top: 26),
              child: GestureDetector(
                onTap: () {
                  if (emailcheck.isNotEmpty && passwordcheck.isNotEmpty) {
                    if (formKey.currentState!.validate()) {
                      context
                          .read<loginbloc>()
                          .add((loginSubmitted(emailcheck, passwordcheck)));
                    }
                  }
                },
                child: Container(
                  height: size.height * 0.06,
                  width: size.width / 1.5,
                  constraints: const BoxConstraints(maxWidth: 600),
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(14),
                      ),
                      color: darkgrey),
                  alignment: Alignment.center,
                  child: text400normal(
                    data: 'Sign In',
                    fontsize: size.height * 0.02,
                    textColor: motard,
                  ),
                ),
              ),
            );
    });
  }

  Widget _donthaveaccount(Size size) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: signuprichtext(
          startText: 'Dont Have An Account ?',
          clickableText: ' Sign Up',
          fontsize: size.height * 0.018,
          onClick: () {
            Navigator.pushNamed(context, SignUpscreenRoute);
          }),
    );
  }

  bool isValidEmail(String email) {
    RegExp emailRegExp =
        RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    return emailRegExp.hasMatch(email);
  }
}
