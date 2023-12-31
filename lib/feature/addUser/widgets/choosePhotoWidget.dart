// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:mondecare/config/theme/colors.dart';
import 'package:mondecare/core/utils/Backend/Backend.dart';

class ChoosePhotoWidget extends StatefulWidget {
  final String imagePath1;
  final String imagePath2;
  final String imagePath3;
  final Function(dynamic) onImageSelected;

  const ChoosePhotoWidget({
    Key? key,
    required this.imagePath1,
    required this.imagePath2,
    required this.imagePath3,
    required this.onImageSelected,
  }) : super(key: key);

  @override
  _ChoosePhotoWidgetState createState() => _ChoosePhotoWidgetState();
}

class _ChoosePhotoWidgetState extends State<ChoosePhotoWidget> {
  dynamic selectedValue;

  @override
  Widget build(BuildContext context) {
    double maxWidth = 500.0;
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      height: 108,
      constraints: const BoxConstraints(maxWidth: 1000),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: _buildImage(
              widget.imagePath1,
              maxWidth,
              screenWidth,
              Backend.cardTypePearl,
            ),
          ),
          Expanded(
            child: _buildImage(
              widget.imagePath2,
              maxWidth,
              screenWidth,
              Backend.cardTypeVip,
            ),
          ),
          Expanded(
            child: _buildImage(
              widget.imagePath3,
              maxWidth,
              screenWidth,
              Backend.cardTypePyramids,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage(
      String imagePath, double maxWidth, double screenWidth, dynamic value) {
    bool isSelected = selectedValue == value;

    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border.all(
          color: isSelected ? gold : Colors.transparent,
          width: isSelected ? 2.0 : 0.0,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedValue = value;
            widget.onImageSelected(selectedValue);
          });
        },
        child: Image.asset(
          imagePath,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
