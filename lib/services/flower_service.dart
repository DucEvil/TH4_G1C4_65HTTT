import 'package:http/http.dart' as http;
import 'dart:convert';
// import 'dart:io';
import '../models/flower_model.dart';
import '../config/api_config.dart';
import '../data/mock_flowers.dart';

class FlowerService {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';

  /// Wikipedia API - lấy ảnh đại diện bài viết các loài hoa
  /// Luôn trả về ảnh thật, chất lượng cao, miễn phí, không cần API key
  static const String _wikiApiUrl = 'https://en.wikipedia.org/w/api.php';

  /// Map tên hoa tiếng Việt → tên bài viết Wikipedia tiếng Anh
  /// Dùng tên khoa học/cụ thể để Wikipedia trả về ảnh đẹp nhất
  static const Map<String, String> _wikiTitles = {
    'Hoa Hồng': 'Garden_roses',
    'Hoa Tulip': 'Tulip',
    'Hoa Lan Hồ Điệp': 'Phalaenopsis',
    'Hoa Cúc': 'Chrysanthemum_indicum',
    'Hoa Hướng Dương': 'Common_sunflower',
    'Hoa Tú Cầu': 'Hydrangea_macrophylla',
    'Hoa Cẩm Chướng': 'Dianthus_caryophyllus',
    'Hoa Lily': 'Lilium',
    'Hoa Mẫu Đơn': 'Peony',
    'Hoa Oải Hương': 'Lavandula',
    'Hoa Đồng Tiền': 'Gerbera',
    'Hoa Thược Dược': 'Dahlia',
    'Hoa Anh Đào': 'Cherry_blossom',
    'Hoa Sen': 'Nelumbo_nucifera',
    'Hoa Sứ': 'Plumeria',
    'Hoa Hải Đường': 'Camellia_japonica',
    'Hoa Iris': 'Iris_(plant)',
    'Hoa Cúc Vạn Thọ': 'Tagetes',
    'Hoa Bỉ Ngạn': 'Lycoris_radiata',
    'Hoa Trạng Nguyên': 'Poinsettia',
  };

