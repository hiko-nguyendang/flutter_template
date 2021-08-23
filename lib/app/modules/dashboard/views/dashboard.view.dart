import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:agree_n/app/modules/auth/controllers/auth.controller.dart';
import 'package:agree_n/app/modules/dashboard/views/buyer_dashboard.view.dart';
import 'package:agree_n/app/modules/dashboard/views/supplier_dashboard.view.dart';
import 'package:agree_n/app/modules/dashboard/controllers/dashboard.controller.dart';

class DashboardView extends GetView<DashboardController> {
  final AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    if (authController.currentUser.isSupplier) {
      return SupplierDashboardView();
    } else {
      return BuyerDashboardView();
    }
  }
}
