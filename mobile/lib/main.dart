import 'package:flutter/material.dart';
import 'package:flutter_application_1/CriarConta.dart';
import 'login_page.dart';
import 'Menu.dart';
import 'MarcarConsulta.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
	const MyApp({Key? key}) : super(key: key);

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