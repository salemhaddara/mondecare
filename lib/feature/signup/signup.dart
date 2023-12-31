// ignore_for_file: camel_case_types, non_constant_identifier_names, library_prefixes

import 'dart:ui';
import 'package:country_picker/country_picker.dart' as countryPicker;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mondecare/authrepository.dart';
import 'package:mondecare/config/theme/colors.dart';
import 'package:mondecare/config/theme/widgets/Snackbar.dart';
import 'package:mondecare/config/theme/widgets/button.dart';
import 'package:mondecare/config/theme/widgets/inputfield.dart';
import 'package:mondecare/config/theme/widgets/phoneinput.dart';
import 'package:mondecare/config/theme/widgets/text400normal.dart';
import 'package:mondecare/core/routes/routes.dart';
import 'package:mondecare/feature/signup/signupcomponents/dropDown.dart';
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
      phoneNumber = '',
      usernamecheck = '',
      firstNamecheck = '',
      lastName = '',
      passwordcheck = '',
      countrycheck = 'Egypt',
      questioncheck = '',
      answercheck = '';
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
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: Container(
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.all(16),
                                      child: Column(children: [
                                        _signupTitle(size),
                                        _SignUpForm(size),
                                        _Spacer(20),
                                        _SignInRichText(size)
                                      ]),
                                    ),
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

  _signupTitle(Size size) {
    return Container(
        height: 50,
        width: size.width,
        constraints: const BoxConstraints(maxWidth: 600),
        margin: const EdgeInsetsDirectional.only(
          top: 10,
        ),
        child: text400normal(
          data: 'Sign Up',
          fontsize: size.height * 0.035,
          textColor: darkgrey,
          fontWeight: FontWeight.w600,
          align: TextAlign.center,
        ));
  }

  _codeInputField(Size size) {
    return InputField(
      hint: '',
      isPassword: false,
      icon: Icons.password,
      validator: (name) {
        if (name != 'mondecarecairo\$#@') {
          return 'Enter The Secret Code ';
        }
        return null;
      },
      initialState: false,
      onChanged: (text) {
        firstNamecheck = '$text';
      },
    );
  }

  _nameInputField(Size size) {
    return InputField(
      hint: '',
      isPassword: false,
      icon: Icons.person_2,
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
        firstNamecheck = '$text';
      },
    );
  }

  _usernameField(Size size) {
    return InputField(
      hint: '',
      isPassword: false,
      icon: Icons.person_4_outlined,
      validator: (username) {
        if (username!.isEmpty) {
          return null;
        }
        if ((username.isNotEmpty) && username.length < 3) {
          return 'Username Must be More than 3 characters';
        }
        if ((username.isNotEmpty) && username.length > 8) {
          return 'Username Must be less than 8 characters';
        }
        if (!isUsernameValid(username)) {
          return 'Spaces Not permitted';
        }
        return null;
      },
      initialState: false,
      onChanged: (text) {
        usernamecheck = '$text';
      },
    );
  }

  _answerField(Size size) {
    return InputField(
      hint: '',
      isPassword: false,
      icon: Icons.question_answer,
      validator: (answer) {
        if (answer!.isEmpty) {
          return null;
        }

        return null;
      },
      initialState: false,
      onChanged: (text) {
        answercheck = '$text';
      },
    );
  }

  _lastNameInputField(Size size) {
    return InputField(
      hint: '',
      isPassword: false,
      icon: Icons.person_3_rounded,
      validator: (lastName) {
        if (lastName != null && lastName.isNotEmpty && lastName.length > 12) {
          return 'Enter You Last Name < 12 characters';
        }
        return null;
      },
      initialState: false,
      onChanged: (text) {
        lastName = '$text';
      },
    );
  }

  _SignInRichText(Size size) {
    return signinrichtext(
      startText: 'Have An Account ? ',
      clickableText: 'Sign In',
      onClick: () {
        Navigator.pushReplacementNamed(context, loginscreenRoute);
      },
      fontsize: size.height * 0.018,
    );
  }

  _signUpButton(Size size, BuildContext pagecontext) {
    bool Navigated = false;
    bool isError = false;
    return BlocBuilder<signupbloc, signupstate>(builder: (context, state) {
      if (state.formstatus is signupsubmissionsuccess && !Navigated) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).pop();
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
                    if (firstNamecheck.isNotEmpty &&
                        lastName.isNotEmpty &&
                        usernamecheck.isNotEmpty &&
                        passwordcheck.isNotEmpty &&
                        countrycheck.isNotEmpty &&
                        questioncheck.isNotEmpty &&
                        phoneNumber.isNotEmpty &&
                        answercheck.isNotEmpty) {
                      context.read<signupbloc>().add((signupSubmitted(
                          firstname: firstNamecheck,
                          lastName: lastName,
                          username: usernamecheck,
                          password: passwordcheck,
                          phoneNumber: phoneNumbercheck,
                          country: countrycheck,
                          question: questioncheck,
                          questionAnswer: answercheck)));
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

  _RetypepasswordInputField(Size size) {
    return InputField(
      hint: '',
      isPassword: true,
      icon: Icons.verified_outlined,
      validator: (password) {
        if (password == null || password.isEmpty) {
          return null;
        }
        if (password != (passwordcheck)) {
          return 'The Passwords are not the same';
        }
        return null;
      },
      initialState: true,
      onChanged: (text) {},
    );
  }

  _phoneNumber(Size size) {
    return Container(
      width: size.width,
      constraints: const BoxConstraints(maxWidth: 600),
      child: Column(
        children: [
          phoneinput(onChanged: (text) {
            phoneNumbercheck = text.completeNumber;
            phoneNumber = text.number;
          }),
        ],
      ),
    );
  }

  //Saved Password to PasswordCheck
  _passwordInputField(Size size) {
    return InputField(
      hint: '',
      isPassword: true,
      icon: Icons.password,
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

  _Title(Size size, String title) {
    return Container(
      width: size.width,
      constraints: const BoxConstraints(maxWidth: 600),
      margin: const EdgeInsets.only(top: 10, bottom: 10),
      child: text400normal(
        data: title,
        textColor: darkgrey,
        fontsize: size.height * 0.013,
      ),
    );
  }

  _Spacer(double height) {
    return SizedBox(
      height: height,
    );
  }

  bool isUsernameValid(String username) {
    if (!username.contains(' ')) {
      return true;
    }
    return false;
  }

  _SignUpForm(Size size) {
    return Form(
        key: formKey,
        child: Column(
          children: [
            //-----------------------------------Secret Code
            _Title(size, 'Secret Code'),
            _codeInputField(size),
            //-----------------------------------First Name
            _Title(size, 'First Name'),
            _nameInputField(size),
            //-----------------------------------LastName
            _Title(size, 'Last Name'),
            _lastNameInputField(size),
            //-----------------------------------User Name
            _Title(size, 'Username'),
            _usernameField(size),
            //-----------------------------------Country Chooser
            _Title(size, 'Choose Your Country'),
            _countryChooser(size),
            //-----------------------------------Safety Question
            _Title(size, 'Choose Your Safety Question'),
            _questionChooser(),
            //-----------------------------------Safety Question Answer
            _Title(size, 'Write an Answer for the question'),
            _answerField(size),
            //-----------------------------------Phone Number
            _Title(size, 'PhoneNumber'),
            _phoneNumber(size),
            //-----------------------------------Password
            _Title(size, 'Password'),
            _passwordInputField(size),

            //-----------------------------------Check Password
            _Title(size, 'Re-Type Password'),
            _RetypepasswordInputField(size),
            //-----------------------------------Submit Button
            _signUpButton(size, context)
          ],
        ));
  }

  _questionChooser() {
    return questionsdropDownMenu(
      onChanged: (value) {
        questioncheck = value;
      },
    );
  }

  _countryChooser(Size size) {
    return Container(
      width: size.width,
      height: 54,
      constraints: const BoxConstraints(maxWidth: 600),
      child: Column(
        children: [
          Material(
            borderRadius: const BorderRadius.all(Radius.circular(14)),
            child: InkWell(
              borderRadius: const BorderRadius.all(Radius.circular(14)),
              onTap: () {
                countryPicker.showCountryPicker(
                  context: context,
                  showPhoneCode: false,
                  onSelect: (countryPicker.Country selectedCountry) {
                    setState(() {
                      countrycheck = selectedCountry.name;
                    });
                  },
                );
              },
              child: Container(
                  width: size.width,
                  height: 54,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: white,
                      border: Border.all(
                        color: darkgrey,
                        width: 2,
                      ),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(14))),
                  child: text400normal(
                    data: countrycheck,
                    fontsize: size.height * 0.017,
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
