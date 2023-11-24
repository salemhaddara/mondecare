import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mondecare/authrepository.dart';
import 'package:mondecare/config/theme/colors.dart';
import 'package:mondecare/config/theme/widgets/drawer.dart';
import 'package:mondecare/config/theme/widgets/text400normal.dart';
import 'package:mondecare/feature/admins/adminsStates/adminsbloc.dart';
import 'package:mondecare/feature/admins/adminsStates/adminsstate.dart';

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
          create: (context) => adminsbloc(context.read<authrepository>()),
          child: SafeArea(
            child: LayoutBuilder(builder: (context, constraints) {
              return SizedBox(
                  height: constraints.maxHeight,
                  width: constraints.maxWidth,
                  child: Column(
                    children: [
                      _homeTitle(size),
                      Expanded(
                          child: Container(
                              constraints: const BoxConstraints(maxWidth: 600),
                              width: size.width,
                              child: ListView.builder(
                                  itemCount: 4,
                                  physics: const BouncingScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return null;
//PUT HERE A BLOC BUILDER AND MAKE GIVE IT THE NAME EMAIL AND THE ID FROM THE STATE LIST
                                    // return  ContainerWithCircleAvatar(name: ,);
                                  }))),
                    ],
                  ));
            }),
          ),
        ));
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

class ContainerWithCircleAvatar extends StatelessWidget {
  String name, id, email;
  double fontsize;
  ContainerWithCircleAvatar(
      {super.key,
      required this.name,
      required this.email,
      required this.id,
      required this.fontsize});

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(14.0),
      elevation: 4.0,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600.0),
        margin: const EdgeInsets.all(10.0),
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 40.0,
              backgroundImage: AssetImage('assets/images/person.png'),
            ),
            const SizedBox(width: 20.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                text400normal(
                  data: 'Name : $name',
                  fontsize: fontsize,
                ),
                text400normal(
                  data: 'Email : $email',
                  fontsize: fontsize,
                ),
                text400normal(
                  data: 'id : $id',
                  fontsize: fontsize,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
