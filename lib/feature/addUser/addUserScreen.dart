// ignore_for_file: non_constant_identifier_names, camel_case_types

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mondecare/config/Models/Customer.dart';
import 'package:mondecare/config/theme/colors.dart';
import 'package:mondecare/config/theme/widgets/Snackbar.dart';
import 'package:mondecare/config/theme/widgets/drawer.dart';
import 'package:mondecare/config/theme/widgets/inputfield.dart';
import 'package:mondecare/config/theme/widgets/phoneinput.dart';
import 'package:mondecare/config/theme/widgets/text400normal.dart';
import 'package:mondecare/core/routes/routes.dart';
import 'package:mondecare/feature/addUser/adduserstates/adduser_bloc.dart';
import 'package:mondecare/feature/addUser/adduserstates/adduser_event.dart';
import 'package:mondecare/feature/addUser/adduserstates/adduser_state.dart';
import 'package:mondecare/feature/addUser/userAdditionStatus/userAdditionStatus.dart';
import 'package:mondecare/feature/addUser/widgets/choosePhotoWidget.dart';
import 'package:mondecare/usercontrolrepository.dart';

class addUserScreen extends StatefulWidget {
  const addUserScreen({super.key});

  @override
  State<addUserScreen> createState() => _addUserScreenState();
}

