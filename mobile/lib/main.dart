import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'login_page.dart';
import 'menu.dart';
import 'marcar_consulta.dart';
import 'asminhasconsultas.dart';
import 'planotratamento.dart';

Future<void> main() async {
	WidgetsFlutterBinding.ensureInitialized();
	// Load environment variables from .env (if present)
	try {
		await dotenv.load(fileName: ".env");
	} catch (_) {
		debugPrint('No .env file found or error loading env');
	}
	runApp(const MyApp());
}

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
    '/menu': (context) => const Menu(),
    '/Consultas': (context) => const MarcarConsulta(),
		'/asminhasconsultas': (context) => const AsMinhasConsultas(),
		'/plano_tratamento': (context) => const PlanoTratamentoPage(),
  },
		);
	}
}