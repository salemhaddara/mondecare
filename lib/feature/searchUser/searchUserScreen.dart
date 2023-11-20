// import 'dart:html' as html;
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mondecare/config/Models/Customer.dart';
import 'package:mondecare/config/theme/colors.dart';
import 'package:mondecare/config/theme/widgets/Snackbar.dart';
import 'package:mondecare/config/theme/widgets/searchbar.dart';
import 'package:mondecare/config/theme/widgets/text400normal.dart';
import 'package:mondecare/feature/searchUser/pdfConstruction/pdfConstruction.dart';
import 'package:mondecare/feature/searchUser/searchbloc/Repository/searchRepository.dart';
import 'package:mondecare/feature/searchUser/searchbloc/searchbloc.dart';
import 'package:mondecare/feature/searchUser/searchbloc/searchevent.dart';
import 'package:mondecare/feature/searchUser/searchbloc/searchstate.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class searchUserScreen extends StatefulWidget {
  const searchUserScreen({super.key});

  @override
  State<searchUserScreen> createState() => _searchUserScreenState();
}

class _searchUserScreenState extends State<searchUserScreen> {
  String? SearchedNumber;
  File? mfile;
  final pdf = pw.Document();

  static pw.Widget _buildMemberInfo(
      Customer customer, PdfColor textColor, pw.Font font) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(height: 10),
        _buildInfoRow('Name:', customer.CustomerName, textColor, font),
        pw.SizedBox(height: 10),
        _buildInfoRow(
            'Identity Number :', customer.IdentityNumber, textColor, font),
        pw.SizedBox(height: 10),
        _buildInfoRow('Phone Number :', customer.PhoneNumber, textColor, font),
        pw.SizedBox(height: 10),
        _buildInfoRow('Country  :', customer.Country, textColor, font),
        pw.SizedBox(height: 10),
        _buildInfoRow(
            'Birthday  :',
            '${customer.Birthday.day}/${customer.Birthday.month}/${customer.Birthday.year}',
            textColor,
            font),
        pw.SizedBox(height: 10),
        _buildInfoRow(
            'MemberShip Date :',
            ' ${customer.MemberShipDate.day}/${customer.MemberShipDate.month}/${customer.MemberShipDate.year}',
            textColor,
            font),
        pw.SizedBox(height: 10),
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

  bool loaded = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            child: Column(
              children: [
                _searchBar(),
                if (mfile != null)
                  Container(
                      width: (MediaQuery.of(context).size.height / 2) - 32,
                      height: ((MediaQuery.of(context).size.height / 2) - 32) *
                          1.414,
                      alignment: Alignment.center,
                      constraints: const BoxConstraints(maxWidth: 500),
                      child: SfPdfViewer.file(
                        mfile!,
                      ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  _searchBar() {
    return BlocBuilder<searchbloc, searchstate>(builder: (context, state) {
      if (state.customer != null) {
        if (!loaded) {
          _ss(context, state.customer!);
          loaded = true;
        }
      }
      return searchbar(
        hint: 'Search By Card',
        onChanged: (text) {
          SearchedNumber = text;
        },
        onSearchTapped: () {
          if (SearchedNumber != null && SearchedNumber!.length > 5) {
            context
                .read<searchbloc>()
                .add(searchUser(searchedNumber: SearchedNumber ?? ''));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(showSnackbar(
              'Enter Number Before',
              MediaQuery.of(context).size,
            ));
          }
        },
      );
    });
  }

  _ss(BuildContext pagecontext, Customer customer) async {
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
                _pdftext(28, 'MemberShip Card', true, true),
                pw.SizedBox(height: 20),
                _buildMemberInfo(customer, PdfColors.black, ttf),
                pw.SizedBox(height: 10),
                _pdfDevider(),
                pw.SizedBox(height: 10),
                _pdftext(28, 'Card Number', true, true),
                _pdftext(40, customer.CardNumber, false, false),
                _pdfDevider(),
                _pdftext(28, 'Card Type', true, true),
                _pdftext(40, customer.CardType, false, false)
              ],
            ),
          )
        ]);
      },
    ));
    if (kIsWeb) {
      // var savedFile = await pdf.save();
      // List<int> fileInts = List.from(savedFile);
      // html.AnchorElement(
      //     href:
      //         "data:application/octet-stream;charset=utf-16le;base64,${base64.encode(fileInts)}")
      //   ..setAttribute(
      //       "download", "${DateTime.now().millisecondsSinceEpoch}.pdf")
      //   ..click();
    } else {
      Directory documentDirectory = await getApplicationDocumentsDirectory();
      String documentPath = documentDirectory.path;

      String filePath = '$documentPath/membership.pdf';
      final file = File(filePath);
      await file.writeAsBytes(await pdf.save());
      print('done ${file.path}');
      setState(() {
        mfile = file;
      });
    }
  }

  _pdfDevider() {
    return pw.Container(
        color: PdfColors.black,
        height: 1,
        margin: const pw.EdgeInsets.only(top: 5, bottom: 5));
  }

  _pdftext(double fontSize, String data, bool isBold, bool isTitle) {
    return pw.Text(
      data,
      textAlign: pw.TextAlign.center,
      style: pw.TextStyle(
        color: PdfColors.black,
        fontWeight: pw.FontWeight.bold,
        fontSize: 40,
      ),
    );
  }
}
