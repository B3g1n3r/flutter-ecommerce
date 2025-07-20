import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

class CartProvider with ChangeNotifier {
  final SharedPreferences _prefs;
  List<CartItem> _items = [];

  CartProvider(this._prefs) {
    _loadCart();
  }

  List<CartItem> get items => _items;
  
  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);
  
  double get totalAmount => _items.fold(0.0, (sum, item) => sum + item.totalPrice);

  void _loadCart() {
    final cartJson = _prefs.getString('cart');
    if (cartJson != null) {
      final List<dynamic> cartList = json.decode(cartJson);
      _items = cartList.map((item) => CartItem.fromJson(item)).toList();
      notifyListeners();
    }
  }

  Future<void> _saveCart() async {
    final cartJson = json.encode(_items.map((item) => item.toJson()).toList());
    await _prefs.setString('cart', cartJson);
  }

  void addToCart(Product product, {int quantity = 1, String? size, String? color}) {
    final existingIndex = _items.indexWhere((item) => 
      item.product.id == product.id && 
      item.selectedSize == size && 
      item.selectedColor == color
    );

    if (existingIndex >= 0) {
      _items[existingIndex].quantity += quantity;
    } else {
      _items.add(CartItem(
        product: product,
        quantity: quantity,
        selectedSize: size,
        selectedColor: color,
      ));
    }

    _saveCart();
    notifyListeners();
  }

  void removeFromCart(String productId, {String? size, String? color}) {
    _items.removeWhere((item) => 
      item.product.id == productId && 
      item.selectedSize == size && 
      item.selectedColor == color
    );
    _saveCart();
    notifyListeners();
  }

  void updateQuantity(String productId, int quantity, {String? size, String? color}) {
    final index = _items.indexWhere((item) => 
      item.product.id == productId && 
      item.selectedSize == size && 
      item.selectedColor == color
    );

    if (index >= 0) {
      if (quantity <= 0) {
        _items.removeAt(index);
      } else {
        _items[index].quantity = quantity;
      }
      _saveCart();
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    _saveCart();
    notifyListeners();
  }

  bool isInCart(String productId, {String? size, String? color}) {
    return _items.any((item) => 
      item.product.id == productId && 
      item.selectedSize == size && 
      item.selectedColor == color
    );
  }

  int getQuantity(String productId, {String? size, String? color}) {
    final item = _items.firstWhere(
      (item) => item.product.id == productId && 
                item.selectedSize == size && 
                item.selectedColor == color,
      orElse: () => CartItem(product: Product(
        id: '', name: '', price: 0, description: '', image: '', 
        images: [], category: '', rating: 0, reviews: 0, 
        inStock: false, features: [], brand: ''
      ), quantity: 0),
    );
    return item.quantity;
  }
}