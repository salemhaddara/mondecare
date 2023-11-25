// ignore_for_file: camel_case_types, non_constant_identifier_names

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mondecare/authrepository.dart';
import 'package:mondecare/config/theme/colors.dart';
import 'package:mondecare/config/theme/widgets/Snackbar.dart';
import 'package:mondecare/config/theme/widgets/button.dart';
import 'package:mondecare/config/theme/widgets/inputfield.dart';
import 'package:mondecare/config/theme/widgets/text400normal.dart';
import 'package:mondecare/core/routes/routes.dart';
import 'package:mondecare/feature/signup/signupstates/signupevent.dart';
import 'package:mondecare/feature/signup/signupstates/signupstate.dart';
import 'package:mondecare/feature/signup/signupsubmission/signupsubmissionevent.dart';
import 'signupcomponents/siginrichtext.dart';
import 'signupstates/signupbloc.dart';

class signup extends StatefulWidget {
  const signup({super.key});

  @override
  State<signup> createState() => _signupState();
}

class _signupState extends State<signup> {
  final formKey = GlobalKey<FormState>();
  String phoneNumbercheck = '',
      namecheck = '',
      emailcheck = '',
      passwordcheck = '';
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: white,
        systemNavigationBarIconBrightness: Brightness.dark));
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: white,
      resizeToAvoidBottomInset: false,
      body: BlocProvider(
        create: (context) => signupbloc(context.read<AuthRepository>()),
        child: Directionality(
          textDirection:
              // defaultLang == 'ar' ? TextDirection.rtl :
              TextDirection.ltr,
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
                          borderRadius:
                              const BorderRadius.all(Radius.circular(18)),
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
                                    child: Column(children: [
                                      _signupTitle(size),
                                      _SignUpForm(size),
                                      _Spacer(20),
                                      _SignInRichText(size)
                                    ]),
                                  ),
                                ),
                              ))))),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: const EdgeInsets.all(0),
                  child: SvgPicture.asset(
                    'assets/images/iconwhite.svg',
                    height: size.height * 0.1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _SignUpForm(Size size) {
    return Form(
        key: formKey,
        child: Column(
          children: [
            _codeTitle(size),
            _codeInputField(size),
            _nameTitle(size),
            _nameInputField(size),
            _emailTitle(size),
            _emailInputField(size),
            _passwordTitle(size),
            _passwordInputField(size),
            _signUpButton(size, context)
          ],
        ));
  }

  Widget _signupTitle(Size size) {
    return Container(
        height: 50,
        width: size.width,
        constraints: const BoxConstraints(maxWidth: 600),
        margin: const EdgeInsetsDirectional.only(
          top: 10,
        ),
        child: text400normal(
          data: 'Sign Up',
          fontsize: size.height * 0.04,
          textColor: darkgrey,
          fontWeight: FontWeight.w600,
          align: TextAlign.center,
        ));
  }

  Widget _codeTitle(Size size) {
    return Container(
      width: size.width,
      constraints: const BoxConstraints(maxWidth: 600),
      margin: const EdgeInsets.only(top: 10, bottom: 10),
      child: text400normal(
        data: 'Secret Code ',
        textColor: darkgrey,
        fontsize: size.height * 0.017,
      ),
    );
  }

  Widget _codeInputField(Size size) {
    return InputField(
      hint: '',
      isPassword: false,
      validator: (name) {
        if (name != 'mondecarecairo\$#@') {
          return 'Enter The Secret Code ';
        }
        return null;
      },
      initialState: false,
      onChanged: (text) {
        namecheck = '$text';
      },
    );
  }

  Widget _nameTitle(Size size) {
    return Container(
      width: size.width,
      constraints: const BoxConstraints(maxWidth: 600),
      margin: const EdgeInsets.only(top: 10, bottom: 10),
      child: text400normal(
        data: 'Name',
        textColor: darkgrey,
        fontsize: size.height * 0.017,
      ),
    );
  }

  Widget _nameInputField(Size size) {
    return InputField(
      hint: '',
      isPassword: false,
      validator: (name) {
        if (name!.isEmpty) {
          return null;
        }
        if (name.length < 3) {
          return 'Enter A Valid Name';
        }
        return null;
      },
      initialState: false,
      onChanged: (text) {
        namecheck = '$text';
      },
    );
  }

  Widget _emailTitle(Size size) {
    return Container(
      width: size.width,
      constraints: const BoxConstraints(maxWidth: 600),
      margin: const EdgeInsets.only(top: 10, bottom: 10),
      child: text400normal(
        data: 'Email Address',
        textColor: darkgrey,
        fontsize: size.height * 0.017,
      ),
    );
  }

  Widget _emailInputField(Size size) {
    return InputField(
      hint: '',
      isPassword: false,
      validator: (email) {
        if (email!.isEmpty) {
          return null;
        }
        if (!isValidEmail(email)) {
          return 'Enter A Valid Email';
        }
        return null;
      },
      initialState: false,
      onChanged: (text) {
        emailcheck = '$text';
      },
    );
  }

  Widget _SignInRichText(Size size) {
    return signinrichtext(
      startText: 'Have An Account ? ',
      clickableText: 'Sign In',
      onClick: () {
        Navigator.pushReplacementNamed(context, loginscreenRoute);
      },
      fontsize: size.height * 0.018,
    );
  }

  Widget _signUpButton(Size size, BuildContext pagecontext) {
    bool Navigated = false;
    bool isError = false;
    return BlocBuilder<signupbloc, signupstate>(builder: (context, state) {
      if (state.formstatus is signupsubmissionsuccess && !Navigated) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.of(pagecontext).pop();
        });
        Navigated = true;
        return Container();
      }
      if (state.formstatus is signupsubmissionfailed && !isError) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          ScaffoldMessenger.of(pagecontext).showSnackBar(showSnackbar(
              (state.formstatus as signupsubmissionfailed).exception.toString(),
              size));
          context.read<signupbloc>().add(returninitial());
        });
        isError = true;
        return Container();
      }
      return state.formstatus is signupformsubmitting
          ? Container(
              margin: const EdgeInsets.only(top: 26),
              child: CircularProgressIndicator(
                strokeWidth: 6,
                color: darkgrey,
              ),
            )
          : Container(
              margin: const EdgeInsets.only(top: 26),
              constraints: const BoxConstraints(maxWidth: 600),
              child: button(
                text: 'Sign Up',
                onTap: () {
                  if (formKey.currentState!.validate()) {
                    if (namecheck.isNotEmpty &&
                        emailcheck.isNotEmpty &&
                        passwordcheck.isNotEmpty) {
                      context.read<signupbloc>().add((signupSubmitted(
                          email: emailcheck,
                          password: passwordcheck,
                          name: namecheck)));
                    } else {
                      ScaffoldMessenger.of(pagecontext).showSnackBar(
                          showSnackbar('Fill All Required Data', size));
                    }
                  } else {
                    ScaffoldMessenger.of(pagecontext).showSnackBar(showSnackbar(
                        'Make Sure All fields Are Properly Filled', size));
                  }
                },
                width: size.width,
              ),
            );
    });
  }

  Widget _passwordInputField(Size size) {
    return InputField(
      hint: '',
      isPassword: true,
      validator: (password) {
        if (password == null || password.isEmpty) {
          return null;
        }
        if (password.length < 8) {
          return 'Enter A Password with A Minimum of 8 charaters';
        }
        return null;
      },
      initialState: true,
      onChanged: (text) {
        passwordcheck = '$text';
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

  Widget _Spacer(double height) {
    return SizedBox(
      height: height,
    );
  }

  bool isValidEmail(String email) {
    RegExp emailRegExp =
        RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    return emailRegExp.hasMatch(email);
  }
}
