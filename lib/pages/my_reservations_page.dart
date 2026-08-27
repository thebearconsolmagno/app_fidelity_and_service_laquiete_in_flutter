
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../services/api_service.dart';
import '../models/app_models.dart';
import 'home_page.dart';

class MyReservationsPage extends StatefulWidget {
  const MyReservationsPage({super.key});

  @override
  State<MyReservationsPage> createState() => _MyReservationsPageState();
}

class _MyReservationsPageState extends State<MyReservationsPage> {
  List<Reservation> _reservations = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchReservations();
  }

  Future<void> _fetchReservations() async {
    final app = context.read<AppProvider>();
    try {
      final items = await ApiService().getReservations(app.token!);
      setState(() {
        _reservations = items;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  String _getStatusLabel(String status) {
    switch (status) {
      case 'pending':
        return 'In Attesa';
      case 'accepted':
        return 'Confermato';
      case 'rejected':
        return 'Rifiutato';
      default:
        return status;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'accepted':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
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
        body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _reservations.isEmpty
              ? const Center(
                  child: Text(
                    "Nessuna prenotazione trovata",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _reservations.length,
                  itemBuilder: (context, index) {
                    final r = _reservations[index];
                    final isPast = DateTime.parse(r.date).isBefore(DateTime.now());
                    final isRejected = r.status == 'rejected';
                    final isFaded = isPast || isRejected;
                    
                    return Opacity(
                      opacity: isFaded ? 0.4 : 1.0,
                      child: Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                Text(
                                  "Prenotazione #${r.id}",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: _getStatusColor(r.status),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    _getStatusLabel(r.status),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Divider(height: 24),
                            Row(
                              children: [
                                const Icon(Icons.calendar_today,
                                    size: 16, color: Colors.grey),
                                const SizedBox(width: 8),
                                Text(r.date,
                                    style: const TextStyle(fontSize: 14)),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.access_time,
                                    size: 16, color: Colors.grey),
                                const SizedBox(width: 8),
                                Text(r.period.toUpperCase(),
                                    style: const TextStyle(fontSize: 14)),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.people,
                                    size: 16, color: Colors.grey),
                                const SizedBox(width: 8),
                                Text("${r.guests} ospiti",
                                    style: const TextStyle(fontSize: 14)),
                              ],
                            ),
                            if (r.eventType.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(Icons.event,
                                      size: 16, color: Colors.grey),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(r.eventType,
                                        style: const TextStyle(fontSize: 14)),
                                  ),
                                ],
                              ),
                            ],
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.phone,
                                    size: 16, color: Colors.grey),
                                const SizedBox(width: 8),
                                Text(r.userPhone,
                                    style: const TextStyle(fontSize: 14)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    );
                  },
                ),
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
            currentIndex: 0,
            onTap: (idx) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => HomePage(initialIndex: idx)),
                (route) => false,
              );
            },
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
