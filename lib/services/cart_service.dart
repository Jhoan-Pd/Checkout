import 'package:flutter/foundation.dart';
import '../models/product_model.dart';

class CartService extends ChangeNotifier {
  static final CartService _instance = CartService._internal();
  factory CartService() => _instance;
  CartService._internal();

  final List<ProductModel> _items = [];

  List<ProductModel> get items => List.unmodifiable(_items);

  double get totalPrice {
    return _items.fold(0, (sum, item) => sum + item.price);
  }

  void addItem(ProductModel product) {
    _items.add(product);
    notifyListeners();
  }

  void removeItem(ProductModel product) {
    _items.removeWhere((item) => item.id == product.id);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
