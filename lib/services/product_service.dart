import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import '../models/product_model.dart';
import '../config/api_config.dart';
import '../data/mock_products.dart';

class ProductService {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';
  static const String _dummyProductApi = 'https://dummyjson.com/products';

  // Map san pham mock (id local) -> san pham that tren DummyJSON (id API).
  static const Map<int, int> _mockProductImageIds = {
    1: 45,
    2: 46,
    3: 43,
    4: 16,
    5: 40,
    6: 174,
    7: 176,
    8: 175,
    9: 172,
    10: 1,
    11: 4,
    12: 5,
    13: 119,
    14: 133,
    15: 123,
    16: 125,
    17: 130,
    18: 51,
    19: 66,
    20: 76,
    21: 99,
    22: 101,
  };

  static Future<String?> _fetchImageByProductId(int productId) async {
    final url = Uri.parse('$_dummyProductApi/$productId');

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 6));
      if (response.statusCode != 200) return null;

      final data = json.decode(response.body) as Map<String, dynamic>;
      final thumbnail = data['thumbnail'] as String?;
      if (thumbnail != null && thumbnail.isNotEmpty) return thumbnail;

      final images = data['images'] as List<dynamic>?;
      if (images != null && images.isNotEmpty) {
        final first = images.first as String?;
        if (first != null && first.isNotEmpty) return first;
      }

      return null;
    } catch (_) {
      return null;
    }
  }

  static Future<List<Product>> _enrichProductsWithImages(
    List<Product> products,
  ) async {
    final updated = await Future.wait(
      products.map((product) async {
        final mappedApiId = _mockProductImageIds[product.id];
        final apiImage = mappedApiId != null
            ? await _fetchImageByProductId(mappedApiId)
            : null;
        if (apiImage != null && apiImage.isNotEmpty) {
          return product.copyWith(image: apiImage);
        }

        return product;
      }),
    );

    return updated;
  }

  /// Fetch danh sách san pham + gọi Wikipedia API lấy ảnh
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
        products = MockProductData.getMockProducts();
      } else {
        products = await _fetchFromApi();
      }

      return _enrichProductsWithImages(products);
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }

  /// Gọi JSONPlaceholder API rồi transform thành Product
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
            image: '', // Sẽ được cập nhật bởi Wikipedia API
            color: _productColors[id % _productColors.length],
            quantity: 10 + id * 5,
            category: _productCategories[id % _productCategories.length],
            originalPrice: (25000 + id * 5000).toDouble(),
            discountPercent: id % 2 == 0 ? (10 + (id % 30)) : 0,
          );
        }).toList();
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception(
        'Lỗi kết nối API: Khong the tai danh sach san pham từ máy chủ. '
        'Vui lòng kiểm tra kết nối Internet và thử lại. Chi tiết: $e',
      );
    }
  }

  static const List<String> _productNames = [
    'San pham Hồng',
    'San pham Tulip',
    'San pham Lan Hồ Điệp',
    'San pham Cúc',
    'San pham Hướng Dương',
    'San pham Tú Cầu',
    'San pham Cẩm Chướng',
    'San pham Lily',
    'San pham Mẫu Đơn',
    'San pham Oải Hương',
    'San pham Đồng Tiền',
    'San pham Thược Dược',
    'San pham Anh Đào',
    'San pham Sen',
    'San pham Sứ',
    'San pham Hải Đường',
    'San pham Iris',
    'San pham Cúc Vạn Thọ',
    'San pham Bỉ Ngạn',
    'San pham Trạng Nguyên',
  ];

  static const List<String> _productColors = [
    'Đỏ',
    'Vàng',
    'Trắng',
    'Hồng',
    'Tím',
    'Cam',
    'Xanh lá',
    'Tím nhạt',
  ];

  static const List<String> _productCategories = ['TRANG_TRI', 'THUC_PHAM'];
}




