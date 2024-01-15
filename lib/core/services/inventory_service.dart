import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

class InventoryService {
  static WebSocketChannel? _channel;
  static StreamController<Map<String, dynamic>>? _inventoryController;
  static bool _isConnected = false;
  static Timer? _reconnectTimer;

  static Stream<Map<String, dynamic>> get inventoryStream {
    _inventoryController ??= StreamController<Map<String, dynamic>>.broadcast();
    return _inventoryController!.stream;
  }

  static Future<void> initialize() async {
    await _connect();
  }

  static Future<void> _connect() async {
    try {
      _channel = WebSocketChannel.connect(
        Uri.parse('wss://inventory.shoppro.com/ws'),
      );

      _channel!.stream.listen(
        (data) {
          final message = jsonDecode(data);
          _handleInventoryUpdate(message);
        },
        onError: (error) {
          print('WebSocket error: $error');
          _scheduleReconnect();
        },
        onDone: () {
          print('WebSocket connection closed');
          _scheduleReconnect();
        },
      );

      _isConnected = true;
      print('Connected to inventory WebSocket');
    } catch (e) {
      print('Failed to connect to inventory WebSocket: $e');
      _scheduleReconnect();
    }
  }

  static void _handleInventoryUpdate(Map<String, dynamic> message) {
    switch (message['type']) {
      case 'stock_update':
        _handleStockUpdate(message['data']);
        break;
      case 'price_update':
        _handlePriceUpdate(message['data']);
        break;
      case 'promotion_update':
        _handlePromotionUpdate(message['data']);
        break;
      case 'reorder_alert':
        _handleReorderAlert(message['data']);
        break;
      default:
        print('Unknown message type: ${message['type']}');
    }
  }

  static void _handleStockUpdate(Map<String, dynamic> data) {
    _inventoryController?.add({
      'type': 'stock_update',
      'productId': data['productId'],
      'newStock': data['newStock'],
      'previousStock': data['previousStock'],
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  static void _handlePriceUpdate(Map<String, dynamic> data) {
    _inventoryController?.add({
      'type': 'price_update',
      'productId': data['productId'],
      'newPrice': data['newPrice'],
      'previousPrice': data['previousPrice'],
      'changePercent': data['changePercent'],
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  static void _handlePromotionUpdate(Map<String, dynamic> data) {
    _inventoryController?.add({
      'type': 'promotion_update',
      'productId': data['productId'],
      'promotionType': data['promotionType'],
      'discountPercent': data['discountPercent'],
      'validUntil': data['validUntil'],
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  static void _handleReorderAlert(Map<String, dynamic> data) {
    _inventoryController?.add({
      'type': 'reorder_alert',
      'productId': data['productId'],
      'currentStock': data['currentStock'],
      'reorderPoint': data['reorderPoint'],
      'suggestedQuantity': data['suggestedQuantity'],
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  static void _scheduleReconnect() {
    _isConnected = false;
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(const Duration(seconds: 5), () {
      _connect();
    });
  }

  static Future<void> updateStock(String productId, int newStock) async {
    if (!_isConnected) return;

    try {
      final message = {
        'type': 'update_stock',
        'productId': productId,
        'newStock': newStock,
        'timestamp': DateTime.now().toIso8601String(),
      };

      _channel?.sink.add(jsonEncode(message));
    } catch (e) {
      print('Failed to update stock: $e');
    }
  }

  static Future<void> updatePrice(String productId, double newPrice) async {
    if (!_isConnected) return;

    try {
      final message = {
        'type': 'update_price',
        'productId': productId,
        'newPrice': newPrice,
        'timestamp': DateTime.now().toIso8601String(),
      };

      _channel?.sink.add(jsonEncode(message));
    } catch (e) {
      print('Failed to update price: $e');
    }
  }

  static Future<void> createPromotion({
    required String productId,
    required String promotionType,
    required double discountPercent,
    required DateTime validUntil,
  }) async {
    if (!_isConnected) return;

    try {
      final message = {
        'type': 'create_promotion',
        'productId': productId,
        'promotionType': promotionType,
        'discountPercent': discountPercent,
        'validUntil': validUntil.toIso8601String(),
        'timestamp': DateTime.now().toIso8601String(),
      };

      _channel?.sink.add(jsonEncode(message));
    } catch (e) {
      print('Failed to create promotion: $e');
    }
  }

  static Future<Map<String, dynamic>> getInventoryStatus(String productId) async {
    // Mock implementation - in real app, this would fetch from API
    return {
      'productId': productId,
      'currentStock': 150,
      'reservedStock': 25,
      'availableStock': 125,
      'reorderPoint': 50,
      'maxStock': 500,
      'lastUpdated': DateTime.now().toIso8601String(),
    };
  }

  static Future<List<Map<String, dynamic>>> getLowStockProducts() async {
    // Mock implementation - in real app, this would fetch from API
    return [
      {
        'productId': 'prod_1',
        'name': 'Product 1',
        'currentStock': 15,
        'reorderPoint': 50,
        'suggestedQuantity': 100,
        'category': 'Electronics',
      },
      {
        'productId': 'prod_2',
        'name': 'Product 2',
        'currentStock': 8,
        'reorderPoint': 25,
        'suggestedQuantity': 75,
        'category': 'Fashion',
      },
    ];
  }

  static Future<Map<String, dynamic>> getInventoryForecast(String productId) async {
    // Mock implementation - in real app, this would use ML models
    return {
      'productId': productId,
      'forecastData': [
        {'date': '2024-01-15', 'predictedDemand': 45, 'confidence': 0.85},
        {'date': '2024-01-16', 'predictedDemand': 52, 'confidence': 0.82},
        {'date': '2024-01-17', 'predictedDemand': 38, 'confidence': 0.88},
        {'date': '2024-01-18', 'predictedDemand': 61, 'confidence': 0.79},
        {'date': '2024-01-19', 'predictedDemand': 47, 'confidence': 0.86},
      ],
      'trend': 'increasing',
      'seasonality': 'high',
      'lastUpdated': DateTime.now().toIso8601String(),
    };
  }

  static Future<void> setReorderPoint(String productId, int reorderPoint) async {
    if (!_isConnected) return;

    try {
      final message = {
        'type': 'set_reorder_point',
        'productId': productId,
        'reorderPoint': reorderPoint,
        'timestamp': DateTime.now().toIso8601String(),
      };

      _channel?.sink.add(jsonEncode(message));
    } catch (e) {
      print('Failed to set reorder point: $e');
    }
  }

  static Future<void> reserveStock(String productId, int quantity) async {
    if (!_isConnected) return;

    try {
      final message = {
        'type': 'reserve_stock',
        'productId': productId,
        'quantity': quantity,
        'timestamp': DateTime.now().toIso8601String(),
      };

      _channel?.sink.add(jsonEncode(message));
    } catch (e) {
      print('Failed to reserve stock: $e');
    }
  }

  static Future<void> releaseReservedStock(String productId, int quantity) async {
    if (!_isConnected) return;

    try {
      final message = {
        'type': 'release_reserved_stock',
        'productId': productId,
        'quantity': quantity,
        'timestamp': DateTime.now().toIso8601String(),
      };

      _channel?.sink.add(jsonEncode(message));
    } catch (e) {
      print('Failed to release reserved stock: $e');
    }
  }

  static void dispose() {
    _reconnectTimer?.cancel();
    _channel?.sink.close(status.goingAway);
    _inventoryController?.close();
    _isConnected = false;
  }
}
