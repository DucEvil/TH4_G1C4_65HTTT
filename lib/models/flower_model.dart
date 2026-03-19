class Flower {
  final int id;
  final String name;
  final String description;
  final double price;
  final String image;
  final String color;
  final int quantity;
  final String category; // e.g. "BÓ HOA", "GIỎ HOA"
  final double originalPrice; // Current price
  final int discountPercent; // Discount percentage (0-100)

  Flower({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.color,
    required this.quantity,
    required this.category,
    required this.originalPrice,
    required this.discountPercent,
  });

  factory Flower.fromJson(Map<String, dynamic> json) {
    return Flower(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? 'Unknown',
      description: json['description'] as String? ?? 'No description',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      image: json['image'] as String? ?? '',
      color: json['color'] as String? ?? 'Red',
      quantity: json['quantity'] as int? ?? 0,
      category: json['category'] as String? ?? 'BÓ HOA',
      originalPrice: (json['originalPrice'] as num?)?.toDouble() ?? 0.0,
      discountPercent: json['discountPercent'] as int? ?? 0,
    );
  }

  Flower copyWith({String? image}) {
    return Flower(
      id: id,
      name: name,
      description: description,
      price: price,
      image: image ?? this.image,
      color: color,
      quantity: quantity,
      category: category,
      originalPrice: originalPrice,
      discountPercent: discountPercent,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'price': price,
    'image': image,
    'color': color,
    'quantity': quantity,
    'category': category,
    'originalPrice': originalPrice,
    'discountPercent': discountPercent,
  };
}
