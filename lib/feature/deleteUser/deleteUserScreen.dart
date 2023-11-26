// ignore_for_file: camel_case_types, use_build_context_synchronously, non_constant_identifier_names

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
      } else if (state.statusTracker is Searching) {
        return Center(child: _searchingWidget(size));
      } else if (state.statusTracker is NotFoundSearchedNUmber) {
        print((state.statusTracker as NotFoundSearchedNUmber).exception);
        return _NotFoundWidget(size);
      } else {
        return Container();
      }
    });
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
                .add(deleteUser(searchedNumber: SearchedNumber ?? ''));
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
