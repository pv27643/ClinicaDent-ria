import 'package:flutter/material.dart';
import 'marcar_consulta.dart';
//cor do amarelo/dourado é a87b05

//criar classe
class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  int _currentIndex = 0;

//definir graficos utilizados
  @override
  Widget build(BuildContext context) {
    final bg = const Color(0xFFFAF7F4);
    final cardBg = Colors.white;
    final primaryGreen = const Color(0xFFA87B05);

//página
    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              //HEADER LOGO E AÇÕES
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [

                      //logo pequeno
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
                      const Text('Clinimolelos', style: TextStyle(fontWeight: FontWeight.w600)),
                    ],
                  ),

                  Row(
                    children: const [
                      Icon(Icons.notifications_none),
                      SizedBox(width: 12),
                      Icon(Icons.help_outline),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 18),
              

              //Card no topo da página
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(color: const Color.fromRGBO(0, 0, 0, 0.03), blurRadius: 8, offset: const Offset(0, 4)),
                  ],
                ),

                //conteúdo
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Olá, João!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 6),
                    const Text('Bem-vindo de volta ao seu espaço de paciente', style: TextStyle(color: Colors.black54)),
                    const SizedBox(height: 12),

                    SizedBox(
                      width: double.infinity, //ocupa a maior largura (ou altura) possível
                      height: 44,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryGreen,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () {
                          // debug: confirmar se o botão foi pressionado
                          // abra a tela de agendamento
                          debugPrint('Marcar Consulta pressed');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MarcarConsulta(),
                            ),
                          );
                        },
                        child: const Text('Marcar Consulta', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
//fim card do inicio


              // Grid cards
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                /*horizontal*/crossAxisSpacing: 12,
                /*vertical*/mainAxisSpacing: 12,
                childAspectRatio: 0.78, //aumenta a altura dos cards para evitar overflow

                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _menuCard(icon: Icons.calendar_today_outlined, title: 'Consultas Agendadas', subtitle: 'Veja próximas datas'),
                  _menuCard(icon: Icons.medical_services_outlined, title: 'Planos de Tratamento', subtitle: 'Acompanhe etapas'),
                  _menuCard(icon: Icons.people_outline, title: 'Dependentes', subtitle: 'Gerir familiares'),
                  _menuCard(icon: Icons.description_outlined, title: 'Declarações/Docs', subtitle: 'Descarregar comprov.'),
                  _menuCard(icon: Icons.person_outline, title: 'Perfil', subtitle: 'Dados e segurança'),
                  _menuCard(icon: Icons.mail_outline, title: 'Contactar Clínica', subtitle: 'Envie uma mensagem'),
                ],
              ),
              const SizedBox(height: 10),

              const Text('Atalhos Rápidos', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),

              // Lista de cards abaixo 
              Column(
                children: [
                  _quickCard(title: 'Consultas Agendadas', subtitle: 'Próxima: 12 Nov, 10:00'),
                  const SizedBox(height: 8),
                  _quickCard(title: 'Plano Atual', subtitle: 'Em progresso • 2/5 etapas'),
                ],
              ),
              const SizedBox(height: 80), 
            ],
          ),
        ),
      ),


      // Bottom navigation bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: primaryGreen,
        unselectedItemColor: Colors.black54,
        onTap: (i) => setState(() => _currentIndex = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Início'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month_outlined), label: 'Consultas'),
          BottomNavigationBarItem(icon: Icon(Icons.folder_open_outlined), label: 'Documentos'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Perfil'),
        ],
      ),
    );
  }


//preenche o conteudo dos cartões grid desenvolve o container
  Widget _menuCard({required IconData icon, required String title, required String subtitle}) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: const Color.fromRGBO(0, 0, 0, 0.02), blurRadius: 8, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFF3EDE7),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.black54, size: 18),
          ),
          const SizedBox(height: 8),
          Flexible(
            child: Text(
              title,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 6),
          Flexible(
            child: Text(
              subtitle,
              style: const TextStyle(fontSize: 12, color: Colors.black54),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }


//preenche o conteudo dos cartões abaixo desenvolve o container
  Widget _quickCard({required String title, required String subtitle}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), boxShadow: [BoxShadow(color: const Color.fromRGBO(0, 0, 0, 0.02), blurRadius: 6, offset: const Offset(0,4))]),
     
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.black54)),
            ],
          ),

          const Icon(Icons.chevron_right, color: Colors.black26),
        ],
      ),
    );
  }
}