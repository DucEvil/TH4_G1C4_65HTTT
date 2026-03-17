import 'dart:async';

import 'package:flutter/material.dart';
import '../models/flower_model.dart';
import '../services/flower_service.dart';
import '../services/cart_service.dart';
import '../services/favorite_service.dart';
import '../widgets/flower_card.dart';
import '../widgets/error_widget.dart';
import '../screens/flower_detail_screen.dart';
import '../screens/flower_search_delegate.dart';
import '../screens/cart_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const String _allCategory = 'Tất cả';

  late Future<List<Flower>> _flowersFuture;
  int _currentIndex = 0;
  String _selectedCategory = _allCategory;
  List<Flower> _loadedFlowers = [];
  int _currentBanner = 0;
  bool _searchBarElevated = false;

  final ScrollController _scrollController = ScrollController();
  final PageController _bannerController = PageController(
    viewportFraction: 0.92,
  );
  Timer? _bannerTimer;

  final List<_BannerItem> _banners = const [
    _BannerItem(
      title: 'Flash Sale 3h',
      subtitle: 'Giảm đến 50% cho bó hoa sinh nhật',
      badge: 'Siêu ưu đãi',
      icon: Icons.local_offer,
      colors: [Color(0xFFE75A7C), Color(0xFFF48FB1)],
    ),
    _BannerItem(
      title: 'FreeShip Toàn Quốc',
      subtitle: 'Đơn từ 149.000đ, giao nhanh trong ngày',
      badge: 'Freeship',
      icon: Icons.local_shipping,
      colors: [Color(0xFF1E88E5), Color(0xFF64B5F6)],
    ),
    _BannerItem(
      title: 'Mall Chính Hãng',
      subtitle: 'Hoa nhập khẩu cao cấp, kiểm định chất lượng',
      badge: 'Mall',
      icon: Icons.verified,
      colors: [Color(0xFF00897B), Color(0xFF4DB6AC)],
    ),
    _BannerItem(
      title: 'Deal Theo Mùa',
      subtitle: 'Combo quà tặng + thiệp, giảm thêm 15%',
      badge: 'Hot deal',
      icon: Icons.celebration,
      colors: [Color(0xFFFF7043), Color(0xFFFFAB91)],
    ),
  ];

  final List<_HomeCategoryItem> _homeCategories = const [
    _HomeCategoryItem(
      label: 'Tất cả',
      icon: Icons.grid_view_rounded,
      color: Color(0xFFE91E63),
      filterKey: 'Tất cả',
    ),
    _HomeCategoryItem(
      label: 'Hoa tươi',
      icon: Icons.local_florist_rounded,
      color: Color(0xFF43A047),
      filterKey: 'HOA TƯƠI',
    ),
    _HomeCategoryItem(
      label: 'Nhập khẩu',
      icon: Icons.flight_takeoff_rounded,
      color: Color(0xFF5E35B1),
      filterKey: 'HOA NHẬP KHẨU',
    ),
    _HomeCategoryItem(
      label: 'Giỏ quà',
      icon: Icons.card_giftcard_rounded,
      color: Color(0xFFF4511E),
      filterKey: 'GIO_QUA',
    ),
    _HomeCategoryItem(
      label: 'Mỹ phẩm',
      icon: Icons.spa_rounded,
      color: Color(0xFF00897B),
      filterKey: 'MY_PHAM',
    ),
    _HomeCategoryItem(
      label: 'Điện thoại',
      icon: Icons.smartphone_rounded,
      color: Color(0xFF1E88E5),
      filterKey: 'DIEN_THOAI',
    ),
    _HomeCategoryItem(
      label: 'Nhà cửa',
      icon: Icons.chair_rounded,
      color: Color(0xFF6D4C41),
      filterKey: 'NHA_CUA',
    ),
    _HomeCategoryItem(
      label: 'Voucher',
      icon: Icons.confirmation_number_rounded,
      color: Color(0xFFFF8F00),
      filterKey: 'VOUCHER',
    ),
  ];

  final _cart = CartService.instance;
  final _favorite = FavoriteService.instance;

  @override
  void initState() {
    super.initState();
    _loadFlowers();
    _startBannerAutoPlay();
    _scrollController.addListener(_onScroll);
    _cart.items.addListener(_onCartChanged);
    _favorite.favoriteIds.addListener(_onFavoriteChanged);
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _bannerController.dispose();
    _cart.items.removeListener(_onCartChanged);
    _favorite.favoriteIds.removeListener(_onFavoriteChanged);
    super.dispose();
  }

  void _onCartChanged() {
    setState(() {});
  }

  void _onFavoriteChanged() {
    setState(() {});
  }

  void _onScroll() {
    final shouldElevate = _scrollController.offset > 16;
    if (shouldElevate != _searchBarElevated) {
      setState(() {
        _searchBarElevated = shouldElevate;
      });
    }
  }

  void _startBannerAutoPlay() {
    _bannerTimer?.cancel();
    _bannerTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!_bannerController.hasClients || _banners.isEmpty) return;
      final nextPage = (_currentBanner + 1) % _banners.length;
      _bannerController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeOut,
      );
    });
  }

  void _loadFlowers() {
    setState(() {
      _flowersFuture = FlowerService.fetchFlowers();
    });
  }

  Future<void> _refreshFlowers() async {
    final future = FlowerService.fetchFlowers();
    setState(() {
      _flowersFuture = future;
    });
    await future;
  }

  List<Flower> _filterByCategory(List<Flower> flowers, String category) {
    if (category == _allCategory) return flowers;
    return flowers
        .where((flower) => _matchesCategory(flower, category))
        .toList();
  }

  bool _matchesCategory(Flower flower, String categoryKey) {
    switch (categoryKey) {
      case 'HOA TƯƠI':
      case 'HOA NHẬP KHẨU':
        return flower.category == categoryKey;
      case 'GIO_QUA':
        return flower.price >= 80000 && flower.discountPercent >= 10;
      case 'MY_PHAM':
        return flower.color == 'Hồng' ||
            flower.color == 'Trắng' ||
            flower.color == 'Tím' ||
            flower.color == 'Tím nhạt';
      case 'DIEN_THOAI':
        return flower.price >= 120000;
      case 'NHA_CUA':
        return flower.quantity >= 80;
      case 'VOUCHER':
        return flower.discountPercent > 0;
      default:
        return true;
    }
  }

  Future<void> _toggleFavorite(Flower flower) async {
    final isNowFavorite = await _favorite.toggleFavorite(flower.id);
    if (!mounted) return;
    _showSnackBar(
      isNowFavorite
          ? 'Đã thêm ${flower.name} vào yêu thích'
          : 'Đã bỏ ${flower.name} khỏi yêu thích',
    );
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: _currentIndex == 0
          ? _buildShopBody(primaryColor, theme)
          : _currentIndex == 1
          ? _buildCategoryBody(primaryColor, theme)
          : _currentIndex == 2
          ? const CartScreen()
          : _currentIndex == 3
          ? _buildFavoriteBody(primaryColor, theme)
          : _buildPlaceholderPage(_getPageInfo(_currentIndex)),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() => _currentIndex = index);
        },
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Trang chủ',
          ),
          const NavigationDestination(
            icon: Icon(Icons.category_outlined),
            selectedIcon: Icon(Icons.category),
            label: 'Danh mục',
          ),
          NavigationDestination(
            icon: Badge(
              isLabelVisible: _cart.totalItems > 0,
              label: Text('${_cart.totalItems}'),
              child: const Icon(Icons.shopping_cart_outlined),
            ),
            selectedIcon: Badge(
              isLabelVisible: _cart.totalItems > 0,
              label: Text('${_cart.totalItems}'),
              child: const Icon(Icons.shopping_cart),
            ),
            label: 'Giỏ hàng',
          ),
          NavigationDestination(
            icon: Badge(
              isLabelVisible: _favorite.totalFavorites > 0,
              label: Text('${_favorite.totalFavorites}'),
              child: const Icon(Icons.favorite_border),
            ),
            selectedIcon: Badge(
              isLabelVisible: _favorite.totalFavorites > 0,
              label: Text('${_favorite.totalFavorites}'),
              child: const Icon(Icons.favorite),
            ),
            label: 'Yêu thích',
          ),
          const NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Tài khoản',
          ),
        ],
      ),
    );
  }

  Widget _buildShopBody(Color primaryColor, ThemeData theme) {
    return FutureBuilder<List<Flower>>(
      future: _flowersFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                ),
                const SizedBox(height: 24),
                Text(
                  'Đang tải dữ liệu hoa...',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          );
        }

        if (snapshot.hasError) {
          return ErrorDisplayWidget(
            error: snapshot.error.toString(),
            onRetry: _loadFlowers,
          );
        }

        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          final allFlowers = snapshot.data!;
          _loadedFlowers = allFlowers;
          final filteredFlowers = _filterByCategory(
            allFlowers,
            _selectedCategory,
          );

          return RefreshIndicator(
            onRefresh: _refreshFlowers,
            color: primaryColor,
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                _buildSliverAppBar(primaryColor),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _StickySearchHeaderDelegate(
                    backgroundColor: _searchBarElevated
                        ? primaryColor
                        : Colors.transparent,
                    child: _buildSearchBar(),
                  ),
                ),
                SliverToBoxAdapter(child: _buildBannerCarousel()),
                SliverToBoxAdapter(child: _buildCategoryGrid()),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Gợi ý hôm nay',
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w800,
                            color: Colors.grey.shade900,
                          ),
                        ),
                        Text(
                          _selectedCategory == 'Tất cả'
                              ? '${allFlowers.length} sản phẩm'
                              : '$_selectedCategory (${filteredFlowers.length})',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      return FlowerCard(
                        flower: filteredFlowers[index],
                        isFavorite: _favorite.isFavorite(
                          filteredFlowers[index].id,
                        ),
                        onToggleFavorite: () =>
                            _toggleFavorite(filteredFlowers[index]),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => FlowerDetailScreen(
                              flower: filteredFlowers[index],
                            ),
                          ),
                        ),
                        onAddToCart: () {
                          _cart.addToCart(filteredFlowers[index]);
                          _showSnackBar(
                            'Đã thêm ${filteredFlowers[index].name} vào giỏ',
                          );
                        },
                      );
                    }, childCount: filteredFlowers.length),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.61,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                  ),
                ),
              ],
            ),
          );
        }

        return const Center(child: Text('Không có dữ liệu'));
      },
    );
  }

  Widget _buildCategoryBody(Color primaryColor, ThemeData theme) {
    return FutureBuilder<List<Flower>>(
      future: _flowersFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return ErrorDisplayWidget(
            error: snapshot.error.toString(),
            onRetry: _loadFlowers,
          );
        }
        final allFlowers = snapshot.data ?? <Flower>[];
        _loadedFlowers = allFlowers;
        final filteredFlowers = _filterByCategory(
          allFlowers,
          _selectedCategory,
        );

        return RefreshIndicator(
          onRefresh: _refreshFlowers,
          color: primaryColor,
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                title: const Text('Danh mục sản phẩm'),
              ),
              SliverToBoxAdapter(child: _buildCategoryGrid()),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: Text(
                    'Sản phẩm: ${filteredFlowers.length}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final flower = filteredFlowers[index];
                    return FlowerCard(
                      flower: flower,
                      isFavorite: _favorite.isFavorite(flower.id),
                      onToggleFavorite: () => _toggleFavorite(flower),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FlowerDetailScreen(flower: flower),
                        ),
                      ),
                      onAddToCart: () {
                        _cart.addToCart(flower);
                        _showSnackBar('Đã thêm ${flower.name} vào giỏ');
                      },
                    );
                  }, childCount: filteredFlowers.length),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.61,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFavoriteBody(Color primaryColor, ThemeData theme) {
    return FutureBuilder<List<Flower>>(
      future: _flowersFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return ErrorDisplayWidget(
            error: snapshot.error.toString(),
            onRetry: _loadFlowers,
          );
        }
        final allFlowers = snapshot.data ?? <Flower>[];
        _loadedFlowers = allFlowers;
        final favoriteFlowers = allFlowers
            .where((f) => _favorite.isFavorite(f.id))
            .toList();

        if (favoriteFlowers.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.favorite_border,
                  size: 64,
                  color: Colors.grey.shade300,
                ),
                const SizedBox(height: 10),
                Text(
                  'Bạn chưa có sản phẩm yêu thích',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: _refreshFlowers,
          color: primaryColor,
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                title: Text('Yêu thích (${favoriteFlowers.length})'),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final flower = favoriteFlowers[index];
                    return FlowerCard(
                      flower: flower,
                      isFavorite: _favorite.isFavorite(flower.id),
                      onToggleFavorite: () => _toggleFavorite(flower),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FlowerDetailScreen(flower: flower),
                        ),
                      ),
                      onAddToCart: () {
                        _cart.addToCart(flower);
                        _showSnackBar('Đã thêm ${flower.name} vào giỏ');
                      },
                    );
                  }, childCount: favoriteFlowers.length),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.61,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // --- Sliver App Bar ---
  Widget _buildSliverAppBar(Color primaryColor) {
    return SliverAppBar(
      pinned: true,
      floating: false,
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      title: const Text(
        'TH4 - Nhóm G1C4',
        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
      ),
      actions: [
        IconButton(
          tooltip: 'Giỏ hàng',
          onPressed: () {
            setState(() {
              _currentIndex = 2;
            });
          },
          icon: Badge(
            isLabelVisible: _cart.items.value.isNotEmpty,
            label: Text('${_cart.items.value.length}'),
            child: const Icon(Icons.shopping_cart_outlined),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: _loadFlowers,
          tooltip: 'Làm mới',
        ),
        const SizedBox(width: 4),
      ],
    );
  }

  // --- Search Bar ---
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: GestureDetector(
        onTap: () {
          showSearch(
            context: context,
            delegate: FlowerSearchDelegate(_loadedFlowers),
          );
        },
        child: Container(
          height: 46,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              const SizedBox(width: 16),
              Icon(Icons.search, color: Colors.grey.shade400, size: 22),
              const SizedBox(width: 10),
              Text(
                'Tìm kiếm hoa, quà tặng...',
                style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
              ),
              const Spacer(),
              Container(
                margin: const EdgeInsets.all(4),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(Icons.tune, color: Colors.white, size: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBannerCarousel() {
    return Column(
      children: [
        SizedBox(
          height: 164,
          child: PageView.builder(
            controller: _bannerController,
            itemCount: _banners.length,
            onPageChanged: (index) {
              setState(() {
                _currentBanner = index;
              });
            },
            itemBuilder: (context, index) {
              final banner = _banners[index];
              return AnimatedPadding(
                duration: const Duration(milliseconds: 240),
                padding: const EdgeInsets.fromLTRB(6, 8, 6, 6),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    gradient: LinearGradient(
                      colors: banner.colors,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        right: -10,
                        bottom: -8,
                        child: Icon(
                          banner.icon,
                          size: 120,
                          color: Colors.white.withValues(alpha: 0.13),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.22),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                banner.badge,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              banner.title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 23,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.2,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              banner.subtitle,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 2),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_banners.length, (index) {
            final isActive = index == _currentBanner;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: isActive ? 16 : 7,
              height: 7,
              decoration: BoxDecoration(
                color: isActive ? Colors.pink.shade400 : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(99),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildCategoryGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
          child: Text(
            'Danh mục',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Colors.grey.shade900,
            ),
          ),
        ),
        SizedBox(
          height: 168,
          child: GridView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: _homeCategories.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1.02,
            ),
            itemBuilder: (context, index) {
              final item = _homeCategories[index];
              final isSelected = item.filterKey == _selectedCategory;
              final productCount = item.filterKey == null
                  ? 0
                  : _filterByCategory(_loadedFlowers, item.filterKey!).length;
              return GestureDetector(
                onTap: () {
                  if (item.filterKey != null) {
                    setState(() {
                      _selectedCategory = item.filterKey!;
                      if (_currentIndex != 1) {
                        _currentIndex = 1;
                      }
                    });
                    return;
                  }
                  _showSnackBar('Danh mục "${item.label}" đang phát triển');
                },
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected ? item.color : Colors.grey.shade200,
                      width: isSelected ? 1.6 : 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 7,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: item.color.withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(item.icon, color: item.color),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item.label,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '$productCount sp',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // --- Placeholder pages (Danh mục, Giỏ hàng, Yêu thích, Tài khoản) ---
  Widget _buildPlaceholderPage((IconData, String, String) info) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(info.$1, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            info.$2,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(info.$3, style: TextStyle(color: Colors.grey.shade400)),
        ],
      ),
    );
  }

  (IconData, String, String) _getPageInfo(int index) {
    switch (index) {
      case 1:
        return (Icons.category, 'Danh mục', '');
      case 2:
        return (Icons.shopping_cart, 'Giỏ hàng', 'Chưa có sản phẩm trong giỏ');
      case 3:
        return (Icons.favorite, 'Yêu thích', '');
      case 4:
        return (Icons.person, 'Tài khoản', 'Đăng nhập để tiếp tục');
      default:
        return (Icons.home, 'Trang chủ', '');
    }
  }
}

class _StickySearchHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final Color backgroundColor;

  _StickySearchHeaderDelegate({
    required this.child,
    required this.backgroundColor,
  });

  @override
  double get minExtent => 62;

  @override
  double get maxExtent => 70;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 240),
      color: backgroundColor,
      alignment: Alignment.center,
      child: child,
    );
  }

  @override
  bool shouldRebuild(covariant _StickySearchHeaderDelegate oldDelegate) {
    return oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.child != child;
  }
}

class _BannerItem {
  final String title;
  final String subtitle;
  final String badge;
  final IconData icon;
  final List<Color> colors;

  const _BannerItem({
    required this.title,
    required this.subtitle,
    required this.badge,
    required this.icon,
    required this.colors,
  });
}

class _HomeCategoryItem {
  final String label;
  final IconData icon;
  final Color color;
  final String? filterKey;

  const _HomeCategoryItem({
    required this.label,
    required this.icon,
    required this.color,
    this.filterKey,
  });
}
