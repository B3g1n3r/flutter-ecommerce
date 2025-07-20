import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/wishlist_item.dart';
import '../models/product.dart';

class WishlistProvider with ChangeNotifier {
  final SharedPreferences _prefs;
  List<WishlistItem> _items = [];

  WishlistProvider(this._prefs) {
    _loadWishlist();
  }

  List<WishlistItem> get items => _items;
  int get itemCount => _items.length;

  void _loadWishlist() {
    final wishlistJson = _prefs.getString('wishlist');
    if (wishlistJson != null) {
      final List<dynamic> wishlistList = json.decode(wishlistJson);
      _items = wishlistList.map((item) => WishlistItem.fromJson(item)).toList();
      notifyListeners();
    }
  }

  Future<void> _saveWishlist() async {
    final wishlistJson = json.encode(_items.map((item) => item.toJson()).toList());
    await _prefs.setString('wishlist', wishlistJson);
  }

  void addToWishlist(Product product) {
    if (!isInWishlist(product.id)) {
      _items.add(WishlistItem(
        product: product,
        addedAt: DateTime.now(),
      ));
      _saveWishlist();
      notifyListeners();
    }
  }

  void removeFromWishlist(String productId) {
    _items.removeWhere((item) => item.product.id == productId);
    _saveWishlist();
    notifyListeners();
  }

  void toggleWishlist(Product product) {
    if (isInWishlist(product.id)) {
      removeFromWishlist(product.id);
    } else {
      addToWishlist(product);
    }
  }

  bool isInWishlist(String productId) {
    return _items.any((item) => item.product.id == productId);
  }

  void clearWishlist() {
    _items.clear();
    _saveWishlist();
    notifyListeners();
  }
}