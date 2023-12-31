// ignore_for_file: library_private_types_in_public_api, camel_case_types, must_be_immutable

import 'package:flutter/material.dart';

class questionsdropDownMenu extends StatefulWidget {
  Function(String) onChanged;
  questionsdropDownMenu({super.key, required this.onChanged});

  @override
  _questionsdropDownMenuState createState() => _questionsdropDownMenuState();
}

class _questionsdropDownMenuState extends State<questionsdropDownMenu> {
  String _selectedItem = 'Option 1'; // Default selected item

  // List of items for the dropdown menu
  final List<String> _dropdownItems = ['Option 1', 'Option 2', 'Option 3'];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      width: MediaQuery.of(context).size.width,
      constraints: const BoxConstraints(maxWidth: 600),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(), // Add border for better visibility
        borderRadius: BorderRadius.circular(8.0), // Optional: Add border radius
      ),
      child: DropdownButton<String>(
        value: _selectedItem,
        icon: const Icon(Icons.arrow_drop_down),
        iconSize: 24,
        elevation: 16,
        style: const TextStyle(color: Colors.black),
        onChanged: (String? newValue) {
          widget.onChanged(newValue ?? '');
          setState(() {
            _selectedItem = newValue!;
          });
        },
        items: _dropdownItems.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}
