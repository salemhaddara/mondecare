import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mondecare/authrepository.dart';
import 'package:mondecare/core/routes/routes.dart';
import 'package:mondecare/feature/addUser/addUserScreen.dart';
import 'package:mondecare/feature/admins/AllUsersScreen.dart';
import 'package:mondecare/feature/deleteUser/deleteUserScreen.dart';
import 'package:mondecare/feature/deleteUser/deletebloc/Repository/deleteRepository.dart';
import 'package:mondecare/feature/forgetPassword/Repo/forgetPassRepo.dart';
import 'package:mondecare/feature/home/home.dart';
import 'package:mondecare/feature/login/login.dart';
import 'package:mondecare/feature/logs/logsScreen.dart';
import 'package:mondecare/feature/logs/logsStates/Repo/logsrepository.dart';
import 'package:mondecare/feature/searchUser/searchUserScreen.dart';
import 'package:mondecare/feature/searchUser/searchbloc/Repository/searchRepository.dart';
import 'package:mondecare/feature/signup/signup.dart';
import 'package:mondecare/feature/splash/splash.dart';
// import 'package:mondecare/feature/splash/splash.dart';
import 'package:mondecare/usercontrolrepository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MultiRepositoryProvider(
    providers: [
      RepositoryProvider(create: ((context) => AuthRepository())),
      RepositoryProvider(
        create: ((context) => usercontrolrepository()),
      ),
      RepositoryProvider(
        create: ((context) => searchRepository()),
      ),
      RepositoryProvider(
        create: ((context) => logsrepository()),
      ),
      RepositoryProvider(
        create: ((context) => deleteRepository()),
      ),
      RepositoryProvider(
        create: ((context) => forgetPassRepo()),
      ),
    ],
    child: MaterialApp(
      home: const splash(),
      debugShowCheckedModeBanner: false,
      routes: {
        loginscreenRoute: (context) => const login(),
        SignUpscreenRoute: (context) => const signup(),
        homescreenRoute: (context) => const home(),
        addUserRoute: (context) => const addUserScreen(),
        searchUserRoute: (context) => const searchUserScreen(),
        logsScreenRoute: (context) => const logsScreen(),
        deleteUserScreenRoute: (context) => const deleteUserScreen(),
        allUsersScreenRoute: (context) => const AllUsersScreen(),
      },
    ),
  ));
}
