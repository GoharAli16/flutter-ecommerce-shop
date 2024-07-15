import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

class AnalyticsService {
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  static final FirebaseAnalyticsObserver _observer = FirebaseAnalyticsObserver(analytics: _analytics);

  static FirebaseAnalyticsObserver get observer => _observer;

  // Track screen views
  static Future<void> logScreenView(String screenName, {String? screenClass}) async {
    try {
      await _analytics.logScreenView(
        screenName: screenName,
        screenClass: screenClass,
      );
      if (kDebugMode) {
        print('Analytics: Screen view logged - $screenName');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Analytics Error: $e');
      }
    }
  }

  // Track user events
  static Future<void> logEvent(String eventName, {Map<String, dynamic>? parameters}) async {
    try {
      await _analytics.logEvent(
        name: eventName,
        parameters: parameters,
      );
      if (kDebugMode) {
        print('Analytics: Event logged - $eventName');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Analytics Error: $e');
      }
    }
  }

  // E-commerce specific events
  static Future<void> logProductView(String productId, String productName, String category) async {
    await logEvent('view_item', parameters: {
      'item_id': productId,
      'item_name': productName,
      'item_category': category,
    });
  }

  static Future<void> logAddToCart(String productId, String productName, String category, double value) async {
    await logEvent('add_to_cart', parameters: {
      'item_id': productId,
      'item_name': productName,
      'item_category': category,
      'value': value,
      'currency': 'USD',
    });
  }

  static Future<void> logRemoveFromCart(String productId, String productName, String category, double value) async {
    await logEvent('remove_from_cart', parameters: {
      'item_id': productId,
      'item_name': productName,
      'item_category': category,
      'value': value,
      'currency': 'USD',
    });
  }

  static Future<void> logBeginCheckout(double value, String currency, int itemCount) async {
    await logEvent('begin_checkout', parameters: {
      'value': value,
      'currency': currency,
      'item_count': itemCount,
    });
  }

  static Future<void> logPurchase(String transactionId, double value, String currency, int itemCount) async {
    await logEvent('purchase', parameters: {
      'transaction_id': transactionId,
      'value': value,
      'currency': currency,
      'item_count': itemCount,
    });
  }

  static Future<void> logSearch(String searchTerm) async {
    await logEvent('search', parameters: {
      'search_term': searchTerm,
    });
  }

  static Future<void> logAddToWishlist(String productId, String productName, String category) async {
    await logEvent('add_to_wishlist', parameters: {
      'item_id': productId,
      'item_name': productName,
      'item_category': category,
    });
  }

  static Future<void> logRemoveFromWishlist(String productId, String productName, String category) async {
    await logEvent('remove_from_wishlist', parameters: {
      'item_id': productId,
      'item_name': productName,
      'item_category': category,
    });
  }

  // User engagement events
  static Future<void> logLogin(String method) async {
    await logEvent('login', parameters: {
      'method': method,
    });
  }

  static Future<void> logSignUp(String method) async {
    await logEvent('sign_up', parameters: {
      'method': method,
    });
  }

  static Future<void> logLogout() async {
    await logEvent('logout');
  }

  static Future<void> logShare(String contentType, String itemId) async {
    await logEvent('share', parameters: {
      'content_type': contentType,
      'item_id': itemId,
    });
  }

  // App performance events
  static Future<void> logAppOpen() async {
    await logEvent('app_open');
  }

  static Future<void> logAppClose() async {
    await logEvent('app_close');
  }

  static Future<void> logError(String error, String? fatal) async {
    await logEvent('app_error', parameters: {
      'error': error,
      'fatal': fatal ?? 'false',
    });
  }

  // Custom events
  static Future<void> logCustomEvent(String eventName, Map<String, dynamic> parameters) async {
    await logEvent(eventName, parameters: parameters);
  }

  // Set user properties
  static Future<void> setUserProperty(String name, String? value) async {
    try {
      await _analytics.setUserProperty(name: name, value: value);
      if (kDebugMode) {
        print('Analytics: User property set - $name: $value');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Analytics Error: $e');
      }
    }
  }

  // Set user ID
  static Future<void> setUserId(String? userId) async {
    try {
      await _analytics.setUserId(id: userId);
      if (kDebugMode) {
        print('Analytics: User ID set - $userId');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Analytics Error: $e');
      }
    }
  }

  // Reset analytics data
  static Future<void> resetAnalyticsData() async {
    try {
      await _analytics.resetAnalyticsData();
      if (kDebugMode) {
        print('Analytics: Data reset');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Analytics Error: $e');
      }
    }
  }

  // Get app instance ID
  static Future<String?> getAppInstanceId() async {
    try {
      return await _analytics.appInstanceId;
    } catch (e) {
      if (kDebugMode) {
        print('Analytics Error: $e');
      }
      return null;
    }
  }

  // Enable/disable analytics
  static Future<void> setAnalyticsCollectionEnabled(bool enabled) async {
    try {
      await _analytics.setAnalyticsCollectionEnabled(enabled);
      if (kDebugMode) {
        print('Analytics: Collection enabled - $enabled');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Analytics Error: $e');
      }
    }
  }
}
