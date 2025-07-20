class Product {
  final String id;
  final String name;
  final double price;
  final double? originalPrice;
  final String description;
  final String image;
  final List<String> images;
  final String category;
  final double rating;
  final int reviews;
  final bool inStock;
  final List<String> features;
  final String brand;
  final Map<String, dynamic>? specifications;

  Product({
    required this.id,
    required this.name,
    required this.price,
    this.originalPrice,
    required this.description,
    required this.image,
    required this.images,
    required this.category,
    required this.rating,
    required this.reviews,
    required this.inStock,
    required this.features,
    required this.brand,
    this.specifications,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      price: json['price'].toDouble(),
      originalPrice: json['originalPrice']?.toDouble(),
      description: json['description'],
      image: json['image'],
      images: List<String>.from(json['images']),
      category: json['category'],
      rating: json['rating'].toDouble(),
      reviews: json['reviews'],
      inStock: json['inStock'],
      features: List<String>.from(json['features']),
      brand: json['brand'],
      specifications: json['specifications'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'originalPrice': originalPrice,
      'description': description,
      'image': image,
      'images': images,
      'category': category,
      'rating': rating,
      'reviews': reviews,
      'inStock': inStock,
      'features': features,
      'brand': brand,
      'specifications': specifications,
    };
  }

  bool get hasDiscount => originalPrice != null && originalPrice! > price;
  
  double get discountPercentage {
    if (!hasDiscount) return 0;
    return ((originalPrice! - price) / originalPrice!) * 100;
  }
}