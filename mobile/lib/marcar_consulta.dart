import 'package:flutter/material.dart';
import 'widgets/app_bottom_nav.dart';

class MarcarConsulta extends StatefulWidget {
  const MarcarConsulta({super.key});

  @override
  State<MarcarConsulta> createState() => _MarcarConsulta();
}

class _MarcarConsulta extends State<MarcarConsulta> {
  int _currentIndex = -1;
  int _selectedDateIndex = 2; // exemplo: 0..6 (o dia 14 é o index 2)
  String? _selectedTime;
  String? _selectedInsurance;

  final List<Map<String, String>> _dateOptions = [
    {'weekday': 'Seg', 'day': '12', 'month': 'Nov'},
    {'weekday': 'Ter', 'day': '13', 'month': 'Nov'},
    {'weekday': 'Qua', 'day': '14', 'month': 'Nov'},
    {'weekday': 'Qui', 'day': '15', 'month': 'Nov'},
    {'weekday': 'Sex', 'day': '16', 'month': 'Nov'},
    {'weekday': 'Sáb', 'day': '17', 'month': 'Nov'},
    {'weekday': 'Dom', 'day': '18', 'month': 'Nov'},
  ];

  final List<Map<String, String>> _timeSlots = [
    {'time': '09:00', 'status': 'available'},
    {'time': '09:30', 'status': 'limited'},
    {'time': '10:00', 'status': 'soldout'},
    {'time': '10:30', 'status': 'available'},
    {'time': '11:00', 'status': 'limited'},
    {'time': '11:30', 'status': 'available'},
  ];

