import 'package:flutter/material.dart';
import '../models/flower_model.dart';
import '../services/flower_service.dart';
import '../services/cart_service.dart';
import '../widgets/flower_card.dart';
import '../widgets/error_widget.dart';
import '../screens/flower_detail_screen.dart';
import '../screens/flower_search_delegate.dart';
import '../screens/cart_screen.dart';
import '../screens/order_history_screen.dart';
import '../config/api_config.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Flower>> _flowersFuture;
  int _currentIndex = 0;
  String _selectedCategory = 'Tất cả';
  List<Flower> _loadedFlowers = [];

  final List<String> _categories = ['Tất cả', 'HOA TƯƠI', 'HOA NHẬP KHẨU'];
  final _cart = CartService.instance;

  @override
  void initState() {
    super.initState();
    _loadFlowers();
    _cart.items.addListener(_onCartChanged);
  }

  @override
  void dispose() {
    _cart.items.removeListener(_onCartChanged);
    super.dispose();
  }

  void _onCartChanged() {
    setState(() {});
  }

  void _loadFlowers() {
    setState(() {
      _flowersFuture = FlowerService.fetchFlowers();
    });
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
      body: _buildPageBody(primaryColor, theme),
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
          const NavigationDestination(
            icon: Icon(Icons.favorite_border),
            selectedIcon: Icon(Icons.favorite),
            label: 'Yêu thích',
          ),
          const NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long),
            label: 'Đơn mua',
          ),
        ],
      ),
    );
  }

  Widget _buildPageBody(Color primaryColor, ThemeData theme) {
    if (_currentIndex == 0) {
      return _buildShopBody(primaryColor, theme);
    }
    if (_currentIndex == 2) {
      return CartScreen(
        onOrderPlaced: () {
          setState(() => _currentIndex = 0);
          _showSnackBar('Đặt hàng thành công');
        },
      );
    }
    if (_currentIndex == 4) {
      return const OrderHistoryScreen();
    }
    return _buildPlaceholderPage(_getPageInfo(_currentIndex));
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
          final filteredFlowers = _selectedCategory == 'Tất cả'
              ? allFlowers
              : allFlowers
                    .where((f) => f.category == _selectedCategory)
                    .toList();

          return CustomScrollView(
            slivers: [
              // --- App Bar ---
              _buildSliverAppBar(primaryColor),

              // --- Search Bar ---
              SliverToBoxAdapter(child: _buildSearchBar()),

              // --- Banner carousel ---
              SliverToBoxAdapter(child: _buildBanner(primaryColor)),

              // --- Category chips ---
              SliverToBoxAdapter(child: _buildCategoryChips(primaryColor)),

              // --- Section title ---
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedCategory == 'Tất cả'
                            ? 'Tất cả hoa (${allFlowers.length})'
                            : '$_selectedCategory (${filteredFlowers.length})',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () =>
                            _showSnackBar('Chức năng đang phát triển'),
                        icon: const Icon(Icons.sort, size: 18),
                        label: const Text('Sắp xếp'),
                      ),
                    ],
                  ),
                ),
              ),

              // --- Product Grid ---
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    return FlowerCard(
                      flower: filteredFlowers[index],
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
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.58,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                ),
              ),
            ],
          );
        }

        return const Center(child: Text('Không có dữ liệu'));
      },
    );
  }

  // --- Sliver App Bar ---
  Widget _buildSliverAppBar(Color primaryColor) {
    return SliverAppBar(
      floating: true,
      snap: true,
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      title: Row(
        children: [
          const Icon(Icons.local_florist, size: 24),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              '${ApiConfig.appBarTitle} - ${ApiConfig.studentName} - ${ApiConfig.studentId}',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.3,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      actions: [
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
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
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

  // --- Banner ---
  Widget _buildBanner(Color primaryColor) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [primaryColor, primaryColor.withValues(alpha: 0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          // Pattern decoration
          Positioned(
            right: -20,
            bottom: -20,
            child: Icon(
              Icons.local_florist,
              size: 150,
              color: Colors.white.withValues(alpha: 0.1),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
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
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    '🌸 Ưu đãi hôm nay',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Giảm đến 40%',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Hoa tươi nhập khẩu • Miễn phí giao hàng',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- Category chips ---
  Widget _buildCategoryChips(Color primaryColor) {
    return SizedBox(
      height: 50,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        separatorBuilder: (_, s) => const SizedBox(width: 8),
        itemBuilder: (_, index) {
          final cat = _categories[index];
          final isSelected = cat == _selectedCategory;
          return FilterChip(
            selected: isSelected,
            label: Text(cat),
            labelStyle: TextStyle(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? Colors.white : Colors.grey.shade700,
            ),
            selectedColor: primaryColor,
            backgroundColor: Colors.white,
            checkmarkColor: Colors.white,
            side: BorderSide(
              color: isSelected ? primaryColor : Colors.grey.shade300,
            ),
            onSelected: (_) {
              setState(() => _selectedCategory = cat);
            },
          );
        },
      ),
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
        return (Icons.category, 'Danh mục', 'Chức năng đang phát triển');
      case 2:
        return (Icons.shopping_cart, 'Giỏ hàng', 'Chưa có sản phẩm trong giỏ');
      case 3:
        return (Icons.favorite, 'Yêu thích', 'Chưa có sản phẩm yêu thích');
      case 4:
        return (Icons.receipt_long, 'Đơn mua', 'Lịch sử đơn hàng của bạn');
      default:
        return (Icons.home, 'Trang chủ', '');
    }
  }
}
