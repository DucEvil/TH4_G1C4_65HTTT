import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../constants/product_colors.dart';
import '../models/cart_item.dart';
import '../models/product_model.dart';
import '../services/cart_service.dart';
import '../services/favorite_service.dart';
import 'cart_screen.dart';
import 'checkout_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  static final _priceFormat = NumberFormat('#,###', 'vi_VN');

  final PageController _imageController = PageController();
  int _currentImage = 0;
  bool _descExpanded = false;

  String _formatPrice(double price) => '${_priceFormat.format(price.toInt())}đ';

  List<String> get _gallery {
    if (widget.product.imageGallery.isNotEmpty) {
      return widget.product.imageGallery;
    }
    if (widget.product.image.isNotEmpty) {
      return [widget.product.image];
    }
    return const [];
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  Future<void> _openChatSheet() async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => const _ProductChatSheet(),
    );
  }

  Future<_VariationResult?> _showVariationSheet({required bool buyNow}) {
    return showModalBottomSheet<_VariationResult>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => _VariationSheet(
        product: widget.product,
        formatPrice: _formatPrice,
        confirmLabel: buyNow ? 'Mua ngay' : 'Xác nhận',
      ),
    );
  }

  Future<void> _handleAddToCart() async {
    if (widget.product.quantity <= 0) {
      _showSnackBar('Sản phẩm hiện đã hết hàng');
      return;
    }

    final result = await _showVariationSheet(buyNow: false);
    if (!mounted || result == null) return;

    CartService.instance.addToCartWithQuantity(
      widget.product,
      result.quantity,
      size: result.size,
      color: result.color,
    );

    _showSnackBar('Thêm thành công');
  }

  Future<void> _handleBuyNow() async {
    if (widget.product.quantity <= 0) {
      _showSnackBar('Sản phẩm hiện đã hết hàng');
      return;
    }

    final result = await _showVariationSheet(buyNow: true);
    if (!mounted || result == null) return;

    CartService.instance.prepareCheckoutDirect(
      widget.product,
      quantity: result.quantity,
      size: result.size,
      color: result.color,
    );

    final checkoutResult = await Navigator.push<CheckoutResult>(
      context,
      MaterialPageRoute(builder: (_) => const CheckoutScreen()),
    );

    if (!mounted) return;
    if (checkoutResult == null) {
      CartService.instance.clearCheckoutDraft();
      return;
    }

    _showSnackBar('Đặt hàng thành công');
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _imageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final productColor = ProductColors.getColor(product.color);
    final hasDiscount = product.discountPercent > 0;
    final gallery = _gallery;

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 340,
            pinned: true,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black87,
            actions: [
              ValueListenableBuilder<Set<int>>(
                valueListenable: FavoriteService.instance.favoriteIds,
                builder: (_, ids, __) {
                  final isFavorite = ids.contains(product.id);
                  return IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                    ),
                    onPressed: () async {
                      final isNowFavorite = await FavoriteService.instance
                          .toggleFavorite(product.id);
                      if (!mounted) return;
                      _showSnackBar(
                        isNowFavorite
                            ? 'Đã thêm vào yêu thích'
                            : 'Đã bỏ khỏi yêu thích',
                      );
                    },
                  );
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  if (gallery.isNotEmpty)
                    PageView.builder(
                      controller: _imageController,
                      itemCount: gallery.length,
                      onPageChanged: (index) {
                        setState(() => _currentImage = index);
                      },
                      itemBuilder: (_, index) {
                        final image = Image.network(
                          gallery[index],
                          fit: BoxFit.cover,
                          loadingBuilder: (_, child, progress) {
                            if (progress == null) return child;
                            return Container(
                              color: Colors.grey.shade200,
                              child: const Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            );
                          },
                          errorBuilder: (_, __, ___) =>
                              _imageFallback(productColor),
                        );

                        if (index == 0) {
                          return Hero(
                            tag: 'product_${product.id}',
                            child: image,
                          );
                        }
                        return image;
                      },
                    )
                  else
                    Hero(
                      tag: 'product_${product.id}',
                      child: _imageFallback(productColor),
                    ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 14,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        gallery.isEmpty ? 1 : gallery.length,
                        (index) {
                          final isActive = _currentImage == index;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 220),
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            width: isActive ? 16 : 7,
                            height: 7,
                            decoration: BoxDecoration(
                              color: isActive ? Colors.white : Colors.white70,
                              borderRadius: BorderRadius.circular(99),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        _formatPrice(product.price),
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 10),
                      if (hasDiscount)
                        Text(
                          _formatPrice(product.originalPrice),
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            decoration: TextDecoration.lineThrough,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.quantity > 0
                        ? 'Tồn kho: ${product.quantity} sản phẩm'
                        : 'Tồn kho: Hết hàng',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: product.quantity > 0
                          ? Colors.green.shade700
                          : Colors.red.shade600,
                    ),
                  ),
                  const SizedBox(height: 14),
                  InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () async {
                      await _showVariationSheet(buyNow: false);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Chọn Kích cỡ, Màu sắc',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ),
                          Icon(Icons.chevron_right),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Mô tả chi tiết',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.description,
                    maxLines: _descExpanded ? null : 5,
                    overflow: _descExpanded
                        ? TextOverflow.visible
                        : TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey.shade700,
                      height: 1.55,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: () {
                        setState(() => _descExpanded = !_descExpanded);
                      },
                      child: Text(_descExpanded ? 'Thu gọn' : 'Xem thêm'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Thông tin chi tiết',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  ...product.detailSpecs.entries.map(
                    (entry) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 110,
                            child: Text(
                              entry.key,
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              entry.value,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 16),
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
            _bottomIcon(
              icon: Icons.chat_bubble_outline,
              label: 'Chat',
              onTap: _openChatSheet,
            ),
            const SizedBox(width: 8),
            ValueListenableBuilder<List<CartItem>>(
              valueListenable: CartService.instance.items,
              builder: (_, items, __) {
                return _bottomIcon(
                  icon: Icons.shopping_cart_outlined,
                  label: 'Giỏ hàng',
                  badgeCount: items.length,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const Scaffold(body: CartScreen()),
                      ),
                    );
                  },
                );
              },
            ),
            const SizedBox(width: 8),
            Expanded(
              child: SizedBox(
                height: 46,
                child: OutlinedButton(
                  onPressed: product.quantity > 0 ? _handleAddToCart : null,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFE91E63),
                    side: const BorderSide(color: Color(0xFFE91E63)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Thêm vào giỏ'),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: SizedBox(
                height: 46,
                child: FilledButton(
                  onPressed: product.quantity > 0 ? _handleBuyNow : null,
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFE91E63),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Mua ngay'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bottomIcon({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    int badgeCount = 0,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: SizedBox(
        width: 62,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Badge(
              isLabelVisible: badgeCount > 0,
              label: Text('$badgeCount'),
              child: Icon(icon, color: Colors.black87),
            ),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(fontSize: 11)),
          ],
        ),
      ),
    );
  }

  Widget _imageFallback(Color color) {
    return Container(
      color: color.withValues(alpha: 0.08),
      child: Center(child: Icon(Icons.image, size: 64, color: color)),
    );
  }
}

