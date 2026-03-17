import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/product_model.dart';
import '../services/cart_service.dart';
import '../constants/product_colors.dart';
import 'product_detail_screen.dart';

class ProductSearchDelegate extends SearchDelegate<Product?> {
  final List<Product> products;
  double? _minPrice;
  double? _maxPrice;

  ProductSearchDelegate(this.products)
    : super(
        searchFieldLabel: 'Tìm kiếm sản phẩm...',
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
      IconButton(
        icon: Icon(
          Icons.tune,
          color: _hasPriceFilter ? Colors.amber.shade200 : Colors.white,
        ),
        tooltip: 'Lọc khoảng giá',
        onPressed: () => _showPriceFilter(context),
      ),
      if (_hasPriceFilter)
        IconButton(
          icon: const Icon(Icons.filter_alt_off_outlined),
          tooltip: 'Xóa lọc giá',
          onPressed: () {
            _minPrice = null;
            _maxPrice = null;
            showSuggestions(context);
          },
        ),
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
    final results = products.where((f) {
      final queryMatch = query.isEmpty
          ? true
          : f.name.toLowerCase().contains(query.toLowerCase()) ||
                f.description.toLowerCase().contains(query.toLowerCase()) ||
                f.category.toLowerCase().contains(query.toLowerCase()) ||
                f.color.toLowerCase().contains(query.toLowerCase());
      return queryMatch && _matchesPrice(f.price);
    }).toList();

    if (results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(
              _emptyMessage,
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
        final product = results[index];
        final productColor = ProductColors.getColor(product.color);

        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProductDetailScreen(product: product),
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
                    child: product.image.isNotEmpty
                        ? Image.network(
                            product.image,
                            fit: BoxFit.cover,
                            errorBuilder: (_, e, s) => Container(
                              color: productColor.withValues(alpha: 0.1),
                              child: Icon(
                                Icons.local_florist,
                                color: productColor,
                              ),
                            ),
                          )
                        : Container(
                            color: productColor.withValues(alpha: 0.1),
                            child: Icon(
                              Icons.local_florist,
                              color: productColor,
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
                        product.name,
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
                        product.category,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: _primaryPink,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        product.description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatPrice(product.price),
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
                    CartService.instance.addToCart(product);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Đã thêm ${product.name} vào giỏ'),
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

  bool get _hasPriceFilter => _minPrice != null || _maxPrice != null;

  bool _matchesPrice(double price) {
    if (_minPrice != null && price < _minPrice!) return false;
    if (_maxPrice != null && price > _maxPrice!) return false;
    return true;
  }

  String get _emptyMessage {
    if (_hasPriceFilter && query.isEmpty) {
      return 'Không có sản phẩm trong khoảng giá đã chọn';
    }
    if (_hasPriceFilter && query.isNotEmpty) {
      return 'Không tìm thấy "$query" trong khoảng giá đã chọn';
    }
    return 'Không tìm thấy "$query"';
  }

  Future<void> _showPriceFilter(BuildContext context) async {
    final ranges = <({String label, double? min, double? max})>[
      (label: 'Dưới 200.000đ', min: null, max: 200000),
      (label: '200.000đ - 1.000.000đ', min: 200000, max: 1000000),
      (label: '1.000.000đ - 5.000.000đ', min: 1000000, max: 5000000),
      (label: 'Trên 5.000.000đ', min: 5000000, max: null),
    ];

    final selected = await showModalBottomSheet<({double? min, double? max})>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Lọc theo khoảng giá',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                ...ranges.map(
                  (range) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(range.label),
                    onTap: () {
                      Navigator.pop(context, (min: range.min, max: range.max));
                    },
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Bỏ lọc giá'),
                  leading: const Icon(Icons.filter_alt_off_outlined),
                  onTap: () => Navigator.pop(context, (min: null, max: null)),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (selected != null) {
      if (!context.mounted) return;
      _minPrice = selected.min;
      _maxPrice = selected.max;
      showSuggestions(context);
    }
  }
}




