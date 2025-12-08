import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../menu.dart';
import '../../services/api_service.dart';
import 'login_fields.dart';
import 'buttons.dart';

class LoginForm extends StatefulWidget {
  final Color bg;
  final Color cardBg;
  final Color loginColor;
  final Color recoverColor;

  const LoginForm({
    super.key,
    required this.bg,
    required this.cardBg,
    required this.loginColor,
    required this.recoverColor,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final senha = _passwordController.text;
    if (email.isEmpty || senha.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Preencha email e palavra-passe')));
      return;
    }

    setState(() => _isLoading = true);
    debugPrint('Login pressed: email=$email');
    try {
      final resp = await ApiService.login(email, senha);
      debugPrint('Login response: $resp');
      final access = resp['accessToken'] as String? ?? resp['token'] as String?;
      final user = resp['user'] as Map<String, dynamic>?;
      final prefs = await SharedPreferences.getInstance();
      if (access != null) {
        await prefs.setString('auth_token', access);
      }
      if (user != null) {
        final uidDynamic = user['id'];
        final int? uidInt = uidDynamic is int
            ? uidDynamic
            : (uidDynamic is String
                ? int.tryParse(uidDynamic)
                : (uidDynamic is num ? uidDynamic.toInt() : null));
        if (uidInt != null) await prefs.setInt('user_id', uidInt);

        final uemail = user['email'] as String?;
        if (uemail != null) await prefs.setString('user_email', uemail);
      }
      if (!context.mounted) return;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Menu()));
    } catch (err) {
      if (!context.mounted) return;
      final msg = err.toString();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro: $msg')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: widget.cardBg,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: const Color.fromRGBO(0, 0, 0, 0.03),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Iniciar sessão',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),

          EmailField(controller: _emailController, backgroundColor: widget.bg),
          const SizedBox(height: 12),

          PasswordField(controller: _passwordController, backgroundColor: widget.bg),
          const SizedBox(height: 16),

          AuthActions(
            isLoading: _isLoading,
            onLoginPressed: _handleLogin,
            loginColor: widget.loginColor,
            recoverColor: widget.recoverColor,
          ),
        ],
      ),
    );
  }
}
