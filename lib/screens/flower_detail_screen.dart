import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';

import '../constants/flower_colors.dart';
import '../models/cart_item.dart';
import '../models/flower_model.dart';
import '../services/cart_service.dart';
import '../services/order_service.dart';
import 'checkout_screen.dart';

class FlowerDetailScreen extends StatefulWidget {
  final Flower flower;

  const FlowerDetailScreen({super.key, required this.flower});

  @override
  State<FlowerDetailScreen> createState() => _FlowerDetailScreenState();
}

class _FlowerDetailScreenState extends State<FlowerDetailScreen> {
  static const _primaryPink = Color(0xFFE91E63);
  static final _priceFormat = NumberFormat('#,###', 'vi_VN');
  static const Map<String, List<String>> _galleryByFlower = {
    'Hoa Hồng': [
      'https://upload.wikimedia.org/wikipedia/commons/thumb/0/09/Pink_rose.jpg/800px-Pink_rose.jpg',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/f/f6/Rosa_hybrid_1.jpg/800px-Rosa_hybrid_1.jpg',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/8/86/Rose_yellowpink.jpg/800px-Rose_yellowpink.jpg',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/3/3f/Rose_Red_Flower.jpg/800px-Rose_Red_Flower.jpg',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e6/Rose_flower_3.jpg/800px-Rose_flower_3.jpg',
    ],
    'Hoa Tulip': [
      'https://upload.wikimedia.org/wikipedia/commons/thumb/6/60/Tulipa_sylvestris2.jpg/800px-Tulipa_sylvestris2.jpg',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d9/Red_tulip.jpg/800px-Red_tulip.jpg',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c8/Keukenhof_tulips.jpg/800px-Keukenhof_tulips.jpg',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/1/18/Tulips_in_bloom.jpg/800px-Tulips_in_bloom.jpg',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b8/Tulipa_suaveolens_floriade_to_canberra.jpg/800px-Tulipa_suaveolens_floriade_to_canberra.jpg',
    ],
    'Hoa Lan Hồ Điệp': [
      'https://upload.wikimedia.org/wikipedia/commons/thumb/d/da/Phalaenopsis_JPEG.png/800px-Phalaenopsis_JPEG.png',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/0/0e/Phalaenopsis_aphrodite_RCHB.f.jpg/800px-Phalaenopsis_aphrodite_RCHB.f.jpg',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e3/Orchidaceae_Phalaenopsis.jpg/800px-Orchidaceae_Phalaenopsis.jpg',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/2/20/Phalaenopsis_White.jpg/800px-Phalaenopsis_White.jpg',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c4/Phalaenopsis_orchid.jpg/800px-Phalaenopsis_orchid.jpg',
    ],
    'Hoa Cúc': [
      'https://upload.wikimedia.org/wikipedia/commons/thumb/8/89/Bushy_yellow_chrysanthemum.jpg/800px-Bushy_yellow_chrysanthemum.jpg',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2b/White_chrysanthemum.jpg/800px-White_chrysanthemum.jpg',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/3/35/Chrysanthemum_indicum.jpg/800px-Chrysanthemum_indicum.jpg',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/9/96/Yellow_daisy_like_chrysanthemum.jpg/800px-Yellow_daisy_like_chrysanthemum.jpg',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/7/70/Chrysanthemum_closeup.jpg/800px-Chrysanthemum_closeup.jpg',
    ],
    'Hoa Hướng Dương': [
      'https://upload.wikimedia.org/wikipedia/commons/thumb/4/40/Sunflower_sky_backdrop.jpg/800px-Sunflower_sky_backdrop.jpg',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/5/56/Helianthus_Annuus_-_Sunflower.jpg/800px-Helianthus_Annuus_-_Sunflower.jpg',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/3/3b/Sunflower_from_Silesia2.jpg/800px-Sunflower_from_Silesia2.jpg',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/f/f0/Close_up_of_sunflower.jpg/800px-Close_up_of_sunflower.jpg',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/0/04/Sunflowers_in_field.jpg/800px-Sunflowers_in_field.jpg',
    ],
    'Hoa Tú Cầu': [
      'https://upload.wikimedia.org/wikipedia/commons/thumb/5/53/Hydrangea_macrophylla_blue.jpg/800px-Hydrangea_macrophylla_blue.jpg',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/9/94/Hydrangea_flowers.jpg/800px-Hydrangea_flowers.jpg',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e9/Hydrangea_macrophylla_%27Mariesii%27.jpg/800px-Hydrangea_macrophylla_%27Mariesii%27.jpg',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2e/Hydrangea_pink.jpg/800px-Hydrangea_pink.jpg',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/7/76/Blue_hydrangea_closeup.jpg/800px-Blue_hydrangea_closeup.jpg',
    ],
    'Hoa Cẩm Chướng': [
      'https://upload.wikimedia.org/wikipedia/commons/thumb/b/bb/Dianthus_caryophyllus_001.JPG/800px-Dianthus_caryophyllus_001.JPG',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2c/Red_carnation.jpg/800px-Red_carnation.jpg',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/9/98/Pink_carnation.jpg/800px-Pink_carnation.jpg',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/3/35/White_carnation.jpg/800px-White_carnation.jpg',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e0/Carnation_bloom.jpg/800px-Carnation_bloom.jpg',
    ],
    'Hoa Lily': [
      'https://upload.wikimedia.org/wikipedia/commons/thumb/0/0c/Lilium_candidum_3.jpg/800px-Lilium_candidum_3.jpg',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/3/34/Lilium_bulbiferum.jpeg/800px-Lilium_bulbiferum.jpeg',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/8/86/Pink_lily.jpg/800px-Pink_lily.jpg',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/9/9c/Orange_lily.jpg/800px-Orange_lily.jpg',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/4/47/Lily_flower_closeup.jpg/800px-Lily_flower_closeup.jpg',
    ],
    'Hoa Mẫu Đơn': [
      'https://upload.wikimedia.org/wikipedia/commons/thumb/6/6c/Peony_3.jpg/800px-Peony_3.jpg',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/0/00/Peony_bloom.jpg/800px-Peony_bloom.jpg',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/6/69/Paeonia_lactiflora.jpg/800px-Paeonia_lactiflora.jpg',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e2/Pink_peony.jpg/800px-Pink_peony.jpg',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/4/4f/Peony_flower_closeup.jpg/800px-Peony_flower_closeup.jpg',
    ],
    'Hoa Oải Hương': [
      'https://upload.wikimedia.org/wikipedia/commons/thumb/4/49/Lavandula_angustifolia_002.JPG/800px-Lavandula_angustifolia_002.JPG',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/4/4e/Lavender_field.jpg/800px-Lavender_field.jpg',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/5/51/Lavender_closeup.jpg/800px-Lavender_closeup.jpg',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/f/f0/Lavandula_flowers.jpg/800px-Lavandula_flowers.jpg',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/8/8a/Lavender_in_Provence.jpg/800px-Lavender_in_Provence.jpg',
    ],
    'Hoa Đồng Tiền': [
      'https://upload.wikimedia.org/wikipedia/commons/thumb/4/43/Orange_gerbera.jpg/800px-Orange_gerbera.jpg',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a9/Gerbera_jamesonii.jpg/800px-Gerbera_jamesonii.jpg',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/6/63/Gerbera_pink.jpg/800px-Gerbera_pink.jpg',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e5/Red_gerbera.jpg/800px-Red_gerbera.jpg',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/7/7f/Gerbera_white.jpg/800px-Gerbera_white.jpg',
    ],
    'Hoa Thược Dược': [
      'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d9/Red_dahlia.jpg/800px-Red_dahlia.jpg',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/7/78/Orange_dahlia.jpg/800px-Orange_dahlia.jpg',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/9/91/Purple_dahlia.jpg/800px-Purple_dahlia.jpg',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/3/34/Dahlia_flower.jpg/800px-Dahlia_flower.jpg',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/1/17/Dahlia_closeup.jpg/800px-Dahlia_closeup.jpg',
    ],
    'Hoa Anh Đào': [
      'https://upload.wikimedia.org/wikipedia/commons/thumb/3/36/Cherry_blossoms_in_full_bloom.jpg/800px-Cherry_blossoms_in_full_bloom.jpg',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/8/8a/Cherry_blossom_tree.jpg/800px-Cherry_blossom_tree.jpg',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/0/07/Sakura_at_Night.jpg/800px-Sakura_at_Night.jpg',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2d/Cherry_blossom_closeup.jpg/800px-Cherry_blossom_closeup.jpg',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/4/44/Cherry_blossom_branch.jpg/800px-Cherry_blossom_branch.jpg',
    ],
    'Hoa Sen': [
      'https://upload.wikimedia.org/wikipedia/commons/thumb/3/35/Lotus_flower.jpg/800px-Lotus_flower.jpg',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/5/5d/White_lotus.jpg/800px-White_lotus.jpg',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/7/7d/Lotus_bud.jpg/800px-Lotus_bud.jpg',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/f/f2/Pink_lotus_flower.jpg/800px-Pink_lotus_flower.jpg',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/4/41/Lotus_pond.jpg/800px-Lotus_pond.jpg',
    ],
    'Hoa Sứ': [
      'https://upload.wikimedia.org/wikipedia/commons/thumb/b/bf/Plumeria_rubra_2.jpg/800px-Plumeria_rubra_2.jpg',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e0/Plumeria_alba.jpg/800px-Plumeria_alba.jpg',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/2/28/Plumeria_flowers.jpg/800px-Plumeria_flowers.jpg',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/1/16/Plumeria_closeup.jpg/800px-Plumeria_closeup.jpg',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/9/99/Frangipani_tree.jpg/800px-Frangipani_tree.jpg',
    ],
    'Hoa Hải Đường': [
      'https://upload.wikimedia.org/wikipedia/commons/thumb/6/6d/Camellia_japonica_2.jpg/800px-Camellia_japonica_2.jpg',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/0/05/Camellia_japonica_red.jpg/800px-Camellia_japonica_red.jpg',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/5/57/Camellia_white.jpg/800px-Camellia_white.jpg',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/0/0f/Camellia_closeup.jpg/800px-Camellia_closeup.jpg',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/4/49/Camellia_bloom.jpg/800px-Camellia_bloom.jpg',
    ],
    'Hoa Iris': [
      'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c8/Iris_germanica_01.JPG/800px-Iris_germanica_01.JPG',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e4/Iris_flower.jpg/800px-Iris_flower.jpg',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/5/59/Blue_iris_closeup.jpg/800px-Blue_iris_closeup.jpg',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/3/37/Iris_petals.jpg/800px-Iris_petals.jpg',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Purple_iris.jpg/800px-Purple_iris.jpg',
    ],
    'Hoa Cúc Vạn Thọ': [
      'https://upload.wikimedia.org/wikipedia/commons/thumb/7/7d/Tagetes_erecta0.jpg/800px-Tagetes_erecta0.jpg',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/5/5c/Orange_marigold.jpg/800px-Orange_marigold.jpg',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/0/08/Marigold_bloom.jpg/800px-Marigold_bloom.jpg',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/f/f6/Yellow_marigold.jpg/800px-Yellow_marigold.jpg',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/3/39/Tagetes_closeup.jpg/800px-Tagetes_closeup.jpg',
    ],
    'Hoa Bỉ Ngạn': [
      'https://upload.wikimedia.org/wikipedia/commons/thumb/5/59/Lycoris_radiata_001.jpg/800px-Lycoris_radiata_001.jpg',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/1/17/Lycoris_radiata_2.jpg/800px-Lycoris_radiata_2.jpg',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/3/3f/Lycoris_red_flower.jpg/800px-Lycoris_red_flower.jpg',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/c/cd/Lycoris_cluster.jpg/800px-Lycoris_cluster.jpg',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2c/Lycoris_closeup.jpg/800px-Lycoris_closeup.jpg',
    ],
    'Hoa Trạng Nguyên': [
      'https://upload.wikimedia.org/wikipedia/commons/thumb/8/89/Poinsettia.jpg/800px-Poinsettia.jpg',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/5/54/Poinsettia_red_leaves.jpg/800px-Poinsettia_red_leaves.jpg',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/1/1a/Poinsettia_closeup.jpg/800px-Poinsettia_closeup.jpg',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/4/43/Poinsettia_white.jpg/800px-Poinsettia_white.jpg',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/6/6a/Poinsettia_plant.jpg/800px-Poinsettia_plant.jpg',
    ],
  };

