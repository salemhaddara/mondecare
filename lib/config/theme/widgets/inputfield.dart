import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mondecare/config/theme/colors.dart';

// ignore: must_be_immutable
class InputField extends StatefulWidget {
  final bool isPassword;
  final String hint;
  bool initialState = false;
  final String? Function(String?) validator;
  Color? color;
  final Function(String?) onChanged;
  double? height;
  bool? withStroke;
  bool isNumber;
  InputField(
      {Key? key,
      required this.isPassword,
      required this.hint,
      required this.initialState,
      required this.validator,
      required this.onChanged,
      this.height,
      this.withStroke,
      this.isNumber = false,
      this.color})
      : super(key: key);

  @override
  _InputFieldState createState() => _InputFieldState(initialState);
}

class _InputFieldState extends State<InputField> {
  bool isVisible = false;
  _InputFieldState(bool istrue) {
    isVisible = istrue;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          constraints: const BoxConstraints(minHeight: 54, maxWidth: 600),
          child: TextFormField(
            onChanged: (text) {
              widget.onChanged(text);
            },
            obscureText: isVisible,
            cursorColor: darkgrey,
            keyboardType:
                widget.isNumber ? TextInputType.number : TextInputType.name,
            maxLines: widget.height != null ? 4 : 1,
            validator: widget.validator,
            autovalidateMode: AutovalidateMode.always,
            style: GoogleFonts.montserrat(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.normal,
            ),
            decoration: InputDecoration(
              errorStyle: GoogleFonts.nunitoSans(color: darkred),
              hintText: widget.hint,
              filled: true,
              fillColor: white,
              errorBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(13)),
                  borderSide: BorderSide(color: darkred)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: darkgrey, width: 2),
                  borderRadius: const BorderRadius.all(Radius.circular(13))),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: darkgrey, width: 2),
                  borderRadius: const BorderRadius.all(Radius.circular(13))),
              focusedErrorBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(13)),
                  borderSide: BorderSide(color: Colors.red)),
              suffixIcon: widget.isPassword
                  ? Container(
                      height: 44,
                      width: 24,
                      alignment: Alignment.center,
                      child: InkWell(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        child: SvgPicture.asset(
                          isVisible
                              ? 'assets/images/hiddenpass.svg'
                              : 'assets/images/visiblepass.svg',
                        ),
                        onTap: () {
                          setState(() {
                            isVisible = !isVisible;
                          });
                        },
                      ),
                    )
                  : const SizedBox(
                      height: 1,
                      width: 1,
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
