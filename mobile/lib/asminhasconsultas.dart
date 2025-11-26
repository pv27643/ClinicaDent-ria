import 'package:flutter/material.dart';

class AsMinhasConsultas extends StatefulWidget {
  const AsMinhasConsultas({super.key});

  @override
  State<AsMinhasConsultas> createState() => _AsMinhasConsultasState();
}

class _AsMinhasConsultasState extends State<AsMinhasConsultas> {
  int _currentIndex = 0;
  int _selectedTab = 0; // 0 = Futuras, 1 = Passadas

  // Dados de exemplo organizados por secção (upcoming / history)
  final List<Map<String, String>> _appointments = [
    // Próximas
    {
      'day': '14',
      'month': 'NOV',
      'name': 'Dra. Sofia Lima',
      'specialty': 'Higiene Oral',
      'time': '10:30',
      'weekday': 'Qui, 14 Nov',
      'status': 'Confirmada',
      'section': 'upcoming'
    },
    {
      'day': '22',
      'month': 'NOV',
      'name': 'Dr. Miguel Torres',
      'specialty': 'Ortodontia',
      'time': '09:00',
      'weekday': 'Sex, 22 Nov',
      'status': 'Pendente',
      'section': 'upcoming'
    },
    {
      'day': '02',
      'month': 'DEZ',
      'name': 'Dra. Inês Carvalho',
      'specialty': 'Implantologia',
      'time': '15:00',
      'weekday': 'Seg, 02 Dez',
      'status': 'Confirmada',
      'section': 'upcoming'
    },

    // Histórico
    {
      'day': '28',
      'month': 'OUT',
      'name': 'Dra. Sofia Lima',
      'specialty': 'Higiene Oral',
      'time': '11:30',
      'weekday': 'Seg, 28 Out',
      'status': 'Concluída',
      'section': 'history'
    },
    {
      'day': '12',
      'month': 'OUT',
      'name': 'Dr. Ricardo Nunes',
      'specialty': 'Cirurgia Oral',
      'time': '14:00',
      'weekday': 'Sáb, 12 Out',
      'status': 'Cancelada',
      'section': 'history'
    },
  ];

  void _showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text)),
    );
  }

  void _cancelAppointment(int index) {
    _showMessage('Consulta "${_appointments[index]['name']}" cancelada');
  }

  void _rescheduleAppointment(int index) {
    _showMessage('Reagendar "${_appointments[index]['name']}"');
  }

  Color _statusBadgeColor(String status) {
    final s = status.toLowerCase();
    if (s.contains('confirm')) return const Color(0xFFDFF5E9); // verde claro
    if (s.contains('pend')) return const Color(0xFFFFF4E0); // amarelo claro
    if (s.contains('concl')) return const Color(0xFFF3F3F3); // cinza claro
    if (s.contains('cancel')) return const Color(0xFFFFE9E9); // vermelho claro
    return const Color(0xFFF3F3F3);
  }

  Color _statusTextColor(String status) {
    final s = status.toLowerCase();
    if (s.contains('confirm')) return Colors.green.shade800;
    if (s.contains('pend')) return Colors.orange.shade800;
    if (s.contains('concl')) return Colors.black54;
    if (s.contains('cancel')) return Colors.red.shade700;
    return Colors.black54;
  }

  Widget _appointmentCard(Map<String, String> appt, int index, Color cardBg) {
    final status = appt['status'] ?? '';
    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 6, offset: const Offset(0, 4))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            // bloco de data
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF7F0),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(appt['day'] ?? '', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 2),
                  Text(appt['month'] ?? '', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                ],
              ),
            ),
            const SizedBox(width: 12),

            // detalhes
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // nome + badge
                  Row(
                    children: [
                      Expanded(
                        child: Text(appt['name'] ?? '', style: const TextStyle(fontWeight: FontWeight.w700)),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: _statusBadgeColor(status),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          status,
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: _statusTextColor(status)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(appt['specialty'] ?? '', style: const TextStyle(color: Colors.black87)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 16, color: Colors.black54),
                      const SizedBox(width: 6),
                      Text(appt['time'] ?? '', style: const TextStyle(color: Colors.black54, fontSize: 13)),
                      const SizedBox(width: 16),
                      const Icon(Icons.calendar_today, size: 16, color: Colors.black54),
                      const SizedBox(width: 6),
                      Expanded(child: Text(appt['weekday'] ?? '', style: const TextStyle(color: Colors.black54, fontSize: 13))),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bg = const Color(0xFFFAF7F4);
    final cardBg = Colors.white;
    final primaryGold = const Color(0xFFA87B05);

    // separar secções
    final upcoming = _appointments.where((a) => a['section'] == 'upcoming').toList();
    final history = _appointments.where((a) => a['section'] == 'history').toList();

    //página
    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              // TÍTULO PRINCIPAL
              const Text('Consultas', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),

              // CARTÃO "Declarações"
              Center(
                child: Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(maxWidth: 360),
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF6EFE8),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.description_outlined, size: 18, color: Colors.black54),
                      const SizedBox(width: 8),
                      Text('Declarações', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // CONTROLO SEGMENTADO (Futuras / Passadas)
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedTab = 0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: _selectedTab == 0 ? const Color(0xFFF3EDE7) : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Center(child: Text('Futuras', style: TextStyle(fontWeight: FontWeight.w600))),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedTab = 1),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: _selectedTab == 1 ? const Color(0xFFF3EDE7) : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Center(child: Text('Passadas', style: TextStyle(fontWeight: FontWeight.w600))),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Lista conforme tab selecionada
              ...() {
                final listToShow = _selectedTab == 0 ? upcoming : history;
                if (listToShow.isEmpty) {
                  return [
                    const SizedBox(height: 40),
                    Center(child: Text(_selectedTab == 0 ? 'Sem consultas futuras' : 'Sem consultas passadas', style: const TextStyle(color: Colors.black54))),
                    const SizedBox(height: 12),
                  ];
                }
                return listToShow.asMap().entries.map<Widget>((entry) {
                  final i = entry.key;
                  final appt = entry.value;
                  // index global se necessário: i + ( _selectedTab==0 ? 0 : upcoming.length )
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _appointmentCard(appt, i + (_selectedTab == 0 ? 0 : upcoming.length), cardBg),
                  );
                }).toList();
              }(),

              const SizedBox(height: 16),

              // Espaço extra
              const SizedBox(height: 16),

            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, 6)),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // item 0 - Início
                _navItem(icon: Icons.home_outlined, label: 'Início', index: 0),
                // item 1 - Consultas (atual)
                _navItem(icon: Icons.calendar_month_outlined, label: 'Consultas', index: 1),
                // item 2 - Planos
                _navItem(icon: Icons.folder_open_outlined, label: 'Planos', index: 2),
                // item 3 - Perfil
                _navItem(icon: Icons.person_outline, label: 'Perfil', index: 3),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // helper para construir cada item da barra
  Widget _navItem({required IconData icon, required String label, required int index}) {
    final primaryGold = const Color(0xFFA87B05);
    final isSelected = _currentIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() => _currentIndex = index);
          // navegação opcional por índice (ajuste rotas conforme precisa)
          if (!mounted) return;
          if (index == 0) Navigator.pushReplacementNamed(context, '/menu');
          if (index == 1) Navigator.pushReplacementNamed(context, '/asminhasconsultas');
          // index 2/3: implementar rotas se existirem (ex: '/planos', '/perfil')
        },
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFF3EDE7) : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 20, color: isSelected ? primaryGold : Colors.black54),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(fontSize: 12, color: isSelected ? primaryGold : Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}