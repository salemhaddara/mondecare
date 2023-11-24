// ignore_for_file: camel_case_types, use_build_context_synchronously, non_constant_identifier_names, prefer_typing_uninitialized_variables, file_names

// import 'dart:html' as html;
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mondecare/config/Models/Customer.dart';
import 'package:mondecare/config/theme/colors.dart';
import 'package:mondecare/config/theme/widgets/Snackbar.dart';
import 'package:mondecare/config/theme/widgets/drawer.dart';
import 'package:mondecare/config/theme/widgets/searchbar.dart';
import 'package:mondecare/config/theme/widgets/text400normal.dart';
import 'package:mondecare/feature/searchUser/pdfConstruction/pdfConstructionconstantes.dart';
import 'package:mondecare/feature/searchUser/searchbloc/Repository/searchRepository.dart';
import 'package:mondecare/feature/searchUser/searchbloc/searchStateTracker/searchStatusTracker.dart';
import 'package:mondecare/feature/searchUser/searchbloc/searchbloc.dart';
import 'package:mondecare/feature/searchUser/searchbloc/searchevent.dart';
import 'package:mondecare/feature/searchUser/searchbloc/searchstate.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class searchUserScreen extends StatefulWidget {
  const searchUserScreen({super.key});

  @override
  State<searchUserScreen> createState() => _searchUserScreenState();
}

