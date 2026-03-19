import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'services/favorite_service.dart';
import 'services/cart_service.dart';
import 'services/order_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FavoriteService.instance.init();
  await CartService.instance.init();
  await OrderService.instance.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CartService>.value(
      value: CartService.instance,
      child: MaterialApp(
        title: 'Product Shop',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFE91E63),
            brightness: Brightness.light,
          ),
          typography: Typography.material2021(),
          appBarTheme: const AppBarTheme(scrolledUnderElevation: 0),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
