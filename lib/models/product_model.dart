class Product {
  final int id;
  final String name;
  final String description;
  final double price;
  final String image;
  final List<String> imageGallery;
  final String color;
  final int quantity;
  final String category; // e.g. "TRANG_TRI", "GIO_QUA"
  final double originalPrice; // Current price
  final int discountPercent; // Discount percentage (0-100)
  final List<String> availableSizes;
  final List<String> availableColors;
  final Map<String, String> detailSpecs;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    this.imageGallery = const [],
    required this.color,
    required this.quantity,
    required this.category,
    required this.originalPrice,
    required this.discountPercent,
    required this.availableSizes,
    required this.availableColors,
    required this.detailSpecs,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? 'Unknown',
      description: json['description'] as String? ?? 'No description',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      image: json['image'] as String? ?? '',
      imageGallery:
          (json['imageGallery'] as List<dynamic>? ??
                  json['images'] as List<dynamic>? ??
                  const [])
              .map((e) => '$e')
              .where((e) => e.isNotEmpty)
              .toList(),
      color: json['color'] as String? ?? 'Red',
      quantity: json['quantity'] as int? ?? 0,
      category: json['category'] as String? ?? 'THOI_TRANG',
      originalPrice: (json['originalPrice'] as num?)?.toDouble() ?? 0.0,
      discountPercent: json['discountPercent'] as int? ?? 0,
      availableSizes: (json['availableSizes'] as List<dynamic>? ?? const ['M'])
          .map((e) => '$e')
          .toList(),
      availableColors:
          (json['availableColors'] as List<dynamic>? ?? const ['Đen'])
              .map((e) => '$e')
              .toList(),
      detailSpecs: (json['detailSpecs'] as Map<String, dynamic>? ?? const {})
          .map((key, value) => MapEntry('$key', '$value')),
    );
  }

  Product copyWith({String? image, List<String>? imageGallery}) {
    return Product(
      id: id,
      name: name,
      description: description,
      price: price,
      image: image ?? this.image,
      imageGallery: imageGallery ?? this.imageGallery,
      color: color,
      quantity: quantity,
      category: category,
      originalPrice: originalPrice,
      discountPercent: discountPercent,
      availableSizes: availableSizes,
      availableColors: availableColors,
      detailSpecs: detailSpecs,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'price': price,
    'image': image,
    'imageGallery': imageGallery,
    'color': color,
    'quantity': quantity,
    'category': category,
    'originalPrice': originalPrice,
    'discountPercent': discountPercent,
    'availableSizes': availableSizes,
    'availableColors': availableColors,
    'detailSpecs': detailSpecs,
  };
}
