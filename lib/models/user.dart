class User {
  final String id;
  final String email;
  final String name;
  final String? avatar;
  final String? phone;
  final String? address;

  User({
    required this.id,
    required this.email,
    required this.name,
    this.avatar,
    this.phone,
    this.address,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      avatar: json['avatar'],
      phone: json['phone'],
      address: json['address'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'avatar': avatar,
      'phone': phone,
      'address': address,
    };
  }

  User copyWith({
    String? id,
    String? email,
    String? name,
    String? avatar,
    String? phone,
    String? address,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      phone: phone ?? this.phone,
      address: address ?? this.address,
    );
  }
}