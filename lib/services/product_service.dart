import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import '../models/product_model.dart';
import '../config/api_config.dart';
import '../data/mock_products.dart';

class ProductService {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';
  static const String _fallbackImageApiBase = 'https://picsum.photos/seed/';

  static List<String> _buildFallbackGallery(String productName, int seed) {
    final encoded = Uri.encodeComponent(productName.toLowerCase());
    return [
      '$_fallbackImageApiBase${encoded}_${seed}_1/1200/1200',
      '$_fallbackImageApiBase${encoded}_${seed}_2/1200/1200',
      '$_fallbackImageApiBase${encoded}_${seed}_3/1200/1200',
      '$_fallbackImageApiBase${encoded}_${seed}_4/1200/1200',
    ];
  }

  static Future<List<Product>> _enrichProductsWithImages(
    List<Product> products,
  ) async {
    return products.map((product) {
      final hasImage = product.image.trim().isNotEmpty;
      final hasGallery = product.imageGallery.isNotEmpty;

      // Keep curated mock images when they already exist.
      if (hasImage && hasGallery) {
        return product;
      }

      final gallery = hasGallery
          ? product.imageGallery
          : _buildFallbackGallery(product.name, product.id);
      final primaryImage = hasImage ? product.image : gallery.first;

      return product.copyWith(image: primaryImage, imageGallery: gallery);
    }).toList();
  }

  /// Fetch danh sách sản phẩm và bổ sung ảnh từ DummyJSON.
  static Future<List<Product>> fetchProducts() async {
    try {
      if (ApiConfig.simulatedDelay > 0) {
        await Future.delayed(Duration(milliseconds: ApiConfig.simulatedDelay));
      }

      if (ApiConfig.simulateNetworkError) {
        throw Exception(
          'Lỗi kết nối mạng: Không thể kết nối tới máy chủ. '
          'Vui lòng kiểm tra kết nối Internet.',
        );
      }

      // Kiểm tra kết nối mạng thật
      try {
        final lookup = await InternetAddress.lookup(
          'google.com',
        ).timeout(const Duration(seconds: 3));
        if (lookup.isEmpty || lookup[0].rawAddress.isEmpty) {
          throw Exception('Không có kết nối');
        }
      } catch (_) {
        throw Exception(
          'Lỗi kết nối mạng: Không có kết nối Internet. '
          'Vui lòng bật WiFi hoặc dữ liệu di động và thử lại.',
        );
      }

      // Load product list (mock or API)
      List<Product> products;
      if (ApiConfig.useMockData) {
        products = mockProducts;
      } else {
        products = await _fetchFromApi();
      }

      return _enrichProductsWithImages(products);
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }

  /// Gọi JSONPlaceholder API rồi transform thành Product.
  static Future<List<Product>> _fetchFromApi() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/posts?_limit=20'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);

        return jsonData.map((item) {
          final id = item['id'] as int;
          return Product(
            id: id,
            name: _productNames[id % _productNames.length],
            description: item['body'] as String,
            price: (20000 + id * 5000).toDouble(),
            image: '', // Sẽ được cập nhật bởi DummyJSON API
            color: _productColors[id % _productColors.length],
            quantity: 10 + id * 5,
            category: _productCategories[id % _productCategories.length],
            originalPrice: (25000 + id * 5000).toDouble(),
            discountPercent: id % 2 == 0 ? (10 + (id % 30)) : 0,
            availableSizes:
                _availableSizeGroups[id % _availableSizeGroups.length],
            availableColors:
                _availableColorGroups[id % _availableColorGroups.length],
            detailSpecs: {
              'Chất liệu': id.isEven ? 'Cotton cao cấp' : 'Da tổng hợp',
              'Phong cách': id.isEven ? 'Casual' : 'Minimal',
              'Bảo quản': 'Giặt nhẹ, tránh nhiệt cao',
            },
          );
        }).toList();
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception(
        'Lỗi kết nối API: Không thể tải dữ liệu sản phẩm. '
        'Vui lòng kiểm tra kết nối Internet và thử lại. Chi tiết: $e',
      );
    }
  }

  static const List<String> _productNames = [
    'Áo thun oversize basic',
    'Áo sơ mi linen tay dài',
    'Quần jean ống suông',
    'Chân váy midi xếp ly',
    'Áo khoác bomber nhẹ',
    'Đầm midi tay phồng',
    'Túi đeo vai da mini',
    'Ví cầm tay khóa kéo',
    'Kính mát gọng vuông',
    'Mũ lưỡi trai thêu chữ',
    'Đồng hồ dây kim loại',
    'Thắt lưng da bản nhỏ',
  ];

  static const List<String> _productColors = [
    'Đen',
    'Trắng',
    'Xám',
    'Đỏ',
    'Xanh',
    'Bạc',
    'Nâu',
    'Cam',
    'Đỏ',
    'Đen',
    'Trắng',
  ];

  static const List<String> _productCategories = ['THOI_TRANG', 'PHU_KIEN'];

  static const List<List<String>> _availableSizeGroups = [
    ['S', 'M', 'L', 'XL'],
    ['28', '29', '30', '31', '32'],
    ['M', 'L', 'XL'],
    ['One Size'],
  ];

  static const List<List<String>> _availableColorGroups = [
    ['Đen', 'Trắng', 'Xám'],
    ['Xanh denim', 'Đen', 'Nâu'],
    ['Be', 'Kem', 'Navy'],
    ['Đen', 'Nâu', 'Bạc'],
  ];
}
