import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class AIService {
  static Interpreter? _recommendationModel;
  static Interpreter? _priceOptimizationModel;
  static Interpreter? _fraudDetectionModel;
  static bool _isInitialized = false;

  static Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Load recommendation model
      _recommendationModel = await Interpreter.fromAsset(
        'models/recommendation_model.tflite',
        options: InterpreterOptions()..threads = 4,
      );

      // Load price optimization model
      _priceOptimizationModel = await Interpreter.fromAsset(
        'models/price_optimization_model.tflite',
        options: InterpreterOptions()..threads = 4,
      );

      // Load fraud detection model
      _fraudDetectionModel = await Interpreter.fromAsset(
        'models/fraud_detection_model.tflite',
        options: InterpreterOptions()..threads = 4,
      );

      _isInitialized = true;
    } catch (e) {
      print('Error initializing AI models: $e');
    }
  }

  /// Generate product recommendations based on user behavior
  static Future<List<String>> getRecommendations({
    required String userId,
    required List<String> userHistory,
    required List<String> similarUsers,
    int limit = 10,
  }) async {
    if (!_isInitialized || _recommendationModel == null) {
      return _getDefaultRecommendations();
    }

    try {
      // Prepare input data
      final input = _prepareRecommendationInput(
        userId: userId,
        userHistory: userHistory,
        similarUsers: similarUsers,
      );

      // Run inference
      final output = List.filled(1, List.filled(100, 0.0));
      _recommendationModel!.run(input, output);

      // Process results
      final predictions = output[0] as List<double>;
      final recommendations = <String>[];

      for (
        int i = 0;
        i < predictions.length && recommendations.length < limit;
        i++
      ) {
        if (predictions[i] > 0.7) {
          recommendations.add('product_$i');
        }
      }

      return recommendations;
    } catch (e) {
      print('Error generating recommendations: $e');
      return _getDefaultRecommendations();
    }
  }

  /// Optimize product pricing based on market conditions
  static Future<double> optimizePrice({
    required String productId,
    required double currentPrice,
    required Map<String, dynamic> marketData,
  }) async {
    if (!_isInitialized || _priceOptimizationModel == null) {
      return currentPrice;
    }

    try {
      // Prepare input data
      final input = _preparePriceOptimizationInput(
        productId: productId,
        currentPrice: currentPrice,
        marketData: marketData,
      );

      // Run inference
      final output = List.filled(1, List.filled(1, 0.0));
      _priceOptimizationModel!.run(input, output);

      // Get optimized price
      final optimizedPrice = (output[0] as List<double>)[0];
      return optimizedPrice;
    } catch (e) {
      print('Error optimizing price: $e');
      return currentPrice;
    }
  }

  /// Detect fraudulent transactions
  static Future<double> detectFraud({
    required Map<String, dynamic> transactionData,
    required List<Map<String, dynamic>> userHistory,
  }) async {
    if (!_isInitialized || _fraudDetectionModel == null) {
      return 0.0;
    }

    try {
      // Prepare input data
      final input = _prepareFraudDetectionInput(
        transactionData: transactionData,
        userHistory: userHistory,
      );

      // Run inference
      final output = List.filled(1, List.filled(1, 0.0));
      _fraudDetectionModel!.run(input, output);

      // Get fraud probability
      final fraudProbability = (output[0] as List<double>)[0];
      return fraudProbability;
    } catch (e) {
      print('Error detecting fraud: $e');
      return 0.0;
    }
  }

  /// Analyze user behavior patterns
  static Map<String, dynamic> analyzeUserBehavior({
    required List<Map<String, dynamic>> userActions,
    required Duration timeWindow,
  }) {
    final now = DateTime.now();
    final startTime = now.subtract(timeWindow);

    final recentActions = userActions
        .where(
          (action) => DateTime.parse(action['timestamp']).isAfter(startTime),
        )
        .toList();

    // Calculate behavior metrics
    final totalActions = recentActions.length;
    final uniqueProducts = recentActions
        .map((action) => action['productId'])
        .toSet()
        .length;

    final avgSessionDuration = _calculateAvgSessionDuration(recentActions);
    final preferredCategories = _getPreferredCategories(recentActions);
    final spendingPattern = _analyzeSpendingPattern(recentActions);

    return {
      'totalActions': totalActions,
      'uniqueProducts': uniqueProducts,
      'avgSessionDuration': avgSessionDuration,
      'preferredCategories': preferredCategories,
      'spendingPattern': spendingPattern,
      'engagementScore': _calculateEngagementScore(recentActions),
    };
  }

  /// Generate personalized content
  static Map<String, dynamic> generatePersonalizedContent({
    required String userId,
    required Map<String, dynamic> userProfile,
    required List<String> trendingTopics,
  }) {
    // Simple content generation logic
    final personalizedContent = <String, dynamic>{
      'recommendedProducts': _getPersonalizedProducts(userProfile),
      'contentTopics': _getPersonalizedTopics(userProfile, trendingTopics),
      'promotionalOffers': _getPersonalizedOffers(userProfile),
      'contentSchedule': _getContentSchedule(userProfile),
    };

    return personalizedContent;
  }

  // Helper methods
  static List<List<double>> _prepareRecommendationInput({
    required String userId,
    required List<String> userHistory,
    required List<String> similarUsers,
  }) {
    // Convert user data to numerical features
    final userFeatures = _encodeUserFeatures(userId, userHistory);
    final similarUserFeatures = _encodeSimilarUserFeatures(similarUsers);

    return [userFeatures + similarUserFeatures];
  }

  static List<List<double>> _preparePriceOptimizationInput({
    required String productId,
    required double currentPrice,
    required Map<String, dynamic> marketData,
  }) {
    final features = <double>[
      currentPrice,
      marketData['demand'] ?? 0.0,
      marketData['competitorPrice'] ?? 0.0,
      marketData['inventory'] ?? 0.0,
      marketData['seasonality'] ?? 0.0,
    ];

    return [features];
  }

  static List<List<double>> _prepareFraudDetectionInput({
    required Map<String, dynamic> transactionData,
    required List<Map<String, dynamic>> userHistory,
  }) {
    final features = <double>[
      transactionData['amount'] ?? 0.0,
      transactionData['hour'] ?? 0.0,
      _calculateAvgTransactionAmount(userHistory),
      _calculateTransactionFrequency(userHistory),
      _calculateLocationAnomaly(transactionData, userHistory),
    ];

    return [features];
  }

  static List<double> _encodeUserFeatures(
    String userId,
    List<String> userHistory,
  ) {
    // Simple encoding - in real app, use proper feature engineering
    return List.generate(
      50,
      (index) => (userId.hashCode + index) % 100 / 100.0,
    );
  }

  static List<double> _encodeSimilarUserFeatures(List<String> similarUsers) {
    return List.generate(
      50,
      (index) => similarUsers.length > index ? 1.0 : 0.0,
    );
  }

  static List<String> _getDefaultRecommendations() {
    return List.generate(10, (index) => 'default_product_$index');
  }

  static Duration _calculateAvgSessionDuration(
    List<Map<String, dynamic>> actions,
  ) {
    if (actions.isEmpty) return Duration.zero;

    // Simple calculation - in real app, use proper session analysis
    return const Duration(minutes: 15);
  }

  static List<String> _getPreferredCategories(
    List<Map<String, dynamic>> actions,
  ) {
    final categoryCount = <String, int>{};

    for (final action in actions) {
      final category = action['category'] as String?;
      if (category != null) {
        categoryCount[category] = (categoryCount[category] ?? 0) + 1;
      }
    }

    final sortedCategories = categoryCount.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sortedCategories.take(5).map((e) => e.key).toList();
  }

  static Map<String, dynamic> _analyzeSpendingPattern(
    List<Map<String, dynamic>> actions,
  ) {
    final totalSpent = actions
        .where((action) => action['type'] == 'purchase')
        .fold(0.0, (sum, action) => sum + (action['amount'] ?? 0.0));

    return {
      'totalSpent': totalSpent,
      'avgTransactionValue': totalSpent / actions.length,
      'spendingTrend': 'increasing', // Simplified
    };
  }

  static double _calculateEngagementScore(List<Map<String, dynamic>> actions) {
    // Simple engagement calculation
    return actions.length / 100.0;
  }

  static List<String> _getPersonalizedProducts(
    Map<String, dynamic> userProfile,
  ) {
    return ['product_1', 'product_2', 'product_3'];
  }

  static List<String> _getPersonalizedTopics(
    Map<String, dynamic> userProfile,
    List<String> trendingTopics,
  ) {
    return trendingTopics.take(3).toList();
  }

  static List<String> _getPersonalizedOffers(Map<String, dynamic> userProfile) {
    return ['offer_1', 'offer_2'];
  }

  static Map<String, dynamic> _getContentSchedule(
    Map<String, dynamic> userProfile,
  ) {
    return {
      'morning': ['product_1', 'offer_1'],
      'afternoon': ['product_2'],
      'evening': ['product_3', 'offer_2'],
    };
  }

  static double _calculateAvgTransactionAmount(
    List<Map<String, dynamic>> userHistory,
  ) {
    if (userHistory.isEmpty) return 0.0;

    final purchases = userHistory.where(
      (action) => action['type'] == 'purchase',
    );
    if (purchases.isEmpty) return 0.0;

    final total = purchases.fold(
      0.0,
      (sum, action) => sum + (action['amount'] ?? 0.0),
    );
    return total / purchases.length;
  }

  static double _calculateTransactionFrequency(
    List<Map<String, dynamic>> userHistory,
  ) {
    if (userHistory.isEmpty) return 0.0;

    final purchases = userHistory.where(
      (action) => action['type'] == 'purchase',
    );
    return purchases.length / 30.0; // Transactions per day
  }

  static double _calculateLocationAnomaly(
    Map<String, dynamic> transactionData,
    List<Map<String, dynamic>> userHistory,
  ) {
    // Simple location anomaly detection
    return 0.0;
  }
}