class _VariationResult {
  final String size;
  final String color;
  final int quantity;

  const _VariationResult({
    required this.size,
    required this.color,
    required this.quantity,
  });
}

class _VariationSheet extends StatefulWidget {
  final Product product;
  final String Function(double) formatPrice;
  final String confirmLabel;

  const _VariationSheet({
    required this.product,
    required this.formatPrice,
    required this.confirmLabel,
  });

  @override
  State<_VariationSheet> createState() => _VariationSheetState();
}

class _VariationSheetState extends State<_VariationSheet> {
  late String _size;
  late String _color;
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    _size = widget.product.availableSizes.isNotEmpty
        ? widget.product.availableSizes.first
        : 'M';
    _color = widget.product.availableColors.isNotEmpty
        ? widget.product.availableColors.first
        : widget.product.color;
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 8, 16, 16 + bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.product.name,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Text(
            widget.formatPrice(widget.product.price),
            style: const TextStyle(
              color: Colors.red,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            widget.product.quantity > 0
                ? 'Tồn kho: ${widget.product.quantity}'
                : 'Tồn kho: Hết hàng',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: widget.product.quantity > 0
                  ? Colors.green.shade700
                  : Colors.red.shade600,
            ),
          ),
          const SizedBox(height: 14),
          const Text('Size', style: TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: widget.product.availableSizes
                .map(
                  (s) => ChoiceChip(
                    label: Text(s),
                    selected: _size == s,
                    onSelected: (_) => setState(() => _size = s),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 12),
          const Text('Màu sắc', style: TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: widget.product.availableColors
                .map(
                  (c) => ChoiceChip(
                    label: Text(c),
                    selected: _color == c,
                    onSelected: (_) => setState(() => _color = c),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Text(
                'Số lượng',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              const Spacer(),
              IconButton(
                onPressed: _quantity > 1
                    ? () => setState(() => _quantity--)
                    : null,
                icon: const Icon(Icons.remove_circle_outline),
              ),
              Text(
                '$_quantity',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              IconButton(
                onPressed: _quantity < widget.product.quantity
                    ? () => setState(() => _quantity++)
                    : null,
                icon: const Icon(Icons.add_circle_outline),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: FilledButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  _VariationResult(
                    size: _size,
                    color: _color,
                    quantity: _quantity,
                  ),
                );
              },
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFE91E63),
              ),
              child: Text(widget.confirmLabel),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatMessage {
  final String text;
  final bool isUser;

  const _ChatMessage({required this.text, required this.isUser});
}

class _ProductChatSheet extends StatefulWidget {
  const _ProductChatSheet();

  @override
  State<_ProductChatSheet> createState() => _ProductChatSheetState();
}

class _ProductChatSheetState extends State<_ProductChatSheet> {
  final TextEditingController _textController = TextEditingController();
  final List<_ChatMessage> _messages = [
    const _ChatMessage(
      text: 'Shop xin chào. Bạn cần tư vấn size hay chất liệu sản phẩm?',
      isUser: false,
    ),
  ];

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(_ChatMessage(text: text, isUser: true));
      _messages.add(
        const _ChatMessage(
          text:
              'Shop đã nhận câu hỏi. Mình sẽ tư vấn size và màu phù hợp ngay cho bạn.',
          isUser: false,
        ),
      );
    });
    _textController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return AnimatedPadding(
      duration: const Duration(milliseconds: 200),
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.62,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Column(
              children: [
                const ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.symmetric(horizontal: 4),
                  title: Text(
                    'Tư vấn sản phẩm',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('Shop phản hồi trong vài phút'),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _messages.length,
                    itemBuilder: (_, index) {
                      final message = _messages[index];
                      return Align(
                        alignment: message.isUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          constraints: const BoxConstraints(maxWidth: 280),
                          decoration: BoxDecoration(
                            color: message.isUser
                                ? const Color(0xFFE91E63)
                                : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Text(
                            message.text,
                            style: TextStyle(
                              color: message.isUser
                                  ? Colors.white
                                  : Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _textController,
                        onSubmitted: (_) => _sendMessage(),
                        decoration: InputDecoration(
                          hintText: 'Nhập câu hỏi của bạn...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          isDense: true,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    FilledButton(
                      onPressed: _sendMessage,
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFFE91E63),
                      ),
                      child: const Icon(Icons.send_rounded),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
