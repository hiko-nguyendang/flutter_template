import 'package:get/get.dart';

import 'package:agree_n/app/modules/chat/views/chat.view.dart';
import 'package:agree_n/app/modules/auth/views/login.view.dart';
import 'package:agree_n/app/modules/base/views/splash.view.dart';
import 'package:agree_n/app/modules/auth/views/profile.view.dart';
import 'package:agree_n/app/modules/auth/views/register.view.dart';
import 'package:agree_n/app/modules/base/views/language.view.dart';
import 'package:agree_n/app/modules/base/views/navigation.view.dart';
import 'package:agree_n/app/modules/chat/bindings/chat.binding.dart';
import 'package:agree_n/app/modules/auth/bindings/auth.binding.dart';
import 'package:agree_n/app/modules/contact/views/contacts.view.dart';
import 'package:agree_n/app/modules/offer/bindings/offer.binding.dart';
import 'package:agree_n/app/modules/offer/views/buyer_offer.view.dart';
import 'package:agree_n/app/modules/offer/views/create_offer.view.dart';
import 'package:agree_n/app/modules/chat/views/conversations.view.dart';
import 'package:agree_n/app/modules/dashboard/views/dashboard.view.dart';
import 'package:agree_n/app/modules/auth/views/forgot_password.view.dart';
import 'package:agree_n/app/modules/offer/views/create_request.view.dart';
import 'package:agree_n/app/modules/offer/views/supplier_offer.view.dart';
import 'package:agree_n/app/modules/contact/views/contact_rate.view.dart';
import 'package:agree_n/app/modules/contact/bindings/contact.binding.dart';
import 'package:agree_n/app/modules/contract/views/past_contracts.view.dart';
import 'package:agree_n/app/modules/contract/bindings/contract.binding.dart';
import 'package:agree_n/app/modules/contract/views/create_contract.view.dart';
import 'package:agree_n/app/modules/dashboard/bindings/dashboard.binding.dart';
import 'package:agree_n/app/modules/dashboard/views/buyer_market_pulse.view.dart';
import 'package:agree_n/app/modules/notification/views/notification.view.dart';
import 'package:agree_n/app/modules/chat/middleware/conversation.middleware.dart';
import 'package:agree_n/app/modules/other_service/views/other_service.view.dart';
import 'package:agree_n/app/modules/contract/views/finalize_the_contract.view.dart';
import 'package:agree_n/app/modules/notification/bindings/notification.binding.dart';
import 'package:agree_n/app/modules/other_service/bindings/other_service.binding.dart';
import 'package:agree_n/app/modules/contract/views/open_purchases_contracts.view.dart';
import 'package:agree_n/app/modules/dashboard/middlewares/market_pulse.middleware.dart';

part 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.SPLASH;

  static final pages = [
    GetPage(
      name: Routes.SPLASH,
      page: () => SplashView(),
      bindings: [ AuthBinding(),],
    ),
    GetPage(
      name: Routes.LOGIN,
      page: () => LoginView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.REGISTER,
      page: () => RegisterView(),
    ),
    GetPage(
      name: Routes.RESET_PASSWORD,
      page: () => ForgotPasswordView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.PROFILE,
      page: () => ProfileView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.LANGUAGE,
      page: () => LanguageView(),
    ),
    GetPage(
      name: Routes.NAVIGATION,
      page: () => NavigationView(),
      transition: Transition.rightToLeft,
      binding: AuthBinding(),
    ),

    ///
    GetPage(
      name: Routes.DASHBOARD,
      page: () => DashboardView(),
      binding:DashboardBinding() ,
    ),
    GetPage(
      name: Routes.BUYER_MARKET_PULSE,
      page: () => BuyerMarketPulseScreen(),
      binding: DashboardBinding(),
      middlewares: [
        MarketPulseMiddleware(),
      ],
    ),

    ///
    GetPage(
      name: Routes.NOTIFICATION,
      page: () => NotificationView(),
      binding: NotificationBinding(),
    ),
    GetPage(
      name: Routes.CHAT,
      page: () => ChatView(),
      binding: ChatBinding(),
    ),
    GetPage(
      name: Routes.CONVERSATIONS,
      page: () => ConversationsView(),
      binding: ChatBinding(),
      middlewares: [
        ConversationMiddleWare(),
      ],
    ),

    ///
    GetPage(
      name: Routes.OPEN_CONTRACTS,
      page: () => OpenContractsView(),
      binding: ContractBinding(),
    ),
    GetPage(
      name: Routes.PAST_CONTRACTS,
      page: () => PastContractsView(),
      binding: ContractBinding(),
    ),
    GetPage(
      name: Routes.CREATE_CONTRACT,
      page: () => CreateContractView(),
      binding: ContractBinding(),
    ),
    GetPage(
      name: Routes.FINALIZE_CONTRACT,
      page: () => FinalizeTheContractView(),
      binding: ContractBinding(),
    ),

    ///
    GetPage(
      name: Routes.CONTACTS,
      page: () => ContactsView(),
      binding: ContactBinding(),
    ),
    GetPage(
      name: Routes.CONTACT_RATE,
      page: () => ContactRateView(),
    ),

    ///
    GetPage(
      name: Routes.BUYER_OFFER,
      page: () => BuyerOfferView(),
      binding: OfferBinding(),
    ),
    GetPage(
      name: Routes.SUPPLIER_OFFER,
      page: () => SupplierOfferView(),
      binding: OfferBinding(),
    ),
    GetPage(
      name: Routes.CREATE_REQUEST,
      page: () => CreateRequestView(),
    ),

    GetPage(
      name: Routes.CREATE_OFFER,
      page: () => CreateOfferView(),
    ),

    ///
    GetPage(
      name: Routes.OTHER_SERVICES,
      page: () => OtherServiceView(),
      binding: OtherServiceBinding(),
    ),
  ];
}