class _addUserScreenState extends State<addUserScreen> {
  late Size size;
  String? adminName,
      Name,
      IdentityNumber,
      CardNumber,
      Country = 'مصر',
      PhoneNumber,
      CardType;
  DateTime? Birthday, MemberShipDate;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
        drawer: drawer(
          choosed: 3,
        ),
        appBar: AppBar(
          backgroundColor: white,
          foregroundColor: darkgrey,
          title: text400normal(
            data: 'Add User',
            fontsize: MediaQuery.of(context).size.height * 0.025,
            fontWeight: FontWeight.w600,
          ),
          centerTitle: true,
        ),
        body: BlocProvider(
            create: (context) =>
                adduser_bloc(context.read<usercontrolrepository>()),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Container(
                margin: EdgeInsets.all(size.width * 0.02),
                child: Wrap(
                  children: [
                    _field(size, 'Admin Name', (text) {
                      adminName = text ?? '';
                    }),
                    _field(size, 'Name ', (text) {
                      Name = text ?? '';
                    }),
                    _field(size, 'Identity Number', (text) {
                      IdentityNumber = text ?? '';
                    }),
                    _field(size, 'Card Number', (text) {
                      CardNumber = text ?? '';
                    }),
                    _countryChooser(size),
                    _phoneNumber(size),
                    _datePickerBirthday(size, 'Birthday'),
                    _datePickerMembership(size, 'MemberShip Date'),
                    ChoosePhotoWidget(
                        imagePath1: 'assets/images/pearl.png',
                        imagePath2: 'assets/images/vip.png',
                        onImageSelected: (value) {
                          CardType = value;
                        }),
                    _signinButton(size, context),
                  ],
                ),
              ),
            )));
  }

  _datePickerMembership(Size size, String fieldTitle) {
    return Container(
      margin: const EdgeInsets.all(16),
      constraints: const BoxConstraints(maxWidth: 500),
      child: Column(
        children: [
          _title(size, fieldTitle),
          InkWell(
            borderRadius: const BorderRadius.all(Radius.circular(14)),
            onTap: () async {
              MemberShipDate = (await showDatePicker(
                  context: context,
                  initialDate: MemberShipDate ?? DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2030)));
              setState(() {});
            },
            child: Container(
              height: 54,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(14)),
                  color: white),
              constraints: const BoxConstraints(maxWidth: 600),
              alignment: Alignment.center,
              child: text400normal(
                  data: MemberShipDate != null
                      ? '${MemberShipDate!.day}/${MemberShipDate!.month}/${MemberShipDate!.year}'
                      : 'Choose Date',
                  align: TextAlign.center,
                  fontsize: size.height * 0.02),
            ),
          )
        ],
      ),
    );
  }

  _datePickerBirthday(Size size, String fieldTitle) {
    return Container(
      margin: const EdgeInsets.all(16),
      constraints: const BoxConstraints(maxWidth: 500),
      child: Column(
        children: [
          _title(size, fieldTitle),
          InkWell(
            borderRadius: const BorderRadius.all(Radius.circular(14)),
            onTap: () async {
              Birthday = (await showDatePicker(
                  context: context,
                  initialDate: Birthday ?? DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2030)));
              setState(() {});
            },
            child: Container(
              height: 54,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(14)),
                  color: white),
              constraints: const BoxConstraints(maxWidth: 600),
              alignment: Alignment.center,
              child: text400normal(
                  data: Birthday != null
                      ? '${Birthday!.day}/${Birthday!.month}/${Birthday!.year}'
                      : 'Choose Date',
                  align: TextAlign.center,
                  fontsize: size.height * 0.02),
            ),
          )
        ],
      ),
    );
  }

  _phoneNumber(Size size) {
    return Container(
      width: size.width,
      margin: const EdgeInsets.all(16),
      constraints: const BoxConstraints(maxWidth: 500),
      child: Column(
        children: [
          _title(size, 'Phone Number'),
          phoneinput(onChanged: (text) {
            PhoneNumber = text.completeNumber;
          }),
        ],
      ),
    );
  }

  _countryChooser(Size size) {
    return Container(
      width: size.width,
      margin: const EdgeInsets.all(16),
      constraints: const BoxConstraints(maxWidth: 500),
      child: Column(
        children: [
          _title(size, 'Country'),
          Container(
            width: size.width,
            height: 54,
            decoration: BoxDecoration(
                color: white,
                borderRadius: const BorderRadius.all(Radius.circular(14))),
            child: CountryCodePicker(
              onChanged: (country) {
                Country = convertArabicCountryToEnglish(country.name!);
              },
              initialSelection: '+20',
              showCountryOnly: true,
              showOnlyCountryWhenClosed: true,
              alignLeft: false,
            ),
          ),
        ],
      ),
    );
  }

  _field(Size size, String fieldTitle, Function(String?) onChanged) {
    return Container(
      margin: const EdgeInsets.all(16),
      constraints: const BoxConstraints(maxWidth: 500),
      child: Column(
        children: [
          _title(size, fieldTitle),
          InputField(
              isPassword: false,
              hint: '',
              initialState: false,
              validator: (text) {
                return null;
              },
              onChanged: (text) {
                onChanged(text);
              })
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

  Widget _signinButton(Size size, BuildContext pagecontext) {
    bool Navigated = false;
    bool isError = false;
    return BlocBuilder<adduser_bloc, adduser_state>(builder: (context, state) {
      if (state.requestStatus is successInsertion && !Navigated) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.of(pagecontext).pushReplacementNamed(homescreenRoute);
        });
        Navigated = true;
        return Container();
      }
      if (state.requestStatus is failedInsertion && !isError) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          ScaffoldMessenger.of(pagecontext).showSnackBar(showSnackbar(
              (state.requestStatus as failedInsertion).exception.toString(),
              size));
          state.copyWith(requestStatus: waitingrequest());
          context.read<adduser_bloc>().add(returnInitial());
        });
        isError = true;
        return Container();
      }
      return state.requestStatus is loadingrequest
          ? Container(
              margin: const EdgeInsets.only(top: 26),
              alignment: Alignment.center,
              child: CircularProgressIndicator(
                color: darkgrey,
                strokeWidth: 6,
              ),
            )
          : Container(
              margin: const EdgeInsets.only(top: 26),
              child: GestureDetector(
                onTap: () {
                  if (adminName != null &&
                      adminName!.isNotEmpty &&
                      Name != null &&
                      Name!.isNotEmpty &&
                      IdentityNumber != null &&
                      IdentityNumber!.isNotEmpty &&
                      CardNumber != null &&
                      CardNumber!.isNotEmpty &&
                      Country != null &&
                      Country!.isNotEmpty &&
                      PhoneNumber != null &&
                      PhoneNumber!.isNotEmpty &&
                      Birthday != null &&
                      MemberShipDate != null &&
                      CardType != null &&
                      CardType!.isNotEmpty) {
                    context.read<adduser_bloc>().add((SaveUser(
                        customer: Customer(
                            AdminName: adminName ?? '',
                            CustomerName: Name ?? '',
                            CustomerID: '',
                            CardNumber: CardNumber ?? '',
                            IdentityNumber: IdentityNumber ?? '',
                            PhoneNumber: PhoneNumber ?? '',
                            Country: Country ?? '',
                            CardType: CardType ?? '',
                            MemberShipDate: MemberShipDate ?? DateTime.now(),
                            Birthday: Birthday ?? DateTime.now()))));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        showSnackbar('Make Sure All Fields Are Filled', size));
                  }
                },
                child: Container(
                  height: size.height * 0.06,
                  width: size.width,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  constraints: const BoxConstraints(maxWidth: 500),
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(14),
                      ),
                      color: darkgrey),
                  alignment: Alignment.center,
                  child: text400normal(
                    data: 'Add Customer',
                    fontsize: size.height * 0.02,
                    textColor: motard,
                  ),
                ),
              ),
            );
    });
  }

  String convertArabicCountryToEnglish(String arabicCountry) {
    switch (arabicCountry) {
      case 'الجزائر':
        return 'Algeria';
      case 'البحرين':
        return 'Bahrain';
      case 'جزر القمر':
        return 'Comoros';
      case 'فلسطين':
        return 'Palestine';
      case 'مصر':
        return 'Egypt';
      case 'العراق':
        return 'Iraq';
      case 'الأردن':
        return 'Jordan';
      case 'الكويت':
        return 'Kuwait';
      case 'أفغانستان':
        return 'Afghanistan';
      case 'لبنان':
        return 'Lebanon';
      case 'ليبيا':
        return 'Libya';
      case 'موريتانيا':
        return 'Mauritania';
      case 'المغرب':
        return 'Morocco';
      case 'عمان':
        return 'Oman';
      case 'فلسطين':
        return 'Palestine';
      case 'قطر':
        return 'Qatar';
      case 'العربية السعودية':
        return 'Saudi Arabia';
      case 'الصومال':
        return 'Somalia';
      case 'السودان':
        return 'Sudan';
      case 'سوريا':
        return 'Syria';
      case 'تونس':
        return 'Tunisia';
      case 'دولة الإمارات العربية المتحدة':
        return 'United Arab Emirates';
      case 'اليمن':
        return 'Yemen';
      case 'إيران':
        return 'Iran';
      default:
        return arabicCountry;
    }
  }
}
