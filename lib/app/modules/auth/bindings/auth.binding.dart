import 'package:get/get.dart';


import 'package:agree_n/app/data/providers/base.provider.dart';
import 'package:agree_n/app/data/repositories/base.repository.dart';
import 'package:agree_n/app/modules/base/controllers/base.controller.dart';
import 'package:agree_n/app/data/providers/user.provider.dart';
import 'package:agree_n/app/data/repositories/user.repository.dart';
import 'package:agree_n/app/modules/auth/controllers/auth.controller.dart';
import 'package:agree_n/app/modules/auth/controllers/login.controller.dart';
import 'package:agree_n/app/modules/auth/controllers/firebase.controller.dart';
import 'package:agree_n/app/modules/auth/controllers/forgot_password.controller.dart';
import 'package:agree_n/app/modules/auth/controllers/reset_password.controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<BaseController>(
      BaseController(
        repository: BaseRepository(
          apiClient: BaseProvider(),
        ),
      ),
      permanent: true,
    );
    Get.put<FireBaseController>(
      FireBaseController(),
      permanent: true,
    );
    Get.put<AuthController>(
      AuthController(
        repository: UserRepository(
          apiClient: UserProvider(),
        ),
      ),
      permanent: true,
    );
    Get.lazyPut(
      () => LoginController(
        repository: UserRepository(
          apiClient: UserProvider(),
        ),
      ),
    );
    Get.lazyPut<ForgotPasswordController>(
      () => ForgotPasswordController(
        repository: UserRepository(
          apiClient: UserProvider(),
        ),
      ),
    );
    Get.lazyPut<ResetPasswordController>(
      () => ResetPasswordController(
        repository: UserRepository(
          apiClient: UserProvider(),
        ),
      ),
    );
  }
}
