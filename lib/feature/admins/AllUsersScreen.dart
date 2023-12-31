// ignore_for_file: file_names, non_constant_identifier_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mondecare/authrepository.dart';
import 'package:mondecare/config/theme/colors.dart';
import 'package:mondecare/config/theme/widgets/drawer.dart';
import 'package:mondecare/config/theme/widgets/text400normal.dart';
import 'package:mondecare/core/routes/routes.dart';
import 'package:mondecare/core/utils/Preferences/Preferences.dart';
import 'package:mondecare/feature/admins/adminsStates/adminsbloc.dart';
import 'package:mondecare/feature/admins/adminsStates/adminsevent.dart';
import 'package:mondecare/feature/admins/adminsStates/adminsstate.dart';
import 'package:mondecare/feature/admins/deleteAdminTracker/deleteTracker.dart';
import 'package:mondecare/feature/admins/widgets/ContainerWithCircleAvatar.dart';

class AllUsersScreen extends StatefulWidget {
  const AllUsersScreen({super.key});

  @override
  State<AllUsersScreen> createState() => _AllUsersScreenState();
}

class _AllUsersScreenState extends State<AllUsersScreen> {
  late Size size;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: white,
          foregroundColor: darkgrey,
          title: text400normal(
            data: 'Admins',
            fontsize: MediaQuery.of(context).size.height * 0.025,
            fontWeight: FontWeight.w600,
          ),
          centerTitle: true,
        ),
        drawer: drawer(choosed: 5),
        body: BlocProvider(
          create: (context) =>
              adminsbloc(context.read<AuthRepository>())..add(requestUsers()),
          child: SafeArea(
            child: LayoutBuilder(builder: (context, constraints) {
              return SizedBox(
                  height: constraints.maxHeight,
                  width: constraints.maxWidth,
                  child: Column(
                    children: [
                      _homeTitle(size),
                      Expanded(
                        child: BlocBuilder<adminsbloc, adminsstate>(
                          builder: (context, state) {
                            if (state.tracker is deleteSuccess) {
                              _return_toInitial(context);
                            }
                            if (state.users.isEmpty) {
                              return Container(
                                width: size.width * 0.2,
                                height: size.width * 0.2,
                                alignment: Alignment.center,
                                child: CircularProgressIndicator(
                                  strokeWidth: 6,
                                  color: darkgrey,
                                ),
                              );
                            }
                            return Container(
                                constraints:
                                    const BoxConstraints(maxWidth: 600),
                                width: size.width,
                                child: ListView.builder(
                                    itemCount: state.users.length,
                                    physics: const BouncingScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return ContainerWithCircleAvatar(
                                        name:
                                            '${state.users[index].firstName} ${state.users[index].lastName}',
                                        country: state.users[index].country,
                                        username: state.users[index].userName,
                                        phoneNumber:
                                            state.users[index].phoneNumber,
                                        fontsize: size.width * 0.026,
                                        OnDeleteClick: (username) {
                                          context
                                              .read<adminsbloc>()
                                              .add(deleteAdmin(username));
                                        },
                                      );
                                    }));
                          },
                        ),
                      ),
                    ],
                  ));
            }),
          ),
        ));
  }

  _return_toInitial(BuildContext context) async {
    if ((await Preferences.getUserName()) != null) {
      context.read<adminsbloc>().add(requestUsers());
    } else {
      Navigator.pushReplacementNamed(context, loginscreenRoute);
    }
  }

  _homeTitle(Size size) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: text400normal(
        data: 'Admins list',
        fontsize: size.height * 0.03,
        fontWeight: FontWeight.w300,
        align: TextAlign.center,
        textColor: darkgrey,
      ),
    );
  }
}
