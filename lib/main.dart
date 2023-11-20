import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mondecare/authrepository.dart';
import 'package:mondecare/core/routes/routes.dart';
import 'package:mondecare/feature/addUser/addUserScreen.dart';
import 'package:mondecare/feature/home/home.dart';
import 'package:mondecare/feature/login/login.dart';
import 'package:mondecare/feature/searchUser/searchUserScreen.dart';
import 'package:mondecare/feature/searchUser/searchbloc/Repository/searchRepository.dart';
import 'package:mondecare/feature/signup/signup.dart';
// import 'package:mondecare/feature/splash/splash.dart';
import 'package:mondecare/firebase_options.dart';
import 'package:mondecare/usercontrolrepository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MultiRepositoryProvider(
    providers: [
      RepositoryProvider(create: ((context) => authrepository())),
      RepositoryProvider(
        create: ((context) => usercontrolrepository()),
      ),
      RepositoryProvider(
        create: ((context) => searchRepository()),
      ),
    ],
    child: MaterialApp(
      home: const home(),
      debugShowCheckedModeBanner: false,
      routes: {
        loginscreenRoute: (context) => const login(),
        SignUpscreenRoute: (context) => const signup(),
        homescreenRoute: (context) => const home(),
        addUserRoute: (context) => const addUserScreen(),
        searchUserRoute: (context) => const searchUserScreen()
      },
    ),
  ));
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}
