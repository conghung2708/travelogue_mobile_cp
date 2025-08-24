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

  //Tour Guide
  static const tourGuide = 'api/tour-guide';

  //Tour Guide Filter
  static const String tourGuideFilter = "/api/tour-guide/filter";

  //Booking Tour
  static const String createBookingTour = '/api/booking/create-booking-tour';

  //Create Payment Link
  static const String createPaymentLink = 'api/booking/create-payment-link';

  //Booking Tour Guide
  static const String createBookingTourGuide =
      'api/booking/create-booking-tour-guide';

  //Get My Bookings
  static const String getMyBookings = '/api/booking/my-bookings';

  //Get Workshop
  static const String getWorkshops = 'api/workshop';

  //Get Workshop Detail
  static const String getWorkshopDetail = 'api/workshop';

  //Booking Workshop
  static const String createBookingWorkshop =
      'api/booking/create-booking-workshop';

  //Tour Guide Request
  static const String tourGuideRequest = 'api/user/tour-guide-request';

  //Nearest Cuisine
  static const String nearestCuisine = '/api/location/nearest-cuisine';

  //Nearest Historical
  static const String nearestHistorical = '/api/location/nearest-historical';

  //Get Trip Plans
  static const String tripPlans = 'api/trip-plans';

  //Update Trip Plan
  static const String tripPlan = 'api/trip-plans/trip-plan';

  //Update Trip Plan Location
  static const String tripPlanLocation = 'api/trip-plans/trip-plan-location';

  //Cancel Booking
  static const String cancelBooking = '/api/booking';

  //Upload multiple certifications
  static const String uploadMultipleCertifications =
      '/api/media/upload-multiple-certifications';

  //Get User
  static const String getUserByIdBase = '/api/user';

  //Refund Request
  static const String createRefundRequest = '/api/refund-request';

  static const String getUserRefundRequests = '/api/refund-request/user';

  static const String getBookingById = '/api/booking';

  static const String withdrawalRequest = '/api/wallet/withdrawal-request';

  static const String bankAccount = 'api/bank-account';

  static const String getCurrentUser = '/api/auth/get-current-user';

  static const String reviewBooking = '/api/booking/review-booking';

  static const String updateUserBase = '/api/user';

  static const String updateUserAvatar = '/api/user/update-avatar';

  static const String getMyReviews = '/api/booking/my-reviews';

  static const String reportReview = '/api/report';

  static const String getMyReports = '/api/report/my-reports';

  static String updateReport(String id) => '/api/report/$id';

  static String deleteReport(String id) => '/api/report/$id';

  static const String uploadMultipleImages =
      '/api/media/upload-multiple-images';

  static const String refundRequest = '/api/refund-request';

  static const String myWithdrawalRequestsFilter = '/api/wallet/my-withdrawal-requests/filter'; 
}
