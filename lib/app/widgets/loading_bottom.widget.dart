import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class LoadingBottomWidget extends StatelessWidget {
  const LoadingBottomWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomFooter(
      height: 30,
      builder: (context, mode) {
        return Center(
          child: CupertinoActivityIndicator(),
        );
      },
    );
  }
}
