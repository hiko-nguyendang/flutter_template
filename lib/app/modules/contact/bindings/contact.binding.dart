import 'package:get/get.dart';

//
import 'package:agree_n/app/data/providers/contact.provider.dart';
import 'package:agree_n/app/data/repositories/contact.repository.dart';
import 'package:agree_n/app/modules/contact/controllers/contact.controller.dart';

class ContactBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ContactController>(
      () => ContactController(
        repository: ContactRepository(
          apiClient: ContactProvider(),
        ),
      ),
    );
  }
}
