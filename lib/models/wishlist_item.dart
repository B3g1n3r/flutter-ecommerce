import 'product.dart';

class WishlistItem {
  final Product product;
  final DateTime addedAt;

  WishlistItem({
    required this.product,
    required this.addedAt,
  });

  factory WishlistItem.fromJson(Map<String, dynamic> json) {
    return WishlistItem(
      product: Product.fromJson(json['product']),
      addedAt: DateTime.parse(json['addedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      'addedAt': addedAt.toIso8601String(),
    };
  }
}