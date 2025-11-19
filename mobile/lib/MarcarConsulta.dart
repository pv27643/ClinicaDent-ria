import 'package:flutter/material.dart';

class MarcarConsulta extends StatefulWidget {
  const MarcarConsulta({super.key});

  @override
  State<MarcarConsulta> createState() => _MarcarConsulta();
}

class _MarcarConsulta extends State<MarcarConsulta> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final bg = const Color(0xFFFAF7F4);
    final cardBg = Colors.white;
    final primaryGreen = const Color(0xFF2E8B57);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Image.asset('assets/CliniMolelos.png'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Agendar Consulta',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
