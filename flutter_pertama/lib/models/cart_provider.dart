import 'package:flutter/foundation.dart';
import 'menu_item.dart';

class CartItem {
  final MenuItem item;
  int qty;
  CartItem({required this.item, this.qty = 1});
}

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  int get totalItems => _items.fold(0, (s, e) => s + e.qty);

  int get totalPrice => _items.fold(0, (s, e) => s + e.qty * e.item.harga);

  void addItem(MenuItem menuItem) {
    final index = _items.indexWhere((e) => e.item.nama == menuItem.nama);
    if (index >= 0) {
      _items[index].qty += 1;
    } else {
      _items.add(CartItem(item: menuItem));
    }
    notifyListeners();
  }

  void removeSingle(MenuItem menuItem) {
    final index = _items.indexWhere((e) => e.item.nama == menuItem.nama);
    if (index >= 0) {
      if (_items[index].qty > 1) {
        _items[index].qty -= 1;
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  void removeAll(MenuItem menuItem) {
    _items.removeWhere((e) => e.item.nama == menuItem.nama);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}