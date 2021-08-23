abstract class Endpoints {
  static const String IAM_URL = 'https://agreen-iam.azurewebsites.net/api';
  static const String API_URL = 'https://agreen-prod.azurewebsites.net/api';

 // static const String API_URL = 'http://b67fb7c6210d.ngrok.io/api';
 // static const String IAM_URL = 'https://207fd08fb42b.ngrok.io/api';

  //Auth
  static const String LOGIN = '$IAM_URL/iam/authentication/login';
  static const String USER_PROFILE = '$API_URL/users?lastAccess=true';
  static const String UPDATE_USER_PROFILE = '$API_URL/users/mobile-update-user-info';
  static const String REFRESH_TOKEN = '$IAM_URL/iam/authentication/refresh';
  static const String FORGOT_PASSWORD = '$API_URL/users/forgot-password';
  static const String RESET_PASSWORD = '$API_URL/users/reset-password';

  //Notification
  static const String NOTIFICATION = '$API_URL/notifications';

  //Contact
  static const String CONTACT = '$API_URL/contacts';
  static const String LIST_CONTACT = '$API_URL/contacts/advance-search';
  static const String CONVERSATION = '$API_URL/conversations/contact';

  //Contract
  static const String CONTRACT = '$API_URL/contracts';
  static const String OPEN_CONTRACT = '$API_URL/contracts/open-contracts';
  static const String OPEN_CONTRACT_SEARCH = '$API_URL/contracts/open/advance-search';
  static const String PAST_CONTRACT_VOLUME = '$API_URL/contracts/past-contracts/volume';
  static const String PAST_CONTRACT_VOLUME_DETAIL = '$API_URL/contracts/past-contracts/volume/detail';
  static const String PAST_CONTRACT_PRICE = '$API_URL/contracts/past-contracts/price';
  static const String PAST_CONTRACT_PRICE_DETAIL = '$API_URL/contracts/past-contracts/price/detail';
  static const String PAST_CONTRACT_PERFORMANCE = '$API_URL/contracts/past-contracts/performance';
  static const String PAST_CONTRACT_PERFORMANCE_DETAIL = '$API_URL/contracts/past-contracts/performance/detail';

  //Dashboard
  static const String WIDGET = '$API_URL/widget';
  static const String DASHBOARD = '$API_URL/dashboard';
  static const String MARKET_PULSE = '$API_URL/dashboard/market-pulses';
  static const String LATEST_MARKET_PULSE =
      '$API_URL/dashboard/market-pulses/latest';

  //Offer
  static const String OFFER = '$API_URL/offers';
  static const String OFFER_ADVANCED_SEARCH = '$API_URL/offers/search';
  static const String OFFER_SIMPLE_SEARCH = '$API_URL/offers/simple-search';
  static const String FAVORITE_OFFER = '$API_URL/offers/favorite';

  //Request
  static const String REQUEST = '$API_URL/requests';
  static const String REQUEST_SIMPLE_SEARCH = '$API_URL/requests/search';
  static const String REQUEST_ADVANCED_SEARCH = '$API_URL/requests/advance-search';

  static const String SUPPLIER = '$API_URL/users/suppliers';

  //Lookup
  static const String LOOK_UP = '$API_URL/terms/list';
  static const String CROP_YEAR = '$API_URL/terms/crop-year';
  static const String TENANT_WAREHOUSE = '$API_URL/users/buyer/warehouses';

  //Chat
  static const String CHAT = '$API_URL/conversations';

  //Upload
  static const String UPLOAD = '$API_URL/storage/upload';

  //Other service
  static const String OTHER_SERVICE = '$API_URL/other-services';
}
