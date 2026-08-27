
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../services/api_service.dart';

class ReservationsPage extends StatefulWidget {
  const ReservationsPage({super.key});

  @override
  State<ReservationsPage> createState() => _ReservationsPageState();
}

class _ReservationsPageState extends State<ReservationsPage> {
  int _guests = 2;
  String _period = "cena";
  String _eventType = "";
  bool _isLoading = false;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now().add(const Duration(days: 1));
  }

  void _handleReserve() async {
    setState(() => _isLoading = true);
    final app = context.read<AppProvider>();
    try {
      await ApiService().createReservation(app.token!, {
        'userId': app.user!.id,
        'guests': _guests,
        'period': _period,
        'eventType': _eventType,
        'date': _selectedDate.toIso8601String().split('T')[0],
        'userName': app.user!.name,
        'userPhone': app.user!.phoneNumber,
      });
      if (mounted) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Prenotazione Inviata"),
            content: const Text("La tua prenotazione è stata inviata per conferma. Quando sarà confermata ti invieremo un messaggio WhatsApp."),
            actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK"))],
          )
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final logoUrl = app.theme?.logoUrl;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text("Seleziona Data", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      const Text("Giorno", style: TextStyle(fontSize: 12, color: Colors.grey)),
                      DropdownButton<int>(
                        isExpanded: true,
                        value: _selectedDate.day,
                        items: List.generate(31, (i) => i + 1).map((day) => DropdownMenuItem(value: day, child: Text(day.toString()))).toList(),
                        onChanged: (day) {
                          if (day != null) {
                            setState(() => _selectedDate = DateTime(_selectedDate.year, _selectedDate.month, day));
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    children: [
                      const Text("Mese", style: TextStyle(fontSize: 12, color: Colors.grey)),
                      DropdownButton<int>(
                        isExpanded: true,
                        value: _selectedDate.month,
                        items: List.generate(12, (i) => i + 1).map((month) => DropdownMenuItem(value: month, child: Text(month.toString().padLeft(2, '0')))).toList(),
                        onChanged: (month) {
                          if (month != null) {
                            setState(() => _selectedDate = DateTime(_selectedDate.year, month, _selectedDate.day));
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    children: [
                      const Text("Anno", style: TextStyle(fontSize: 12, color: Colors.grey)),
                      DropdownButton<int>(
                        isExpanded: true,
                        value: _selectedDate.year,
                        items: List.generate(5, (i) => DateTime.now().year + i).map((year) => DropdownMenuItem(value: year, child: Text(year.toString()))).toList(),
                        onChanged: (year) {
                          if (year != null) {
                            setState(() => _selectedDate = DateTime(year, _selectedDate.month, _selectedDate.day));
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            const Text("Quante persone?", style: TextStyle(fontWeight: FontWeight.bold)),
            Slider(
              value: _guests.toDouble(),
              min: 1, max: 20,
              onChanged: (v) => setState(() => _guests = v.toInt()),
            ),
            Text("Ospiti: $_guests", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: ChoiceChip(
                    label: const Center(child: Text("Pranzo")),
                    selected: _period == "pranzo",
                    onSelected: (v) => setState(() => _period = "pranzo"),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ChoiceChip(
                    label: const Center(child: Text("Cena")),
                    selected: _period == "cena",
                    onSelected: (v) => setState(() => _period = "cena"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: "Tipo di Evento"),
              items: [
                "Raduni familiari",
                "Serate danzanti",
                "Matrimonio",
                "Anniversario di matrimonio",
                "Compleanno",
                "Laurea",
                "Gruppi - Pullman",
                "Battesimo",
                "Comunione",
                "Cresima",
                "Cena aziendali",
                "Pranzo aziendali",
                "Conviviale",
                "Evento",
                "Pensionamento",
                "Giuramento",
                "Promessa di Matrimonio",
                "Compleanno adulto",
                "Compleanno bambini (kids party)",
                "Compleanno a tema",
                "Festa dei 18 anni",
                "Festa dei 30/40/50/60 anni",
                "Fine anno scolastico",
                "Diploma",
                "Festa di classe",
                "Meeting aziendali",
                "Conferenze",
                "Workshop",
                "Presentazione di prodotto",
                "Premi e riconoscimenti",
                "Pranzi e cene di gala",
                "Buffet a tema",
                "Feste di associazioni",
              ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (v) => _eventType = v!,
            ),
            const SizedBox(height: 32),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[400]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListTile(
                title: const Text("Data della Prenotazione"),
                subtitle: Text(
                  "${_selectedDate.day.toString().padLeft(2, '0')}/${_selectedDate.month.toString().padLeft(2, '0')}/${_selectedDate.year} - ${_period.toUpperCase()} - ${_eventType.isNotEmpty ? _eventType : 'Evento non selezionato'}"
                ),
              ),
            ),
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleReserve,
                child: _isLoading ? const CircularProgressIndicator() : const Text("PRENOTA ORA"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
