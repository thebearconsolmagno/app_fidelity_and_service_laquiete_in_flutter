
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../services/api_service.dart';
import 'menu_page.dart';
import 'dashboard_page.dart';
import 'fidelity_page.dart';
import 'reservations_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  late final List<Widget> _pages = [
    DashboardPage(onNavigate: (index) => setState(() => _currentIndex = index)),
    const MenuPage(),
    const FidelityPage(),
    const ReservationsPage(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final logoUrl = app.theme?.logoUrl;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: _currentIndex == 0
            ? null
            : IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => setState(() => _currentIndex = 0),
              ),
        toolbarHeight: 140,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (logoUrl != null && logoUrl.isNotEmpty)
              Image.network(
                ApiService().resolveUrl(logoUrl),
                height: 60,
                errorBuilder: (_, __, ___) => const Icon(Icons.restaurant, size: 40),
              )
            else
              const Icon(Icons.restaurant, size: 40),
            const SizedBox(height: 8),
            const Text(
              'La Quiete',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 2),
            const Text(
              'Hotel, Ristorante e Bar',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20)],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          child: BottomNavigationBar(
            backgroundColor: Colors.white,
            selectedItemColor: Theme.of(context).primaryColor,
            unselectedItemColor: Colors.grey[600],
            currentIndex: _currentIndex,
            onTap: (idx) => setState(() => _currentIndex = idx),
            showSelectedLabels: true,
            showUnselectedLabels: false,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.restaurant_menu), label: 'Menu'),
              BottomNavigationBarItem(icon: Icon(Icons.credit_card), label: 'Fedeltà'),
              BottomNavigationBarItem(icon: Icon(Icons.event_available), label: 'Prenota'),
            ],
          ),
        ),
      ),
    );
  }
}
