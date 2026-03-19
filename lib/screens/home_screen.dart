import 'dart:async';

import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/product_service.dart';
import '../services/cart_service.dart';
import '../services/favorite_service.dart';
import '../services/order_service.dart';
import '../widgets/product_card.dart';
import '../widgets/error_widget.dart';
import '../screens/product_detail_screen.dart';
import '../screens/product_search_delegate.dart';
import '../screens/cart_screen.dart';
import '../screens/order_history_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const String _allCategory = 'Tất cả';

  late Future<List<Product>> _productsFuture;
  int _currentIndex = 0;
  String _selectedCategory = _allCategory;
  List<Product> _loadedProducts = [];
  double? _minPrice;
  double? _maxPrice;
  int _currentBanner = 0;
  bool _searchBarElevated = false;
  int _visibleHomeProducts = 8;
  bool _isLoadingMore = false;

  final ScrollController _scrollController = ScrollController();
  final PageController _bannerController = PageController(
    viewportFraction: 0.92,
  );
  Timer? _bannerTimer;

  final List<_BannerItem> _banners = const [
    _BannerItem(
      title: 'Flash Sale 3h',
      subtitle: 'Deal đồng giá cho áo thun, jean, hoodie và phụ kiện',
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
      title: 'Fashion Mall Chính Hãng',
      subtitle: 'Bộ sưu tập quần áo và giày mới nhất trong tuần',
      badge: 'Mall',
      icon: Icons.verified,
      colors: [Color(0xFF00897B), Color(0xFF4DB6AC)],
    ),
    _BannerItem(
      title: 'Mix & Match Cuối Tuần',
      subtitle: 'Mua 2 giảm thêm 10% cho phụ kiện và balo',
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
      label: 'Quần áo',
      icon: Icons.checkroom_rounded,
      color: Color(0xFF43A047),
      filterKey: 'THOI_TRANG',
    ),
    _HomeCategoryItem(
      label: 'Phụ kiện',
      icon: Icons.watch_rounded,
      color: Color(0xFFF4511E),
      filterKey: 'PHU_KIEN',
    ),
    _HomeCategoryItem(
      label: 'Áo mới',
      icon: Icons.dry_cleaning_rounded,
      color: Color(0xFF00897B),
      filterKey: 'THOI_TRANG',
    ),
    _HomeCategoryItem(
      label: 'Túi xách',
      icon: Icons.shopping_bag_rounded,
      color: Color(0xFF6D4C41),
      filterKey: 'PHU_KIEN',
    ),
    _HomeCategoryItem(
      label: 'Xu hướng',
      icon: Icons.trending_up_rounded,
      color: Color(0xFFFF8F00),
      filterKey: 'THOI_TRANG',
    ),
    _HomeCategoryItem(
      label: 'Phụ kiện mới',
      icon: Icons.backpack_rounded,
      color: Color(0xFF3949AB),
      filterKey: 'PHU_KIEN',
    ),
    _HomeCategoryItem(
      label: 'Bộ sưu tập',
      icon: Icons.style_rounded,
      color: Color(0xFF8E24AA),
      filterKey: 'THOI_TRANG',
    ),
  ];

  final _cart = CartService.instance;
  final _favorite = FavoriteService.instance;
  final _order = OrderService.instance;

  @override
  void initState() {
    super.initState();
    _loadProducts();
    _startBannerAutoPlay();
    _scrollController.addListener(_onScroll);
    _cart.items.addListener(_onCartChanged);
    _favorite.favoriteIds.addListener(_onFavoriteChanged);
    _order.orders.addListener(_onOrderChanged);
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _bannerController.dispose();
    _cart.items.removeListener(_onCartChanged);
    _favorite.favoriteIds.removeListener(_onFavoriteChanged);
    _order.orders.removeListener(_onOrderChanged);
    super.dispose();
  }

  void _onCartChanged() {
    setState(() {});
  }

  void _onFavoriteChanged() {
    setState(() {});
  }

  void _onOrderChanged() {
    setState(() {});
  }

  void _onScroll() {
    final shouldElevate = _scrollController.offset > 16;
    if (shouldElevate != _searchBarElevated) {
      setState(() {
        _searchBarElevated = shouldElevate;
      });
    }

    if (_isLoadingMore) return;
    if (!_scrollController.hasClients) return;

    final maxExtent = _scrollController.position.maxScrollExtent;
    final current = _scrollController.position.pixels;
    if (maxExtent - current < 280) {
      _loadMoreHomeProducts();
    }
  }

  Future<void> _loadMoreHomeProducts() async {
    if (_isLoadingMore) return;

    setState(() {
      _isLoadingMore = true;
    });

    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;

    setState(() {
      _visibleHomeProducts += 8;
      _isLoadingMore = false;
    });
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

  void _loadProducts() {
    setState(() {
      _visibleHomeProducts = 8;
      _productsFuture = ProductService.fetchProducts();
    });
  }

  Future<void> _refreshProducts() async {
    final future = ProductService.fetchProducts();
    setState(() {
      _visibleHomeProducts = 8;
      _productsFuture = future;
    });
    await future;
  }

  List<Product> _filterByCategory(List<Product> products, String category) {
    if (category == _allCategory) return products;
    return products
        .where((product) => _matchesCategory(product, category))
        .toList();
  }

  List<Product> _applyPriceFilter(List<Product> products) {
    return products.where((product) {
      if (_minPrice != null && product.price < _minPrice!) return false;
      if (_maxPrice != null && product.price > _maxPrice!) return false;
      return true;
    }).toList();
  }

  bool _matchesCategory(Product product, String categoryKey) {
    switch (categoryKey) {
      case 'THOI_TRANG':
      case 'PHU_KIEN':
        return product.category == categoryKey;
      default:
        return product.category == categoryKey;
    }
  }

  Future<void> _toggleFavorite(Product product) async {
    final isNowFavorite = await _favorite.toggleFavorite(product.id);
    if (!mounted) return;
    _showSnackBar(
      isNowFavorite
          ? 'Đã thêm ${product.name} vào yêu thích'
          : 'Đã bỏ ${product.name} khỏi yêu thích',
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

  String get _priceFilterHint {
    if (_minPrice == null && _maxPrice == null) {
      return 'Tìm kiếm sản phẩm, quà tặng...';
    }
    if (_minPrice == null) {
      return 'Giá dưới ${_maxPrice!.toInt()}đ';
    }
    if (_maxPrice == null) {
      return 'Giá trên ${_minPrice!.toInt()}đ';
    }
    return 'Giá ${_minPrice!.toInt()}đ - ${_maxPrice!.toInt()}đ';
  }

  Future<void> _showHomePriceFilter() async {
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
                const SizedBox(height: 8),
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
                  leading: const Icon(Icons.filter_alt_off_outlined),
                  title: const Text('Bỏ lọc giá'),
                  onTap: () => Navigator.pop(context, (min: null, max: null)),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (!mounted || selected == null) return;
    setState(() {
      _minPrice = selected.min;
      _maxPrice = selected.max;
    });
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
          ? CartScreen(
              onCheckoutCompleted: () {
                setState(() {
                  _currentIndex = 0;
                });
              },
            )
          : _currentIndex == 3
          ? _buildFavoriteBody(primaryColor, theme)
          : const OrderHistoryScreen(),
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
              isLabelVisible: _cart.totalDistinctItems > 0,
              label: Text('${_cart.totalDistinctItems}'),
              child: const Icon(Icons.shopping_cart_outlined),
            ),
            selectedIcon: Badge(
              isLabelVisible: _cart.totalDistinctItems > 0,
              label: Text('${_cart.totalDistinctItems}'),
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
          NavigationDestination(
            icon: Badge(
              isLabelVisible: _order.orders.value.isNotEmpty,
              label: Text('${_order.orders.value.length}'),
              child: const Icon(Icons.receipt_long_outlined),
            ),
            selectedIcon: Badge(
              isLabelVisible: _order.orders.value.isNotEmpty,
              label: Text('${_order.orders.value.length}'),
              child: const Icon(Icons.receipt_long),
            ),
            label: 'Đơn mua',
          ),
        ],
      ),
    );
  }

  Widget _buildShopBody(Color primaryColor, ThemeData theme) {
    return FutureBuilder<List<Product>>(
      future: _productsFuture,
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
                  'Đang tải dữ liệu sản phẩm...',
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
            onRetry: _loadProducts,
          );
        }

        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          final allProducts = snapshot.data!;
          _loadedProducts = allProducts;
          final filteredProducts = _applyPriceFilter(
            _filterByCategory(allProducts, _selectedCategory),
          );
          final visibleCount = filteredProducts.length < _visibleHomeProducts
              ? filteredProducts.length
              : _visibleHomeProducts;
          final visibleProducts = filteredProducts.take(visibleCount).toList();
          final canLoadMore = visibleProducts.length < filteredProducts.length;

          return RefreshIndicator(
            onRefresh: _refreshProducts,
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
                              ? '${allProducts.length} sản phẩm'
                              : '$_selectedCategory (${filteredProducts.length})',
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
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        if (index >= visibleProducts.length) {
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Center(
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          );
                        }

                        return ProductCard(
                          product: visibleProducts[index],
                          isFavorite: _favorite.isFavorite(
                            visibleProducts[index].id,
                          ),
                          onToggleFavorite: () =>
                              _toggleFavorite(visibleProducts[index]),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ProductDetailScreen(
                                product: visibleProducts[index],
                              ),
                            ),
                          ),
                          onAddToCart: () {
                            _cart.addToCart(visibleProducts[index]);
                            _showSnackBar(
                              'Đã thêm ${visibleProducts[index].name} vào giỏ',
                            );
                          },
                        );
                      },
                      childCount:
                          visibleProducts.length + (canLoadMore ? 1 : 0),
                    ),
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
    return FutureBuilder<List<Product>>(
      future: _productsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return ErrorDisplayWidget(
            error: snapshot.error.toString(),
            onRetry: _loadProducts,
          );
        }
        final allProducts = snapshot.data ?? <Product>[];
        _loadedProducts = allProducts;
        final filteredProducts = _applyPriceFilter(
          _filterByCategory(allProducts, _selectedCategory),
        );

        return RefreshIndicator(
          onRefresh: _refreshProducts,
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
                    'Sản phẩm: ${filteredProducts.length}',
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
                    final product = filteredProducts[index];
                    return ProductCard(
                      product: product,
                      isFavorite: _favorite.isFavorite(product.id),
                      onToggleFavorite: () => _toggleFavorite(product),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProductDetailScreen(product: product),
                        ),
                      ),
                      onAddToCart: () {
                        _cart.addToCart(product);
                        _showSnackBar('Đã thêm ${product.name} vào giỏ');
                      },
                    );
                  }, childCount: filteredProducts.length),
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
    return FutureBuilder<List<Product>>(
      future: _productsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return ErrorDisplayWidget(
            error: snapshot.error.toString(),
            onRetry: _loadProducts,
          );
        }
        final allProducts = snapshot.data ?? <Product>[];
        _loadedProducts = allProducts;
        final favoriteProducts = allProducts
            .where((f) => _favorite.isFavorite(f.id))
            .toList();

        if (favoriteProducts.isEmpty) {
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
          onRefresh: _refreshProducts,
          color: primaryColor,
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                title: Text('Yêu thích (${favoriteProducts.length})'),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final product = favoriteProducts[index];
                    return ProductCard(
                      product: product,
                      isFavorite: _favorite.isFavorite(product.id),
                      onToggleFavorite: () => _toggleFavorite(product),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProductDetailScreen(product: product),
                        ),
                      ),
                      onAddToCart: () {
                        _cart.addToCart(product);
                        _showSnackBar('Đã thêm ${product.name} vào giỏ');
                      },
                    );
                  }, childCount: favoriteProducts.length),
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
            label: Text('${_cart.totalDistinctItems}'),
            child: const Icon(Icons.shopping_cart_outlined),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: _loadProducts,
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
            Expanded(
              child: GestureDetector(
                onTap: () {
                  showSearch(
                    context: context,
                    delegate: ProductSearchDelegate(_loadedProducts),
                  );
                },
                child: Text(
                  _priceFilterHint,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                ),
              ),
            ),
            GestureDetector(
              onTap: _showHomePriceFilter,
              child: Container(
                margin: const EdgeInsets.all(4),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(Icons.tune, color: Colors.white, size: 18),
              ),
            ),
          ],
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
          height: 204,
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            clipBehavior: Clip.none,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 14),
            itemCount: _homeCategories.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 0.9,
            ),
            itemBuilder: (context, index) {
              final item = _homeCategories[index];
              final isSelected = item.filterKey == _selectedCategory;
              final productCount = item.filterKey == null
                  ? 0
                  : _filterByCategory(_loadedProducts, item.filterKey!).length;
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
                    color: isSelected
                        ? item.color.withValues(alpha: 0.08)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected ? item.color : Colors.grey.shade200,
                      width: 1,
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
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: item.color.withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(item.icon, color: item.color, size: 20),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        '$productCount sp',
                        style: TextStyle(
                          fontSize: 10,
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
