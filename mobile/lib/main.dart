import 'package:flutter/material.dart';
import 'criar_conta.dart';
import 'login_page.dart';
import 'menu.dart';
import 'marcar_consulta.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
	const MyApp({super.key});

	@override
	Widget build(BuildContext context) {
		return MaterialApp(
			title: 'CliniMolelos',
			debugShowCheckedModeBanner: false,
			theme: ThemeData(
				primarySwatch: Colors.green,
			),
			home: const LoginPage(),
        routes: {
    '/login': (context) => const LoginPage(),
    '/criarconta': (context) => const CreateAccount(),
    '/menu': (context) => const Menu(),
    '/Consultas': (context) => const MarcarConsulta(),
  },
		);
	}
}