  final _cart = CartService.instance;
  final _pageController = PageController();
  Timer? _autoSlideTimer;
  Timer? _resumeAutoSlideTimer;

  int _currentImageIndex = 0;
  bool _isDescriptionExpanded = false;
  late _SelectedVariation _selection;

  Flower get _flower => widget.flower;

  List<String> get _availableSizes => const ['S', 'M', 'L'];

  List<String> get _availableColors {
    switch (_flower.color) {
      case 'Vàng':
        return const ['Vàng', 'Cam', 'Vàng kem'];
      case 'Hồng':
        return const ['Hồng', 'Đỏ', 'Kem'];
      case 'Đỏ':
        return const ['Đỏ', 'Hồng đậm', 'Kem'];
      case 'Trắng':
        return const ['Trắng', 'Kem', 'Xanh'];
      default:
        return [_flower.color, 'Đỏ', 'Xanh'];
    }
  }

  List<String> get _galleryImages {
    final gallery = <String>[];

    if (_flower.image.isNotEmpty) {
      gallery.add(_flower.image);
    }

    final extras = _galleryByFlower[_flower.name] ?? const <String>[];
    for (final imageUrl in extras) {
      if (imageUrl != _flower.image && !gallery.contains(imageUrl)) {
        gallery.add(imageUrl);
      }
      if (gallery.length == 6) {
        break;
      }
    }

    if (gallery.isEmpty) {
      return const [];
    }

    return gallery;
  }

