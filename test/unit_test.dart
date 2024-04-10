import 'package:flutter_test/flutter_test.dart';
import 'package:ecommerce_shop/core/config/app_config.dart';

void main() {
  group('AppConfig Tests', () {
    test('should have correct app name', () {
      expect(AppConfig.appName, equals('ShopPro'));
    });

    test('should have correct app version', () {
      expect(AppConfig.appVersion, equals('3.2.0'));
    });

    test('should have correct app build number', () {
      expect(AppConfig.appBuildNumber, equals('25'));
    });

    test('should have valid base URL', () {
      expect(AppConfig.baseUrl, isNotEmpty);
      expect(AppConfig.baseUrl, startsWith('https://'));
    });

    test('should have valid payment API URL', () {
      expect(AppConfig.paymentApiUrl, isNotEmpty);
      expect(AppConfig.paymentApiUrl, startsWith('https://'));
    });

    test('should have valid analytics API URL', () {
      expect(AppConfig.analyticsApiUrl, isNotEmpty);
      expect(AppConfig.analyticsApiUrl, startsWith('https://'));
    });

    test('should have valid recommendation API URL', () {
      expect(AppConfig.recommendationApiUrl, isNotEmpty);
      expect(AppConfig.recommendationApiUrl, startsWith('https://'));
    });

    test('should have valid feature flags', () {
      expect(AppConfig.enablePushNotifications, isA<bool>());
      expect(AppConfig.enableLocationServices, isA<bool>());
      expect(AppConfig.enableSocialLogin, isA<bool>());
      expect(AppConfig.enableWishlist, isA<bool>());
      expect(AppConfig.enableReviews, isA<bool>());
      expect(AppConfig.enableChat, isA<bool>());
      expect(AppConfig.enableAR, isA<bool>());
      expect(AppConfig.enableAIRecommendations, isA<bool>());
    });

    test('should have valid database configuration', () {
      expect(AppConfig.databaseName, isNotEmpty);
      expect(AppConfig.databaseVersion, isA<int>());
      expect(AppConfig.databaseVersion, greaterThan(0));
    });

    test('should have valid cache configuration', () {
      expect(AppConfig.imageCacheDays, isA<int>());
      expect(AppConfig.imageCacheDays, greaterThan(0));
      expect(AppConfig.productCacheHours, isA<int>());
      expect(AppConfig.productCacheHours, greaterThan(0));
      expect(AppConfig.userCacheHours, isA<int>());
      expect(AppConfig.userCacheHours, greaterThan(0));
    });

    test('should have valid UI configuration', () {
      expect(AppConfig.defaultPadding, isA<double>());
      expect(AppConfig.defaultPadding, greaterThan(0));
      expect(AppConfig.defaultRadius, isA<double>());
      expect(AppConfig.defaultRadius, greaterThan(0));
      expect(AppConfig.cardRadius, isA<double>());
      expect(AppConfig.cardRadius, greaterThan(0));
      expect(AppConfig.buttonRadius, isA<double>());
      expect(AppConfig.buttonRadius, greaterThan(0));
    });

    test('should have valid animation configuration', () {
      expect(AppConfig.defaultAnimationDuration, isA<Duration>());
      expect(AppConfig.fastAnimationDuration, isA<Duration>());
      expect(AppConfig.slowAnimationDuration, isA<Duration>());
    });

    test('should have valid pagination configuration', () {
      expect(AppConfig.productsPerPage, isA<int>());
      expect(AppConfig.productsPerPage, greaterThan(0));
      expect(AppConfig.ordersPerPage, isA<int>());
      expect(AppConfig.ordersPerPage, greaterThan(0));
      expect(AppConfig.reviewsPerPage, isA<int>());
      expect(AppConfig.reviewsPerPage, greaterThan(0));
    });

    test('should have valid search configuration', () {
      expect(AppConfig.minSearchLength, isA<int>());
      expect(AppConfig.minSearchLength, greaterThan(0));
      expect(AppConfig.maxSearchHistory, isA<int>());
      expect(AppConfig.maxSearchHistory, greaterThan(0));
      expect(AppConfig.searchDebounceMs, isA<int>());
      expect(AppConfig.searchDebounceMs, greaterThan(0));
    });

    test('should have valid cart configuration', () {
      expect(AppConfig.maxCartItems, isA<int>());
      expect(AppConfig.maxCartItems, greaterThan(0));
      expect(AppConfig.maxQuantityPerItem, isA<int>());
      expect(AppConfig.maxQuantityPerItem, greaterThan(0));
    });

    test('should have valid wishlist configuration', () {
      expect(AppConfig.maxWishlistItems, isA<int>());
      expect(AppConfig.maxWishlistItems, greaterThan(0));
    });

    test('should have valid notification configuration', () {
      expect(AppConfig.orderChannelId, isNotEmpty);
      expect(AppConfig.promotionChannelId, isNotEmpty);
      expect(AppConfig.generalChannelId, isNotEmpty);
    });

    test('should have valid social media configuration', () {
      expect(AppConfig.facebookAppId, isNotEmpty);
      expect(AppConfig.instagramClientId, isNotEmpty);
      expect(AppConfig.twitterApiKey, isNotEmpty);
    });

    test('should have valid analytics events', () {
      expect(AppConfig.productViewEvent, isNotEmpty);
      expect(AppConfig.addToCartEvent, isNotEmpty);
      expect(AppConfig.purchaseEvent, isNotEmpty);
      expect(AppConfig.searchEvent, isNotEmpty);
      expect(AppConfig.wishlistEvent, isNotEmpty);
    });

    test('should have valid error messages', () {
      expect(AppConfig.networkError, isNotEmpty);
      expect(AppConfig.serverError, isNotEmpty);
      expect(AppConfig.authError, isNotEmpty);
      expect(AppConfig.paymentError, isNotEmpty);
    });

    test('should have valid success messages', () {
      expect(AppConfig.orderPlacedSuccess, isNotEmpty);
      expect(AppConfig.itemAddedToCart, isNotEmpty);
      expect(AppConfig.itemAddedToWishlist, isNotEmpty);
      expect(AppConfig.profileUpdated, isNotEmpty);
    });

    test('should have valid validation rules', () {
      expect(AppConfig.minPasswordLength, isA<int>());
      expect(AppConfig.minPasswordLength, greaterThan(0));
      expect(AppConfig.maxPasswordLength, isA<int>());
      expect(AppConfig.maxPasswordLength, greaterThan(AppConfig.minPasswordLength));
      expect(AppConfig.minNameLength, isA<int>());
      expect(AppConfig.minNameLength, greaterThan(0));
      expect(AppConfig.maxNameLength, isA<int>());
      expect(AppConfig.maxNameLength, greaterThan(AppConfig.minNameLength));
      expect(AppConfig.maxAddressLength, isA<int>());
      expect(AppConfig.maxAddressLength, greaterThan(0));
      expect(AppConfig.maxReviewLength, isA<int>());
      expect(AppConfig.maxReviewLength, greaterThan(0));
    });

    test('should have valid currency configuration', () {
      expect(AppConfig.defaultCurrency, isNotEmpty);
      expect(AppConfig.currencySymbol, isNotEmpty);
      expect(AppConfig.currencyDecimals, isA<int>());
      expect(AppConfig.currencyDecimals, greaterThanOrEqualTo(0));
    });

    test('should have valid shipping configuration', () {
      expect(AppConfig.freeShippingThreshold, isA<double>());
      expect(AppConfig.freeShippingThreshold, greaterThan(0));
      expect(AppConfig.standardShippingCost, isA<double>());
      expect(AppConfig.standardShippingCost, greaterThan(0));
      expect(AppConfig.expressShippingCost, isA<double>());
      expect(AppConfig.expressShippingCost, greaterThan(0));
      expect(AppConfig.standardShippingDays, isA<int>());
      expect(AppConfig.standardShippingDays, greaterThan(0));
      expect(AppConfig.expressShippingDays, isA<int>());
      expect(AppConfig.expressShippingDays, greaterThan(0));
    });

    test('should have valid return policy', () {
      expect(AppConfig.returnWindowDays, isA<int>());
      expect(AppConfig.returnWindowDays, greaterThan(0));
      expect(AppConfig.exchangeWindowDays, isA<int>());
      expect(AppConfig.exchangeWindowDays, greaterThan(0));
    });

    test('should have valid AI configuration', () {
      expect(AppConfig.recommendationModel, isNotEmpty);
      expect(AppConfig.searchModel, isNotEmpty);
      expect(AppConfig.recommendationThreshold, isA<double>());
      expect(AppConfig.recommendationThreshold, greaterThan(0));
      expect(AppConfig.recommendationThreshold, lessThanOrEqualTo(1));
      expect(AppConfig.maxRecommendations, isA<int>());
      expect(AppConfig.maxRecommendations, greaterThan(0));
    });

    test('should have valid performance configuration', () {
      expect(AppConfig.imageCompressionQuality, isA<int>());
      expect(AppConfig.imageCompressionQuality, greaterThan(0));
      expect(AppConfig.imageCompressionQuality, lessThanOrEqualTo(100));
      expect(AppConfig.thumbnailSize, isA<int>());
      expect(AppConfig.thumbnailSize, greaterThan(0));
      expect(AppConfig.fullImageSize, isA<int>());
      expect(AppConfig.fullImageSize, greaterThan(0));
    });

    test('should have valid security configuration', () {
      expect(AppConfig.maxLoginAttempts, isA<int>());
      expect(AppConfig.maxLoginAttempts, greaterThan(0));
      expect(AppConfig.sessionTimeoutMinutes, isA<int>());
      expect(AppConfig.sessionTimeoutMinutes, greaterThan(0));
      expect(AppConfig.enableBiometricAuth, isA<bool>());
      expect(AppConfig.enableTwoFactorAuth, isA<bool>());
    });

    test('should have valid development configuration', () {
      expect(AppConfig.enableLogging, isA<bool>());
      expect(AppConfig.enableCrashReporting, isA<bool>());
      expect(AppConfig.enablePerformanceMonitoring, isA<bool>());
    });
  });
}
