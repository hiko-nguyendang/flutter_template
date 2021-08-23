import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:agree_n/app/theme/theme.dart';
import 'package:agree_n/generated/locales.g.dart';
import 'package:agree_n/app/widgets/loading_widget.dart';

class MessageDialog {
  static void showLoading() {
    Get.dialog(LoadingWidget());
  }

  static void hideLoading() {
    if (Get.isDialogOpen) {
      Get.back();
    }
  }

  static void confirm(String message,
      {String title,
      String confirmButtonText,
      Color confirmButtonColor,
      String cancelButtonText,
      Color cancelButtonColor = Colors.black12,
      TextStyle errorTextStyle,
      Function onClosed,
      Function onConfirmed}) {
    _showDialog(
      content: message,
      title: title,
      contentTextStyle: errorTextStyle ??
          TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w400,
            fontSize: 14,
          ),
      onClosed: onClosed,
      onConfirmed: onConfirmed,
      confirmButtonText: confirmButtonText,
      confirmButtonColor: confirmButtonColor,
      cancelButtonText: cancelButtonText,
      cancelButtonColor: cancelButtonColor,
      isConfirmDialog: true,
    );
  }

  static void showMessage(String message,
      {String title,
      TextStyle contentTextStyle,
      Function onClosed,
      Color textColor = Colors.black}) {
    _showDialog(
        content: message,
        title: title,
        textColor: textColor,
        contentTextStyle: contentTextStyle ??
            TextStyle(
              color: textColor,
              fontWeight: FontWeight.w400,
              fontSize: 18,
            ),
        onClosed: onClosed,
        isConfirmDialog: false);
  }

  static void showError(
      {String message,
      String title,
      TextStyle contentTextStyle,
      Function onClosed}) {
    _showDialog(
      content: message ?? LocaleKeys.Shared_ErrorMessage.tr,
      title: LocaleKeys.Shared_Error.tr,
      contentTextStyle: contentTextStyle ??
          TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w400,
            fontSize: 14,
          ),
      onClosed: onClosed,
      isConfirmDialog: false,
    );
  }

  static void _showDialog(
      {String title,
      String content,
      String confirmButtonText,
      Color confirmButtonColor,
      String cancelButtonText,
      Color cancelButtonColor,
      TextStyle contentTextStyle,
      Function onConfirmed,
      Function onClosed,
      Color textColor,
      bool isConfirmDialog = false}) {
    Get.generalDialog(
      barrierDismissible: false,
      barrierColor: Color.fromRGBO(0, 0, 0, 0.3),
      transitionDuration: Duration(milliseconds: 0),
      pageBuilder: (context, _, __) {
        return AlertDialog(
          title: title != null
              ? Text(
                  title,
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                )
              : null,
          insetPadding:
              const EdgeInsets.symmetric(horizontal: kHorizontalContentPadding),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(5.0),
            ),
          ),
          content: ConstrainedBox(
            constraints: new BoxConstraints(
              minWidth: 0,
              minHeight: 30,
            ),
            child: Text(
              content,
              style: contentTextStyle,
              textAlign: TextAlign.center,
            ),
          ),
          contentPadding: const EdgeInsets.only(
            top: 20,
            left: kHorizontalContentPadding,
            right: kHorizontalContentPadding,
          ),
          buttonPadding: EdgeInsets.zero,
          actions: <Widget>[
            FlatButton(
              child: Text(
                cancelButtonText != null ? cancelButtonText : 'OK',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              onPressed: () {
                if (onClosed != null) {
                  onClosed();
                } else {
                  Get.back();
                }
              },
            ),
            if (isConfirmDialog)
              FlatButton(
                child: Text(
                  confirmButtonText != null ? confirmButtonText : 'OK',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: confirmButtonColor != null
                        ? confirmButtonColor
                        : Theme.of(context).primaryColor,
                  ),
                ),
                onPressed: () {
                  if (onConfirmed != null) {
                    Get.back();
                    onConfirmed();
                  } else {
                    Get.back();
                  }
                },
              ),
          ],
        );
      },
    );
  }
}
