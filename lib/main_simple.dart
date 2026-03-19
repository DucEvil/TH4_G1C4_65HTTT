import 'package:flutter/material.dart';
import 'data/mock_flowers.dart';
import 'models/flower_model.dart';

void main() {
  runApp(const SimpleApp());
}

class SimpleApp extends StatelessWidget {
  const SimpleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Flower App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.pink,
        useMaterial3: true,
      ),
      home: const SimpleHomeScreen(),
    );
  }
}

class SimpleHomeScreen extends StatefulWidget {
  const SimpleHomeScreen({super.key});

  @override
  State<SimpleHomeScreen> createState() => _SimpleHomeScreenState();
}

class _SimpleHomeScreenState extends State<SimpleHomeScreen> {
  late Future<List<Flower>> _flowersFuture;

  @override
  void initState() {
    super.initState();
    _loadFlowers();
  }

  void _loadFlowers() {
    setState(() {
      _flowersFuture = _getMockFlowers();
    });
  }

  Future<List<Flower>> _getMockFlowers() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    return MockFlowerData.getMockFlowers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TH3 - Đỗ Đình Đức - 2351160510'),
        backgroundColor: Colors.pink,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<Flower>>(
        future: _flowersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Đang tải dữ liệu...'),
                ],
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Lỗi: ${snapshot.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadFlowers,
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('Không có dữ liệu'),
            );
          }

          final flowers = snapshot.data!;
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.6,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: flowers.length,
            itemBuilder: (context, index) {
              final flower = flowers[index];
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image placeholder
                    Expanded(
                      flex: 3,
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.pink.withOpacity(0.1),
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(12),
                          ),
                        ),
                        child: flower.image.isNotEmpty
                            ? Image.network(
                                flower.image,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => const Icon(
                                  Icons.local_florist,
                                  size: 40,
                                  color: Colors.pink,
                                ),
                              )
                            : const Icon(
                                Icons.local_florist,
                                size: 40,
                                color: Colors.pink,
                              ),
                      ),
                    ),
                    // Info
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              flower.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              flower.category,
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey[600],
                              ),
                            ),
                            const Spacer(),
                            Text(
                              '${flower.price.toInt()}đ',
                              style: const TextStyle(
                                color: Colors.pink,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _loadFlowers,
        backgroundColor: Colors.pink,
        child: const Icon(Icons.refresh, color: Colors.white),
      ),
    );
  }
}
