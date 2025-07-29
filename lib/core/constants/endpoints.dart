class Endpoints {
  static const login = 'api/auth/login';
  static const register = 'api/auth/register';
  static const sendOTPEmail = 'api/auth/forgot-password';
  static const checkValidOTP = 'api/auth/check-valid-code';
  static const resetPassword = 'api/auth/reset-password';
  static const loginGoogle = 'api/auth/google-login';
  static const sendContactSupport = 'api/user/send-feedback';

  // Home
  static const locationType = 'api/type-location';
  static const events = 'api/event';

  // Location
  static const searchLocation = 'api/location/filter-paged';
  static const locationFavorite = 'api/location/favorite';

  // Details Location
  static const location = 'api/location';
  static const hotelByLocation = '/recommended-hotels';
  static const restaurantLocation = '/recommended-restaurants';

  // News
  static const news = 'api/news';

  // Experience
  static const experiences = 'api/experience';

  //Restaurant
  static const restaurant = 'api/restaurant';

  //Tour
  static const tour = 'api/tour';
}
