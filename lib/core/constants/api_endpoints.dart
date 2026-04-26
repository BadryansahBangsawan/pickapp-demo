class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl = 'https://api.pickup.example.com/api/v1';

  // Auth
  static const String sendOtp = '/auth/send-otp';
  static const String verifyOtp = '/auth/verify-otp';
  static const String googleLogin = '/auth/google';
  static const String appleLogin = '/auth/apple';
  static const String refreshToken = '/auth/refresh-token';
  static const String logout = '/auth/logout';

  // User
  static const String userMe = '/user/me';
  static const String userPhoto = '/user/me/photo';
  static const String userAddresses = '/user/addresses';

  // Ride
  static const String rideEstimate = '/ride/estimate';
  static const String rideBook = '/ride/book';
  static String rideById(String id) => '/ride/$id';
  static String rideCancel(String id) => '/ride/$id/cancel';
  static String rideRate(String id) => '/ride/$id/rate';

  // Food
  static const String restaurants = '/food/restaurants';
  static String restaurantById(String id) => '/food/restaurants/$id';
  static String restaurantMenu(String id) => '/food/restaurants/$id/menu';
  static const String foodOrders = '/food/orders';

  // Wallet
  static const String walletBalance = '/wallet/balance';
  static const String walletTransactions = '/wallet/transactions';
  static const String walletTopup = '/wallet/topup';

  // Location
  static const String locationSearch = '/location/search';
  static const String locationReverse = '/location/reverse';
  static const String locationAutocomplete = '/location/autocomplete';

  // Notifications
  static const String notifications = '/notifications';
  static const String fcmToken = '/user/fcm-token';

  // Promo
  static const String promoBanners = '/promos/banners';
  static const String promoVouchers = '/promos/vouchers';
}
