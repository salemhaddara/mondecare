// ignore_for_file: camel_case_types, non_constant_identifier_names, unused_element

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mondecare/config/Models/Customer.dart';
import 'package:mondecare/config/theme/colors.dart';
import 'package:mondecare/config/theme/widgets/drawer.dart';
import 'package:mondecare/config/theme/widgets/text400normal.dart';
import 'package:mondecare/core/routes/routes.dart';
import 'package:mondecare/feature/home/homeStates/home_bloc.dart';
import 'package:mondecare/feature/home/homeStates/home_event.dart';
import 'package:mondecare/feature/home/homeStates/home_state.dart';
import 'package:mondecare/usercontrolrepository.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  late Size size;
  late TooltipBehavior _tooltip;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    _tooltip = TooltipBehavior(enable: true, color: white, borderColor: white);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: white,
          foregroundColor: darkgrey,
          title: text400normal(
            data: 'Home',
            fontsize: MediaQuery.of(context).size.height * 0.025,
            fontWeight: FontWeight.w600,
          ),
          centerTitle: true,
        ),
        drawer: drawer(
          choosed: 1,
        ),
        body: BlocProvider(
          create: (context) {
            return home_bloc(context.read<usercontrolrepository>())
              ..add(fetchData())
              ..add(saveLog());
          },
          child: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  _decorationTop(size),
                  _insights(size),
                  _homeTitle(size),
                  _homelist(),
                ],
              ),
            ),
          ),
        ));
  }

  _decorationTop(Size size) {
    return Container(
      height: size.height / 5,
      width: size.width,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
            darkgrey,
            grey,
            darkred,
          ])),
      child: Stack(children: [
        Align(
            alignment: Alignment.center,
            child: SvgPicture.asset('assets/images/iconwhite.svg'))
      ]),
    );
  }

  _insights(Size size) {
    return BlocBuilder<home_bloc, home_state>(builder: (context, state) {
      if (state.customers.isNotEmpty) {
        Map<String, int> customerCountPerCountry =
            getCountOfCustomersPerCountry(state.customers);

        List<_PieData> pieData = customerCountPerCountry.entries.map((entry) {
          double percentage = (entry.value / state.customers.length) * 100;
          return _PieData(entry.key, percentage.toInt(),
              '${percentage.toStringAsFixed(2)}%');
        }).toList();
        Map<String, int> userCountPerCardType =
            getCountOfUsersPerCardType(state.customers);

        List<_ChartData> data = userCountPerCardType.entries.map((entry) {
          return _ChartData(entry.key, entry.value.toDouble());
        }).toList();
        return ClipRRect(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(14), topRight: Radius.circular(14)),
          child: Wrap(
            children: [
              _InsightsTitle(size),
              Container(
                  margin: const EdgeInsets.all(10),
                  width: size.width > 600 ? (size.width / 2) - 32 : size.width,
                  decoration: BoxDecoration(
                      color: darkgrey,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(14))),
                  child: Material(
                    borderRadius: const BorderRadius.all(Radius.circular(14)),
                    elevation: 4,
                    color: Colors.transparent,
                    child: SfCircularChart(
                      title: ChartTitle(
                        text: 'Customers by Country',
                        textStyle: GoogleFonts.montserrat(
                            fontSize: size.width * 0.02,
                            fontWeight: FontWeight.w600,
                            color: Colors.white),
                      ),
                      legend: Legend(
                          isVisible: true, textStyle: TextStyle(color: white)),
                      series: <PieSeries<_PieData, String>>[
                        PieSeries<_PieData, String>(
                          legendIconType: LegendIconType.circle,
                          pointColorMapper: (datum, index) {
                            var colorsList = [
                              white,
                              grey,
                            ];
                            if (index < 2) {
                              return colorsList[index];
                            }
                            return null;
                          },
                          explode: true,
                          explodeIndex: 0,
                          dataSource: pieData,
                          strokeColor: white,
                          xValueMapper: (_PieData data, _) => data.xData,
                          yValueMapper: (_PieData data, _) => data.yData,
                          dataLabelMapper: (_PieData data, _) => data.text,
                          dataLabelSettings:
                              const DataLabelSettings(isVisible: true),
                        )
                      ],
                    ),
                  )),
              Container(
                  margin: const EdgeInsets.all(10),
                  width: size.width > 600 ? (size.width / 2) - 32 : size.width,
                  child: Material(
                    borderRadius: const BorderRadius.all(Radius.circular(14)),
                    elevation: 4,
                    color: darkred,
                    child: SfCartesianChart(
                        title: ChartTitle(
                          text: 'Customers By Card Type',
                          textStyle: GoogleFonts.montserrat(
                              fontSize: size.width * 0.02,
                              fontWeight: FontWeight.w400,
                              color: white),
                        ),
                        crosshairBehavior: CrosshairBehavior(lineColor: white),
                        primaryXAxis: CategoryAxis(
                            labelStyle: TextStyle(color: white),
                            isVisible: true,
                            borderColor: white,
                            axisLine: AxisLine(color: white)),
                        primaryYAxis: NumericAxis(
                            labelStyle: TextStyle(color: white),
                            borderColor: white,
                            minimum: 0,
                            axisLine: AxisLine(color: white),
                            maximum: state.customers.length.floorToDouble(),
                            interval: _getInterval(state.customers.length)),
                        tooltipBehavior: _tooltip,
                        series: <ChartSeries<_ChartData, String>>[
                          AreaSeries<_ChartData, String>(
                              dataSource: data,
                              xValueMapper: (_ChartData data, _) => data.x,
                              yValueMapper: (_ChartData data, _) => data.y,
                              name: '',
                              color: white)
                        ]),
                  )),
            ],
          ),
        );
      }
      return Container();
    });
  }

  double _getInterval(int length) {
    if (length < 20) {
      return 1;
    } else if (length % 2 == 0) {
      return (length / 2) / 2;
    } else {
      return ((length + 1) / 2) / 2;
    }
  }

  Map<String, int> getCountOfCustomersPerCountry(List<Customer> customers) {
    Map<String, int> customerCountPerCountry = {};

    for (var customer in customers) {
      customerCountPerCountry.update(
        customer.Country,
        (value) => value + 1,
        ifAbsent: () => 1,
      );
    }

    return customerCountPerCountry;
  }

  _homelist() {
    return Container(
      constraints: const BoxConstraints(maxHeight: 800),
      child: GridView(
        physics: const FixedExtentScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: _calculateCrossAxisCount(context),
          crossAxisSpacing: 12.0,
          mainAxisSpacing: 12.0,
        ),
        children: [
          _homelistItem(size, 'searchuser', 'Search Member', searchUserRoute),
          _homelistItem(size, 'adduser', 'Add Member', addUserRoute),
          _homelistItem(size, 'admin', 'Admins', allUsersScreenRoute),
          _homelistItem(
              size, 'deleteuser', 'Delete Member', deleteUserScreenRoute),
          _homelistItem(size, 'logs', 'Logs', logsScreenRoute),
        ],
      ),
    );
  }

  _InsightsTitle(Size size) {
    return Container(
      margin: const EdgeInsets.all(16),
      width: size.width,
      alignment: Alignment.center,
      child: text400normal(
        data: 'Insights',
        fontsize: size.height * 0.03,
        fontWeight: FontWeight.w300,
        align: TextAlign.center,
        textColor: darkgrey,
      ),
    );
  }

  _homeTitle(Size size) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: text400normal(
        data: 'Control Panel',
        fontsize: size.height * 0.03,
        fontWeight: FontWeight.w300,
        align: TextAlign.center,
        textColor: darkgrey,
      ),
    );
  }

  _homelistItem(Size size, String imagePath, String title, String routeName) {
    return Container(
      margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14.0),
      ),
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(14.0),
        color: Colors.white,
        child: InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(14)),
          onTap: () {
            Navigator.pushNamed(context, routeName);
          },
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Column(
              children: [
                Expanded(
                    flex: 3,
                    child: SvgPicture.asset(
                      'assets/images/$imagePath.svg',
                    )),
                Expanded(
                    flex: 1,
                    child: text400normal(
                      data: title,
                      fontsize: size.height * 0.02,
                      fontWeight: FontWeight.w500,
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  int _calculateCrossAxisCountcharts(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    int itemCountPerRow = screenWidth ~/ 300;
    if (screenWidth > 600) {
      itemCountPerRow = screenWidth ~/ 300;
    }
    return itemCountPerRow > 0 ? itemCountPerRow : 1;
  }

  int _calculateCrossAxisCount(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    int itemCountPerRow = screenWidth ~/ 180;
    if (screenWidth > 600) {
      itemCountPerRow = screenWidth ~/ 250;
    }
    return itemCountPerRow > 0 ? itemCountPerRow : 1;
  }

  Map<String, int> getCountOfUsersPerCardType(List<Customer> customers) {
    Map<String, int> userCountPerCardType = {};

    for (var customer in customers) {
      userCountPerCardType.update(
        customer.CardType,
        (value) => value + 1,
        ifAbsent: () => 1,
      );
    }

    return userCountPerCardType;
  }
}

class _PieData {
  _PieData(this.xData, this.yData, this.text);
  final String xData;
  final int yData;
  final String text;
}

class _ChartData {
  _ChartData(this.x, this.y);

  final String x;
  final double y;
}
