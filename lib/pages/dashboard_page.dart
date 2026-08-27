
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../services/api_service.dart';
import 'menu_page.dart';
import 'reservations_page.dart';
import 'my_reservations_page.dart';
import 'home_page.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key, this.onNavigate});

  final ValueChanged<int>? onNavigate;

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final user = app.user;
    final theme = app.theme;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Bentornato,",
                        style: TextStyle(color: Colors.grey[400], fontWeight: FontWeight.bold),
                      ),
                      Text(
                        user?.name.split(' ')[0] ?? 'Ospite',
                        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => app.logout(),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)]
                      ),
                      child: const Icon(Icons.logout, color: Colors.redAccent),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 32),
              _buildPointsCard(context, "Ristorante", user?.pointsRistorante ?? 0, Theme.of(context).primaryColor),
              const SizedBox(height: 16),
              _buildPointsCard(context, "Pizzeria", user?.pointsPizzeria ?? 0, Theme.of(context).colorScheme.secondary),
              const SizedBox(height: 40),
              const Text("AZIONI RAPIDE", style: TextStyle(letterSpacing: 2, fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  if (onNavigate != null) {
                    onNavigate!(1);
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => HomePage(initialIndex: 1)),
                    );
                  }
                },
                child: _buildActionItem(context, Icons.restaurant_menu, "SFOGLIA IL MENU", "Guarda le specialità di oggi"),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () {
                  if (onNavigate != null) {
                    onNavigate!(3);
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => HomePage(initialIndex: 3)),
                    );
                  }
                },
                child: _buildActionItem(context, Icons.event_available, "PRENOTA UN TAVOLO", "Assicurati il tuo posto"),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MyReservationsPage())),
                child: _buildActionItem(context, Icons.list_alt, "LE MIE PRENOTAZIONI", "Vedi le tue prenotazioni"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPointsCard(BuildContext context, String title, int points, Color color) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: color.withOpacity(0.1), width: 2),
        boxShadow: [BoxShadow(color: color.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 10))]
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title.toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1.5, color: Colors.grey)),
              const SizedBox(height: 4),
              const Text("Punti Fedeltà", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
          Text(
            points.toString(),
            style: TextStyle(fontSize: 42, fontWeight: FontWeight.w900, color: color, fontStyle: FontStyle.italic),
          )
        ],
      ),
    );
  }

  Widget _buildActionItem(BuildContext context, IconData icon, String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)]
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(16)),
            child: Icon(icon, color: Theme.of(context).primaryColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13, letterSpacing: 1)),
                Text(subtitle, style: TextStyle(color: Colors.grey[400], fontSize: 11)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.grey)
        ],
      ),
    );
  }
}
