import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/flower_model.dart';
import '../constants/flower_colors.dart';

class FlowerCard extends StatelessWidget {
  final Flower flower;
  final VoidCallback? onTap;
  final VoidCallback? onAddToCart;
  final VoidCallback? onToggleFavorite;
  final bool isFavorite;

  const FlowerCard({
    super.key,
    required this.flower,
    this.onTap,
    this.onAddToCart,
    this.onToggleFavorite,
    this.isFavorite = false,
  });

  static final _priceFormat = NumberFormat('#,###', 'vi_VN');

  String _formatPrice(double price) {
    return '${_priceFormat.format(price.toInt())}đ';
  }

  @override
  Widget build(BuildContext context) {
    final flowerColor = FlowerColors.getColor(flower.color);
    final hasDiscount = flower.discountPercent > 0;
    final soldCount = ((flower.id * 137) % 3200) + 150;
    final soldText = soldCount >= 1000
        ? 'Đã bán ${(soldCount / 1000).toStringAsFixed(1)}k'
        : 'Đã bán $soldCount';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Ảnh hoa ---
            Expanded(
              flex: 5,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Ảnh
                  Hero(
                    tag: 'flower_${flower.id}',
                    child: flower.image.isNotEmpty
                        ? Image.network(
                            flower.image,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            errorBuilder: (_, e, s) =>
                                _placeholder(flowerColor),
                            loadingBuilder: (_, child, progress) {
                              if (progress == null) return child;
                              return Container(
                                color: flowerColor.withValues(alpha: 0.05),
                                child: Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation(
                                      flowerColor,
                                    ),
                                  ),
                                ),
                              );
                            },
                          )
                        : _placeholder(flowerColor),
                  ),

                  // Badge giảm giá
                  if (hasDiscount)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '-${flower.discountPercent}%',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                  // Nút yêu thích
                  Positioned(
                    top: 6,
                    right: 6,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: onToggleFavorite,
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          size: 18,
                          color: isFavorite
                              ? const Color(0xFFE53935)
                              : Colors.grey.shade400,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // --- Thông tin sản phẩm ---
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      _buildTag('Mall', const Color(0xFFEE4D2D)),
                      if (hasDiscount)
                        _buildTag(
                          'Giảm ${flower.discountPercent}%',
                          const Color(0xFFE53935),
                        )
                      else
                        _buildTag('Yêu thích', const Color(0xFF1E88E5)),
                    ],
                  ),

                  const SizedBox(height: 6),

                  Text(
                    flower.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    soldText,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 6),

                  // Giá + nút thêm giỏ
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _formatPrice(flower.price),
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: hasDiscount ? Colors.red : primaryPink,
                              ),
                            ),
                            if (hasDiscount)
                              Text(
                                _formatPrice(flower.originalPrice),
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey.shade400,
                                  decoration: TextDecoration.lineThrough,
                                  decorationColor: Colors.grey.shade400,
                                ),
                              ),
                          ],
                        ),
                      ),
                      // Nút thêm giỏ hàng
                      GestureDetector(
                        onTap: onAddToCart,
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: primaryPink,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static const Color primaryPink = Color(0xFFE91E63);

  Widget _buildTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }

  Widget _placeholder(Color color) {
    return Container(
      color: color.withValues(alpha: 0.08),
      child: Center(child: Icon(Icons.local_florist, size: 40, color: color)),
    );
  }
}
