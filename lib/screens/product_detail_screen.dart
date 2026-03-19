import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/product_model.dart';
import '../constants/product_colors.dart';
import '../services/cart_service.dart';
import '../services/favorite_service.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  static final _priceFormat = NumberFormat('#,###', 'vi_VN');

  String _formatPrice(double price) {
    return '${_priceFormat.format(price.toInt())}đ';
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final favoriteService = FavoriteService.instance;
    final productColor = ProductColors.getColor(product.color);
    final hasDiscount = product.discountPercent > 0;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // --- App Bar with image ---
          SliverAppBar(
            expandedHeight: screenHeight * 0.45,
            pinned: true,
            backgroundColor: productColor,
            foregroundColor: Colors.white,
            actions: [
              ValueListenableBuilder<Set<int>>(
                valueListenable: favoriteService.favoriteIds,
                builder: (context, ids, _) {
                  final isFavorite = ids.contains(product.id);
                  return IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                    ),
                    onPressed: () async {
                      final isNowFavorite = await favoriteService
                          .toggleFavorite(product.id);
                      if (!context.mounted) return;
                      _showSnackBar(
                        context,
                        isNowFavorite
                            ? 'Đã thêm vào yêu thích'
                            : 'Đã bỏ khỏi yêu thích',
                      );
                    },
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: () =>
                    _showSnackBar(context, 'Chức năng đang phát triển'),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'product_${product.id}',
                child: product.image.isNotEmpty
                    ? Image.network(
                        product.image,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorBuilder: (_, e, s) => Container(
                          color: productColor.withValues(alpha: 0.1),
                          child: Center(
                            child: Icon(
                              Icons.local_florist,
                              size: 80,
                              color: productColor,
                            ),
                          ),
                        ),
                      )
                    : Container(
                        color: productColor.withValues(alpha: 0.1),
                        child: Center(
                          child: Icon(
                            Icons.local_florist,
                            size: 80,
                            color: productColor,
                          ),
                        ),
                      ),
              ),
            ),
          ),

          // --- Body content ---
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: productColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      product.category,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: productColor,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Name
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Rating (mock)
                  Row(
                    children: [
                      ...List.generate(
                        5,
                        (i) => Icon(
                          i < 4 ? Icons.star : Icons.star_half,
                          color: Colors.amber,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '4.5 (128 đánh giá)',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Price section
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _formatPrice(product.price),
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: hasDiscount
                                    ? Colors.red
                                    : const Color(0xFFE91E63),
                              ),
                            ),
                            if (hasDiscount)
                              Row(
                                children: [
                                  Text(
                                    _formatPrice(product.originalPrice),
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey.shade400,
                                      decoration: TextDecoration.lineThrough,
                                      decorationColor: Colors.grey.shade400,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.red.shade50,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      'Tiết kiệm ${_formatPrice(product.originalPrice - product.price)}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.red.shade700,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Description
                  const Text(
                    'Mô tả sản phẩm',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.description,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey.shade700,
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Info chips
                  const Text(
                    'Thông tin chi tiết',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _infoChip(
                        Icons.palette,
                        'Màu: ${product.color}',
                        productColor,
                      ),
                      _infoChip(
                        Icons.inventory_2,
                        'Còn ${product.quantity} sản phẩm',
                        Colors.teal,
                      ),
                      _infoChip(
                        Icons.local_shipping,
                        'Giao hàng miễn phí',
                        Colors.blue,
                      ),
                      _infoChip(
                        Icons.verified,
                        'Cam kết hàng chính hãng',
                        Colors.green,
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Delivery info
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade200),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        _deliveryRow(
                          Icons.local_shipping_outlined,
                          'Giao hàng nhanh 2h',
                          'Nội thành TP.HCM',
                        ),
                        const Divider(height: 20),
                        _deliveryRow(
                          Icons.replay,
                          'Đổi trả miễn phí',
                          'Trong vòng 24h nếu sản phẩm lỗi',
                        ),
                        const Divider(height: 20),
                        _deliveryRow(
                          Icons.verified_user_outlined,
                          'Bảo đảm chất lượng',
                          'Sản phẩm tươi 100% từ vườn',
                        ),
                      ],
                    ),
                  ),

                  // Bottom padding for button
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),

      // --- Bottom Add to Cart bar ---
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: Row(
          children: [
            // Chat button
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: const Icon(Icons.chat_bubble_outline),
                onPressed: () =>
                    _showSnackBar(context, 'Chức năng đang phát triển'),
              ),
            ),
            const SizedBox(width: 12),
            // Add to cart
            Expanded(
              child: SizedBox(
                height: 48,
                child: OutlinedButton.icon(
                  onPressed: () {
                    CartService.instance.addToCart(product);
                    _showSnackBar(
                      context,
                      'Đã thêm ${product.name} vào giỏ hàng',
                    );
                  },
                  icon: const Icon(Icons.add_shopping_cart),
                  label: const Text('Thêm vào giỏ'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFE91E63),
                    side: const BorderSide(color: Color(0xFFE91E63)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Buy now
            Expanded(
              child: SizedBox(
                height: 48,
                child: FilledButton(
                  onPressed: () {
                    CartService.instance.addToCart(product);
                    _showSnackBar(
                      context,
                      'Đã thêm ${product.name} vào giỏ hàng',
                    );
                    Navigator.pop(context);
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFE91E63),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Mua ngay',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _deliveryRow(IconData icon, String title, String subtitle) {
    return Row(
      children: [
        Icon(icon, size: 24, color: Colors.grey.shade600),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
              ),
            ],
          ),
        ),
      ],
    );
  }
}




