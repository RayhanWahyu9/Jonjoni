import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'order.dart';

class OrdersProvider extends ChangeNotifier {
  static const _key = 'orders_history';
  List<Order> _orders = [];

  List<Order> get orders => List.unmodifiable(_orders);

  OrdersProvider() {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final s = prefs.getString(_key);
    if (s != null && s.isNotEmpty) {
      try {
        _orders = Order.listFromJson(s);
        notifyListeners();
      } catch (_) {}
    }
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, Order.listToJson(_orders));
  }

  Future<void> addOrder(Order order) async {
    _orders.insert(0, order); // newest first
    await _save();
    notifyListeners();
  }

  Future<void> clearAll() async {
    _orders.clear();
    await _save();
    notifyListeners();
  }
}