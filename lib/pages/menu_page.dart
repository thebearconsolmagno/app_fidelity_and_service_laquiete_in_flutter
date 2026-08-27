
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../services/api_service.dart';
import '../models/app_models.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  List<Product> _products = [];
  List<String> _categories = [];
  bool _loading = true;

  static const List<String> _defaultCategoryOrder = [
    'Antipasti',
    'Primi',
    'Secondi',
    'Contorni',
    'Pizze',
    'Dolci',
    'Bevande',
    'Caffetteria',
    'Amari',
    'Vini',
    'Birre',
    'Altro',
  ];

  @override
  void initState() {
    super.initState();
    _fetchMenu();
  }

  Future<void> _fetchMenu() async {
    final app = context.read<AppProvider>();
    try {
      final results = await Future.wait([
        ApiService().getProducts(app.token!),
        ApiService().getMenuCategories(app.token!),
      ]);
      final items = results[0] as List<Product>;
      final cats = results[1] as List<String>;
      setState(() {
        _products = items;
        _categories = cats.isNotEmpty ? cats : _defaultCategoryOrder;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  String _normalize(String value) => value.trim().toLowerCase();

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final logoUrl = app.theme?.logoUrl;
    
    // Group products by category.
    Map<String, List<Product>> groupedProducts = {};
    for (var product in _products) {
      final category = (product.category.isNotEmpty ? product.category : 'Altro');
      if (!groupedProducts.containsKey(category)) {
        groupedProducts[category] = [];
      }
      groupedProducts[category]!.add(product);
    }

    final Map<String, String> normalizedMap = {
      for (final key in groupedProducts.keys) _normalize(key): key
    };

    final orderedCategories = <String>[];
    for (final cat in _categories) {
      final match = normalizedMap[_normalize(cat)];
      if (match != null && !orderedCategories.contains(match)) {
        orderedCategories.add(match);
      }
    }

    final remaining = groupedProducts.keys
        .where((c) => !orderedCategories.contains(c))
        .toList()
      ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

    final categories = [
      ...orderedCategories,
      ...remaining,
    ];

    final totalItems = categories.length + categories.fold<int>(0, (sum, c) => sum + (groupedProducts[c]?.length ?? 0));

    return Scaffold(
      body: _loading 
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: totalItems,
            itemBuilder: (context, index) {
              int productCount = 0;

              for (var i = 0; i < categories.length; i++) {
                if (index == productCount) {
                  // Display the category header.
                  return Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 12),
                    child: Text(
                      categories[i].toUpperCase(),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.5,
                        color: Colors.grey,
                      ),
                    ),
                  );
                }
                productCount++;
                
                // Display products in the category.
                int productsInCategory = groupedProducts[categories[i]]!.length;
                if (index < productCount + productsInCategory) {
                  final product = groupedProducts[categories[i]]![index - productCount];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          ApiService().resolveUrl(product.imageUrl),
                          width: 60, height: 60, fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(Icons.fastfood),
                        ),
                      ),
                      title: Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(product.description, maxLines: 2, overflow: TextOverflow.ellipsis),
                      trailing: Text("€${product.price.toStringAsFixed(2)}", 
                        style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.w900)),
                    ),
                  );
                }
                productCount += productsInCategory;
              }
              return const SizedBox();
            },
          ),
    );
  }
}
