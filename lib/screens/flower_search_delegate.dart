import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/flower_model.dart';
import '../services/cart_service.dart';
import '../constants/flower_colors.dart';
import 'flower_detail_screen.dart';

class FlowerSearchDelegate extends SearchDelegate<Flower?> {
  final List<Flower> flowers;

  FlowerSearchDelegate(this.flowers)
    : super(
        searchFieldLabel: 'Tìm kiếm hoa...',
        searchFieldStyle: const TextStyle(fontSize: 16),
      );

  static final _priceFormat = NumberFormat('#,###', 'vi_VN');
  static const _primaryPink = Color(0xFFE91E63);

  String _formatPrice(double price) {
    return '${_priceFormat.format(price.toInt())}đ';
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      appBarTheme: const AppBarTheme(
        backgroundColor: _primaryPink,
        foregroundColor: Colors.white,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.white70),
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(icon: const Icon(Icons.clear), onPressed: () => query = ''),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults(context);
  }

  Widget _buildSearchResults(BuildContext context) {
    final results = query.isEmpty
        ? flowers
        : flowers.where((f) {
            final q = query.toLowerCase();
            return f.name.toLowerCase().contains(q) ||
                f.description.toLowerCase().contains(q) ||
                f.category.toLowerCase().contains(q) ||
                f.color.toLowerCase().contains(q);
          }).toList();

    if (results.isEmpty) {sádcdswwsdfcfds
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(
              'Không tìm thấy "$query"',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: results.length,
      separatorBuilder: (_, i) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final flower = results[index];
        final flowerColor = FlowerColors.getColor(flower.color);

        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => FlowerDetailScreen(flower: flower),
              ),
            );
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    width: 70,
                    height: 70,
                    child: flower.image.isNotEmpty
                        ? Image.network(
                            flower.image,
                            fit: BoxFit.cover,
                            errorBuilder: (_, e, s) => Container(
                              color: flowerColor.withValues(alpha: 0.1),
                              child: Icon(
                                Icons.local_florist,
                                color: flowerColor,
                              ),
                            ),
                          )
                        : Container(
                            color: flowerColor.withValues(alpha: 0.1),
                            child: Icon(
                              Icons.local_florist,
                              color: flowerColor,
                            ),
                          ),
                  ),
                ),
                const SizedBox(width: 12),
                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        flower.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        flower.category,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: _primaryPink,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        flower.description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatPrice(flower.price),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: _primaryPink,
                        ),
                      ),
                    ],
                  ),
                ),
                // Add to cart
                IconButton(
                  icon: const Icon(Icons.add_shopping_cart, size: 22),
                  color: _primaryPink,
                  onPressed: () {
                    CartService.instance.addToCart(flower);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Đã thêm ${flower.name} vào giỏ'),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
