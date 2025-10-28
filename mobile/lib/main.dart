import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ADM Drawer Routes',
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/pagina1': (context) => const Pagina1(),
        '/pagina2': (context) => const Pagina2(),
      },
    );
  }
}

class AppDrawer extends StatelessWidget {
  final String? currentRoute;
  const AppDrawer({super.key, required this.currentRoute});

  void _goTo(BuildContext context, String route) {
    if (currentRoute == route) {
      Navigator.pop(context); // fecha o drawer
      return;
    }
    Navigator.pop(context); // fecha o drawer
    Navigator.pushReplacementNamed(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text('Navegação', style: TextStyle(color: Colors.white, fontSize: 20)),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Início'),
            selected: currentRoute == '/',
            onTap: () => _goTo(context, '/'),
          ),
          ListTile(
            leading: const Icon(Icons.pageview),
            title: const Text('Página 1'),
            selected: currentRoute == '/pagina1',
            onTap: () => _goTo(context, '/pagina1'),
          ),
          ListTile(
            leading: const Icon(Icons.pages),
            title: const Text('Página 2'),
            selected: currentRoute == '/pagina2',
            onTap: () => _goTo(context, '/pagina2'),
          ),
        ],
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final current = ModalRoute.of(context)?.settings.name;
    return Scaffold(
      appBar: AppBar(title: const Text('Início')),
      drawer: AppDrawer(currentRoute: current),
      body: const Center(child: Text('Conteúdo da página inicial')),
    );
  }
}

class Pagina1 extends StatelessWidget {
  const Pagina1({super.key});

  @override
  Widget build(BuildContext context) {
    final current = ModalRoute.of(context)?.settings.name;
    return Scaffold(
      appBar: AppBar(title: const Text('Página 1')),
      drawer: AppDrawer(currentRoute: current),
      body: const Center(child: Text('Conteúdo da Página 1')),
    );
  }
}

class Pagina2 extends StatelessWidget {
  const Pagina2({super.key});

  @override
  Widget build(BuildContext context) {
    final current = ModalRoute.of(context)?.settings.name;
    return Scaffold(
      appBar: AppBar(title: const Text('Página 2')),
      drawer: AppDrawer(currentRoute: current),
      body: const Center(child: Text('Conteúdo da Página 2')),
    );
  }
}