  @override
  Widget build(BuildContext context) {
    final bg = const Color(0xFFFAF7F4);
    final cardBg = Colors.white;
    final primaryGold = const Color(0xFFA87B05);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                            color: const Color.fromRGBO(0, 0, 0, 0.02),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        Icons.calendar_today_outlined,
                        color: primaryGold,
                        size: 22,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Agendar Consulta',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                  ),
                  const Spacer(),
                  IconButton(
                    splashRadius: 20,
                    icon: const Icon(Icons.close, color: Colors.black87),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromRGBO(0, 0, 0, 0.02),
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: const Text(
                  'Vamos marcar a sua consulta\nSiga os passos simples abaixo',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(color: const Color.fromRGBO(0, 0, 0, 0.03), blurRadius: 8, offset: const Offset(0, 5)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('1. Paciente', style: TextStyle(color: Colors.black54)),
                    const SizedBox(height: 6),

                    //Lista titular
                    SizedBox(
                      height: 44,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              backgroundColor: const Color(0xFFDFF7EE),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              side: const BorderSide(color: Color.fromRGBO(168, 123, 5, 0.18)),
                            ),

                            child: Text(
                              'João (Titular)',
                              style: TextStyle(
                                color: primaryGold,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),

                          //dependente1
                          OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              side: const BorderSide(color: Color.fromRGBO(0, 0, 0, 0.06)),
                            ),
                            child: const Text(
                              'Maria (Dependente)',
                              style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),

                          //dependente2
                          OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              side: const BorderSide(color: Color.fromRGBO(0, 0, 0, 0.06)),
                            ),
                            child: const Text(
                              'Pedro (Dependente)',
                              style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              //Médico e Especialidade
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(color: const Color.fromRGBO(0, 0, 0, 0.03), blurRadius: 8, offset: const Offset(0, 5)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('2. Médico e Especialidade', style: TextStyle(color: Colors.black54)),
                    const SizedBox(height: 8),

                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {},
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: const Color.fromRGBO(0, 0, 0, 0.06)),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 44,
                                      height: 44,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFDFF7EE),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Center(child: Icon(Icons.medical_services_outlined, color: Color(0xFFA87B05), size: 22)),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: const [
                                          Text('Especialidade', style: TextStyle(fontSize: 13, color: Colors.black54), maxLines: 1, overflow: TextOverflow.ellipsis),
                                          SizedBox(height: 4),
                                          Text('Higiene Oral', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14), maxLines: 2, overflow: TextOverflow.ellipsis),
                                        ],
                                      ),
                                    ),
                                    const Icon(Icons.keyboard_arrow_down, color: Colors.black54),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {},
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: const Color.fromRGBO(0, 0, 0, 0.06)),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 44,
                                      height: 44,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF3F6FF),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Center(child: Icon(Icons.person_outline, color: Color(0xFF334155), size: 22)),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: const [
                                          Text('Médico', style: TextStyle(fontSize: 13, color: Colors.black54), maxLines: 1, overflow: TextOverflow.ellipsis),
                                          SizedBox(height: 4),
                                          Text('Dra. Sofia Lima', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14), maxLines: 2, overflow: TextOverflow.ellipsis),
                                        ],
                                      ),
                                    ),
                                    const Icon(Icons.keyboard_arrow_down, color: Colors.black54),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // 3. Data e Hora
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(12)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('3. Data e Hora', style: TextStyle(color: Colors.black54)),
                    const SizedBox(height: 10),

                    // dias
                    SizedBox(
                      height: 92,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _dateOptions.length,
                        itemBuilder: (ctx, i) {
                          final d = _dateOptions[i];
                          final selected = _selectedDateIndex == i;
                          // availability mock: highlight middle as available
                          final availColor = (i % 3 == 0) ? const Color(0xFFDFF5E9) : (i % 3 == 1) ? const Color(0xFFFFF4E0) : const Color(0xFFF3F3F3);
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: GestureDetector(
                              onTap: () => setState(() => _selectedDateIndex = i),
                              child: Container(
                                width: 72,
                                decoration: BoxDecoration(
                                  color: selected ? const Color(0xFFF3EDE7) : Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: selected ? const Color(0xFFD7B77D) : const Color(0xFFF0ECE8)),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(d['weekday'] ?? '', style: const TextStyle(fontSize: 12, color: Colors.black54)),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: availColor,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(d['day'] ?? '', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 12),

                    // legenda
                    Row(
                      children: [
                        Row(children: [Container(width: 10, height: 10, decoration: BoxDecoration(color: const Color(0xFFDFF5E9), shape: BoxShape.circle)), const SizedBox(width: 6), const Text('Disponível')]),
                        const SizedBox(width: 12),
                        Row(children: [Container(width: 10, height: 10, decoration: BoxDecoration(color: const Color(0xFFFFF4E0), shape: BoxShape.circle)), const SizedBox(width: 6), const Text('Limitado')]),
                        const SizedBox(width: 12),
                        Row(children: [Container(width: 10, height: 10, decoration: BoxDecoration(color: const Color(0xFFF3F3F3), shape: BoxShape.circle)), const SizedBox(width: 6), const Text('Esgotado')]),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // times
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: _timeSlots.map((ts) {
                        final time = ts['time']!;
                        final status = ts['status']!;
                        final isSelected = _selectedTime == time;
                        Color bgColor;
                        Color textColor = Colors.black87;
                        Border? border;
                        if (status == 'available') {
                          bgColor = const Color(0xFFDFF5E9);
                          textColor = Colors.green.shade800;
                          border = isSelected ? Border.all(color: Colors.green.shade800, width: 2) : null;
                        } else if (status == 'limited') {
                          bgColor = const Color(0xFFFFF4E0);
                          textColor = Colors.orange.shade800;
                          border = isSelected ? Border.all(color: Colors.orange.shade800, width: 2) : null;
                        } else {
                          bgColor = const Color(0xFFF3F3F3);
                          textColor = Colors.black54;
                        }

                        // selected gets white bg with colored border like screenshot
                        final displayBg = isSelected ? Colors.white : bgColor;
                        final displayTextColor = isSelected ? (status == 'available' ? Colors.green.shade800 : (status == 'limited' ? Colors.orange.shade800 : textColor)) : textColor;

                        return GestureDetector(
                          onTap: status == 'soldout' ? null : () => setState(() => _selectedTime = time),
                          child: Container(
                            width: 92,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: displayBg,
                              borderRadius: BorderRadius.circular(12),
                              border: border ?? Border.all(color: Colors.transparent),
                            ),
                            child: Center(child: Text(time, style: TextStyle(color: displayTextColor, fontWeight: FontWeight.w700))),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // 4. Entidade/Seguro
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(12)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('4. Entidade/Seguro', style: TextStyle(color: Colors.black54)),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        _insuranceButton('ADSE', Icons.shield_outlined),
                        _insuranceButton('Multicare', Icons.health_and_safety_outlined),
                        _insuranceButton('Particular', Icons.credit_card_outlined),
                        _insuranceButton('Médis', Icons.local_hospital_outlined),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // 5. Confirmar
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(12)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('5. Confirmar', style: TextStyle(color: Colors.black54)),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: const Color(0xFFF7F7F7), borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today_outlined, size: 20, color: Colors.black54),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              '${_dateOptions[_selectedDateIndex]['day']} ${_dateOptions[_selectedDateIndex]['month']} • ${_selectedTime ?? '—'} • Higiene Oral • Dra. Sofia',
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: primaryGold, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                        onPressed: (_selectedTime != null) ? () {
                          // ação de confirmação simples
                          showDialog(context: context, builder: (_) => AlertDialog(title: const Text('Confirmação'), content: const Text('Marcação confirmada.'), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))]));
                        } : null,
                        child: const Text('Confirmar Marcação', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

            ],
          ),
        ),
      ),
      bottomNavigationBar: AppBottomNav(selectedIndex: _currentIndex),
    );
  }

  Widget _insuranceButton(String label, IconData icon) {
    final selected = _selectedInsurance == label;
    final double availableWidth = MediaQuery.of(context).size.width;
    final double itemWidth = (availableWidth - 32 - 12) / 2; // padding 16 left/right + spacing
    return GestureDetector(
      onTap: () => setState(() => _selectedInsurance = label),
      child: Container(
        width: itemWidth,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFF6F6F6) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: selected ? const Color(0xFFD7B77D) : const Color(0xFFF0ECE8)),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.black54),
            const SizedBox(width: 10),
            Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600))),
            const Icon(Icons.keyboard_arrow_right, color: Colors.black54),
          ],
        ),
      ),
    );
  }

}
