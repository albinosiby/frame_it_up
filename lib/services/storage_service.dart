import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _ordersKey = 'orders';

  // Save an order
  Future<void> saveOrder(Map<String, dynamic> order) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> orders = prefs.getStringList(_ordersKey) ?? [];

    // Add timestamp to order if not present
    if (!order.containsKey('timestamp')) {
      order['timestamp'] = DateTime.now().toIso8601String();
    }

    orders.add(jsonEncode(order));
    await prefs.setStringList(_ordersKey, orders);
  }

  // Update an order at a specific index
  Future<void> updateOrder(int index, Map<String, dynamic> updatedOrder) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> orders = prefs.getStringList(_ordersKey) ?? [];

    if (index >= 0 && index < orders.length) {
      orders[index] = jsonEncode(updatedOrder);
      await prefs.setStringList(_ordersKey, orders);
    }
  }

  // Get all orders
  Future<List<Map<String, dynamic>>> getOrders() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> orders = prefs.getStringList(_ordersKey) ?? [];

    return orders.map((orderStr) {
      return jsonDecode(orderStr) as Map<String, dynamic>;
    }).toList();
  }

  // Clear all orders (optional, for testing/admin)
  Future<void> clearOrders() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_ordersKey);
  }
}