  /// Gọi Wikipedia pageimages API — batch 1 lần cho tất cả loài hoa
  /// Trả về map [wikiTitle -> imageUrl]
  static Future<Map<String, String>> _fetchWikiImages(
    List<String> titles,
  ) async {
    final result = <String, String>{};

    // Wikipedia cho phép tối đa 50 titles/request
    final titlesParam = titles.join('|');
    final url = Uri.parse(
      '$_wikiApiUrl?action=query'
      '&titles=${Uri.encodeComponent(titlesParam)}'
      '&prop=pageimages'
      '&piprop=thumbnail'
      '&pithumbsize=800'
      '&format=json'
      '&origin=*',
    );

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 5));
      if (response.statusCode != 200) {
        throw Exception('HTTP ${response.statusCode}');
      }
      final data = json.decode(response.body);
      final pages = data['query']?['pages'] as Map<String, dynamic>?;
      if (pages != null) {
        for (final page in pages.values) {
          final title = page['title'] as String?;
          final thumbnail = page['thumbnail'] as Map<String, dynamic>?;
          if (title != null && thumbnail != null) {
            final imageUrl = thumbnail['source'] as String?;
            if (imageUrl != null) {
              result[title] = imageUrl;
            }
          }
        }
      }
    } catch (e) {
      // Lỗi mạng → ném lỗi để hiển thị thông báo
      throw Exception(
        'Lỗi kết nối mạng: Không thể tải ảnh hoa. '
        'Vui lòng kiểm tra kết nối Internet.',
      );
    }

    if (result.isEmpty) {
      throw Exception(
        'Lỗi kết nối mạng: Không tải được ảnh hoa. '
        'Vui lòng kiểm tra kết nối Internet.',
      );
    }

    return result;
  }

  /// Fetch danh sách hoa + gọi Wikipedia API lấy ảnh
  static Future<List<Flower>> fetchFlowers() async {
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

      // Bỏ qua kiểm tra kết nối mạng - dùng mock data
      // try {
      //   final lookup = await InternetAddress.lookup(
      //     'google.com',
      //   ).timeout(const Duration(seconds: 3));
      //   if (lookup.isEmpty || lookup[0].rawAddress.isEmpty) {
      //     throw Exception('Không có kết nối');
      //   }
      // } catch (_) {
      //   throw Exception(
      //     'Lỗi kết nối mạng: Không có kết nối Internet. '
      //     'Vui lòng bật WiFi hoặc dữ liệu di động và thử lại.',
      //   );
      // }

      // Lấy danh sách hoa (mock hoặc API)
      List<Flower> flowers;
      if (ApiConfig.useMockData) {
        flowers = MockFlowerData.getMockFlowers();
      } else {
        flowers = await _fetchFromApi();
      }

      // Tạo danh sách Wikipedia titles cần lấy ảnh
      final wikiTitlesToFetch = <String>[];
      final nameToWikiTitle = <String, String>{};
      for (final f in flowers) {
        final wikiTitle = _wikiTitles[f.name];
        if (wikiTitle != null) {
          wikiTitlesToFetch.add(wikiTitle);
          nameToWikiTitle[f.name] = wikiTitle;
        }
      }

      // Gọi Wikipedia API 1 lần duy nhất cho tất cả 20 hoa
      if (!ApiConfig.skipWikiImages) {
        final imageMap = await _fetchWikiImages(wikiTitlesToFetch);

        // Cập nhật flowers với ảnh từ Wikipedia
        final updatedFlowers = flowers.map((flower) {
          final wikiTitle = nameToWikiTitle[flower.name];
          if (wikiTitle != null) {
            // Wikipedia có thể normalize title (VD: Iris_(plant) → Iris (plant))
            final normalized = wikiTitle.replaceAll('_', ' ');
            final apiImage = imageMap[wikiTitle] ?? imageMap[normalized];
            if (apiImage != null && apiImage.isNotEmpty) {
              return flower.copyWith(image: apiImage);
            }
          }
          return flower;
        }).toList();

        return updatedFlowers;
      }

      // Nếu skipWikiImages = true, trả về flowers với ảnh mặc định
      return flowers;
    } catch (e) {
      throw Exception('Error fetching flowers: $e');
    }
  }

  /// Gọi JSONPlaceholder API rồi transform thành Flower
  static Future<List<Flower>> _fetchFromApi() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/posts?_limit=20'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);

        return jsonData.map((item) {
          final id = item['id'] as int;
          return Flower(
            id: id,
            name: _flowerNames[id % _flowerNames.length],
            description: item['body'] as String,
            price: (20000 + id * 5000).toDouble(),
            image: '', // Sẽ được cập nhật bởi Wikipedia API
            color: _flowerColors[id % _flowerColors.length],
            quantity: 10 + id * 5,
            category: _flowerCategories[id % _flowerCategories.length],
            originalPrice: (25000 + id * 5000).toDouble(),
            discountPercent: id % 2 == 0 ? (10 + (id % 30)) : 0,
          );
        }).toList();
      } else {
        throw Exception('Failed to load flowers: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception(
        'Lỗi kết nối API: Không thể tải danh sách hoa từ máy chủ. '
        'Vui lòng kiểm tra kết nối Internet và thử lại. Chi tiết: $e',
      );
    }
  }

  static const List<String> _flowerNames = [
    'Hoa Hồng',
    'Hoa Tulip',
    'Hoa Lan Hồ Điệp',
    'Hoa Cúc',
    'Hoa Hướng Dương',
    'Hoa Tú Cầu',
    'Hoa Cẩm Chướng',
    'Hoa Lily',
    'Hoa Mẫu Đơn',
    'Hoa Oải Hương',
    'Hoa Đồng Tiền',
    'Hoa Thược Dược',
    'Hoa Anh Đào',
    'Hoa Sen',
    'Hoa Sứ',
    'Hoa Hải Đường',
    'Hoa Iris',
    'Hoa Cúc Vạn Thọ',
    'Hoa Bỉ Ngạn',
    'Hoa Trạng Nguyên',
  ];

  static const List<String> _flowerColors = [
    'Đỏ',
    'Vàng',
    'Trắng',
    'Hồng',
    'Tím',
    'Cam',
    'Xanh lá',
    'Tím nhạt',
  ];

  static const List<String> _flowerCategories = ['HOA TƯƠI', 'HOA NHẬP KHẨU'];
}
