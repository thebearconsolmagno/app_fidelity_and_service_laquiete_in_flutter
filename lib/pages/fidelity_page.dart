
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../providers/app_provider.dart';
import '../services/api_service.dart';
import '../models/app_models.dart';

class FidelityPage extends StatefulWidget {
  const FidelityPage({super.key});

  @override
  State<FidelityPage> createState() => _FidelityPageState();
}

class _FidelityPageState extends State<FidelityPage> {
  List<FidelityHistory> _history = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchHistory();
  }

  Future<void> _fetchHistory() async {
    final app = context.read<AppProvider>();
    try {
      final items = await ApiService().getFidelity(app.token!);
      setState(() {
        _history = items;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final user = app.user;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: _buildSmallStat(context, "RISTORANTE", user?.restaurantPoints ?? 0, Theme.of(context).primaryColor)),
                const SizedBox(width: 16),
                Expanded(child: _buildSmallStat(context, "PIZZERIA", user?.pizzeriaPoints ?? 0, Theme.of(context).colorScheme.secondary)),
              ],
            ),
            const SizedBox(height: 40),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: const Color(0xFF1e3a8a),
                borderRadius: BorderRadius.circular(40),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 30, offset: const Offset(0, 15))]
              ),
              child: Column(
                children: [
                  const Text(
                    "MOSTRA IN CASSA",
                    style: TextStyle(color: Colors.white54, fontWeight: FontWeight.w900, letterSpacing: 3, fontSize: 10),
                  ),
                  const SizedBox(height: 32),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: QrImageView(
                      data: user?.id ?? '0',
                      version: QrVersions.auto,
                      size: 200.0,
                      eyeStyle: const QrEyeStyle(
                        eyeShape: QrEyeShape.square,
                        color: Color(0xFF24903e),
                      ),
                      dataModuleStyle: const QrDataModuleStyle(
                        dataModuleShape: QrDataModuleShape.square,
                        color: Color(0xFF24903e),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    user?.name.toUpperCase() ?? '',
                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic),
                  ),
                  Text(
                    "ID: ${user?.id ?? '---'}",
                    style: const TextStyle(color: Colors.white30, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              "STORICO PUNTI",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            _loading
                ? const Center(child: CircularProgressIndicator())
                : _history.isEmpty
                    ? const Text(
                        "Nessuna transazione trovata",
                        style: TextStyle(color: Colors.grey),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _history.length,
                        itemBuilder: (context, index) {
                          final h = _history[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: h.type == 'earn'
                                    ? Colors.green.withOpacity(0.1)
                                    : Colors.red.withOpacity(0.1),
                                child: Icon(
                                  h.type == 'earn' ? Icons.add : Icons.remove,
                                  color: h.type == 'earn' ? Colors.green : Colors.red,
                                ),
                              ),
                              title: Text(
                                h.description,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                "${h.date.day.toString().padLeft(2, '0')}/${h.date.month.toString().padLeft(2, '0')}/${h.date.year} - ${h.sector.toUpperCase()}",
                                style: const TextStyle(fontSize: 12),
                              ),
                              trailing: Text(
                                "${h.type == 'earn' ? '+' : '-'}${h.points}",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                  color: h.type == 'earn' ? Colors.green : Colors.red,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
          ],
        ),
      ),
    );
  }

  Widget _buildSmallStat(BuildContext context, String label, int val, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey[100]!)
      ),
      child: Column(
        children: [
          Text(label, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 1, color: Colors.grey)),
          const SizedBox(height: 4),
          Text(val.toString(), style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: color)),
        ],
      ),
    );
  }
}
