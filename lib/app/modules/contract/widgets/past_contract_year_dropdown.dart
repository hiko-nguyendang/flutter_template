import 'package:flutter/material.dart';

class PastContractYearDropDown extends StatelessWidget {
  final int value;
  final double sizeIcon;
  final List<int> items;
  final void Function(int) onChanged;

  PastContractYearDropDown(
      {this.value, this.items, this.onChanged, this.sizeIcon});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton(
          icon: Icon(
            Icons.arrow_drop_down,
            size: sizeIcon != null ? sizeIcon : 16,
            color: Colors.grey,
          ),
          isExpanded: true,
          value: value,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
          items: items.map((int year) {
            return DropdownMenuItem<int>(
              value: year,
              child: Center(child: Text('$year')),
            );
          }).toList(),
          onChanged: onChanged),
    );
  }
}