  String _formatPrice(double price) {
    return '${_priceFormat.format(price.toInt())}đ';
  }

  String get _selectedSummary =>
      'Đã chọn: Size ${_selection.size}, màu ${_selection.color}, SL ${_selection.quantity}';

  @override
  void initState() {
    super.initState();
    _selection = _SelectedVariation(
      size: _availableSizes.first,
      color: _availableColors.first,
      quantity: 1,
    );
    _startAutoSlide();
  }

  @override
  void dispose() {
    _autoSlideTimer?.cancel();
    _resumeAutoSlideTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoSlide() {
    _autoSlideTimer?.cancel();

    if (_galleryImages.length <= 1) {
      return;
    }

    _autoSlideTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!_pageController.hasClients || !mounted) {
        return;
      }

      final nextPage = (_currentImageIndex + 1) % _galleryImages.length;
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeInOut,
      );
    });
  }

  void _pauseAutoSlide() {
    _autoSlideTimer?.cancel();
    _resumeAutoSlideTimer?.cancel();
  }

  void _resumeAutoSlideWithDelay() {
    _pauseAutoSlide();
    _resumeAutoSlideTimer = Timer(const Duration(seconds: 4), () {
      if (!mounted) {
        return;
      }
      _startAutoSlide();
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  Future<void> _openChatSheet() async {
    _pauseAutoSlide();
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      builder: (context) => _ChatBottomSheet(
        flower: _flower,
        formatPrice: _formatPrice,
      ),
    );
    if (mounted) {
      _resumeAutoSlideWithDelay();
    }
  }

  Future<void> _openVariationSheet({required bool buyNow}) async {
    final result = await showModalBottomSheet<_SelectedVariation>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      builder: (context) {
        return _VariationBottomSheet(
          flower: _flower,
          initialSelection: _selection,
          sizes: _availableSizes,
          colors: _availableColors,
          formatPrice: _formatPrice,
          confirmLabel: buyNow ? 'Xác nhận mua ngay' : 'Xác nhận',
        );
      },
    );

    if (!mounted || result == null) {
      return;
    }

    setState(() {
      _selection = result;
    });

    if (buyNow) {
      await _handleBuyNow(result);
      return;
    }

    _cart.addToCartWithQuantity(_flower, result.quantity);
    _showSnackBar('Thêm thành công');
  }

  Future<void> _handleBuyNow(_SelectedVariation selection) async {
    final result = await Navigator.push<CheckoutResult>(
      context,
      MaterialPageRoute(
        builder: (_) => CheckoutScreen(
          selectedItems: [
            CartItem(flower: _flower, quantity: selection.quantity),
          ],
        ),
      ),
    );

    if (!mounted || result == null) {
      return;
    }

    OrderService.instance.addOrder(result.order);
    _showSnackBar('Đặt hàng thành công');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final flowerColor = FlowerColors.getColor(_flower.color);
    final accentColor = FlowerColors.getAccentColor(_flower.color);
    final hasDiscount = _flower.discountPercent > 0;
    final galleryImages = _galleryImages;
    final screenHeight = MediaQuery.of(context).size.height;
    final topHeight = screenHeight * 0.33;
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      body: Stack(
        children: [
          Container(
            height: topHeight,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  flowerColor.withValues(alpha: 0.92),
                  flowerColor.withValues(alpha: 0.76),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: Colors.transparent,
                pinned: true,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  color: Colors.white,
                  onPressed: () => Navigator.pop(context),
                ),
                actions: [
                  ValueListenableBuilder<List<CartItem>>(
                    valueListenable: _cart.items,
                    builder: (_, __, ___) => IconButton(
                      onPressed: () =>
                          _showSnackBar('Giỏ hàng hiện có ${_cart.totalItems} sản phẩm'),
                      icon: Badge(
                        isLabelVisible: _cart.totalItems > 0,
                        backgroundColor: const Color(0xFFB71C1C),
                        label: Text('${_cart.totalItems}'),
                        child: const Icon(
                          Icons.shopping_cart_outlined,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.favorite_border, color: Colors.white),
                    onPressed: () => _showSnackBar('Đã thêm vào yêu thích'),
                  ),
                  IconButton(
                    icon: const Icon(Icons.share_outlined, color: Colors.white),
                    onPressed: () => _showSnackBar('Chức năng đang phát triển'),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                      child: Column(
                        children: [
                          _buildImageGallery(
                            galleryImages: galleryImages,
                            flowerColor: flowerColor,
                          ),
                          const SizedBox(height: 10),
                          _buildThumbnailStrip(
                            galleryImages: galleryImages,
                            flowerColor: flowerColor,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF7F8FC),
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(32),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                          20,
                          24,
                          20,
                          140 + bottomInset,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: flowerColor.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                _flower.category,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: accentColor,
                                ),
                              ),
                            ),
                            const SizedBox(height: 18),
                            _buildPriceCard(hasDiscount: hasDiscount),
                            const SizedBox(height: 18),
                            _buildVariationTile(),
                            const SizedBox(height: 18),
                            _buildDescriptionCard(),
                            const SizedBox(height: 18),
                            _buildExtraInfoTable(),
                            const SizedBox(height: 18),
                            _buildReviewCard(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.fromLTRB(16, 12, 16, 16 + bottomInset),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          children: [
            SizedBox(
              width: 70,
              child: SizedBox(
                height: 58,
                child: _BottomIconAction(
                  icon: Icons.chat_bubble_outline_rounded,
                  label: 'Chat',
                  onTap: _openChatSheet,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Row(
                children: [
                  Flexible(
                    flex: 6,
                    child: SizedBox(
                      height: 56,
                      child: OutlinedButton(
                        onPressed: () => _openVariationSheet(buyNow: false),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: _primaryPink,
                          backgroundColor: Colors.white,
                          side: const BorderSide(color: Color(0xFFE91E63)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_shopping_cart_rounded, size: 20),
                            SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                'Thêm vào\ngiỏ hàng',
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  height: 1.05,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Flexible(
                    flex: 5,
                    child: SizedBox(
                      height: 56,
                      child: FilledButton(
                        onPressed: () => _openVariationSheet(buyNow: true),
                        style: FilledButton.styleFrom(
                          backgroundColor: _primaryPink,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Mua ngay',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageGallery({
    required List<String> galleryImages,
    required Color flowerColor,
  }) {
    final itemCount = galleryImages.isEmpty ? 1 : galleryImages.length;

    return Column(
      children: [
        SizedBox(
          height: 242,
          child: GestureDetector(
            onPanDown: (_) => _pauseAutoSlide(),
            onPanCancel: _resumeAutoSlideWithDelay,
            onPanEnd: (_) => _resumeAutoSlideWithDelay(),
            child: Stack(
              children: [
                PageView.builder(
                  controller: _pageController,
                  itemCount: itemCount,
                  onPageChanged: (index) {
                    setState(() {
                      _currentImageIndex = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    final imageUrl = galleryImages.isEmpty ? '' : galleryImages[index];
                    final image = ClipRRect(
                      borderRadius: BorderRadius.circular(34),
                      child: _buildImage(imageUrl, flowerColor),
                    );

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: index == 0
                          ? Hero(tag: 'flower_${_flower.id}', child: image)
                          : image,
                    );
                  },
                ),
                Positioned(
                  left: 16,
                  bottom: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.28),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${_currentImageIndex + 1}/$itemCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(itemCount, (index) {
            final isActive = index == _currentImageIndex;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: isActive ? 30 : 10,
              height: 10,
              decoration: BoxDecoration(
                color: isActive
                    ? Colors.white
                    : Colors.white.withValues(alpha: 0.45),
                borderRadius: BorderRadius.circular(999),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildThumbnailStrip({
    required List<String> galleryImages,
    required Color flowerColor,
  }) {
    final items = galleryImages.isEmpty ? [''] : galleryImages;

    return SizedBox(
      height: 66,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final isSelected = index == _currentImageIndex;
          return GestureDetector(
            onTap: () {
              _pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 260),
                curve: Curves.easeOut,
              );
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 86,
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? Colors.white : Colors.transparent,
                  width: 2.5,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.16),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ]
                    : null,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: _buildImage(items[index], flowerColor),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPriceCard({required bool hasDiscount}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _flower.name,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 22),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      _formatPrice(_flower.price),
                      style: const TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w900,
                        color: Colors.red,
                      ),
                    ),
                    if (hasDiscount)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          _formatPrice(_flower.originalPrice),
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.grey.shade500,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3F5),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Text(
                  'Đã bán ${_flower.quantity * 8 + 45}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
            ],
          ),
          if (hasDiscount) ...[
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF4F2),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Text(
                'Giảm ${_flower.discountPercent}% so với giá gốc',
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildVariationTile() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () => _openVariationSheet(buyNow: false),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Chọn kích cỡ, màu sắc',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _selectedSummary,
                    style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(Icons.chevron_right_rounded, size: 30),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDescriptionCard() {
    final fullDescription =
        '${_flower.description}. Bó hoa được tuyển chọn kỹ, giữ form đẹp, phù hợp làm quà tặng và trang trí không gian. '
        'Màu sắc và kích cỡ có thể thay đổi theo lựa chọn của bạn trong phần phân loại.';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Mô tả chi tiết',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 16),
          AnimatedCrossFade(
            firstChild: Text(
              fullDescription,
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 15,
                height: 1.7,
                color: Colors.grey.shade700,
              ),
            ),
            secondChild: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 15,
                  height: 1.7,
                  color: Colors.grey.shade700,
                ),
                children: [
                  TextSpan(text: fullDescription),
                  const TextSpan(text: '\n\n'),
                  TextSpan(
                    text:
                        'Thiết kế mang phong cách hiện đại, thích hợp tặng sinh nhật, khai trương hoặc trang trí bàn làm việc.',
                    style: TextStyle(
                      color: Colors.grey.shade800,
                    ),
                  ),
                ],
              ),
            ),
            crossFadeState: _isDescriptionExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 220),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: () {
                setState(() {
                  _isDescriptionExpanded = !_isDescriptionExpanded;
                });
              },
              style: TextButton.styleFrom(
                foregroundColor: _primaryPink,
                padding: const EdgeInsets.symmetric(horizontal: 4),
              ),
              child: Text(
                _isDescriptionExpanded ? 'Thu gọn' : 'Xem thêm',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExtraInfoTable() {
    final rows = <(String, String)>[
      ('Mã sản phẩm', '#${_flower.id}'),
      ('Danh mục', _flower.category),
      ('Giá hiện tại', _formatPrice(_flower.price)),
      ('Xuất xứ', _flower.category == 'HOA NHẬP KHẨU' ? 'Nhập khẩu' : 'Trong nước'),
      ('Bảo quản', 'Nơi khô ráo, thoáng mát'),
      ('Kích cỡ có sẵn', _availableSizes.join(', ')),
      ('Màu sắc', _availableColors.join(', ')),
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Thông tin bổ sung',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 18),
          Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: const Color(0xFFFFE3EA)),
            ),
            child: Column(
              children: List.generate(rows.length, (index) {
                final row = rows[index];
                return Container(
                  decoration: BoxDecoration(
                    border: index == rows.length - 1
                        ? null
                        : const Border(
                            bottom: BorderSide(
                              color: Color(0xFFFFE8ED),
                              width: 1,
                            ),
                          ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: index.isEven
                                ? const Color(0xFFFFFAFB)
                                : const Color(0xFFFFF4F7),
                          ),
                          child: Text(
                            row.$1,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            row.$2,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard() {
    final bars = <(String, double, int)>[
      ('5*', 0.72, 1),
      ('4*', 0.52, 1),
      ('3*', 0.0, 0),
      ('2*', 0.0, 0),
      ('1*', 0.0, 0),
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.star_rounded, color: Colors.amber),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Đánh giá sản phẩm',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                ),
              ),
              const Text(
                '4.5 / 5',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFFE2834A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 6),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFBF7),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Column(
              children: bars.map((bar) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 28,
                        child: Text(
                          bar.$1,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(999),
                          child: LinearProgressIndicator(
                            value: bar.$2,
                            minHeight: 10,
                            backgroundColor: const Color(0xFFF0ECE7),
                            valueColor: const AlwaysStoppedAnimation(
                              Color(0xFFE2834A),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      SizedBox(
                        width: 12,
                        child: Text(
                          '${bar.$3}',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 22),
          Row(
            children: [
              Text(
                'Sắp xếp:',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Mới nhất',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.arrow_drop_down_rounded, size: 22),
            ],
          ),
          const SizedBox(height: 16),
          const Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _ReviewFilterChip(label: 'Tất cả', selected: true),
              _ReviewFilterChip(label: '1 sao'),
              _ReviewFilterChip(label: '2 sao'),
              _ReviewFilterChip(label: '3 sao'),
              _ReviewFilterChip(label: '4 sao'),
              _ReviewFilterChip(label: '5 sao'),
            ],
          ),
          const SizedBox(height: 22),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFFFE8ED)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Text(
                      'Minh Anh',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(width: 10),
                    Icon(Icons.star, size: 18, color: Colors.amber),
                    Icon(Icons.star, size: 18, color: Colors.amber),
                    Icon(Icons.star, size: 18, color: Colors.amber),
                    Icon(Icons.star, size: 18, color: Colors.amber),
                    Icon(Icons.star, size: 18, color: Colors.amber),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  '${_flower.name} lên form đẹp, màu sắc đúng mô tả và đóng gói rất cẩn thận.',
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.6,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: SizedBox(
                    width: 96,
                    height: 96,
                    child: _flower.image.isNotEmpty
                        ? Image.network(
                            _flower.image,
                            fit: BoxFit.cover,
                            color: Colors.black.withValues(alpha: 0.28),
                            colorBlendMode: BlendMode.saturation,
                            errorBuilder: (_, __, ___) => Container(
                              color: Colors.grey.shade200,
                              child: const Icon(Icons.image_outlined),
                            ),
                          )
                        : Container(
                            color: Colors.grey.shade200,
                            child: const Icon(Icons.image_outlined),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(28),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.035),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
      ],
    );
  }

  Widget _buildImage(String imageUrl, Color flowerColor) {
    if (imageUrl.isEmpty) {
      return Container(
        color: Colors.white.withValues(alpha: 0.24),
        child: Center(
          child: Icon(Icons.local_florist, size: 88, color: flowerColor),
        ),
      );
    }

    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      width: double.infinity,
      errorBuilder: (_, __, ___) => Container(
        color: Colors.white.withValues(alpha: 0.24),
        child: Center(
          child: Icon(Icons.local_florist, size: 88, color: flowerColor),
        ),
      ),
      loadingBuilder: (_, child, progress) {
        if (progress == null) {
          return child;
        }
        return Container(
          color: Colors.white.withValues(alpha: 0.22),
          child: Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation(flowerColor),
            ),
          ),
        );
      },
    );
  }
}

class _SelectedVariation {
  final String size;
  final String color;
  final int quantity;

  const _SelectedVariation({
    required this.size,
    required this.color,
    required this.quantity,
  });

  _SelectedVariation copyWith({
    String? size,
    String? color,
    int? quantity,
  }) {
    return _SelectedVariation(
      size: size ?? this.size,
      color: color ?? this.color,
      quantity: quantity ?? this.quantity,
    );
  }
}

class _BottomIconAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final int badgeCount;
  final VoidCallback onTap;

  const _BottomIconAction({
    required this.icon,
    required this.label,
    required this.onTap,
    this.badgeCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Badge(
              isLabelVisible: badgeCount > 0,
              label: Text('$badgeCount'),
              child: Icon(icon, size: 25, color: const Color(0xFF2A2A2A)),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReviewFilterChip extends StatelessWidget {
  final String label;
  final bool selected;

  const _ReviewFilterChip({
    required this.label,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: selected ? const Color(0xFFFFE8DD) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: selected ? const Color(0xFFF0C5B1) : const Color(0xFFE8DDD6),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: selected ? const Color(0xFF8C5A42) : const Color(0xFF4A4541),
        ),
      ),
    );
  }
}

class _VariationBottomSheet extends StatefulWidget {
  final Flower flower;
  final _SelectedVariation initialSelection;
  final List<String> sizes;
  final List<String> colors;
  final String Function(double price) formatPrice;
  final String confirmLabel;

  const _VariationBottomSheet({
    required this.flower,
    required this.initialSelection,
    required this.sizes,
    required this.colors,
    required this.formatPrice,
    required this.confirmLabel,
  });

  @override
  State<_VariationBottomSheet> createState() => _VariationBottomSheetState();
}

class _VariationBottomSheetState extends State<_VariationBottomSheet> {
  late _SelectedVariation _draft;

  @override
  void initState() {
    super.initState();
    _draft = widget.initialSelection;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 12,
        right: 12,
        bottom: MediaQuery.of(context).viewInsets.bottom + 12,
      ),
      child: Container(
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(34)),
        ),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 64,
                    height: 6,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: SizedBox(
                        width: 92,
                        height: 92,
                        child: widget.flower.image.isNotEmpty
                            ? Image.network(
                                widget.flower.image,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  color: Colors.pink.shade50,
                                  child: const Icon(
                                    Icons.local_florist,
                                    color: Color(0xFFE91E63),
                                  ),
                                ),
                              )
                            : Container(
                                color: Colors.pink.shade50,
                                child: const Icon(
                                  Icons.local_florist,
                                  color: Color(0xFFE91E63),
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.flower.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.formatPrice(widget.flower.price),
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              color: Colors.red,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Đã chọn: Size ${_draft.size}, màu ${_draft.color}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Text(
                  'Chọn kích cỡ',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: widget.sizes.map((size) {
                    return _ChoiceChipButton(
                      label: size,
                      selected: size == _draft.size,
                      onTap: () {
                        setState(() {
                          _draft = _draft.copyWith(size: size);
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 22),
                const Text(
                  'Chọn màu sắc',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: widget.colors.map((color) {
                    return _ChoiceChipButton(
                      label: color,
                      selected: color == _draft.color,
                      onTap: () {
                        setState(() {
                          _draft = _draft.copyWith(color: color);
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 26),
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Số lượng',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    _QuantityCircleButton(
                      icon: Icons.remove,
                      enabled: _draft.quantity > 1,
                      onTap: () {
                        if (_draft.quantity <= 1) {
                          return;
                        }
                        setState(() {
                          _draft = _draft.copyWith(quantity: _draft.quantity - 1);
                        });
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: Text(
                        '${_draft.quantity}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    _QuantityCircleButton(
                      icon: Icons.add,
                      enabled: true,
                      onTap: () {
                        setState(() {
                          _draft = _draft.copyWith(quantity: _draft.quantity + 1);
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: FilledButton(
                    onPressed: () => Navigator.pop(context, _draft),
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFFE91E63),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: Text(
                      widget.confirmLabel,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ChatMessage {
  final String text;
  final bool fromUser;

  const _ChatMessage({
    required this.text,
    required this.fromUser,
  });
}

class _QuickQuestion {
  final String question;
  final String answer;

  const _QuickQuestion({
    required this.question,
    required this.answer,
  });
}

class _ChatBottomSheet extends StatefulWidget {
  final Flower flower;
  final String Function(double price) formatPrice;

  const _ChatBottomSheet({
    required this.flower,
    required this.formatPrice,
  });

  @override
  State<_ChatBottomSheet> createState() => _ChatBottomSheetState();
}

class _ChatBottomSheetState extends State<_ChatBottomSheet> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final List<_ChatMessage> _messages = [];

  late final List<_QuickQuestion> _quickQuestions;

  @override
  void initState() {
    super.initState();
    _quickQuestions = [
      _QuickQuestion(
        question: 'Sản phẩm có còn hàng không?',
        answer:
            'Dạ ${widget.flower.name} hiện còn hàng ạ. Shop đang có khoảng ${widget.flower.quantity} sản phẩm sẵn kho.',
      ),
      _QuickQuestion(
        question: 'Sản phẩm có giá bao nhiêu?',
        answer:
            'Dạ sản phẩm này hiện có giá ${widget.formatPrice(widget.flower.price)} ạ.',
      ),
      _QuickQuestion(
        question: 'Sản phẩm có giao nhanh không?',
        answer:
            'Dạ shop có hỗ trợ giao nhanh trong ngày tại nội thành, thường từ 2-4 giờ tùy khu vực ạ.',
      ),
      _QuickQuestion(
        question: 'Sản phẩm có được kiểm hàng không?',
        answer:
            'Dạ bên em hỗ trợ kiểm tra mẫu hoa trước khi nhận hàng và gửi ảnh xác nhận nếu mình cần ạ.',
      ),
    ];
    _messages.add(
      _ChatMessage(
        text: 'Xin chào, shop có thể hỗ trợ gì cho bạn về sản phẩm này?',
        fromUser: false,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendQuickQuestion(_QuickQuestion item) async {
    setState(() {
      _messages.add(_ChatMessage(text: item.question, fromUser: true));
    });
    _scrollToBottom();

    await Future.delayed(const Duration(milliseconds: 450));
    if (!mounted) {
      return;
    }

    setState(() {
      _messages.add(_ChatMessage(text: item.answer, fromUser: false));
    });
    _scrollToBottom();
  }

  Future<void> _sendManualMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) {
      return;
    }

    setState(() {
      _messages.add(_ChatMessage(text: text, fromUser: true));
      _controller.clear();
    });
    _scrollToBottom();

    await Future.delayed(const Duration(milliseconds: 450));
    if (!mounted) {
      return;
    }

    setState(() {
      _messages.add(
        _ChatMessage(
          text:
              'Shop đã nhận tin nhắn "${text.length > 30 ? '${text.substring(0, 30)}...' : text}". Bên em sẽ phản hồi chi tiết ngay cho mình ạ.',
          fromUser: false,
        ),
      );
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) {
        return;
      }
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 120,
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(
        left: 14,
        right: 14,
        bottom: bottomInset + 14,
      ),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 18),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF7FA),
          borderRadius: BorderRadius.circular(34),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.14),
              blurRadius: 30,
              offset: const Offset(0, 16),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              Container(
                width: 76,
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFE1EA),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Icon(
                      Icons.storefront_rounded,
                      color: Color(0xFFB35A76),
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Chat với shop',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF9B5367),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Hỏi nhanh về: ${widget.flower.name}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Expanded(
                child: ListView(
                  controller: _scrollController,
                  children: [
                    ..._quickQuestions.map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () => _sendQuickQuestion(item),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            child: Text(
                              item.question,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF9B5367),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    ..._messages.map(_buildMessageBubble),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: const Color(0xFFF3C5D4)),
                      ),
                      child: TextField(
                        controller: _controller,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) => _sendManualMessage(),
                        decoration: const InputDecoration(
                          hintText: 'Nhập tin nhắn cho shop',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 56,
                    height: 56,
                    child: FilledButton(
                      onPressed: _sendManualMessage,
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFFB35A76),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: const Icon(Icons.send_rounded, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageBubble(_ChatMessage message) {
    final isUser = message.fromUser;

    return Padding(
      padding: EdgeInsets.only(
        left: isUser ? 54 : 0,
        right: isUser ? 0 : 54,
        bottom: 14,
      ),
      child: Align(
        alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: isUser ? const Color(0xFFB35A76) : Colors.white,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Text(
            message.text,
            style: TextStyle(
              fontSize: 15,
              height: 1.5,
              color: isUser ? Colors.white : const Color(0xFF2A2A2A),
            ),
          ),
        ),
      ),
    );
  }
}

class _ChoiceChipButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ChoiceChipButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFFFEFF5) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? const Color(0xFFE91E63) : Colors.grey.shade300,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: selected ? const Color(0xFFE91E63) : const Color(0xFF2A2A2A),
          ),
        ),
      ),
    );
  }
}

class _QuantityCircleButton extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  const _QuantityCircleButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: enabled ? onTap : null,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Icon(
          icon,
          color: enabled ? const Color(0xFFE91E63) : Colors.grey.shade400,
        ),
      ),
    );
  }
}
