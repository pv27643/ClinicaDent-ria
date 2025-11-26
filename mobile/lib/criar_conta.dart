import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({Key? key}) : super(key: key);

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _acceptedTerms = false;
  bool _obscure = true;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bg = Theme.of(context).colorScheme.background;
    final cardBg = Theme.of(context).colorScheme.surface;
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 8),
                Image.asset('assets/CliniMolelos.png', width: 72, height: 72),
                const SizedBox(height: 12),
                const Text('Clinimolelos', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                const Text('Registo de novo paciente', style: TextStyle(color: Colors.black54)),

                const SizedBox(height: 18),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 12, offset: Offset(0, 6)),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text('Dados da conta', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 12),

                        _buildField(controller: _nameCtrl, hint: 'Nome completo', icon: Icons.person_outline),
                        const SizedBox(height: 12),
                        _buildField(controller: _phoneCtrl, hint: 'Telefone', icon: Icons.phone),
                        const SizedBox(height: 12),
                        _buildField(controller: _emailCtrl, hint: 'E-mail', icon: Icons.email_outlined, keyboardType: TextInputType.emailAddress),
                        const SizedBox(height: 12),
                        _buildPasswordField(controller: _passwordCtrl, hint: 'Palavra-passe'),
                        const SizedBox(height: 12),
                        _buildPasswordField(controller: _confirmCtrl, hint: 'Confirmar Palavra-passe'),
                        const SizedBox(height: 12),

                        Row(
                          children: [
                            Checkbox(value: _acceptedTerms, onChanged: (v) => setState(() => _acceptedTerms = v ?? false)),
                            const Expanded(child: Text('Concordo com os Termos e a Política de Privacidade.')),
                          ],
                        ),

                        const SizedBox(height: 12),

                        SizedBox(
                          height: 48,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFA87B05),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            onPressed: _onCreate,
                            child: const Text('Criar Conta', style: TextStyle(color: Colors.white, fontSize: 16)),
                          ),
                        ),

                        const SizedBox(height: 12),
                        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                          const Text('Já tem conta? '),
                          GestureDetector(onTap: () => Navigator.of(context).pop(), child: const Text('Voltar para Entrar', style: TextStyle(fontWeight: FontWeight.w600))),
                        ])
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField({required TextEditingController controller, required String hint, required IconData icon, TextInputType keyboardType = TextInputType.text}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(color: const Color(0xFFF8F6F3), borderRadius: BorderRadius.circular(12)),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(border: InputBorder.none, hintText: hint, prefixIcon: Icon(icon)),
        validator: (v) {
          if (v == null || v.trim().isEmpty) return 'Campo obrigatório';
          return null;
        },
      ),
    );
  }

  Widget _buildPasswordField({required TextEditingController controller, required String hint}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(color: const Color(0xFFF8F6F3), borderRadius: BorderRadius.circular(12)),
      child: TextFormField(
        controller: controller,
        obscureText: _obscure,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          prefixIcon: const Icon(Icons.lock_outline),
          suffixIcon: IconButton(icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility), onPressed: () => setState(() => _obscure = !_obscure)),
        ),
        validator: (v) {
          if (v == null || v.isEmpty) return 'Campo obrigatório';
          if (v.length < 6) return 'Mínimo 6 caracteres';
          return null;
        },
      ),
    );
  }

  void _onCreate() {
    if (!_formKey.currentState!.validate()) return;
    if (!_acceptedTerms) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Aceite os Termos para continuar.')));
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Conta criada (simulada)')));
    Navigator.of(context).pop();
  }
}

