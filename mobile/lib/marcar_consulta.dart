import 'package:flutter/material.dart';

class MarcarConsulta extends StatefulWidget {
  const MarcarConsulta({super.key});

  @override
  State<MarcarConsulta> createState() => _MarcarConsulta();
}

class _MarcarConsulta extends State<MarcarConsulta> {

  @override
  Widget build(BuildContext context) {
    final bg = const Color(0xFFFAF7F4);
    final cardBg = Colors.white;
    final primaryGreen = const Color(0xFFA87B05);

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
                        color: primaryGreen,
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
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius:BorderRadius.circular(12),
                      boxShadow:[
                        BoxShadow(color: const Color.fromRGBO(0, 0, 0, 0.03), blurRadius: 8, offset: const Offset(0,5)),
                      ],
                    ),


                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:[
                        const Text('1. Paciente', style: TextStyle(color: Colors.black54)),
                        const SizedBox(height: 6),
                          SizedBox(
                          height: 44,
                          child: Row(
                         

                         /*Dependentes e titular*/
                          children: [
                              GestureDetector(
                                onTap: () {},
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFDFF7EE),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: const Color.fromRGBO(168, 123, 5, 0.18)),
                                  ),
                                  child: Text(
                                    'João (Titular)',
                                    style: TextStyle(
                                      color: primaryGreen,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                            ],
                          ),
                        ),
                      ]
                    ),
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