class _searchUserScreenState extends State<searchUserScreen> {
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
      drawer: drawer(choosed: 2),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: white,
        foregroundColor: darkgrey,
        title: text400normal(
          data: 'Search User',
          fontsize: MediaQuery.of(context).size.height * 0.025,
          fontWeight: FontWeight.w600,
        ),
        centerTitle: true,
      ),
      body: BlocProvider(
        create: (context) => searchbloc(context.read<searchRepository>()),
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
    return BlocBuilder<searchbloc, searchstate>(builder: (context, state) {
      if (state.statusTracker is SearchedNumberFound) {
        return Wrap(
          children: [
            _memberCardInfo(size, state),
          ],
        );
      } else if (state.statusTracker is Searching) {
        return Center(child: _searchingWidget(size));
      } else if (state.statusTracker is NotFoundSearchedNUmber) {
        return _NotFoundWidget(size);
      } else {
        return Container();
      }
    });
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

  _memberCardInfo(Size size, searchstate state) {
    return Material(
      elevation: 4,
      borderRadius: const BorderRadius.all(Radius.circular(14)),
      child: Container(
        margin: const EdgeInsets.all(10),
        child: Wrap(
          children: [
            _savePdfButton(size, state.customer!),
            _field(size, 'Admin Name', state.customer!.AdminName),
            _field(size, 'Name ', state.customer!.CustomerName),
            _field(size, 'Identity Number', state.customer!.IdentityNumber),
            _field(size, 'Card Number', state.customer!.CardNumber),
            _field(size, 'Country', state.customer!.Country),
            _field(size, 'Phone Number', state.customer!.PhoneNumber),
            _field(size, 'Birthday',
                '${state.customer!.Birthday.day}/${state.customer!.Birthday.month}/${state.customer!.Birthday.year}'),
            _field(size, 'Member Ship Date',
                '${state.customer!.MemberShipDate.day}/${state.customer!.MemberShipDate.month}/${state.customer!.MemberShipDate.year}'),
          ],
        ),
      ),
    );
  }

  static pw.Widget _buildMemberInfo(
      Customer customer, PdfColor textColor, pw.Font font) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(height: 10),
        _buildInfoRow('Name:', customer.CustomerName, textColor, font),
        pw.SizedBox(height: 5),
        _buildInfoRow(
            'Identity Number :', customer.IdentityNumber, textColor, font),
        pw.SizedBox(height: 5),
        _buildInfoRow('Phone Number :', customer.PhoneNumber, textColor, font),
        pw.SizedBox(height: 5),
        _buildInfoRow('Country  :', customer.Country, textColor, font),
        pw.SizedBox(height: 5),
        _buildInfoRow(
            'Birthday  :',
            '${customer.Birthday.day}/${customer.Birthday.month}/${customer.Birthday.year}',
            textColor,
            font),
        pw.SizedBox(height: 5),
        _buildInfoRow(
            'MemberShip Date :',
            ' ${customer.MemberShipDate.day}/${customer.MemberShipDate.month}/${customer.MemberShipDate.year}',
            textColor,
            font),
        pw.SizedBox(height: 5),
      ],
    );
  }

  static pw.Widget _buildInfoRow(
      String label, String value, PdfColor textColor, pw.Font font) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.start,
      children: [
        pw.Text(
          label,
          style: pw.TextStyle(
              color: textColor,
              fontWeight: pw.FontWeight.bold,
              fontSize: 20,
              font: font),
        ),
        pw.SizedBox(width: 5),
        pw.Text(
          value,
          style: pw.TextStyle(
            color: textColor,
            fontSize: 20,
            font: font,
          ),
        ),
      ],
    );
  }

  _savePdfButton(Size size, Customer customer) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      constraints: const BoxConstraints(maxWidth: 500),
      child: Column(
        children: [
          _title(size, 'Save The Customer Informations'),
          InkWell(
            onTap: () async {
              _ss(context, customer, true);
            },
            child: Container(
              alignment: Alignment.center,
              width: size.width,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(14)),
                  color: darkgrey),
              constraints: const BoxConstraints(minHeight: 54, maxWidth: 500),
              child: text400normal(
                data: 'Download As Pdf',
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

  _searchBar() {
    return BlocBuilder<searchbloc, searchstate>(builder: (context, state) {
      return searchbar(
        hint: 'Search User By Card Number',
        onChanged: (text) {
          SearchedNumber = text;
        },
        onSearchTapped: () {
          FocusScope.of(context).unfocus();
          if (SearchedNumber != null && SearchedNumber!.length > 5) {
            context
                .read<searchbloc>()
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

  _ss(BuildContext pagecontext, Customer customer, bool WithDownload) async {
    final pdf = pw.Document();
    final backgroundImage = pw.MemoryImage(
      (await rootBundle.load('assets/images/watermark.png'))
          .buffer
          .asUint8List(),
    );
    var data = await rootBundle.load("assets/fonts/artisticfont.ttf");
    final ttf = pw.Font.ttf(data);
    pdf.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      build: (pw.Context context) {
        return pw.Stack(children: [
          pw.Opacity(
            opacity: 0.1,
            child: pw.Image(backgroundImage, fit: pw.BoxFit.cover),
          ),
          pw.Container(
            decoration: pw.BoxDecoration(
              borderRadius: pw.BorderRadius.circular(12),
            ),
            padding: const pw.EdgeInsets.all(30),
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.start,
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Container(
                    height: 150,
                    child: pw.SvgImage(
                        svg: pdfConstruction.svgPicture, fit: pw.BoxFit.cover)),
                _pdfDevider(),
                _pdftext(24, 'MemberShip Card', true, true, ttf),
                pw.SizedBox(height: 10),
                _buildMemberInfo(customer, PdfColors.black, ttf),
                pw.SizedBox(height: 10),
                _pdfDevider(),
                pw.SizedBox(height: 10),
                _pdftext(20, 'Card Number', true, true, ttf),
                _pdftext(28, customer.CardNumber, false, false, ttf),
                _pdfDevider(),
                _pdftext(20, 'Card Type', true, true, ttf),
                _pdftext(28, customer.CardType, false, false, ttf)
              ],
            ),
          )
        ]);
      },
    ));
    savedFile = await pdf.save();
    fileInts = List.from(savedFile);
    if (kIsWeb) {
      if (WithDownload) {
        // html.AnchorElement(
        //     href:
        //         "data:application/octet-stream;charset=utf-16le;base64,${base64.encode(fileInts)}")
        //   ..setAttribute("download", "${customer.CustomerName}.pdf")
        //   ..click();
      }
      setState(() {
        mfile = File('');
      });
    } else {
      Directory documentDirectory = await getApplicationDocumentsDirectory();
      String documentPath = documentDirectory.path;

      String filePath = '$documentPath/membership.pdf';
      final file = File(filePath);
      await file.writeAsBytes(savedFile);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: text400normal(
              data: 'Pdf Saved in ${file.path}',
              fontsize: size.height * 0.017)));
      setState(() {
        mfile = file;
      });
    }
  }

  _pdfDevider() {
    return pw.Container(
        color: PdfColors.black,
        height: 1,
        margin: const pw.EdgeInsets.only(bottom: 5));
  }

  _pdftext(
      double fontSize, String data, bool isBold, bool isTitle, pw.Font font) {
    return pw.Text(
      data,
      textAlign: pw.TextAlign.center,
      style: pw.TextStyle(
          color: PdfColors.black,
          fontWeight: pw.FontWeight.bold,
          fontSize: fontSize,
          font: font),
    );
  }
}