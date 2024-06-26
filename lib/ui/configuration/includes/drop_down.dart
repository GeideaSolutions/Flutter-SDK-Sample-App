import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:test_app/storage/app_preference.dart';

class MyDropDown extends StatelessWidget {
  final String hint;
  final String initialValue;
  final List<String> items;
  final String keyPref;
  final Function(dynamic)? onChange;

  const MyDropDown({
    super.key,
    required this.hint,
    required this.initialValue,
    required this.items,
    required this.keyPref,
    this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2(
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        border: const OutlineInputBorder(),
        labelText: hint,
        counterText: "",
      ),
      isExpanded: true,
      items: items
          .map((item) => DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ))
          .toList(),
      validator: (value) {
        if (value == null) {
          return 'Please select connectivity.';
        }
        return null;
      },
      onChanged: (value) {
        if (onChange != null) {
          onChange!(value);
        } else {
          value.addPrefData(keyPref);
        }
      },
      onSaved: (value) {
        if (onChange != null) {
          onChange!(value);
        } else {
          value.addPrefData(keyPref);
        }
      },
      value: initialValue,
      iconStyleData: const IconStyleData(
        icon: Icon(
          Icons.arrow_drop_down,
        ),
        iconSize: 30,
      ),
    );
  }
}
