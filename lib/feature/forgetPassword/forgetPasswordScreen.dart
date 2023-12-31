// ignore_for_file: camel_case_types, file_names

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mondecare/config/theme/colors.dart';
import 'package:mondecare/config/theme/widgets/Snackbar.dart';
import 'package:mondecare/config/theme/widgets/inputfield.dart';
import 'package:mondecare/config/theme/widgets/text400normal.dart';
import 'package:mondecare/feature/forgetPassword/Repo/forgetPassRepo.dart';
import 'package:mondecare/feature/forgetPassword/state/forgetPass_bloc.dart';
import 'package:mondecare/feature/forgetPassword/state/forgetPass_event.dart';
import 'package:mondecare/feature/forgetPassword/state/forgetPass_state.dart';
import 'package:mondecare/feature/forgetPassword/tracker/forgetPassTracker.dart';
import 'package:mondecare/feature/login/login.dart';
import 'package:mondecare/feature/signup/signupcomponents/dropDown.dart';

class forgetPasswordScreen extends StatefulWidget {
  const forgetPasswordScreen({super.key});

  @override
  State<forgetPasswordScreen> createState() => _forgetPasswordScreenState();
}

class _forgetPasswordScreenState extends State<forgetPasswordScreen> {
  final formKey = GlobalKey<FormState>();
  String usernameCheck = '',
      newPassCheck = '',
      newPass = '',
      questionCheck = 'What is the name of your BestFriend ?',
      answerCheck = '';

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
        create: (context) => forgetPass_bloc(context.read<forgetPassRepo>()),
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
                                _forgetPass(size),
                                _form(size),
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

  _form(Size size) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          _title(size, 'UserName'),
          _userNameField(size),
          _title(size, 'New Password'),
          _passwordField(size),
          _title(size, 'Question'),
          questionsdropDownMenu(onChanged: (question) {
            questionCheck = question;
          }),
          _title(size, 'Answer'),
          _answer(size),
          _resetPassButton(size, context)
        ],
      ),
    );
  }

  _forgetPass(Size size) {
    return Container(
        width: size.width,
        height: 50,
        alignment: Alignment.center,
        margin: const EdgeInsets.all(10),
        child: text400normal(
          data: 'Forget Password',
          fontsize: size.height * 0.035,
          fontWeight: FontWeight.w600,
          textColor: darkgrey,
        ));
  }

  _title(Size size, String title) {
    return Container(
      width: size.width,
      margin: const EdgeInsets.only(top: 26, bottom: 10),
      constraints: const BoxConstraints(maxWidth: 600),
      child: text400normal(
        data: title,
        textColor: darkgrey,
        fontsize: size.height * 0.017,
        align: TextAlign.start,
      ),
    );
  }

  _userNameField(Size size) {
    return BlocBuilder<forgetPass_bloc, forgetPass_state>(
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

            return null;
          },
          initialState: false,
          onChanged: (text) {
            usernameCheck = text ?? '';
          },
        );
      },
    );
  }

  _answer(Size size) {
    return BlocBuilder<forgetPass_bloc, forgetPass_state>(
      builder: (context, state) {
        return InputField(
          hint: '',
          isPassword: false,
          icon: Icons.question_answer,
          validator: (answer) {
            if (answer!.isEmpty) {
              return null;
            }
            if (answer.isNotEmpty && answer.length < 3) {
              return 'Answer Must be more than 3 characters';
            }

            return null;
          },
          initialState: false,
          onChanged: (text) {
            answerCheck = text ?? '';
          },
        );
      },
    );
  }

  _passwordField(Size size) {
    return BlocBuilder<forgetPass_bloc, forgetPass_state>(
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
            newPass = text ?? '';
          },
        );
      },
    );
  }

  _resetPassButton(Size size, BuildContext pagecontext) {
    bool navigated = false;
    bool isError = false;
    return BlocBuilder<forgetPass_bloc, forgetPass_state>(
        builder: (context, state) {
      if (state.tracker is successstateTracker && !navigated) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.of(pagecontext).pushReplacement(
              MaterialPageRoute(builder: (context) => const login()));
        });
        navigated = true;
        return Container();
      }
      if (state.tracker is failedStateTracker && !isError) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          ScaffoldMessenger.of(pagecontext).showSnackBar(showSnackbar(
              (state.tracker as failedStateTracker).exception.toString(),
              size));
          context.read<forgetPass_bloc>().add(returnInitial());
        });
        isError = true;
        return Container();
      }
      return state.tracker is loadingStateTracker
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
                  if (usernameCheck.isNotEmpty &&
                      newPass.isNotEmpty &&
                      answerCheck.isNotEmpty &&
                      questionCheck.isNotEmpty) {
                    if (formKey.currentState!.validate()) {
                      context.read<forgetPass_bloc>().add((updatePass(
                            username: usernameCheck,
                            newPass: newPass,
                            answer: answerCheck,
                            question: questionCheck,
                          )));
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
}
