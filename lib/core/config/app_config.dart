class AppConfig {
  static const String appName = 'ShopPro';
  static const String appVersion = '3.2.0';
  static const String appBuildNumber = '25';

  // API Configuration
  static const String baseUrl = 'https://api.shoppro.com/v3';
  static const String paymentApiUrl = 'https://payments.shoppro.com/v1';
  static const String analyticsApiUrl = 'https://analytics.shoppro.com/v1';
  static const String recommendationApiUrl = 'https://ai.shoppro.com/v1';

  // Payment Configuration
  static const String stripePublishableKey = 'pk_test_...';
  static const String paypalClientId = 'your_paypal_client_id';
  static const String razorpayKeyId = 'rzp_test_...';
  static const String paystackPublicKey = 'pk_test_...';

  // Feature Flags
  static const bool enablePushNotifications = true;
  static const bool enableLocationServices = true;
  static const bool enableSocialLogin = true;
  static const bool enableWishlist = true;
  static const bool enableReviews = true;
  static const bool enableChat = true;
  static const bool enableAR = false;
  static const bool enableAIRecommendations = true;

  // Database Configuration
  static const String databaseName = 'ecommerce_shop.db';
  static const int databaseVersion = 2;

  // Cache Configuration
  static const int imageCacheDays = 30;
  static const int productCacheHours = 6;
  static const int userCacheHours = 24;

  // UI Configuration
  static const double defaultPadding = 16.0;
  static const double defaultRadius = 12.0;
  static const double cardRadius = 16.0;
  static const double buttonRadius = 8.0;

  // Animation Configuration
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
  static const Duration fastAnimationDuration = Duration(milliseconds: 150);
  static const Duration slowAnimationDuration = Duration(milliseconds: 500);

  // Pagination
  static const int productsPerPage = 20;
  static const int ordersPerPage = 10;
  static const int reviewsPerPage = 15;

  // Search Configuration
  static const int minSearchLength = 2;
  static const int maxSearchHistory = 20;
  static const int searchDebounceMs = 500;

  // Cart Configuration
  static const int maxCartItems = 50;
  static const int maxQuantityPerItem = 10;

  // Wishlist Configuration
  static const int maxWishlistItems = 100;

  // Notification Configuration
  static const String orderChannelId = 'order_notifications';
  static const String promotionChannelId = 'promotion_notifications';
  static const String generalChannelId = 'general_notifications';

  // Social Media
  static const String facebookAppId = 'your_facebook_app_id';
  static const String instagramClientId = 'your_instagram_client_id';
  static const String twitterApiKey = 'your_twitter_api_key';

  // Analytics Events
  static const String productViewEvent = 'product_viewed';
  static const String addToCartEvent = 'add_to_cart';
  static const String purchaseEvent = 'purchase';
  static const String searchEvent = 'search';
  static const String wishlistEvent = 'wishlist_toggle';

  // Error Messages
  static const String networkError = 'Please check your internet connection';
  static const String serverError = 'Something went wrong. Please try again';
  static const String authError = 'Please login to continue';
  static const String paymentError = 'Payment failed. Please try again';

  // Success Messages
  static const String orderPlacedSuccess = 'Order placed successfully!';
  static const String itemAddedToCart = 'Item added to cart';
  static const String itemAddedToWishlist = 'Item added to wishlist';
  static const String profileUpdated = 'Profile updated successfully';

  // Validation Rules
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 50;
  static const int minNameLength = 2;
  static const int maxNameLength = 50;
  static const int maxAddressLength = 200;
  static const int maxReviewLength = 500;

  // Currency Configuration
  static const String defaultCurrency = 'USD';
  static const String currencySymbol = '\$';
  static const int currencyDecimals = 2;

  // Shipping Configuration
  static const double freeShippingThreshold = 50.0;
  static const double standardShippingCost = 5.99;
  static const double expressShippingCost = 9.99;
  static const int standardShippingDays = 5;
  static const int expressShippingDays = 2;

  // Return Policy
  static const int returnWindowDays = 30;
  static const int exchangeWindowDays = 14;

  // AI Configuration
  static const String recommendationModel = 'product_recommender_v2.tflite';
  static const String searchModel = 'search_optimizer_v1.tflite';
  static const double recommendationThreshold = 0.7;
  static const int maxRecommendations = 10;

  // Performance Configuration
  static const int imageCompressionQuality = 85;
  static const int thumbnailSize = 200;
  static const int fullImageSize = 800;

  // Security Configuration
  static const int maxLoginAttempts = 5;
  static const int sessionTimeoutMinutes = 60;
  static const bool enableBiometricAuth = true;
  static const bool enableTwoFactorAuth = false;

  // Development Configuration
  static const bool enableLogging = true;
  static const bool enableCrashReporting = true;
  static const bool enablePerformanceMonitoring = true;
}
