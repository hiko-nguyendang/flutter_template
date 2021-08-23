import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:agree_n/app/enums/enums.dart';
import 'package:agree_n/app/theme/theme.dart';
import 'package:agree_n/app/data/models/contract.model.dart';
import 'package:agree_n/app/modules/auth/controllers/auth.controller.dart';
import 'package:agree_n/app/modules/chat/controllers/chat.controller.dart';

class ChatTerms extends StatelessWidget {
  final AuthController _authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(
      init: Get.find(),
      builder: (controller) {
        if (controller.terms == null || controller.terms.isEmpty) {
          return SizedBox();
        }
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: kHorizontalContentPadding,
            vertical: 10,
          ),
          child: Wrap(
            spacing: 5,
            runSpacing: 3,
            crossAxisAlignment: WrapCrossAlignment.end,
            alignment: WrapAlignment.center,
            children: controller.terms
                .map((term) => _buildTermItem(controller, term))
                .toList(),
          ),
        );
      },
    );
  }

  Widget _buildTermItem(ChatController controller, TermModel term) {
    return GestureDetector(
      onTap: () {
        Get.focusScope.unfocus();
        if (_authController.currentUser.isSupplier && !term.isNew ||
            _authController.currentUser.isBuyer &&
                !controller.isTermInProgress) {
          controller.onSelectTerm(term);
        }
      },
      child: Container(
        padding: const EdgeInsets.only(left: 8, top: 2, bottom: 2, right: 2),
        decoration: BoxDecoration(
          color: term.isSelecting ? Color(0xffeef7f4) : Colors.white,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(
            color: term.status == TermStatusEnum.Accepted ||
                    term.status == TermStatusEnum.Skipped
                ? kPrimaryColor
                : term.isSelecting
                    ? kPrimaryColor.withOpacity(0.6)
                    : Colors.grey[500],
          ),
        ),
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 5,
          children: [
            Text(
              term.displayName,
              style: TextStyle(
                fontSize: 14,
                color: term.status == TermStatusEnum.Skipped ||
                        term.status == TermStatusEnum.Accepted
                    ? kPrimaryColor
                    : term.isSelecting
                        ? kPrimaryColor.withOpacity(0.6)
                        : Colors.grey[500],
                fontWeight: FontWeight.w400,
              ),
            ),
            Icon(
              term.status == TermStatusEnum.Skipped ||
                      term.status == TermStatusEnum.Accepted
                  ? Icons.check_circle_rounded
                  : Icons.album_outlined,
              color: _statusColor(term),
              size: 20,
            )
          ],
        ),
      ),
    );
  }

  Color _statusColor(TermModel term) {
    if (term.status == TermStatusEnum.Skipped ||
        term.status == TermStatusEnum.Accepted) {
      return kPrimaryColor;
    }
    if (term.status == TermStatusEnum.InProgress) {
      return Colors.yellow[700];
    }
    return Colors.grey[500];
  }
}
