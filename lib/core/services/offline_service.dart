import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OfflineService {
  static const String _cartBoxName = 'cart';
  static const String _wishlistBoxName = 'wishlist';
  static const String _userPrefsBoxName = 'user_preferences';
  static const String _syncStatusKey = 'sync_status';

  static Box? _cartBox;
  static Box? _wishlistBox;
  static Box? _userPrefsBox;
  static SharedPreferences? _prefs;

  static Future<void> initialize() async {
    // Initialize Hive boxes
    _cartBox = await Hive.openBox(_cartBoxName);
    _wishlistBox = await Hive.openBox(_wishlistBoxName);
    _userPrefsBox = await Hive.openBox(_userPrefsBoxName);

    // Initialize SharedPreferences
    _prefs = await SharedPreferences.getInstance();
  }

  // Cart Operations
  static Future<void> addToCart(Map<String, dynamic> item) async {
    if (_cartBox == null) return;

    final cartItem = {
      'id': item['id'],
      'name': item['name'],
      'price': item['price'],
      'quantity': item['quantity'] ?? 1,
      'image': item['image'],
      'addedAt': DateTime.now().toIso8601String(),
    };

    await _cartBox!.put(item['id'], cartItem);
    await _markForSync('cart');
  }

  static Future<void> removeFromCart(String itemId) async {
    if (_cartBox == null) return;

    await _cartBox!.delete(itemId);
    await _markForSync('cart');
  }

  static Future<void> updateCartQuantity(String itemId, int quantity) async {
    if (_cartBox == null) return;

    final item = _cartBox!.get(itemId);
    if (item != null) {
      item['quantity'] = quantity;
      await _cartBox!.put(itemId, item);
      await _markForSync('cart');
    }
  }

  static List<Map<String, dynamic>> getCartItems() {
    if (_cartBox == null) return [];

    return _cartBox!.values
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  static Future<void> clearCart() async {
    if (_cartBox == null) return;

    await _cartBox!.clear();
    await _markForSync('cart');
  }

  // Wishlist Operations
  static Future<void> addToWishlist(Map<String, dynamic> item) async {
    if (_wishlistBox == null) return;

    final wishlistItem = {
      'id': item['id'],
      'name': item['name'],
      'price': item['price'],
      'image': item['image'],
      'addedAt': DateTime.now().toIso8601String(),
    };

    await _wishlistBox!.put(item['id'], wishlistItem);
    await _markForSync('wishlist');
  }

  static Future<void> removeFromWishlist(String itemId) async {
    if (_wishlistBox == null) return;

    await _wishlistBox!.delete(itemId);
    await _markForSync('wishlist');
  }

  static List<Map<String, dynamic>> getWishlistItems() {
    if (_wishlistBox == null) return [];

    return _wishlistBox!.values
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  static bool isInWishlist(String itemId) {
    if (_wishlistBox == null) return false;
    return _wishlistBox!.containsKey(itemId);
  }

  // User Preferences
  static Future<void> saveUserPreference(String key, dynamic value) async {
    if (_userPrefsBox == null) return;

    await _userPrefsBox!.put(key, value);
  }

  static T? getUserPreference<T>(String key) {
    if (_userPrefsBox == null) return null;
    return _userPrefsBox!.get(key);
  }

  // Search History
  static Future<void> addSearchHistory(String query) async {
    if (_prefs == null) return;

    final searchHistory = getSearchHistory();
    searchHistory.remove(query); // Remove if exists
    searchHistory.insert(0, query); // Add to beginning

    // Keep only last 20 searches
    if (searchHistory.length > 20) {
      searchHistory.removeRange(20, searchHistory.length);
    }

    await _prefs!.setStringList('search_history', searchHistory);
  }

  static List<String> getSearchHistory() {
    if (_prefs == null) return [];
    return _prefs!.getStringList('search_history') ?? [];
  }

  static Future<void> clearSearchHistory() async {
    if (_prefs == null) return;
    await _prefs!.remove('search_history');
  }

  // Recently Viewed Products
  static Future<void> addRecentlyViewed(Map<String, dynamic> product) async {
    if (_prefs == null) return;

    final recentlyViewed = getRecentlyViewed();
    recentlyViewed.removeWhere((item) => item['id'] == product['id']);
    recentlyViewed.insert(0, {
      ...product,
      'viewedAt': DateTime.now().toIso8601String(),
    });

    // Keep only last 50 products
    if (recentlyViewed.length > 50) {
      recentlyViewed.removeRange(50, recentlyViewed.length);
    }

    await _prefs!.setString('recently_viewed', jsonEncode(recentlyViewed));
  }

  static List<Map<String, dynamic>> getRecentlyViewed() {
    if (_prefs == null) return [];

    final jsonString = _prefs!.getString('recently_viewed');
    if (jsonString == null) return [];

    try {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.map((item) => Map<String, dynamic>.from(item)).toList();
    } catch (e) {
      return [];
    }
  }

  // Sync Status Management
  static Future<void> _markForSync(String dataType) async {
    if (_prefs == null) return;

    final syncStatus = getSyncStatus();
    syncStatus[dataType] = {
      'needsSync': true,
      'lastModified': DateTime.now().toIso8601String(),
    };

    await _prefs!.setString(_syncStatusKey, jsonEncode(syncStatus));
  }

  static Map<String, dynamic> getSyncStatus() {
    if (_prefs == null) return {};

    final jsonString = _prefs!.getString(_syncStatusKey);
    if (jsonString == null) return {};

    try {
      return Map<String, dynamic>.from(jsonDecode(jsonString));
    } catch (e) {
      return {};
    }
  }

  static Future<void> markAsSynced(String dataType) async {
    if (_prefs == null) return;

    final syncStatus = getSyncStatus();
    syncStatus[dataType] = {
      'needsSync': false,
      'lastSynced': DateTime.now().toIso8601String(),
    };

    await _prefs!.setString(_syncStatusKey, jsonEncode(syncStatus));
  }

  // Data Export/Import
  static Future<Map<String, dynamic>> exportUserData() async {
    return {
      'cart': getCartItems(),
      'wishlist': getWishlistItems(),
      'searchHistory': getSearchHistory(),
      'recentlyViewed': getRecentlyViewed(),
      'preferences': _userPrefsBox?.toMap() ?? {},
      'exportedAt': DateTime.now().toIso8601String(),
    };
  }

  static Future<void> importUserData(Map<String, dynamic> data) async {
    // Import cart
    if (data['cart'] != null) {
      await _cartBox?.clear();
      for (final item in data['cart']) {
        await _cartBox?.put(item['id'], item);
      }
    }

    // Import wishlist
    if (data['wishlist'] != null) {
      await _wishlistBox?.clear();
      for (final item in data['wishlist']) {
        await _wishlistBox?.put(item['id'], item);
      }
    }

    // Import search history
    if (data['searchHistory'] != null) {
      await _prefs?.setStringList(
        'search_history',
        List<String>.from(data['searchHistory']),
      );
    }

    // Import recently viewed
    if (data['recentlyViewed'] != null) {
      await _prefs?.setString(
        'recently_viewed',
        jsonEncode(data['recentlyViewed']),
      );
    }

    // Import preferences
    if (data['preferences'] != null) {
      await _userPrefsBox?.clear();
      for (final entry in data['preferences'].entries) {
        await _userPrefsBox?.put(entry.key, entry.value);
      }
    }
  }

  // Cache Management
  static Future<void> clearCache() async {
    await _cartBox?.clear();
    await _wishlistBox?.clear();
    await _userPrefsBox?.clear();
    await _prefs?.clear();
  }

  static Future<int> getCacheSize() async {
    int size = 0;

    if (_cartBox != null) size += _cartBox!.length;
    if (_wishlistBox != null) size += _wishlistBox!.length;
    if (_userPrefsBox != null) size += _userPrefsBox!.length;

    return size;
  }

  // Cleanup
  static Future<void> dispose() async {
    await _cartBox?.close();
    await _wishlistBox?.close();
    await _userPrefsBox?.close();
  }
}
