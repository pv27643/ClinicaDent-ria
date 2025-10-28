import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Início')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => context.push('/details'),
          // ou: context.goNamed('details')
          child: const Text('Ir para Detalhes'),
        ),
      ),
    );
  }
}
