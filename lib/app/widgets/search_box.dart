import 'package:agree_n/app/theme/theme.dart';
import 'package:agree_n/app/utils/debounce.dart';

import 'package:flutter/material.dart';

class SearchBox extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onSearch;
  final String hintText;
  final EdgeInsetsGeometry margin;
  final _debounce = Debounce(milliseconds: 1000);

  SearchBox({
    Key key,
    this.controller,
    this.onSearch,
    this.hintText,
    this.margin = const EdgeInsets.all(0),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      margin: margin,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: kPrimaryColor.withOpacity(0.28),
            offset: Offset(0, 0),
            blurRadius: 5.0,
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        // onFieldSubmitted: onSearch,
        onChanged: (text) {
          _debounce.run(() => onSearch(text));
        },
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: hintText,
          suffixIcon: Icon(
            Icons.search,
            color: kPrimaryColor,
          ),
          hintStyle: TextStyle(
            fontSize: 12,
            color: kHintTextColor,
            fontWeight: FontWeight.w300,
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: kHorizontalContentPadding),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: kPrimaryColor.withOpacity(0.5),
            ),
            borderRadius: BorderRadius.circular(5),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: kPrimaryColor.withOpacity(0.5),
            ),
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ),
    );
  }
}
