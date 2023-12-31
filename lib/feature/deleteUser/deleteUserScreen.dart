// ignore_for_file: camel_case_types, use_build_context_synchronously, non_constant_identifier_names, file_names

// import 'dart:html' as html;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mondecare/config/theme/colors.dart';
import 'package:mondecare/config/theme/widgets/Snackbar.dart';
import 'package:mondecare/config/theme/widgets/drawer.dart';
import 'package:mondecare/config/theme/widgets/searchbar.dart';
import 'package:mondecare/config/theme/widgets/text400normal.dart';
import 'package:mondecare/feature/deleteUser/deletebloc/Repository/deleteRepository.dart';
import 'package:mondecare/feature/deleteUser/deletebloc/deletebloc.dart';
import 'package:mondecare/feature/deleteUser/deletebloc/deleteevent.dart';
import 'package:mondecare/feature/deleteUser/deletebloc/deletestate.dart';
import 'package:mondecare/feature/deleteUser/deletebloc/searchStateTracker/deleteStatusTracker.dart';

import 'package:pdf/widgets.dart' as pw;

class deleteUserScreen extends StatefulWidget {
  const deleteUserScreen({super.key});

  @override
  State<deleteUserScreen> createState() => _deleteUserScreenState();
}

class _deleteUserScreenState extends State<deleteUserScreen> {
  String? SearchedNumber;
  File? mfile;
  final pdf = pw.Document();
  late List<int> fileInts;
  var savedFile;
  bool loaded = false;
  late Size size;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      drawer: drawer(choosed: 6),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: white,
        foregroundColor: darkgrey,
        title: text400normal(
          data: 'Delete User',
          fontsize: MediaQuery.of(context).size.height * 0.025,
          fontWeight: FontWeight.w600,
        ),
        centerTitle: true,
      ),
      body: BlocProvider(
        create: (context) => deletebloc(context.read<deleteRepository>()),
        child: SafeArea(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  _searchBar(),
                  Container(
                      margin: EdgeInsets.all(size.width * 0.02),
                      child: _centerContent(size))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _centerContent(Size size) {
    return BlocBuilder<deletebloc, deletestate>(builder: (context, state) {
      if (state.statusTracker is SearchedNumberDeleted) {
        return Wrap(
          children: [
            _deleteSuccess(
                (state.statusTracker as SearchedNumberDeleted).message),
          ],
        );
      } else if (state.statusTracker is FoundSearchedNumber) {
        return _memberCardInfo(size, (state.searchedNumberData) ?? {}, context);
      } else if (state.statusTracker is Searching) {
        return Center(child: _searchingWidget(size));
      } else if (state.statusTracker is NotFoundSearchedNUmber) {
        return _NotFoundWidget(size);
      } else {
        return Container();
      }
    });
  }

  _deleteUserButton(
    Size size,
    BuildContext blocContext,
    Map<String, dynamic> usedata,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      constraints: const BoxConstraints(maxWidth: 500),
      child: Column(
        children: [
          _title(size, 'Click To delete User '),
          InkWell(
            onTap: () async {
              showDialog(
                  context: context,
                  builder: (context) {
                    return Dialog(
                      backgroundColor: Colors.transparent,
                      child: Container(
                        height: 350,
                        width: 350,
                        decoration: BoxDecoration(
                            color: darkred,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(14))),
                        child: Column(
                          children: [
                            Container(
                              height: 75,
                              width: 350,
                              alignment: Alignment.center,
                              child: text400normal(
                                data: 'Delete Notice ',
                                fontsize: 20,
                                textColor: white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Divider(
                              height: 2,
                              color: grey,
                            ),
                            Container(
                              height: 190,
                              width: 350,
                              alignment: Alignment.center,
                              child: text400normal(
                                data:
                                    'Are You Sure That you want to delete ${usedata['fields']['CustomerName']['stringValue']} ?',
                                fontsize: 20,
                                align: TextAlign.center,
                                textColor: white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Container(
                              height: 2,
                              width: 350,
                              color: white,
                            ),
                            SizedBox(
                              height: 75,
                              width: 350,
                              child: Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      blocContext
                                          .read<deletebloc>()
                                          .add(deleteUser(usedata));
                                      Navigator.of(context).pop();
                                    },
                                    child: Container(
                                      width: 174,
                                      height: 75,
                                      alignment: Alignment.center,
                                      child: text400normal(
                                        data: 'Yes',
                                        fontsize: 16,
                                        textColor: white,
                                        align: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 75,
                                    width: 2,
                                    color: white,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Container(
                                      width: 174,
                                      height: 75,
                                      alignment: Alignment.center,
                                      child: text400normal(
                                        data: 'No',
                                        fontsize: 16,
                                        textColor: white,
                                        align: TextAlign.center,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  });
            },
            child: Container(
              alignment: Alignment.center,
              width: size.width,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(14)),
                  color: darkred),
              constraints: const BoxConstraints(minHeight: 54, maxWidth: 500),
              child: text400normal(
                data: 'Delete User',
                align: TextAlign.center,
                fontsize: size.height * 0.017,
                fontWeight: FontWeight.w600,
                textColor: white,
              ),
            ),
          )
        ],
      ),
    );
  }

  _memberCardInfo(
      Size size, Map<String, dynamic> usedata, BuildContext context) {
    return Material(
      elevation: 4,
      borderRadius: const BorderRadius.all(Radius.circular(14)),
      child: Container(
        margin: const EdgeInsets.all(10),
        child: Wrap(
          children: [
            _field(size, 'Name ',
                usedata['fields']['CustomerName']['stringValue']),
            _field(size, 'Identity Number',
                usedata['fields']['IdentityNumber']['stringValue']),
            _field(size, 'Card Number',
                usedata['fields']['CardNumber']['stringValue']),
            _deleteUserButton(size, context, usedata)
          ],
        ),
      ),
    );
  }

  _field(Size size, String fieldTitle, String data) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      constraints: const BoxConstraints(maxWidth: 500),
      child: Column(
        children: [
          _title(size, fieldTitle),
          Container(
            alignment: Alignment.center,
            width: size.width,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(14)),
                color: white),
            constraints: const BoxConstraints(minHeight: 54, maxWidth: 500),
            child: text400normal(
              data: data,
              align: TextAlign.center,
              fontsize: size.height * 0.017,
              fontWeight: FontWeight.w600,
            ),
          )
        ],
      ),
    );
  }

  Widget _title(Size size, String title) {
    return Container(
      width: size.width,
      margin: const EdgeInsets.only(bottom: 10),
      constraints: const BoxConstraints(maxWidth: 600),
      child: text400normal(
        data: title,
        textColor: darkgrey,
        fontsize: size.height * 0.017,
        align: TextAlign.start,
      ),
    );
  }

  _deleteSuccess(String message) {
    return Center(
      child: Column(
        children: [
          SvgPicture.asset(
            'assets/images/done.svg',
            height: size.height * 0.1,
          ),
          text400normal(data: message, fontsize: size.height * 0.02)
        ],
      ),
    );
  }

  _NotFoundWidget(Size size) {
    return Center(
      child: Column(
        children: [
          SvgPicture.asset(
            'assets/images/notfounduser.svg',
            height: size.height * 0.1,
          ),
          text400normal(
              data: 'This Number Is not Registered',
              fontsize: size.height * 0.02)
        ],
      ),
    );
  }

  _searchingWidget(Size size) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: [
          SizedBox(
            height: size.height * 0.1,
            width: size.height * 0.1,
            child: CircularProgressIndicator(
              color: darkgrey,
              strokeWidth: 12,
            ),
          ),
          Container(
            margin: const EdgeInsets.all(16),
            child: text400normal(
              data: 'Searching...',
              fontsize: size.height * 0.02,
              textColor: Colors.black,
            ),
          )
        ],
      ),
    );
  }

  _searchBar() {
    return BlocBuilder<deletebloc, deletestate>(builder: (context, state) {
      return searchbar(
        hint: 'Delete User By Card Number',
        imagePath: 'saa',
        onChanged: (text) {
          SearchedNumber = text;
        },
        onSearchTapped: () {
          FocusScope.of(context).unfocus();
          if (SearchedNumber != null && SearchedNumber!.length > 5) {
            context
                .read<deletebloc>()
                .add(searchUser(searchedNumber: SearchedNumber ?? ''));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(showSnackbar(
              'Enter A Valid Card Number (>5)',
              MediaQuery.of(context).size,
            ));
          }
        },
      );
    });
  }
}
