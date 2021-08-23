part of 'app_pages.dart';

abstract class Routes {
  ///
  static const SPLASH = '/splash';
  static const LANGUAGE = '/language';
  static const LOGIN = '/login';
  static const REGISTER = '/register';
  static const RESET_PASSWORD = '/reset_password';
  static const PROFILE = '/profile';
  static const NAVIGATION = '/navigation';

  ///
  static const CHAT = '/chat';
  static const CONVERSATIONS = '/conversations';
  static const NOTIFICATION = '/notification';

  ///
  static const DASHBOARD = '/dashboard';
  static const BUYER_MARKET_PULSE = '/market_pulse';

  ///
  static const PAST_CONTRACTS = '/past_contracts';
  static const OPEN_CONTRACTS = '/open_contracts';
  static const CREATE_CONTRACT = '/buyer_create_contract';
  static const FINALIZE_CONTRACT = '/finalize_contract';

  ///
  static const CONTACTS = '/contacts';
  static const CONTACT_RATE = '/contact_rate';

  ///
  static const BUYER_OFFER = '/buyer_offer';
  static const SUPPLIER_OFFER = '/supplier_offer';
  static const CREATE_REQUEST = '/create_request';

  ///
  static const OTHER_SERVICES = '/other_services';

  ///
  static const CREATE_OFFER = '/create_offer';
}
